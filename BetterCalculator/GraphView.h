//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Chris Moyer on 7/17/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate

@required
-(double)getYForGraphView:(GraphView *)requestor :(float)x;
-(BOOL)getLineMode:(GraphView *)requestor;

@end


@interface GraphView : UIView {
    id <GraphViewDelegate> delegate;
    CGFloat scale;
    CGPoint origin;
}

@property CGFloat scale;
@property CGPoint origin;
@property (assign) id <GraphViewDelegate> delegate;

@end
