//
//  BetterCalculatorAppDelegate.h
//  BetterCalculator
//
//  Created by Chris Moyer on 7/24/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetterCalculatorAppDelegate : NSObject <UIApplicationDelegate>
{
    UINavigationController *navcon;
}

@property (readonly) BOOL iPad;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
