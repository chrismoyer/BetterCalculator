//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Chris Moyer on 7/1/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import "CalculatorBrain.h"

#define VARIABLE_PREFIX @"%"

@implementation CalculatorBrain

@synthesize memory, waitingOperation;

-(id)init
{
    internalExpression = [[NSMutableArray alloc] init];
    return [super init];
}

- (void)dealloc
{
    [internalExpression release];
    self.waitingOperation = nil;
    [super dealloc];
}

- (id)expression 
{
    id expressionCopy = [internalExpression copy];
    [expressionCopy autorelease];
    
    return expressionCopy;
}

- (void)setOperand:(double)anOperand
{
    operand = anOperand;
    [internalExpression addObject:[NSNumber numberWithDouble:anOperand]];
    
}

- (void)performWaitingOperation
{
    if ([@"+" isEqual:self.waitingOperation]) {
        operand = waitingOperand + operand;
    } else if ([@"-" isEqual:self.waitingOperation]) {
        operand = waitingOperand - operand;
    } else if ([@"*" isEqual:self.waitingOperation]) {
        operand = waitingOperand * operand;
    } else if ([@"/" isEqual:self.waitingOperation]) {
        if (operand) {
            operand = waitingOperand / operand;            
        } else {
            // Used to display an error here, but no longer appropriate when graphing
            
//            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Dude"
//                                                             message:@"Can't divide by zero" 
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"I'm Sorry" 
//                                                   otherButtonTitles: nil] autorelease];
//            [alert show];
        }
    }  
}

- (void)clear
{
    NSLog(@"CLEAR OPERATION BEGINNING");
    operand = 0;
    self.waitingOperation = nil;
    waitingOperand = 0;
    NSLog(@"Internal Expression: %@", internalExpression);
    [internalExpression release];
    internalExpression = [[NSMutableArray alloc] init];
}

- (double)performOperation:(NSString *)operation
{
    BOOL addToExpression = YES;
    
    if ([operation isEqual:@"sqrt"]) {
        if (operand >= 0) {
            operand = sqrt(operand);
        } else {
            // Used to display an error here, but no longer appropriate when graphing

            
//            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Dude"
//                                                             message:@"I am incapable of handling the depths of your imagination" 
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"I'm Sorry" 
//                                                   otherButtonTitles: nil] autorelease];
//            [alert show];
        }
    } else if ([operation isEqual:@"+/-"]) { 
        operand = operand * -1;
    } else if ([operation isEqual:@"sin"]) {
        operand = sin(operand);
    } else if ([operation isEqual:@"cos"]) {
        operand = cos(operand);
    } else if ([operation isEqual:@"π"]) {
        operand = 3.1415926535;        
    } else if ([operation isEqual:@"1/x"]) {
        if (operand) {
            operand = 1 / operand;
        }
    } else if ([operation isEqual:@"C"]) {
        [self clear];
        addToExpression = NO;
    } else if ([operation isEqual:@"MS"]) {
        memory = operand;
    } else if ([operation isEqual:@"MR"]) {
        operand = memory;
    } else if ([operation isEqual:@"M+"]) {
        memory = memory + operand;        
    } else if ([operation isEqual:@"MC"]) {
        memory = 0;
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        waitingOperand = operand;
    }
    
    if (addToExpression) {
        [internalExpression addObject:operation];
    }
    
    return operand;
}

- (void)setVariableAsOperand:(NSString *)variableName
{
    NSString *variable = [VARIABLE_PREFIX stringByAppendingString:variableName];
    [internalExpression addObject:variable];
}

+ (NSString *)getVariable:(NSString *)potentialVariable
{
    NSString *variable;
    
    if ([potentialVariable hasPrefix:VARIABLE_PREFIX]) {
        variable = [potentialVariable substringFromIndex:[VARIABLE_PREFIX length]];
    } else {
        variable = NO;
    }
    
    return variable;
}

- (void)loadExpression:(id)anExpression 
{
    [self clear];
    
    for (id element in anExpression) {
        if ([element isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)element;
            [self setOperand:[num doubleValue]];
        } else if ([element isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)element;
            
            NSString *variable = [CalculatorBrain getVariable:str];
            if (variable) {

                [self setVariableAsOperand:variable];
            } else {
                [self performOperation:str];
            }
            
        } else {
            NSLog(@"Unknown object found in expression: %@", element);
        }        
    }
}

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables
{
    CalculatorBrain *tempBrain = [[CalculatorBrain alloc] init];
    
    double result = 0;
    
    for (id element in anExpression) {
        if ([element isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)element;
            [tempBrain setOperand:[num doubleValue]];
        } else if ([element isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)element;
            
            NSString *variable = [CalculatorBrain getVariable:str];
            if (variable) {
                // It's a variable
                NSNumber *variableValue = [variables objectForKey:variable];
                [tempBrain setOperand:[variableValue doubleValue]];                
            } else {
                result = [tempBrain performOperation:str];
            }
          
        } else {
            NSLog(@"Unknown object found in expression: %@", element);
        }        
    }

    [tempBrain release];
    return result;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *set = [NSMutableSet set];
    
    for (id object in anExpression) {
        if ([object isKindOfClass:[NSString class]]) {
            // It's a string
            NSString *str = (NSString *)object;
            
            if ([str hasPrefix:VARIABLE_PREFIX]) {
                NSString *variableStr = [str substringFromIndex:[VARIABLE_PREFIX length]];
                [set addObject:variableStr];
            }
        }
    }
    
    if (![set count]) set = nil;
    return set;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *exp = [NSMutableString string];
    
    for (id element in anExpression) {
        [exp appendString:@" "];
        
        if ([element isKindOfClass:[NSNumber class]]) {
            [exp appendString:[((NSNumber *)element) stringValue]];
        } else if ([element isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)element;
            
            if ([str hasPrefix:VARIABLE_PREFIX]) {
                NSString *variableStr = [str substringFromIndex:[VARIABLE_PREFIX length]];
                [exp appendString:variableStr];
            } else {
                [exp appendString:element];
            }

        } else {
            NSLog(@"Unknown object found in expression: %@", element); 
        }
    }
    return exp;
}

+ (id)propertyListForExpression:(id)anExpression
{
    return [[[NSMutableArray alloc]initWithArray:anExpression copyItems:YES] autorelease];   
}

+ (id)expressionForPropertyList:(id)propertyList
{
    return [[[NSMutableArray alloc]initWithArray:propertyList copyItems:YES] autorelease];  
}



@end
