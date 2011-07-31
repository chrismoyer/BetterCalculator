//
//  GraphController.m
//  GraphingCalculator
//
//  Created by Chris Moyer on 7/17/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"

@implementation GraphViewController

@synthesize expression, drawLines;
@synthesize graphView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    GraphView *gv = [[GraphView alloc] init];
    
    gv.backgroundColor = [UIColor whiteColor];
    
    self.view = gv;
    self.graphView = gv;
    [gv release];
}

- (void)viewWillAppear
{
    NSLog(@"viewWillAppear called");
}

- (id)initWithExpression:(id)ex
{
    self = [super init];
    self.expression = ex;
    
    return self;
}

- (void)releaseOutlets
{
    self.graphView = nil;
}

- (void)dealloc
{
    self.expression = nil;
    [self releaseOutlets];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.graphView.delegate = self; 
    self.drawLines = YES;
    
    UIGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)];
    [self.graphView addGestureRecognizer:pinchgr];
    [pinchgr release];
    
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)];
    [self.graphView addGestureRecognizer:pangr];
    [pangr release];
    
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 2;
    [self.graphView addGestureRecognizer:tapgr];
    [tapgr release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (double)getYForGraphView:(GraphView *)requestor :(float)x
{
    double myY = 0;
    if (requestor == graphView) {
        
        NSMutableDictionary *xdict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"];
        myY = [CalculatorBrain evaluateExpression:self.expression usingVariableValues:xdict];
    }
    return myY;
}

-(BOOL)getLineMode:(GraphView *)requestor 
{
    return drawLines;
}

- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
  //  pc.popoverContentSize = CGSizeMake(320, 460); //aViewController.view.bounds.size;
}

- (void)splitViewController:(UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    self.navigationItem.rightBarButtonItem = nil;
}
@end
