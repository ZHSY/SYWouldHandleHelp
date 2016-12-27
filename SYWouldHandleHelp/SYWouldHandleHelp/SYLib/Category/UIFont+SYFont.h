//
//  UIFont+SYFont.h
//  SYWouldHandleHelp
//
//  Created by 夜雨 on 2016/12/23.
//  Copyright © 2016年 ZHSY. All rights reserved.
//

#import <UIKit/UIKit.h>




#pragma mark - font


#define FONT_SYS16 FONT_SYS(16)
#define FONT_SYS15 FONT_SYS(14)
#define FONT_SYS14 FONT_SYS(14)

#define FONT_SYS(a) [UIFont systemFontOfSize:a]
#define FONT_bSYS(a) [UIFont boldSystemFontOfSize:a]

#define FONT_NVGTITLE FONT_bSYS(18)

#define FONT_ICON(a) [UIFont fontWithName:@"iconfont" size:a]




@interface UIFont (SYFont)



@end
