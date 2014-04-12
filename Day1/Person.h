//
//  Person.h
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic) personLabel personType;
@property (nonatomic, strong) UIImage *headshot;
@property (nonatomic, copy) NSString *headshotPath;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *github;

- (id)initWithFullName:(NSString *)fullName personType:(personLabel)personType;
- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName personType:(personLabel)personType;
- (NSString *)fullName;
- (void)splitFullName:(NSString *)fullName;

@end
