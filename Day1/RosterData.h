//
//  RosterData.h
//  Day1
//
//  Created by Lauren Lee on 4/9/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface RosterData : NSObject

@property (nonatomic, strong) NSDictionary *personDictionary;
@property (nonatomic, strong) NSMutableArray *students, *teachers;

+ (NSMutableArray *)studentsFromPlist;
+ (NSMutableArray *)teachersFromPlist;
+ (RosterData *)sharedData;

- (void)sortByKey:(NSString *)sortKey;
- (void)addNewPerson:(Person *)newPerson withType:(personLabel)newPersonType;
- (void)removePersonAtIndex:(NSInteger)row section:(NSInteger)section;
- (void)save;
- (void)saveImagePath:(UIImage *)image person:(Person *)person;


@end
