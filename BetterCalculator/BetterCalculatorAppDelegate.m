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


- (void)dealloc
{
    [navcon release];
    [_window release];
    [super dealloc];
}

@end
