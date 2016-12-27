//
//  BaseViewController.m
//  ECOCondition
//
//  Created by zhsy on 16/10/28.
//  Copyright © 2016年 bjzcx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = COLOR_NAV;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}



- (void)addBarTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    
    
    label.font = FONT_NVGTITLE;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    [self.navigationItem setTitleView:label];
    
    
    
}




- (void)addBarItem:(BarItemType)barType  title:(NSString *)title  action:(SEL)action
{
    
    UIButton *btnView = [[UIButton alloc] init];
    
    
    [btnView setTitle:title forState:UIControlStateNormal];
    
    btnView.titleLabel.font = FONT_ICON(20);
    
    [btnView sizeToFit];
    
    [btnView addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    
    if (barType == BarItemTypeLeft) {
        self.navigationItem.leftBarButtonItem = barButton;
    }else{
        self.navigationItem.rightBarButtonItem = barButton;
    }
    
    
}




#pragma mark - action
/**
 *  backItemClick方法
 */
- (void)backItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
