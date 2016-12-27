//
//  BaseViewController.h
//  ECOCondition
//
//  Created by zhsy on 16/10/28.
//  Copyright © 2016年 bjzcx. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  BarItem left/right
 */
typedef NS_ENUM(NSInteger , BarItemType) {
    /**
     *  left Bar
     */
    BarItemTypeLeft   = 0,
    /**
     *  right Bar
     */
    BarItemTypeRight  = 1

};



@interface BaseViewController : UIViewController



- (void)addBarTitle:(NSString *)title;


- (void)addBarItem:(BarItemType)barType  title:(NSString *)title  action:(SEL)action;


/**
 *  backItemClick方法
 */
- (void)backItemClick;


@end
