//
//  LJsignView.m
//  LJsignView
//
//  Created by Gzedu on 2017/3/13.
//  Copyright © 2017年 Gzedu. All rights reserved.
//

#import "LJsignView.h"
#define INITIAL_COLOR [UIColor blackColor]; // Initial color for line  drawing.
#define FINAL_COLOR [UIColor redColor];// End color after completd drawing

#define INITIAL_LABEL_TEXT @"Sign Here";

@interface LJsignView ()
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger count;


@property (nonatomic,strong)UIImage *image;
@end

@implementation LJsignView

{
    UIBezierPath *beizerPath;
    UIImage *incrImage;
    CGPoint points[5];
    uint control;
    BOOL isTouch;
}

// Create a View which contains Signature Label

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float lblHeight = 61;
        self.backgroundColor = [UIColor whiteColor];
        [self setMultipleTouchEnabled:NO];
        beizerPath = [UIBezierPath bezierPath];
        [beizerPath setLineWidth:2.0];
        lblSignature = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - lblHeight/2, self.frame.size.width, lblHeight)];
        lblSignature.font = [UIFont fontWithName:@"HelveticaNeue" size:51];
        lblSignature.text = INITIAL_LABEL_TEXT;
        lblSignature.textColor = [UIColor lightGrayColor];
        lblSignature.textAlignment = NSTextAlignmentCenter;
        lblSignature.alpha = 0.3;
        [self addSubview:lblSignature];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [incrImage drawInRect:rect];
    [beizerPath stroke];
    
    // Set initial color for drawing
    
    UIColor *fillColor = INITIAL_COLOR;
    [fillColor setFill];
    UIColor *strokeColor = INITIAL_COLOR;
    [strokeColor setStroke];
    [beizerPath stroke];
}

#pragma mark - UIView Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _count = 0;
    [self.timer setFireDate:[NSDate distantFuture]];
    
    
    if ([lblSignature superview]){
        [lblSignature removeFromSuperview];
    }
    control = 0;
    UITouch *touch = [touches anyObject];
    points[0] = [touch locationInView:self];
    
    CGPoint startPoint = points[0];
    CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y
                                   + 2);
    
    [beizerPath moveToPoint:startPoint];
    [beizerPath addLineToPoint:endPoint];
    
    isTouch = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    control++;
    points[control] = touchPoint;
    
    if (control == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        
        [beizerPath moveToPoint:points[0]];
        [beizerPath addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        [self setNeedsDisplay];
        
        points[0] = points[3];
        points[1] = points[4];
        control = 1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Bitmap Image Creation

- (void)drawBitmapImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrImage drawAtPoint:CGPointZero];
    
    //Set final color for drawing
    //    UIColor *strokeColor = FINAL_COLOR;
    UIColor *strokeColor = [UIColor blackColor];
    [strokeColor setStroke];
    [beizerPath stroke];
    incrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)clearSignature
{
    incrImage = nil;
    self.userInteractionEnabled = YES;
    [self setNeedsDisplay];
}

#pragma mark - beginTimer
- (void)beginTimer{
    _count++;
    
    if (_count == 3) {
        [self drawBitmapImage];
        [self setNeedsDisplay];
        [beizerPath removeAllPoints];
        control = 0 ;
        isTouch = NO;
        self.userInteractionEnabled = NO;
        self.image = [self getSignatureImage];
        
        [_delegate LJsignViewDelegateWithImage:self.image];
    }
}


#pragma mark - Get Signature image from given path

- (UIImage *)getSignatureImage {
    
    if([lblSignature superview]){
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return signatureImage;
}

#pragma mark - 懒加载
- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

@end
