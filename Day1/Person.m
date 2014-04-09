//
//  Person.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName personType:(NSInteger)personType
{
    if (self = [super init]) {
        _firstName = firstName;
        _lastName = lastName;
        _personType = personType;
        _headshot = [UIImage imageNamed:@"mulldrifter_small.jpg"];
        _contactInfo = @"Twitter: ";
    }
    
    return self;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.headshot = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
        self.contactInfo = [aDecoder decodeObjectForKey:@"contactInfo"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.headshot) forKey:@"image"];
    [aCoder encodeObject:self.contactInfo forKey:@"contactInfo"];
}

@end
