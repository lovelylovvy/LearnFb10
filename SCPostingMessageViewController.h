//
//  SCPostingMessageViewController.h
//  LearnFb10
//
//  Created by Lav Tomar on 20/08/13.
//  Copyright (c) 2013 YML. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPostingMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *publishOnWall;
- (IBAction)publishInFeeds:(id)sender;
- (IBAction)pickImage:(id)sender;

@end
