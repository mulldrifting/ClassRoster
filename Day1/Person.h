//
//  Person.h
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
//@property (nonatomic, strong) UIImage *headshot;

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
- (NSString *)fullName;

@end