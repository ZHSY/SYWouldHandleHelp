//
//  ViewPagerController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "SYViewPagerController.h"
#import "Tool_ZSY.h"
#import "UIView+SYExtend.h"
#import "UIColor+SYColor.h"

//#import "DefineHeader.h"

#import "SYPageTitleView.h"



#define COLOR_LINE RGBColor(232, 232, 232)
#define COLOR_Tab RGBColor(65, 98, 255)

#define kDefaultTabHeight 44.0 // Default tab height
#define kDefaultTabOffset 56.0 // Offset of the second and further tabs' from left
#define kDefaultTabWidth 375/2

#define kDefaultTabLocation 1.0 // 1.0: Top, 0.0: Bottom

#define kDefaultStartFromSecondTab 0.0 // 1.0: YES, 0.0: NO

#define kDefaultCenterCurrentTab 0.0 // 1.0: YES, 0.0: NO

#define kDefaultIsMoreTabs 0.0 // 1.0: YES, 0.0: NO

#define kPageViewTag 34

#define kDefaultMoreTabsBtnWidth 50.0 //默认的标题栏更多按钮的宽度
#define kDefaultSelectedTabIconWidth 40.0 //默认的标题栏更多按钮的宽度


#define kDefaultSelectedLineColor   COLOR_Tab   //tab选中滑条 颜色
#define kDefaultTabSelectedColor    COLOR_Tab   //tab选中颜色
#define kDefaultTabDfTextColor      RGBColor(0, 0, 0)//tabText 默认中颜色

#define kDefaultTabViewBgColor      RGBColor(255, 255, 255)//tab 背景颜色


#define kDefaultContentViewBackgroundColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]

//[UIColor colorWithRed:248.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:0.75]

// TabView for tabs, that provides un/selected state indicators



// ViewPagerController
@interface SYViewPagerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property UIPageViewController *pageViewController;
@property (weak) id<UIScrollViewDelegate> origPageScrollViewDelegate;


@property (nonatomic, strong)UIView *splitLineView;


@property (nonatomic, strong)NSMutableArray *contents;


@property NSUInteger tabCount;
@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;



@end

@implementation SYViewPagerController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}


#pragma mark - View life cycle


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
	_splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDWidth, 1)];
    _splitLineView.backgroundColor = COLOR_LINE;
    
    [self.view addSubview:_splitLineView];
    
    [self reloadData];
    
    
    
    
    
}
- (void)viewWillLayoutSubviews {
    
    
    CGFloat mainWidth = self.view.width;
    CGFloat mainHeight = self.view.height;
    
    //现在只考虑在顶部的情况
    if (self.tabLocation) {
        
        //栏目
        _tabsView.frame = CGRectMake(0, self.topSpace, mainWidth, self.tabHeight);
        
        //分割线
        _splitLineView.top = _tabsView.bottom;
        
        //主体部分
        _contentView.frame = CGRectMake(0, _splitLineView.bottom, self.view.width, mainHeight - _splitLineView.bottom);


    }
    
    
    
}



#pragma mark - 返回对应下标的viewController
- (UIViewController *)getViewControllerAtIndex:(NSInteger)index
{
    if (index<_contents.count) {
        return _contents[index];
    }
    return nil;
}

/**
 *  选中对应下标的栏目
 */
- (void)currentContentViewAtIndex:(NSInteger)index
{
    __block NSInteger currentIndex = index;
    UIViewController *viewController = [self viewControllerAtIndex:currentIndex];
    
    // __weak pageViewController to be used in blocks to prevent retaining strong reference to self
    __weak UIPageViewController *weakPageViewController = self.pageViewController;
    __weak SYViewPagerController *weakSelf = self;
    
    //    NSLog(@"%@",weakPageViewController.view);
    
    if (currentIndex < self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             // Set the current page again to obtain synchronisation between tabs and content
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionReverse
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    } else if (currentIndex > self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             // Set the current page again to obtain synchronisation between tabs and content
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    }
    
    // Set activeTabIndex
    self.activeTabIndex = currentIndex;

}


#pragma mark - 头部点击事件
- (void)handleTapGesture:(id)sender {
    
    self.animatingToTab = YES;
    
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    UIView *tabView = tapGestureRecognizer.view;
    
    [self currentContentViewAtIndex:[_tabs indexOfObject:tabView]];
}


