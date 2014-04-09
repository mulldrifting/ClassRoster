//
//  RosterViewDataSource.h
//  Day1
//
//  Created by Lauren Lee on 4/8/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RosterDataSourceController : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *students, *teachers;

@end
