//
//  Person.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName personType:(personLabel)personType
{
    if (self = [super init]) {
        _firstName = firstName;
        _lastName = lastName;
        _personType = personType;
        _headshot = [UIImage imageNamed:@"mulldrifter_small.jpg"];
        _headshotPath = nil;
        _twitter = @"Test";
        _github = @"Test";
    }
    
    return self;
}

- (id)initWithFullName:(NSString *)fullName personType:(personLabel)personType
{
    if (self = [super init]) {
        [self splitFullName:fullName];
        _personType = personType;
        _headshot = [UIImage imageNamed:@"mulldrifter_small.jpg"];
        _headshotPath = nil;
        _twitter = @"Test";
        _github = @"Test";

    }
    return self;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

-(void)splitFullName:(NSString *)fullName
{
    NSArray *nameArray = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    nameArray = [nameArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    _firstName = [nameArray objectAtIndex:0];
    
    _lastName = @"";
    if ([nameArray count] > 1) {
        for (int i = 1; i < [nameArray count]; i+=1) {
            _lastName = [_lastName stringByAppendingString:nameArray[i]];
        }
    }
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.headshot = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
        self.headshotPath = [aDecoder decodeObjectForKey:@"headshotPath"];
        self.twitter = [aDecoder decodeObjectForKey:@"twitter"];
        self.github = [aDecoder decodeObjectForKey:@"github"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
//    [aCoder encodeObject:UIImagePNGRepresentation(self.headshot) forKey:@"image"];
    [aCoder encodeObject:self.headshotPath forKey:@"headshotPath"];
    [aCoder encodeObject:self.twitter forKey:@"twitter"];
    [aCoder encodeObject:self.github forKey:@"github"];
}

@end
