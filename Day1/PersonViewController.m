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


@interface PersonViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *personImageView;
@property (nonatomic, weak) IBOutlet UITextView *personTextView;
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
    
    self.title = _person.fullName;
    
    _personImageView.image = _person.headshot;
    
    [_personImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [_personImageView addGestureRecognizer:singleTap];
    [self.view addSubview:_personImageView];
    
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
    
//    _person.firstName = _firstNameTextField.text;
    
//    NSLog(@" textfield: %@", _firstNameTextField.text);
    
    [[RosterData sharedData] save];
}

#pragma mark - UIActionSheet Delegate Methods

-(void)singleTapping:(UIGestureRecognizer *)recognizer
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

//- (void)showcamera {
//    imagePicker = [[UIImagePickerController alloc] init];
//    [imagePicker setDelegate:self];
//    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    [imagePicker setAllowsEditing:YES];
//    
//    [self presentModalViewController:imagePicker animated:YES];
//}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _person.headshot = [info objectForKey:UIImagePickerControllerEditedImage];
    _personImageView.image = _person.headshot;
//    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
//            NSLog(@"Authorization status authorized: %ld Authorization status not determined: %ld", (long)ALAuthorizationStatusAuthorized, (long)ALAuthorizationStatusNotDetermined);
            [assetsLibrary writeImageToSavedPhotosAlbum:_person.headshot.CGImage
                                            orientation:ALAssetOrientationUp
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                NSLog(@"Error Saving Image: %@", error.localizedDescription);
                                            }
                                        }];
        }
        else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
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
