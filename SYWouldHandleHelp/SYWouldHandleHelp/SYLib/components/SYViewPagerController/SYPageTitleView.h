//
//  SYPageTitleView.h
//  testScrollVoew
//
//  Created by 夜雨 on 2016/11/15.
//  Copyright © 2016年 bjzcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPageTitleView : UIView

@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic, retain) UIColor *indicatorColor;
@property (nonatomic, retain) UIView *tabHead;
@property (nonatomic, assign) CGFloat selectedTabIconWidth;


@end
