//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Chris Moyer on 7/1/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject {
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    double memory;
    
    NSMutableArray *internalExpression;
}

@property (readonly) double memory;
@property (retain) NSString *waitingOperation;

- (void)setOperand:(double)anOperand;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)anOperation;
- (void)performWaitingOperation;
- (void)loadExpression:(id)anExpression;

@property (readonly, copy) id expression; 

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;

+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression; 
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
