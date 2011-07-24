//
//  BetterCalculatorAppDelegate.m
//  BetterCalculator
//
//  Created by Chris Moyer on 7/24/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import "BetterCalculatorAppDelegate.h"
#import "CalculatorViewController.h"

@implementation BetterCalculatorAppDelegate


@synthesize window=_window;

- (BOOL)iPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    navcon = [[UINavigationController alloc] init];
    navcon.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    CalculatorViewController *cvcon = [[CalculatorViewController alloc] init];
    cvcon.title = @"Calculator";
    [navcon pushViewController:cvcon animated:NO];
    
    
    if (self.iPad) {
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        UINavigationController *rightNav = [[UINavigationController alloc] init];
        rightNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [rightNav pushViewController:cvcon.graphViewController animated:NO];
        svc.delegate = cvcon.graphViewController;
        svc.viewControllers = [NSArray arrayWithObjects:navcon, rightNav, nil];
        [cvcon release];
        [rightNav release];
        [_window addSubview:svc.view];
    } else {
        [cvcon release];
        [_window addSubview:navcon.view];
    }
    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [navcon release];
    [_window release];
    [super dealloc];
}

@end
