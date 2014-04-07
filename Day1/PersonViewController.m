//
//  PersonViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "PersonViewController.h"
#import "Person.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _person.fullName;
    
    _personImageView.image = _person.headshot;
    
//    _personImageView = [[UIImageView alloc] initWithImage:_person.headshot];
//    _personTextView = [[UITextView alloc] init];
    _personTextView.text = _person.contactInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
