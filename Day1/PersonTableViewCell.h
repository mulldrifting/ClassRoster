//
//  PersonTableViewCell.h
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface PersonTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *personTextLabel;
@property (nonatomic, strong) UIImage *personImageView;
@property (nonatomic, weak) Person *person;

@end
