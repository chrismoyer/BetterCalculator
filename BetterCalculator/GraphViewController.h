//
//  GraphController.h
//  GraphingCalculator
//
//  Created by Chris Moyer on 7/17/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"


@interface GraphViewController : UIViewController <GraphViewDelegate, UISplitViewControllerDelegate>{
    id expression;
    BOOL drawLines;
    GraphView *graphView;
    
}

@property BOOL drawLines;
@property (retain) id expression;
@property (retain) IBOutlet GraphView *graphView;

- (id)initWithExpression:(id)expression;
- (double)getYForGraphView:(GraphView *)requestor :(float)x;

- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc;

- (void)splitViewController:(UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)button;
@end
