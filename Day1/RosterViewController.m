//
//  ViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "RosterViewController.h"
#import "Person.h"



@interface RosterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation RosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"Class Roster";
    
    Person *firstStudent = [[Person alloc] initWithFirstName:@"Sean" lastName:@"Mcneil"];
    Person *secondStudent = [[Person alloc] initWithFirstName:@"Lauren" lastName:@"Lee"];
    Person *thirdStudent = [[Person alloc] initWithFirstName:@"Dan" lastName:@"Fairbanks"];
    Person *firstTeacher = [[Person alloc] initWithFirstName:@"Brad" lastName:@"Johnson"];
    Person *secondTeacher = [[Person alloc] initWithFirstName:@"John" lastName:@"Clem"];
    
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _students.count;
    } else {
        return _teachers.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40; //play around with this value
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Students";
    } else {
        return @"Teachers";
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Person *person = [[Person alloc] init];
    
    if (indexPath.section == 0) {
        person = [_students objectAtIndex:indexPath.row];
    } else {
        person = [_teachers objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = person.fullName;
    
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
        
        UIViewController *destinationViewController = segue.destinationViewController;
        
        Person *selectedPerson = [[Person alloc] init];
        if (indexPath.section == 0) {
            selectedPerson = [_students objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
        } else {
            selectedPerson = [_teachers objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
        }
        destinationViewController.navigationItem.title = selectedPerson.fullName;
    }
}

@end
