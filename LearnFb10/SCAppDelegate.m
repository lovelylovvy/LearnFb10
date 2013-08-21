//
//  SCAppDelegate.m
//  LearnFb10
//
//  Created by Lav Tomar on 14/08/13.
//  Copyright (c) 2013 YML. All rights reserved.
//

#import "SCAppDelegate.h"

#import "SCViewController.h"
//#import "SCLoginViewController.h"

NSString *const SCSessionStateChangedNotification =@"com.ymal.lav.LearnFb10:SCSessionStateChangedNotification";

@implementation SCAppDelegate
@synthesize navController;
@synthesize mainViewController;
@synthesize permissions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[SCViewController alloc] initWithNibName:@"SCViewController" bundle:nil];
    self.navController =[[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    
    
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    if(FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        /// if previously login 
        
    NSLog(@"we are logged in th facebok");
    [self openSession];

    }
    
    else {
        //if not previorls login
        
        NSLog(@"we are not yet login in the facebook");
        
        [self showLoginView];
    }
    

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    
    UIViewController *modalViewController =[self.navController visibleViewController];
    
    NSLog(@"we are in the ShowloginVIew topViewController== %@", [topViewController description]);
    NSLog(@"we are in the showloginView presentViewController== %@", [modalViewController description]);
    
    
    if (![modalViewController isKindOfClass:[SCLoginViewController class]]) {
        //dothe following
        NSLog(@"the top class **** is %@" ,[topViewController  description]);
        
        SCLoginViewController *loginViewController =[[SCLoginViewController alloc]initWithNibName:@"SCLoginViewController" bundle:nil];
         [topViewController presentViewController:loginViewController animated:NO completion:nil];
    }
    else{
        // there is the 
        NSLog(@"####we are in the #### %@",[[self.navController visibleViewController] description]);

        SCLoginViewController *loginViewController = (SCLoginViewController*)[self.navController visibleViewController];
       
        
        NSLog(@"we are in the #### %@",[loginViewController description]);
        
        //[loginViewController loginFailed];
        
    }
    
    
    
    NSLog(@"#### we are in the SlowloginVIew topViewController== %@", [[topViewController presentingViewController] description]);
    
    NSLog(@"#### we are in the Self.visibleViewController== %@", [[self.navController visibleViewController] description]);
    
    /*
    SCLoginViewController *loginViewController =[[SCLoginViewController alloc]initWithNibName:@"SCLoginViewController" bundle:nil];
    [topViewController presentViewController:loginViewController animated:NO completion:nil];
    NSLog(@"we are in the showloginView");
    
*/

}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"we are in sessionStateChanged");
    
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[self.navController visibleViewController]
                 isKindOfClass:[SCLoginViewController class]]) {
                [topViewController dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"successfully login");
                //[FBSession setActiveSession:session];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification object:session];
    }
    
    
    

}


-(void) openSession
{
    NSLog(@"we are in opensession");
    self.permissions =[[NSMutableArray alloc]init];
    
    [self.permissions addObject:[NSString stringWithFormat:@"read_stream"]];
    [self.permissions addObject:[NSString stringWithFormat:@"read_friendlists"]];
    [self.permissions addObject:[NSString stringWithFormat:@"email"]];

    NSLog(@"total number of permissionin open session is  = %d", [self.permissions count]);
    
   // [FBSession op]
    
    [FBSession openActiveSessionWithReadPermissions:self.permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error){
        [self sessionStateChanged:session state:state error:error];
    }];
    //[FBSession ]
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}



@end

