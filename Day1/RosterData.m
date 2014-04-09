//
//  RosterData.m
//  Day1
//
//  Created by Lauren Lee on 4/9/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "RosterData.h"
#import "Person.h"

@implementation RosterData


// singleton of RosterData
+(RosterData *)sharedData
{
    static dispatch_once_t pred;
    static RosterData *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[RosterData alloc] init];
        shared.teachers = [[RosterData teachersFromPlist] mutableCopy];
        shared.students = [[RosterData studentsFromPlist] mutableCopy];
    });
    return shared;
}

// class method for grabbing students array from property list
+ (NSMutableArray *)studentsFromPlist
{
    NSMutableArray *students = [[NSMutableArray alloc] init];
    
    // path from main bundle
    NSString *pathBundle = [[NSBundle mainBundle] pathForResource:@"personList" ofType:@"plist"];
    // path from application documents
    NSString *plistPath = [[RosterData applicationDocumentsDirectory] stringByAppendingPathComponent:@"studentList.plist"];

    if ([RosterData checkForPlistFileInDocs:@"studentList.plist"])
    {
        // If the student plist exists then read from it
        
//        RosterData *sharedData = [RosterData sharedData];
//        sharedData.students = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        
        return [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
    }
    else // create the student plist from personList
    {
        // create a dictionary using personList.plist
        NSDictionary *personDictionary = [[NSDictionary alloc] initWithContentsOfFile:pathBundle];
        
        // for loop for creating students array
        for(NSString *currentStudentName in personDictionary[@"studentArray"]) {
            
            // creates and initializes new Person object
            NSArray *splitName = [currentStudentName componentsSeparatedByString: @" "];
            Person *newStudent = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kStudent];
            [students addObject:newStudent];
        }

        // writes data to plist
        [NSKeyedArchiver archiveRootObject:students toFile:plistPath];
    }

    return students;
}

+ (NSMutableArray *)teachersFromPlist {
    NSMutableArray *teachers = [[NSMutableArray alloc] init];
    
    // path from main bundle
    NSString *pathBundle = [[NSBundle mainBundle] pathForResource:@"personList" ofType:@"plist"];
    // path from application documents
    NSString *plistPath = [[RosterData applicationDocumentsDirectory] stringByAppendingPathComponent:@"teacherList.plist"];
    
    if ([RosterData checkForPlistFileInDocs:@"teacherList.plist"])
    {
        // If the teacher plist exists then read from it
        
        //        RosterData *sharedData = [RosterData sharedData];
        //        sharedData.students = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        
        return [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
    }
    else // create the teacher plist from personList
    {
        // create a dictionary using personList.plist
        NSDictionary *personDictionary = [[NSDictionary alloc] initWithContentsOfFile:pathBundle];
        
        // for loop for creating teachers array
        for(NSString *currentTeacherName in personDictionary[@"teacherArray"]) {
            NSArray *splitName = [currentTeacherName componentsSeparatedByString: @" "];
            
            Person *newTeacher = [[Person alloc] initWithFirstName:splitName[0] lastName:splitName[1] personType:kTeacher];
            [teachers addObject:newTeacher];
        }
        
        // writes data to plist
        [NSKeyedArchiver archiveRootObject:teachers toFile:plistPath];
    }

    return teachers;
}

- (void)sortByKey:(NSString *)sortKey
{
    //Sort teacher and student arrays by first name
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    NSArray *sortDescriptors = @[firstNameDescriptor];
    NSArray *sortedStudentArray = [_students sortedArrayUsingDescriptors:sortDescriptors];
    NSArray *sortedTeacherArray = [_teachers sortedArrayUsingDescriptors:sortDescriptors];
    //Set teacher and student arrays to sorted arrays
    _students = [NSMutableArray arrayWithArray:sortedStudentArray];
    _teachers = [NSMutableArray arrayWithArray:sortedTeacherArray];

}

-(void)addNewPerson:(Person *)newPerson withType:(NSInteger)newPersonType {
    switch (newPersonType) {
        case kStudent:
            [_students insertObject:newPerson atIndex:0];
            break;
        default:
            [_teachers insertObject:newPerson atIndex:0];
            break;
    }
    [[RosterData sharedData] save];
}

// update and save the teachers and students files
- (void)save {
    [NSKeyedArchiver archiveRootObject:self.teachers toFile:[[RosterData applicationDocumentsDirectory] stringByAppendingPathComponent:@"teacherList.plist"]];
    [NSKeyedArchiver archiveRootObject:self.students toFile:[[RosterData applicationDocumentsDirectory] stringByAppendingPathComponent:@"studentList.plist"]];
}

#pragma mark - plistPath

+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //    [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(BOOL)checkForPlistFileInDocs:(NSString*)fileName
{
//    NSError *error;
    
    NSFileManager *myManager = [NSFileManager defaultManager];
    
//    NSString *pathForPlistResource = [[NSBundle mainBundle] pathForResource:@"personList" ofType:@"plist"];
    NSString *pathForPlistInDocs = [[RosterData applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    return [myManager fileExistsAtPath:pathForPlistInDocs];
    
    //    if ([myManager fileExistsAtPath:pathForPlistInDocs]) {
    //        return YES;
    //    }
    //
    //    // copy item to destination folder
    //    [myManager copyItemAtPath:pathForPlistResource toPath:pathForPlistInDocs error:&error];
    //
    //    if (error) {
    //        NSLog(@" error: %@", error.localizedDescription);
    //    }
    //    else {
    //        return YES;
    //    }
    
    //    return NO;
    
    //    [[myManager copyItemAtURL:[NSBundle mainBundle] URLForResource:@"personList" withExtension:@"plist"] toURL:[self applicationDocumentsDirectory] error:];

}


@end
