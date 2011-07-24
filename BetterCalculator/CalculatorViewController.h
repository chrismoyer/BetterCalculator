//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Chris Moyer on 7/1/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController {
    UILabel *display;
    UILabel *memoryDisplay;
    
    GraphViewController *graphViewController;
    
    CalculatorBrain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
    
}

@property (readonly) GraphViewController *graphViewController;
@property (retain) IBOutlet UILabel *display;
@property (retain) IBOutlet UILabel *memoryDisplay;

- (IBAction)digitPressed:(UIButton *) sender;
- (IBAction)operationPressed:(UIButton *) sender;
- (IBAction)variablePressed:(UIButton *) sender;

- (IBAction)solve;
- (IBAction)graph;

@end
