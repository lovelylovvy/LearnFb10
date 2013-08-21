//
//  SCViewController.h
//  LearnFb10
//
//  Created by Lav Tomar on 14/08/13.
//  Copyright (c) 2013 YML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SCTableViewController.h"
@interface SCViewController : UIViewController
-(void)logoutButtonWasPressed:(id)sender;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
- (IBAction)loadDataintableView:(id)sender;

- (IBAction)publishNews:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property SCTableViewController *tableViewControllerClass;

@end
