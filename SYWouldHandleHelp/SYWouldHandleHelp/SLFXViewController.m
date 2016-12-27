//
//  SLFXViewController.m
//  SYWouldHandleHelp
//
//  Created by 夜雨 on 2016/12/23.
//  Copyright © 2016年 ZHSY. All rights reserved.
//

#import "SLFXViewController.h"

@interface SLFXViewController ()

@end

@implementation SLFXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    
    
    
    
}


- (UIView *)creatDefaultView
{
    
    CGFloat margin = 15;
    
    UIView *dfView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, kDWidth - margin *2, kDHeight - HEIGHT_NAV - HEIGHT_TAB - 2 *margin)];
    
    dfView.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    
    
    
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dfView.width, 30)];
    label.text = @"请导入诊断图片";
    
    
    [dfView addSubview:label];
    
    
    UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputImage)];
    
    [dfView addGestureRecognizer:gesture];
    
    return dfView;
    
    
}

#pragma mark - action



- (void)inputImage
{
    
    
    
    
    
    
}


















@end
