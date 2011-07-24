//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Chris Moyer on 7/17/11.
//  Copyright 2011 MoeCode. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize delegate;


- (void)setOrigin:(CGPoint)aOrigin
{
    origin = aOrigin;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setDouble:origin.x forKey:@"origin-x"];
    [defaults setDouble:origin.y forKey:@"origin-y"];
    
    [defaults synchronize];
}

- (CGPoint)origin 
{
    return origin;
}

- (void)resetOrigin
{
    CGPoint point;
    point.x = MAXFLOAT;
    point.y = MAXFLOAT;
    NSLog(@"%f, %f", point.x, point.y);
    
    self.origin = point;    
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    float originx = [defaults floatForKey:@"origin-x"];
    float originy = [defaults floatForKey:@"origin-y"];
    float aScale = [defaults floatForKey:@"scale"];
    
    if (aScale) {
        scale = aScale;
    }
    
    if (originx) {
        origin = CGPointMake(originx, originy);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

#define DEFAULT_SCALE 28

+ (BOOL)scaleIsValid:(CGFloat)aScale
{
    return (aScale > 0) && (aScale < 100);
}

- (CGFloat)scale 
{
    return [GraphView scaleIsValid:scale] ? scale : DEFAULT_SCALE;
}

- (void)setScale:(CGFloat)newScale
{ 
    if (newScale != scale) {
        if ([GraphView scaleIsValid:newScale]) {
            scale = newScale;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];        
            [defaults setDouble:scale forKey:@"scale"];
            
            [self setNeedsDisplay];
        }
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint trans = [gesture translationInView:self];      
        self.origin = CGPointMake(self.origin.x + trans.x, self.origin.y + trans.y);
        [gesture setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];
    }                     
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"tap logged");
        [self resetOrigin];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat pointScale = self.contentScaleFactor;


    double graphScale = self.scale;
       
    CGContextSetLineWidth(context, 1 / pointScale);
    
    if (origin.x == MAXFLOAT) {
        CGPoint point;
        point.x = rect.size.width/2;
        point.y = rect.size.height/2;

        origin = point;
    }   
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:graphScale];
    
    CGContextBeginPath(context);
    
    BOOL lineMode = [delegate getLineMode:self];
    
    BOOL firstPoint = YES;
    for (double x = 0; x < rect.size.width; x += (1/pointScale)) {
    
        double gx = (x - (origin.x)) / (graphScale);
        double gy = [delegate getYForGraphView:self :gx];
        
        double y = ((-1 * gy * (graphScale)) + (origin.y));

        //NSLog(@"x = %f, y = %f, pixel = %f, %f", x, y, pixelX, pixelY);

        if (lineMode) {
            if (firstPoint) {
                CGContextMoveToPoint(context, x, y);
                firstPoint = NO;
            } else {
                CGContextAddLineToPoint(context, x, y); 
            }
            
        } else {
            CGContextFillRect(context, CGRectMake(x,
                                                  y,
                                                  1/pointScale,
                                                  1/pointScale
                                                  ));
        }

    }
    CGContextStrokePath(context);
    
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
