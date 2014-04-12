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


@interface RosterViewController () <UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>

@property (strong, nonatomic) RosterDataSourceController *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActionSheet *sortActionSheet;
@property (strong, nonatomic) UIAlertView *addAlertView;
//@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@end

@implementation RosterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up table view
    self.dataSource = [RosterDataSourceController new];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.userInteractionEnabled = YES;
    
    self.title = @"Class Roster";
    
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set up navigation buttons
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(pickSortOption:)];
    self.navigationItem.leftBarButtonItem = sortButton;
    
    // Initialize action sheet
    _sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"First Name", @"Last Name", nil];
    
    // Initialize alert view
    _addAlertView = [[UIAlertView alloc] initWithTitle:@"Add New Person:" message:@"Please enter their first and last name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    _addAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_addAlertView addButtonWithTitle:@"Go"];
    [[_addAlertView textFieldAtIndex:0] setDelegate:self];
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
//    _logoImageView.image = [UIImage imageNamed:@"Code-Fellows-Logo.png"];
    
}

#pragma mark - UIActionSheetDelegate Methods

-(void)pickSortOption:(id)sender
{
    [self.sortActionSheet showInView:self.view];
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



#pragma mark - UIAlertView and UITextFieldDelegate Methods

- (void)showStudentAlert:(id)sender
{
    _addAlertView.title = @"Enter New Student:";
    _addAlertView.tag = kStudent;
    [_addAlertView show];
}

- (void)showTeacherAlert:(id)sender
{
    _addAlertView.title = @"Enter New Teacher:";
    _addAlertView.tag = kTeacher;
    [_addAlertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textfield = [alertView textFieldAtIndex:0];
    
    if (alertView.tag == kStudent) {
        if (buttonIndex == 1) {
            Person *newPerson = [[Person alloc] initWithFullName:textfield.text personType:kStudent];
            [[RosterData sharedData] addNewPerson:newPerson withType:kStudent];
        }
    }
    else if (alertView.tag == kTeacher)
    {
        if (buttonIndex == 1) {
            Person *newPerson = [[Person alloc] initWithFullName:textfield.text personType:kTeacher];
            [[RosterData sharedData] addNewPerson:newPerson withType:kTeacher];
        }
    }
    
    [self.tableView reloadData];
}

//-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
//{
//    NSLog(@"alert view return");
//    [_addAlertView dismissWithClickedButtonIndex:_addAlertView.firstOtherButtonIndex animated:YES];
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"text field return");
    [_addAlertView dismissWithClickedButtonIndex:_addAlertView.firstOtherButtonIndex animated:YES];
    return YES;
}

#pragma mark - UIView and UITableViewDelegate Methods

//-(void)didMoveToParentViewController:(UIViewController *)parent {
//    [self.tableView reloadData];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Class Roster";
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"";
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
    titleLabel.textColor = [UIColor colorWithRed:0.216 green:0.233 blue:0.349 alpha:1.000];
//    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:(17.0)];
    titleLabel.font = [titleLabel.font fontWithSize:(16.0)];
    switch (section) {
        case kStudent:
            titleLabel.text = @"STUDENTS";
            break;
        default:
            titleLabel.text = @"TEACHERS";
    }
    
    [customView addSubview:titleLabel];
    
    // create the button object
    UIImage *unhighlightedButton = [UIImage imageNamed:@"Add_Button2.png"];
    UIImage *highlightedButton = [UIImage imageNamed:@"Add_Button.png"];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectZero];
    addButton.backgroundColor = [UIColor clearColor];
    addButton.opaque = YES;
    addButton.frame = CGRectMake(280.0, 15.0, 30.0, 30.0);
    [addButton setBackgroundImage:unhighlightedButton forState:UIControlStateNormal];
    [addButton setBackgroundImage:highlightedButton forState:UIControlStateHighlighted];
    [addButton setBackgroundImage:highlightedButton forState:UIControlStateSelected];
    
    switch (section) {
        case kStudent:
            [addButton addTarget:self action:@selector(showStudentAlert:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            [addButton addTarget:self action:@selector(showTeacherAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [customView addSubview:addButton];
    
    return customView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}




//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

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
