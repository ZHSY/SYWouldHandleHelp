//
//  ToolView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "ToolView.h"
#import "ToolViewBtn.h"

#import "UIView+SYExtend.h"

#define BtnSpace 10

@interface ToolView ()


@property (nonatomic, copy)ToolColorBlock    toolColorBlock;
@property (nonatomic, copy)LineWidthBlock    lineWidthBlock;

@property (weak, nonatomic) ToolViewBtn *selectBtn;
@property (weak, nonatomic) ToolcolorView *colorView;
@property (weak, nonatomic) LineWidthView *lineWidthView;
@end

@implementation ToolView

- (id)initWithFrame:(CGRect)frame afterToolColor:(ToolColorBlock)toolColor afterLineWidthBlock:(LineWidthBlock)lineWidth
{
    _toolColorBlock = toolColor;
    _lineWidthBlock = lineWidth;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        NSArray *BtnArray = @[@"颜色",@"线宽"];
        [self creatButton:BtnArray];
    }
    return self;
}

- (void)creatButton:(NSArray *)array
{
    CGFloat btnWidth = (self.bounds.size.width-BtnSpace*array.count+1)/array.count;
    for (NSInteger i = 0; i<array.count; i++) {
        ToolViewBtn *button = [ToolViewBtn buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(BtnSpace + i*(BtnSpace + btnWidth), 5, btnWidth, self.bounds.size.height-10);
        button.tag = 1001+i;
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

- (void)button:(ToolViewBtn *)sender
{
    if (_selectBtn != nil && _selectBtn != sender) {
        
        
        _selectBtn.isSelectBtn = NO;
    }
    sender.isSelectBtn = YES;
    _selectBtn = sender;
    
    __weak typeof(self)weakSelf = self;
    
    switch (sender.tag) {
        case 1001:
        {
            
            if (_colorView == nil) {
                ToolcolorView *colorview =[[ToolcolorView alloc] initWithFrame:CGRectMake(0, kDHeight, kDWidth, self.height) afterToolColor:^(UIColor *color) {
                    
                    [weakSelf hideToolVIew:weakSelf.colorView];
                    weakSelf.toolColorBlock(color);

                }];
                [self.superview addSubview:colorview];
                _colorView = colorview;
            }
            
            if (_lineWidthView.frame.origin.y != kDHeight) {
                
                [self hideToolVIew:_lineWidthView];
            }
            
            [self showToolView:_colorView];
            
        }
            break;
        case 1002:
        {
            if (_lineWidthView == nil) {
                LineWidthView *lineWidView =[[LineWidthView alloc] initWithFrame:CGRectMake(0, kDHeight, kDWidth, self.height)afterLineWidthBlock:^(CGFloat lineFloat) {

                    [weakSelf hideToolVIew:weakSelf.lineWidthView];
                    weakSelf.lineWidthBlock(lineFloat);

                }];
                [self.superview addSubview:lineWidView];
                _lineWidthView = lineWidView;
            }
            

            if (_colorView.frame.origin.y != kDHeight) {
                
                [self hideToolVIew:_colorView];
            }
            
            [self showToolView:_lineWidthView];
            


        }
            break;
        default:
            break;
    }
}


- (void)showToolView:(UIView *)view
{
    
    
    CGFloat top = (view.top == kDHeight)?self.top - view.height:kDHeight;
    
    [UIView animateWithDuration:0.5f animations:^{
        view.top = top;
    }];

}

- (void)hideToolVIew:(UIView *)view
{
    [UIView animateWithDuration:0.5f animations:^{
        view.top = kDHeight;
    }];
}





@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
