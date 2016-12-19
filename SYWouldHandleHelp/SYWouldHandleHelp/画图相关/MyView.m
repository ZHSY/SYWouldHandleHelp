//
//  MyView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "MyView.h"
#import "MyViewModel.h"

#import "Tool_ZSY.h"

#import "UIImage+SYImage.h"
#import "UIColor+SYColor.h"

#import <QuartzCore/QuartzCore.h>

@interface MyView ()


@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isHavePath;


@property (nonatomic, strong)NSArray    *graPoints;

@property (nonatomic, assign)BOOL    touchMoved;

@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _lineWidth = 10.0f;
        _lineColor = [UIColor redColor];
    }
    return self;
}


- (double)getArea
{
    
    UIImage *cImage = [UIImage imageForView:self];
    
    NSInteger pointsCount = [cImage pointCountForColor:[UIColor redColor]];
    return pointsCount;
    
    
}

- (void)cleanAllLine
{
    _isHavePath = NO;
    [_pathArray removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}
- (void)drawView:(CGContextRef)context
{
    for (MyViewModel *myViewModel in _pathArray) {
        CGContextAddPath(context, myViewModel.path.CGPath);
        
        
        [myViewModel.color set];
        if([myViewModel.color isEqual:[UIColor clearColor]]){
            
            CGContextSetBlendMode(context, kCGBlendModeClear);
            
        }else{
            CGContextSetBlendMode(context, kCGBlendModeNormal);
        }
        
        CGContextSetLineWidth(context, myViewModel.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        
        [_lineColor set];
        
        if([_lineColor isEqual:[UIColor clearColor]]){
            
            CGContextSetBlendMode(context, kCGBlendModeClear);
            
        }else{
            CGContextSetBlendMode(context, kCGBlendModeNormal);
        }
        
        
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    _path = CGPathCreateMutable();
    _isHavePath = YES;
    CGPathMoveToPoint(_path, NULL, location.x, location.y);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    
    _touchMoved = YES;
    
    [self setNeedsDisplay];
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_touchMoved) {

        if (_pathArray == nil) {
            _pathArray = [NSMutableArray array];
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
        MyViewModel *myViewModel = [MyViewModel viewModelWithColor:_lineColor Path:path Width:_lineWidth];
        [_pathArray addObject:myViewModel];
        
        
        CGPathRelease(_path);
        
    }else{
        
        
        CGPathRelease(_path);
        
//        UITouch *touch = [touches anyObject];
//        CGPoint location =[touch locationInView:self];
//        [self showColorOfPoint:location];
        
    }
    
    
    _touchMoved = NO;
    _isHavePath = NO;
}


- (void)showColorOfPoint:(CGPoint)point
{
    UIColor *pointColor = [UIColor colorOfPoint:point intView:self];
    
    CGFloat piexl[4] = {};
    [pointColor getRGBComponents:piexl];
    
    NSArray *name = @[@"red",@"green",@"blue",@"alpa"];
    
    for (int i = 0; i<4; i++) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@ : %.2f",name[i],piexl[i]]);
        
    }

}


@end






