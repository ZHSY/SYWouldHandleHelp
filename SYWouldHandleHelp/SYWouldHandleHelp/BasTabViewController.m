//
//  BasTabViewController.m
//  SYWouldHandleHelp
//
//  Created by 夜雨 on 2016/12/23.
//  Copyright © 2016年 ZHSY. All rights reserved.
//

#import "BasTabViewController.h"


@interface BasTabViewController ()


@end

@implementation BasTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSArray *className = @[@"SLFXViewController",@"FXParamViewController",@"FXDataViewController"];
    NSArray *titleArr = @[@"伤口分析",@"分析参数",@"分析记录"];
    NSArray *iconArr = @[@"",@"",@""];

    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i<titleArr.count ; i++ ) {
        
        
        Class class = NSClassFromString(className[i]);
        
        UIViewController *vc = [[class alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.title = titleArr[i];
        
        
        [vcs addObject:nvc];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleArr[i] image:[UIImage imageNamed:iconArr[i]] tag:i+1];
        
        [items addObject:item];
        
        
    }
    
    
   
    self.tabBar.barStyle = UIBarStyleDefault;
    
    self.viewControllers = vcs;
    //设置初始选中项
    self.selectedIndex = 0;
    
    //设置tabBarItem的间距
    //    tbc.tabBar.itemSpacing = 30.;
    
//    self.delegate = self;
    
    

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