#pragma mark - 选中tabView
- (void)setActiveTabIndex:(NSUInteger)activeTabIndex {
    
    SYPageTitleView *activeTabView;
    
    // Set to-be-inactive tab unselected
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    activeTabView.selected = NO;
    [(UILabel *)activeTabView.tabHead setTextColor:kDefaultTabDfTextColor];

    
    
    // Set to-be-active tab selected
    activeTabView = [self tabViewAtIndex:activeTabIndex];
    activeTabView.selected = YES;
    [(UILabel *)activeTabView.tabHead setTextColor:kDefaultTabSelectedColor];

    // Set current activeTabIndex
    _activeTabIndex = activeTabIndex;
    
    // Inform delegate about the change
    if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex];
    }
    
    // Bring tab to active position
    // Position the tab in center if centerCurrentTab option provided as YES
    
    UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
    CGRect frame = tabView.frame;
    
    if (self.centerCurrentTab) {
        
        frame.origin.x += (frame.size.width / 2);
        frame.origin.x -= _tabsView.frame.size.width / 2;
        frame.size.width = _tabsView.frame.size.width;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        
        if ((frame.origin.x + frame.size.width) > _tabsView.contentSize.width) {
            frame.origin.x = (_tabsView.contentSize.width - _tabsView.frame.size.width);
        }
    } else {
        
        frame.origin.x -= self.tabOffset;
        frame.size.width = self.tabsView.frame.size.width;
    }
    
    [_tabsView scrollRectToVisible:frame animated:YES];
}

#pragma mark -
- (void)defaultSettings {
    
    // Default settings
    _tabHeight = kDefaultTabHeight;
    _tabOffset = kDefaultTabOffset;
    _tabWidth = kDefaultTabWidth;
    
    _tabLocation = kDefaultTabLocation;
    
    _startFromSecondTab = kDefaultStartFromSecondTab;
    
    _centerCurrentTab = kDefaultCenterCurrentTab;
    
    // Default colors
    _tabsSelectedLineColor = kDefaultSelectedLineColor;
    _tabsViewBackgroundColor = kDefaultTabViewBgColor;
    _contentViewBackgroundColor = kDefaultContentViewBackgroundColor;
    
    // pageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    //Setup some forwarding events to hijack the scrollview
    self.origPageScrollViewDelegate = ((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]).delegate;
    self.pageScroll = [_pageViewController.view.subviews objectAtIndex:0];
    [_pageScroll setDelegate:self];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    self.animatingToTab = NO;
    
    
}
#pragma mark - 数据初始化
- (void)reloadData {
    
    // Get settings if provided
    if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)]) {
        
        _tabHeight = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabHeight withDefault:kDefaultTabHeight];
        _tabOffset = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabOffset withDefault:kDefaultTabOffset];
        
        _tabLocation = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabLocation withDefault:kDefaultTabLocation];
        
        _startFromSecondTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionStartFromSecondTab withDefault:kDefaultStartFromSecondTab];
        
        _centerCurrentTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionCenterCurrentTab withDefault:kDefaultCenterCurrentTab];
        _isMoreTabs = [self.delegate viewPager:self valueForOption:ViewPagerOptionIsMoreTabs withDefault:kDefaultIsMoreTabs];
       
    }
    
    // Get colors if provided
    if ([self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
        
        _tabsSelectedLineColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabLine withDefault:kDefaultSelectedLineColor];
        _tabsViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabBgColor withDefault:kDefaultTabViewBgColor];
        _contentViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerContent withDefault:kDefaultContentViewBackgroundColor];
        
        _tabsDefaultTextColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabDfText withDefault:kDefaultTabDfTextColor];
        
        _tabsSelectedTextColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabSelText withDefault:kDefaultTabDfTextColor];
        
        
        
    }
    
    // Empty tabs and contents
    [_tabs removeAllObjects];
    [_contents removeAllObjects];
    
    _tabCount = [self.dataSource numberOfTabsForViewPager:self];
    
    // Populate arrays with [NSNull null];
    _tabs = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_tabs addObject:[NSNull null]];
    }
    
    _contents = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_contents addObject:[NSNull null]];
    }
    
    // Add tabsView
    if (!_tabsView) {
        CGFloat tabsViewWidth = _isMoreTabs? self.view.frame.size.width - kDefaultMoreTabsBtnWidth :self.view.bounds.size.width;

         _tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, tabsViewWidth, self.tabHeight)];
        _tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tabsView.backgroundColor = self.tabsViewBackgroundColor;
        _tabsView.showsHorizontalScrollIndicator = NO;
        _tabsView.showsVerticalScrollIndicator = NO;
    
    [self.view insertSubview:_tabsView atIndex:0];
    }
   
    [self refreshTabViews];
    
    // Add contentView
    _contentView = [self.view viewWithTag:kPageViewTag];
    if (!_contentView) {
        
        _contentView = _pageViewController.view;
        
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = self.contentViewBackgroundColor;
        _contentView.bounds = self.view.bounds;
        _contentView.tag = kPageViewTag;
        
        [self.view insertSubview:_contentView atIndex:0];
    }
    
    
    

    // Set first viewController
    UIViewController *viewController;
    
    if (self.startFromSecondTab) {
        viewController = [self viewControllerAtIndex:1];
    } else {
        viewController = [self viewControllerAtIndex:0];
    }
    
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }
    
    [_pageViewController setViewControllers:@[viewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
 
    // Set activeTabIndex
    self.activeTabIndex = self.startFromSecondTab;
    
    
    //添加 ‘更多‘
    
    
}

/**
 *  刷新标题栏
 */
- (void)refreshTabViews
{
    NSArray *tabViews = self.tabsView.subviews;
    for (UIView *tabView in tabViews) {
        [tabView removeFromSuperview];
    }
    
    // Add tab views to _tabsView
    CGFloat contentSizeWidth = 0;
    for (int i = 0; i < _tabCount; i++) {
        if ([self.delegate respondsToSelector:@selector(viewPager:tabViewWidthIndex:)]){
            _tabWidth = [self.delegate viewPager:self tabViewWidthIndex:i];
        }
        
        UIView *tabView = [self tabViewAtIndex:i];
        
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = self.tabWidth;
        tabView.frame = frame;
        
        [_tabsView addSubview:tabView];
        
        contentSizeWidth += tabView.frame.size.width;
        
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
    }
    
    _tabsView.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight);
}

