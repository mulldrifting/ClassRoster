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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[RosterData sharedData] removePersonAtIndex:indexPath.row section:indexPath.section];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
