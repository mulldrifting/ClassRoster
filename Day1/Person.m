//
//  Person.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    if (self = [super init]) {
        _firstName = firstName;
        _lastName = lastName;
    }
    
    return self;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

@end
