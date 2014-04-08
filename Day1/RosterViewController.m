//
//  ViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "RosterViewController.h"
#import "PersonViewController.h"
#import "RosterViewDataSource.h"
#import "Person.h"

// Enumerator that labels the student type and teacher type
typedef NS_ENUM(NSInteger, personType) {
    kStudent,
    kTeacher,
    numberOfPersonTypes
};

@interface RosterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *personDictionary;
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
    
    _students = [[NSMutableArray alloc] init];
    _teachers = [[NSMutableArray alloc] init];
    
//    NSString *plistPath = @"/Users/Drifter/Documents/XCode/Day1/Day1/personList.plist";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"personList" ofType:@"plist"];
    _personDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    for(NSString *currentStudentName in _personDictionary[@"studentArray"]) {
        NSArray *splitName = [currentStudentName componentsSeparatedByString: @" "];
        
        Person *newStudent = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kStudent];
        [_students addObject:newStudent];
    }
    
    for(NSString *currentTeacherName in _personDictionary[@"teacherArray"]) {
        NSArray *splitName = [currentTeacherName componentsSeparatedByString: @" "];
        
        Person *newTeacher = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kTeacher];
        [_teachers addObject:newTeacher];
    }
    
    //Sort teacher and student arrays by first name
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[firstNameDescriptor];
    NSArray *sortedStudentArray = [_students sortedArrayUsingDescriptors:sortDescriptors];
    NSArray *sortedTeacherArray = [_teachers sortedArrayUsingDescriptors:sortDescriptors];
    //Set teacher and student arrays to sorted arrays
    _students = [NSMutableArray arrayWithArray:sortedStudentArray];
    _teachers = [NSMutableArray arrayWithArray:sortedTeacherArray];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Class Roster";
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
    
    switch (indexPath.section) {
        case kStudent:
            person = [_students objectAtIndex:indexPath.row];
            break;
        default:
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
