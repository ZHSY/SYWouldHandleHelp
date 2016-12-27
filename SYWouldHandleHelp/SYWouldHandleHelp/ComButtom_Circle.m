//
//  ComButtom_Circle.m
//  ECOCondition
//
//  Created by zhsy on 16/10/28.
//  Copyright © 2016年 bjzcx. All rights reserved.
//

#import "ComButtom_Circle.h"

@implementation ComButtom_Circle


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = COLOR_NAV;
    
    self.layer.cornerRadius = 5;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = COLOR_NAV;
    
    self.layer.cornerRadius = 5;
    
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor *)color{
    
    self = [super initWithFrame:frame];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = color;
    
    self.layer.cornerRadius = 5;

    
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = COLOR_NAV;
    
    [self setTitle:title forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 5;
    
    return self;

    
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title bgColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = color;
    
    [self setTitle:title forState:UIControlStateNormal];
    self.layer.cornerRadius = 5;
    
    
    return self;

}














@end
