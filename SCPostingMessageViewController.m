//
//  SCPostingMessageViewController.m
//  LearnFb10
//
//  Created by Lav Tomar on 20/08/13.
//  Copyright (c) 2013 YML. All rights reserved.
//

#import "SCPostingMessageViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SCPostingMessageViewController ()

@end

@implementation SCPostingMessageViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)publishInFeeds:(id)sender {
    
    NSString *imgUrl  = @"http://i284.photobucket.com/albums/ll16/Railage/audi-r8.jpg";
    NSLog(@"the publish button was clicked");
    
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // Permission hasn't been granted, so ask for publish_actions
   [[FBSession activeSession] requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
       //[FBSession setActiveSession:session];
       if(FBSession.activeSession.isOpen && !error)
       {
          ///publish the story
           //[FBSession setActiveSession:session];
           NSLog(@"the publish permission was granted");
           
           [self publishStory];
       }
       
       else
       {
           NSLog(@"error in getting publish permissions");
       }
    }];
    }
    else{
        [self publishStory];
    }
}

- (IBAction)pickImage:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    // or use the below code for taking the image from camera;
    
    
    //imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    
    /// or for taking picture from camera use the one above
    
    
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    
}

-(void) publishStory
{
    
    NSString *imgUrl  = @"http://i284.photobucket.com/albums/ll16/Railage/audi-r8.jpg";
    NSString *message = @"hey peoples look at this car it is awesome is not it ";
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithObjectsAndKeys:message,@"message", nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feeds" parameters:dic HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *alertText;
        if (error) {
            alertText=[NSString stringWithFormat:@"i am sorry unable to publish it error: domain = %@, code = %d",
                       error.domain, error.code];
            
        
        }
        else
        {
            alertText =[NSString stringWithFormat:@"Successfully published in the application Posted action, id: %@",
                        result[@"id"]];
            NSLog(@"the message is publish in the facebook feeds");
        }
        //// this will show the alert text
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertText
                                   delegate:self
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
        
        
        //// here is the alert text
        
    }];
    
    
}
/// this is the deligate method of the alert view
- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"the alert view is dissmissed");
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

/// this is the delegate methoD of ui Image pickker
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    // Dismiss the image selection, hide the picker and
    self.imageView.image = image;
    
    //show the image view with the picked image
    
    //[picker dismissViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //UIImage *newImage = image;
    
    
}

@end
