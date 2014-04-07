//
//  PersonTableViewCell.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "Person.h"

@implementation PersonTableViewCell

- (void)setPerson:(Person *)person
{
    _person = person;
    
    // Don't use self.person = person here = infinite loop
    
    _personTextLabel.text = _person.firstName;
//    _personImageView.image = (UIImage *);
}

@end
