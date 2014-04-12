//
//  PersonViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>
#import "PersonViewController.h"
#import "RosterData.h"
#import "Person.h"

typedef NS_ENUM(NSInteger, textFieldType) {
    kTitle,
    kTwitter,
    kGitbhub,
    numberOfTextFields
};

@interface PersonViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *scrollSubview;

@property (nonatomic, weak) IBOutlet UIImageView *personImageView;

@property (nonatomic, weak) IBOutlet UITextField *twitterTextField;
@property (nonatomic, weak) IBOutlet UITextField *githubTextField;
@property (nonatomic, strong) UITextField *navBarTextField;
@property (nonatomic, strong) NSArray *textFieldArray;

@property (weak, nonatomic) IBOutlet UIButton *tweetButton;

//@property (weak, nonatomic) IBOutlet UIButton *tweetButton;


@property (strong, nonatomic) UIActionSheet *myActionSheet;

@end

@implementation PersonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up views
//    [self.scrollView setBackgroundColor:[UIColor yellowColor]];
//    [self.scrollSubview setBackgroundColor:[UIColor grayColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // Set up text field in nav bar
    _navBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
    _navBarTextField.text = _person.fullName;
    _navBarTextField.font = [UIFont boldSystemFontOfSize:19];
    _navBarTextField.textAlignment = NSTextAlignmentCenter;

    // Create array of text fields
    self.textFieldArray = [NSArray arrayWithObjects:self.navBarTextField, self.twitterTextField, self.githubTextField, nil];
    
    NSInteger i = 0;
    for (UITextField *textField in self.textFieldArray) {
    // Set all text field delegates to the view controller
        textField.delegate = self;
        
        // Make keyboard disappear upon return
        [textField addTarget:textField action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        // Set tags for each textfield
        textField.tag = i;
        i+=1;
    }
    
    // Set items to the text field
    self.navigationItem.titleView = _navBarTextField;
    if (_person.twitter) {
        _twitterTextField.text = _person.twitter;
    }
    if (_person.github) {
        _githubTextField.text = _person.github;
    }
    
    // Make keyboard disappear upon tapping outside text field
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.scrollSubview addGestureRecognizer:tapOutside];
    
    // Set up image in image view
    _personImageView.image = _person.headshot;
    CALayer *imageLayer = [_personImageView layer];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setCornerRadius:50.0];
    [imageLayer setBorderColor: [[UIColor blackColor] CGColor]];
    [imageLayer setBorderWidth: 10.0];
    
    // Make action sheet open when tapping image
    [_personImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapImage =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openActionSheet:)];
    [_personImageView addGestureRecognizer:tapImage];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.navigationController.navigationBar endEditing:YES];
////    [self.navBarTextField endEditing:YES];
//    for (UIControl *control in self.view.subviews) {
//        if ([control isKindOfClass:[UITextField class]]) {
//            [control endEditing:YES];
//        }
//    }
}

-(IBAction)sharePhoto:(id)sender
{
    UIActivityViewController *sharePhotoVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.personImageView.image] applicationActivities:nil];
    [self presentViewController:sharePhotoVC animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case kTitle:
            break;
        default: // is equal to kTwitter or kGitbhub
            [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-100) animated:YES];
            break;
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    switch (textField.tag) {
        case kTitle:
            [self.person splitFullName:textField.text];
            break;
        case kTwitter:
            self.person.twitter = textField.text;
            break;
        default: // is equal to kGithub
            self.person.github = textField.text;
            break;
    }
    
    [[RosterData sharedData] save];
}

-(void)dismissKeyboard {
    for (UITextField *textField in self.textFieldArray) {
        [textField resignFirstResponder];
    }
}

#pragma mark - UIActionSheet Delegate Methods

-(void)openActionSheet:(UIGestureRecognizer *)recognizer
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
    } else {
        _myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo",nil];
    }
    
    [self.myActionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Photo"])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
            NSLog(@"Authorization not granted");
            // handle no authorization
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Access Photos" message:@"Authorization status not granted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }
    
    else {
        return;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];

}

#pragma mark - UIImagePickerController Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _person.headshot = [info objectForKey:UIImagePickerControllerEditedImage];
    _personImageView.image = _person.headshot;
    
    [[RosterData sharedData] saveImagePath:_personImageView.image person:_person];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined)
        {
            // If authorized to access photo library, save image to library
            
//            NSLog(@"Authorization status authorized: %ld Authorization status not determined: %ld", (long)ALAuthorizationStatusAuthorized, (long)ALAuthorizationStatusNotDetermined);
            
            [assetsLibrary writeImageToSavedPhotosAlbum:_person.headshot.CGImage
                                            orientation:ALAssetOrientationUp
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                NSLog(@"Error Saving Image: %@", error.localizedDescription);
                                            }
                                        }];
        }
        
        else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted)
        {
            NSLog(@"Authorization not granted");
            // handle no authorization
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Save Photo" message:@"Authorization status not granted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
        }
        else {
            NSLog(@"Authorization ???");
        }
    }];
    
}

#pragma mark - Social Media Methods

-(IBAction)sendToTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"@%@ ",self.person.twitter]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}


@end
