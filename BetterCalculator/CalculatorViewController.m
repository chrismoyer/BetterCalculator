//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Chris Moyer on 7/1/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphViewController.h"

@implementation CalculatorViewController

@synthesize display, memoryDisplay;

- (void)releaseOutlets
{
    self.display = nil;
    self.memoryDisplay = nil;
}

- (void)dealloc
{
    [brain release];
    [graphViewController release];
    [self releaseOutlets];
    [super dealloc];
}

- (void)viewDidUnload
{
    NSLog(@"viewDidUnload called");
    [self releaseOutlets];
    display = nil;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad called");
    if (!brain) brain = [[CalculatorBrain alloc] init];    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id exp = [defaults objectForKey:@"expression"];
    if (exp) {
        NSLog(@"Got expression from NSUserDefaults: %@", exp);
        
        [brain loadExpression:exp];
        self.display.text = [CalculatorBrain descriptionOfExpression:exp];
        
        self.graphViewController.expression = brain.expression;
        self.graphViewController.title = [CalculatorBrain descriptionOfExpression:self.graphViewController.expression];
        [self.graphViewController.view setNeedsDisplay];
        
    //    [self graph];
    }
    
    memoryDisplay.text = @"";
}

- (GraphViewController *)graphViewController
{
    if (!graphViewController) graphViewController = [[GraphViewController alloc] init];
    return graphViewController;
}

- (IBAction)digitPressed:(UIButton *) sender
{
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber) {
        if ([digit isEqual:@"."]) {
            
            NSRange dotRange = [display.text rangeOfString:@"."];
            if (dotRange.location != NSNotFound) {
                return;
            }
        }
        display.text = [display.text stringByAppendingString:digit];
    } else {
        display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
    
}

- (IBAction)operationPressed:(UIButton *) sender
{
    if (userIsInTheMiddleOfTypingANumber) {
        [brain setOperand:display.text.doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    NSString *operation = sender.titleLabel.text;
    NSLog(@"operation button was pressed: %@", operation);
    
    double result = [brain performOperation:operation];
    
    if ([CalculatorBrain variablesInExpression:brain.expression]) {
        display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
    } else {
        display.text = [NSString stringWithFormat:@"%g", result];
    }
    
    if ([operation hasPrefix:@"M"]) {
        memoryDisplay.text = [NSString stringWithFormat:@"%g", brain.memory];
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    [brain setVariableAsOperand:sender.titleLabel.text];
    display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
    
}

- (IBAction)solve
{
    if (userIsInTheMiddleOfTypingANumber) {
        [brain setOperand:display.text.doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }    
    
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    [variables setObject:[NSNumber numberWithDouble:2] forKey:@"x"];
    [variables setObject:[NSNumber numberWithDouble:4] forKey:@"a"];
    [variables setObject:[NSNumber numberWithDouble:6] forKey:@"b"];
        
    NSString *expressionDescription = [CalculatorBrain descriptionOfExpression:brain.expression];
    
    if (![expressionDescription hasSuffix:@"="]) {
        [brain performOperation:@"="];
    }
    
    double result = [CalculatorBrain evaluateExpression:brain.expression usingVariableValues:variables];    
    
    display.text = [NSString stringWithFormat:@"%@ %g", [CalculatorBrain descriptionOfExpression:brain.expression], result];

    
}

- (IBAction)graph
{
    NSString *expressionDescription = [CalculatorBrain descriptionOfExpression:brain.expression];
    
    if (![expressionDescription hasSuffix:@"="]) {
        [brain performOperation:@"="];
    }
    
    id props = [CalculatorBrain propertyListForExpression:brain.expression];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:props forKey:@"expression"];
    [defaults synchronize];
    
    self.graphViewController.expression = brain.expression;
    self.graphViewController.title = [CalculatorBrain descriptionOfExpression:self.graphViewController.expression];
    [self.graphViewController.view setNeedsDisplay];
    
    if (self.graphViewController.view.window == nil) {
        [self.navigationController pushViewController:self.graphViewController animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
