//
//  ViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "RosterViewController.h"
#import "PersonViewController.h"
#import "Person.h"

typedef NS_ENUM(NSInteger, personType) {
    kStudent,
    kTeacher,
    numberOfPersonTypes
};

@interface RosterViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@end

@implementation RosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"Class Roster";
//    _logoImageView.image = [UIImage imageNamed:@"Code-Fellows-Logo.png"];
    
    Person *firstStudent = [[Person alloc] initWithFirstName:@"Sean" lastName:@"Mcneil" personType:kStudent];
    Person *secondStudent = [[Person alloc] initWithFirstName:@"Lauren" lastName:@"Lee" personType:kStudent];
    Person *thirdStudent = [[Person alloc] initWithFirstName:@"Dan" lastName:@"Fairbanks" personType:kStudent];
    Person *firstTeacher = [[Person alloc] initWithFirstName:@"Brad" lastName:@"Johnson" personType:kTeacher];
    Person *secondTeacher = [[Person alloc] initWithFirstName:@"John" lastName:@"Clem" personType:kTeacher];
    
    _students = [NSMutableArray arrayWithObjects:firstStudent, secondStudent, thirdStudent, nil];
    _teachers = [NSMutableArray arrayWithObjects:firstTeacher, secondTeacher, nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Class Roster";
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"Back";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return numberOfSections;
    return numberOfPersonTypes;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kStudent:
            return _students.count;
        default:
            return _teachers.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40; //play around with this value
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case kStudent:
            return @"Students";
        default:
            return @"Teachers";
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0.0;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Person *person;
    
    if (indexPath.section == 0) {
        person = [_students objectAtIndex:indexPath.row];
    } else {
        person = [_teachers objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = person.fullName;
    cell.imageView.image = person.headshot;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    //check which segue you clicked on
    if ([segue.identifier isEqualToString:@"showPersonSegue"]) {
        // == doesn't work because the two pointers wouldn't be equal
        
        PersonViewController *destination = segue.destinationViewController;
        
        if (indexPath.section == 0) {
            destination.person = [_students objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
        } else {
            destination.person = [_teachers objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
        }

        //destinationViewController.navigationItem.title = selectedPerson.fullName;
    }
}

@end
