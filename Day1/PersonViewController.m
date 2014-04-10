//
//  PersonViewController.m
//  Day1
//
//  Created by Lauren Lee on 4/7/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PersonViewController.h"
#import "RosterData.h"
#import "Person.h"


@interface PersonViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *personImageView;
@property (nonatomic, weak) IBOutlet UITextView *personTextView;
@property (nonatomic, strong) UITextField *navBarTextField;
@property (strong, nonatomic) UIActionSheet *myActionSheet;

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
    
    
    // Set up text field over nav bar title
    _navBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
    _navBarTextField.text = _person.fullName;
    _navBarTextField.font = [UIFont boldSystemFontOfSize:19];
    _navBarTextField.textAlignment = NSTextAlignmentCenter;
    
    // Set text field delegate to self
    _navBarTextField.delegate = self;
    
    self.navigationItem.titleView = _navBarTextField;
    
    // Make keyboard disappear upon return
    [_navBarTextField addTarget:_navBarTextField
                  action:@selector(resignFirstResponder)
        forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // Make keyboard disappear upon tapping outside text field
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapOutside];
    
    // Set up image in image view
    _personImageView.image = _person.headshot;
    
    // Make action sheet open when tapping image
    [_personImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapImage =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openActionSheet:)];
    [_personImageView addGestureRecognizer:tapImage];
    [self.view addSubview:_personImageView];
    
    // Set up second text field for later
    _personTextView.editable = NO;
    _personTextView.text = _person.contactInfo;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[RosterData sharedData] save];
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSArray *splitName = [textField.text componentsSeparatedByString: @" "];

    _person.firstName = splitName[0];
    _person.lastName = splitName[1];
    
    [[RosterData sharedData] save];
    
}

-(void)dismissKeyboard {
    [_navBarTextField resignFirstResponder];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    NSLog(@" %ld", (long)buttonIndex);
    
    // this works but it crashes: bad access
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
