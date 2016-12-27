//
//  ViewPagerController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ViewPagerOption) {
    ViewPagerOptionTabHeight,
    ViewPagerOptionTabOffset,
    ViewPagerOptionTabWidth,
    ViewPagerOptionTabLocation,
    ViewPagerOptionStartFromSecondTab,
    ViewPagerOptionCenterCurrentTab,
    ViewPagerOptionIsMoreTabs,

};

typedef NS_ENUM(NSUInteger, ViewPagerComponent) {
    ViewPagerTabLine,
    ViewPagerTabDfText,
    ViewPagerTabSelText,
    ViewPagerTabBgColor,

    ViewPagerContent
};

@protocol SYViewPagerDelegate;
@protocol SYViewPagerDataSource;

@interface SYViewPagerController : UIViewController

@property (nonatomic, strong)UIScrollView   *tabsView;//标题栏
@property (nonatomic, strong)UIView         *contentView;//主题view i


@property (nonatomic, copy)NSMutableArray   *tabs;


@property (nonatomic, weak)id<SYViewPagerDataSource> dataSource;
@property (nonatomic, weak)id<SYViewPagerDelegate> delegate;


#pragma mark ViewPagerOptions

@property CGFloat tabHeight;
@property CGFloat tabOffset;
@property CGFloat tabWidth;

// 1.0: Top, 0.0: Bottom, changes tab bar's location in the screen
@property (nonatomic, assign)CGFloat    tabLocation;// Defaults to Top


// 1.0: YES, 0.0: NO, defines if view should appear with the second or the first tab
@property CGFloat startFromSecondTab;// Defaults to NO


// 1.0: YES, 0.0: NO, defines if tabs should be centered, with the given tabWidth
@property CGFloat centerCurrentTab;// Defaults to NO


@property (nonatomic, assign)CGFloat isMoreTabs;
@property (nonatomic, assign)NSUInteger activeTabIndex;



/**
 上下剩余空间
 */
@property (nonatomic, assign)CGFloat    topSpace;
@property (nonatomic, assign)CGFloat    bottomSpace;



#pragma mark Colors


@property UIColor *tabsViewBackgroundColor;//tab 背景色
@property UIColor *contentViewBackgroundColor;


@property (nonatomic, strong)UIColor    *tabsDefaultTextColor;//tab默认字体颜色
@property (nonatomic, strong)UIColor    *tabsSelectedTextColor;//tab选中字体颜色
@property (nonatomic, strong)UIColor    *tabsSelectedLineColor;//tab选中滑条 颜色



@property (nonatomic, strong)UIScrollView    *pageScroll;


#pragma mark Methods
// Reload all tabs and contents
- (void)reloadData;

#pragma mark - 返回对应下标的viewController
- (UIViewController *)getViewControllerAtIndex:(NSInteger)index;


/**
 *  选中对应下标的栏目
 */
- (void)currentContentViewAtIndex:(NSInteger)index;
/**
 *  刷新标题栏
 */
- (void)refreshTabViews;


@end

#pragma mark dataSource
@protocol SYViewPagerDataSource <NSObject>

// Asks dataSource how many tabs will be
- (NSUInteger)numberOfTabsForViewPager:(SYViewPagerController *)viewPager;
// Asks dataSource to give a view to display as a tab item
// It is suggested to return a view with a clearColor background
// So that un/selected states can be clearly seen
- (UIView *)viewPager:(SYViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index;

@optional
// The content for any tab. Return a view controller and ViewPager will use its view to show as content
- (UIViewController *)viewPager:(SYViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
- (UIView *)viewPager:(SYViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index;

/**
*  标题栏 选中时下标线的宽度
*/
- (CGFloat)viewPager:(SYViewPagerController *)viewPager tabViewSelectedIconWidthIndex:(NSInteger)index;
@end

#pragma mark delegate
@protocol SYViewPagerDelegate <NSObject>

@optional
// delegate object must implement this method if wants to be informed when a tab changes
- (void)viewPager:(SYViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index;
// Every time - reloadData called, ViewPager will ask its delegate for option values
// So you don't have to set options from ViewPager itself
- (CGFloat)viewPager:(SYViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value;
/*
 * Use this method to customize the look and feel.
 * viewPager will ask its delegate for colors for its components.
 * And if they are provided, it will use them, otherwise it will use default colors.
 * Also not that, colors for tab and content views will change the tabView's and contentView's background 
 * (you should provide these views with a clearColor to see the colors),
 * and indicator will change its own color.
 */
- (UIColor *)viewPager:(SYViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color;

//返回对应tabView的宽度
- (CGFloat)viewPager:(SYViewPagerController *)viewPager tabViewWidthIndex:(int)index;




@end
