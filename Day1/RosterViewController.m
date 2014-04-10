//
//  ViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "RosterViewController.h"
#import "PersonViewController.h"
#import "RosterData.h"
#import "RosterDataSourceController.h"
#import "Person.h"


@interface RosterViewController () <UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) RosterDataSourceController *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActionSheet *sortActionSheet;
//@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@end

@implementation RosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [RosterDataSourceController new];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
    self.title = @"Class Roster";
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(pickSortOption:)];
    self.navigationItem.leftBarButtonItem = sortButton;
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
//    _logoImageView.image = [UIImage imageNamed:@"Code-Fellows-Logo.png"];
    
//    _students = [[NSMutableArray alloc] init];
//    _teachers = [[NSMutableArray alloc] init];
//    
////    NSString *plistPath = @"/Users/Drifter/Documents/XCode/Day1/Day1/personList.plist";
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"personList" ofType:@"plist"];
//    _personDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    
//    for(NSString *currentStudentName in _personDictionary[@"studentArray"]) {
//        NSArray *splitName = [currentStudentName componentsSeparatedByString: @" "];
//        
//        Person *newStudent = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kStudent];
//        [_students addObject:newStudent];
//    }
//    
//    for(NSString *currentTeacherName in _personDictionary[@"teacherArray"]) {
//        NSArray *splitName = [currentTeacherName componentsSeparatedByString: @" "];
//        
//        Person *newTeacher = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kTeacher];
//        [_teachers addObject:newTeacher];
//    }
//    
        
    
}

-(void)pickSortOption:(id)sender {
    
   _sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"First Name", @"Last Name", nil];
    
    [self.sortActionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *sortKey;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"First Name"])
    {
        sortKey = @"firstName";
        [[RosterData sharedData] sortByKey:sortKey];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Last Name"])
    {
        sortKey = @"lastName";
        [[RosterData sharedData] sortByKey:sortKey];
    }
    else
    {
        return;
    }
    
    [self.tableView reloadData];
    
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[RosterData sharedData] removePersonAtIndex:indexPath.row section:indexPath.section];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)insertNewStudent:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add New Student:" message:@"Please enter your first and last name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = kStudent;
    [alert addButtonWithTitle:@"Go"];
    [alert show];
    
}

- (void)insertNewTeacher:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add New Teacher:" message:@"Please enter your first and last name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = kTeacher;
    [alert addButtonWithTitle:@"Go"];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kStudent) {
        if (buttonIndex == 1) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            
            NSArray *splitName = [textfield.text componentsSeparatedByString: @" "];
            Person *newPerson = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kStudent];
            [[RosterData sharedData] addNewPerson:newPerson withType:kStudent];
            
            NSLog(@"username: %@", textfield.text);
            
        }
        
    }
    else if (alertView.tag == kTeacher)
    {
        if (buttonIndex == 1) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            
            NSArray *splitName = [textfield.text componentsSeparatedByString: @" "];
            Person *newPerson = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kTeacher];
            [[RosterData sharedData] addNewPerson:newPerson withType:kTeacher];
            
            NSLog(@"username: %@", textfield.text);
        }
    }
    
    [self.tableView reloadData];
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


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0.0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50; //play around with this value
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 10.0, 300.0, 40.0)];
    
    // create a label object
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0,10.0,100.0,40.0)];
    
    switch (section) {
        case kStudent:
            titleLabel.text = @"Students";
            break;
        default:
            titleLabel.text = @"Teachers";
    }
    
    [customView addSubview:titleLabel];
    
    // create the button object
    UIImage *unhighlightedButton = [UIImage imageNamed:@"Add_Button.png"];
    UIImage *highlightedButton = [UIImage imageNamed:@"Add_Button2.png"];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectZero];
    addButton.backgroundColor = [UIColor clearColor];
    addButton.opaque = YES;
    addButton.frame = CGRectMake(280.0, 15.0, 30.0, 30.0);
    [addButton setBackgroundImage:unhighlightedButton forState:UIControlStateNormal];
    [addButton setBackgroundImage:highlightedButton forState:UIControlStateHighlighted];
    [addButton setBackgroundImage:highlightedButton forState:UIControlStateSelected];
    
    switch (section) {
        case kStudent:
            [addButton addTarget:self action:@selector(insertNewStudent:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            [addButton addTarget:self action:@selector(insertNewTeacher:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [customView addSubview:addButton];
    
    return customView;
    
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
            destination.person = [[[RosterData sharedData] students] objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
        } else {
            destination.person = [[[RosterData sharedData] teachers] objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
        }

        //destinationViewController.navigationItem.title = selectedPerson.fullName;
    }
}

@end