- (SYPageTitleView*)tabViewAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    
    if ([[_tabs objectAtIndex:index] isEqual:[NSNull null]]) {

        // Get view from dataSource
        UIView *tabViewContent = [self.dataSource viewPager:self viewForTabAtIndex:index];
        
        // Create SYPageTitleViewand subview the content
        SYPageTitleView *tabView = [[SYPageTitleView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tabWidth, self.tabHeight)];
        CGFloat selectedTabIconWidth = kDefaultSelectedTabIconWidth;
        if ([self.dataSource respondsToSelector:@selector(viewPager:tabViewSelectedIconWidthIndex:)]) {
            selectedTabIconWidth = [self.dataSource viewPager:self tabViewSelectedIconWidthIndex:index];
        }
        tabView.selectedTabIconWidth = selectedTabIconWidth;
        tabView.tabHead = tabViewContent;
        [tabView addSubview:tabView.tabHead];
        [tabView setClipsToBounds:YES];
        [tabView setIndicatorColor:self.tabsSelectedLineColor];
        
        tabViewContent.center = tabView.center;
        tabViewContent.frame = tabView.bounds;
        // Replace the null object with tabView
        [_tabs replaceObjectAtIndex:index withObject:tabView];
    }
    
    return [_tabs objectAtIndex:index];
}
- (NSUInteger)indexForTabView:(UIView *)tabView {
    
    return [_tabs indexOfObject:tabView];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    
    if ([[_contents objectAtIndex:index] isEqual:[NSNull null]]) {
        
        UIViewController *viewController;
        
        if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)]) {
            viewController = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
        } else if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewForTabAtIndex:)]) {
            
            UIView *view = [self.dataSource viewPager:self contentViewForTabAtIndex:index];
            
            // Adjust view's bounds to match the pageView's bounds
            UIView *pageView = [self.view viewWithTag:kPageViewTag];
            view.frame = pageView.bounds;
            
            viewController = [UIViewController new];
            viewController.view = view;
        } else {
            viewController = [[UIViewController alloc] init];
            viewController.view = [[UIView alloc] init];
        }
        
        [_contents replaceObjectAtIndex:index withObject:viewController];
    }
    
    return [_contents objectAtIndex:index];
}
- (NSUInteger)indexForViewController:(UIViewController *)viewController {
    
    return [_contents indexOfObject:viewController];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexForViewController:viewController];
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
//    NSLog(@"willTransitionToViewController: %i", [self indexForViewController:[pendingViewControllers objectAtIndex:0]]);
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    self.activeTabIndex = [self indexForViewController:viewController];
}



#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScroll:scrollView];
    }
    
    if (![self isAnimatingToTab]) {
        UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
        
        // Get the related tab view position
        CGRect frame = tabView.frame;
        
        CGFloat movedRatio = (scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
        frame.origin.x += movedRatio * frame.size.width;
        
        if (self.centerCurrentTab) {
            
            frame.origin.x += (frame.size.width / 2);
            frame.origin.x -= _tabsView.frame.size.width / 2;
            frame.size.width = _tabsView.frame.size.width;
            
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            
            if ((frame.origin.x + frame.size.width) > _tabsView.contentSize.width) {
                frame.origin.x = (_tabsView.contentSize.width - _tabsView.frame.size.width);
            }
        } else {
            
            frame.origin.x -= self.tabOffset;
            frame.size.width = self.tabsView.frame.size.width;
        }
        
//        [_tabsView scrollRectToVisible:frame animated:NO];
    }
}




@end
