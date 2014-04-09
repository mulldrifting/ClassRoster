//
//  RosterViewDataSource.m
//  Day1
//
//  Created by Lauren Lee on 4/8/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "RosterViewController.h"
#import "RosterDataSourceController.h"
#import "RosterData.h"
#import "Person.h"

@implementation RosterDataSourceController

-(id)init {
    self = [super init];
    
    if (self) {
        
        
        //Sort teacher and student arrays by first name
//        NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
//        NSArray *sortDescriptors = @[firstNameDescriptor];
//        NSArray *sortedStudentArray = [_students sortedArrayUsingDescriptors:sortDescriptors];
//        NSArray *sortedTeacherArray = [_teachers sortedArrayUsingDescriptors:sortDescriptors];
//        
//        //Set teacher and student arrays to sorted arrays
//        _students = [NSMutableArray arrayWithArray:sortedStudentArray];
//        _teachers = [NSMutableArray arrayWithArray:sortedTeacherArray];

    }
    
    return self;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return numberOfSections;
    return numberOfPersonTypes;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kStudent:
            return [[RosterData sharedData] students].count;
        default:
            return [[RosterData sharedData] teachers].count;
    }
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Person *person;
    
    switch (indexPath.section) {
        case kStudent:
            person = [[[RosterData sharedData] students] objectAtIndex:indexPath.row];
            break;
        default:
            person = [[[RosterData sharedData] teachers] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = person.fullName;
    cell.imageView.image = person.headshot;
    
    return cell;
}


@end
