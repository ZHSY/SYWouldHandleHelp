//
//  SYPageTitleView.m
//  testScrollVoew
//
//  Created by 夜雨 on 2016/11/15.
//  Copyright © 2016年 bjzcx. All rights reserved.
//

#import "SYPageTitleView.h"

@implementation SYPageTitleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    
    if (_selected != selected) {
        
        CGFloat currentSize = [[(UILabel *)_tabHead font] pointSize];
        
        selected?(currentSize++):(currentSize--);
        [(UILabel *)_tabHead setFont:[UIFont systemFontOfSize:currentSize]];
        
    }
    
    _selected = selected;
    
    
    
    // Update view as state changed
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    // Draw an indicator line if tab is selected
    if (self.selected) {
        
        bezierPath = [UIBezierPath bezierPath];
        
        // Draw the indicator
        CGFloat width = CGRectGetWidth(rect) - 10;
        width = MIN(width, _selectedTabIconWidth - 10);
        CGFloat left = (CGRectGetWidth(rect) - width)/2;
        [bezierPath moveToPoint:CGPointMake(left, rect.size.height - 1.0)];
        [bezierPath addLineToPoint:CGPointMake(left+width, rect.size.height - 1.0)];
        [bezierPath setLineWidth:2.0];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
    }
}

@end
