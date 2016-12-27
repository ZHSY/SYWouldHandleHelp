//
//  Tool_ZSY.m
//  XzyDoctor
//
//  Created by 张双义 on 15/11/25.
//  Copyright © 2015年 xzy. All rights reserved.
//

#import "Tool_ZSY.h"
#import "UIView+SYExtend.h"
#import "UIColor+SYColor.h"

@implementation Tool_ZSY

#define OneMinuteTime 60
#define OneHourTime (OneMinuteTime*60)
#define OneDayTime (OneHourTime*24)

//出生Date 计算年龄 到天
//@张双义
+(NSInteger)ageByBirthDay:(NSDate *)birthDay
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:birthDay];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    // 获取系统当前 年月日
//    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge;
}

#pragma mark －－ 日期和时间 相互格式化

//日期转时间 转出格式：2015-11-19 19:05:11
+(NSString *)strDateFrameDate_ss:(NSDate *)date
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formater stringFromDate:date];
}

/**
 *  日期转时间 转出格式：2015-11-19
 */
+(NSString *)strDateFrameDate_dd:(NSDate *)date
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater stringFromDate:date];
}

/**
 *  日期转时间 转出格式：2015年11月19日
 */
+(NSString *)strCNDateFrameDate:(NSDate *)date{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    return [formater stringFromDate:date];
}

//str转date 传入格式：2015-11-19 19:05:11
+(NSDate *)dateFromeStr_ss:(NSString *)strDate
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:strDate];
    
    return date;

}

//str转date 传入格式：2015-11-19
+(NSDate *)dateFromeStr_dd:(NSString *)strDate
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formater dateFromString:strDate];
    
    return date;
}

/**
 *  str转date ---- 传入格式：2015年11月19日 ---- NSDate
 */
+(NSDate *)dateFromeStrCN_dd:(NSString *)strDate{
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    NSDate* date = [formater dateFromString:strDate];
    
    return date;
}


//str转时间戳 2015-11-19 19:05:11
+(NSTimeInterval)strDateToTimeInterval_ss:(NSString *)strDate
{
 
    NSDate *date = [self dateFromeStr_ss:strDate];

    
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

/**
 *   转换日期 到整天 ---- 传入格式：2015-11-19 19:05:11 ---- return 2015-11-19
 */
+(NSString *)strDateToDayDate_ss:(NSString *)strDate
{
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:strDate];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater stringFromDate:date];
}

/**
 *   转换日期 到整天 ---- 传入格式：2015-11-19 19:05:11/2015-11-19 ---- return 2015年11月19日
 */
+(NSString *)strDateToDayDateCN:(NSString *)strDate;
{
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    if (strDate.length>10) {
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formater setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSDate* date = [formater dateFromString:strDate];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    return [formater stringFromDate:date];
}

/**
 *   转换日期 到整天 ---- 传入格式：2015年11月19日 ---- return 2015-11-19
 */
+(NSString *)strDateFrameCNDate:(NSString *)strDate
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
   
    [formater setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate* date = [formater dateFromString:strDate];
    [formater setDateFormat:@"yyyy-MM-dd"];
    
    return [formater stringFromDate:date];
    
}


#pragma mark - 计算时间差

/**
 *  计算时间差 ---- 精确到1分钟 ---- 传入格式：2015-11-19 19:05:11
 */
+(NSString *)getDatePassBySS:(NSString *)strDate
{
    
    NSDate *sinceDate = [self dateFromeStr_ss:strDate];
    NSString *datePass;
    NSTimeInterval passTime = [[NSDate date] timeIntervalSinceDate:sinceDate];
    if (passTime<OneDayTime) {//一天之内
        if (passTime<OneHourTime) {
            if (passTime<OneMinuteTime) {
                datePass = @"刚刚";
            }else{
//                NSLog(@"%lg",passTime/OneMinuteTime);
                datePass = [NSString stringWithFormat:@"%d分钟前",(int)passTime/OneMinuteTime];
            }
        }else{
            datePass = [NSString stringWithFormat:@"%d个小时前",(int)passTime/OneHourTime];
        }
    }else{
        NSInteger passDay = passTime/OneDayTime;
        if (passDay<31) {
            datePass = [NSString stringWithFormat:@"%d天前",(int)passTime/OneDayTime];
        }else{
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy-MM-dd"];
            datePass = [formater stringFromDate:sinceDate];
        }
    }
    return datePass;
}

/**
 *  计算时间差 ---- strDate(2015-11-19) ----- 天数（0天返回nil）
 */
+(NSString *)getDatePassByDay:(NSString *)strDate
{
    
    //转换日期 到整天
    if (strDate.length>10) {
        strDate = [self strDateToDayDate_ss:strDate];
    }
    //无时分秒的 开始时间
    NSDate * startDate = [self dateFromeStr_dd:strDate];
    
    //无时分秒的 结束时间
    NSString *strNow = [self strDateFrameDate_dd:[NSDate date]];
    NSDate * nowDate = [self dateFromeStr_dd:strNow];

    //转换成时间戳 计算时间差
    NSTimeInterval startTime = [startDate timeIntervalSince1970];
    NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
    
    NSTimeInterval passTime = nowTime-startTime;
    
    if (passTime<OneDayTime) {//一天之内
        return nil;
    }else{
        NSInteger passDay = passTime/OneDayTime;
        if (passDay<31) {
            return [NSString stringWithFormat:@"%d天前",(int)passTime/OneDayTime];
        }else{//超过一个月 直接返回
            return strDate;
        }
    }
}

/**
 *  计算时间差 ---- 精确到1分钟 ----- 传入格式：2015-11-19 19:05:11
 */
+(NSString *)getDatePassByStrDate_ss:(NSString *)strDate
{
    
    return [self getDatePassBySS:strDate];
}

/**
 *  计算时间差 ---- 精确到1天 ---- strDate(2015-11-19`)
 */
+(NSString *)getDatePassByStrDate_dd:(NSString *)strDate
{
    NSString *datePass = [self getDatePassByDay:strDate];
    if (!datePass) {
        datePass = @"今天";
    }
    
    return datePass;
}

/**
 *  计算时间差天 ---- 传入格式：2015-11-19
 */
+(NSInteger)getDayPassFromStrDate_dd:(NSString *)fromDate toDate:(NSString *)toDate
{
    
    //无时分秒的 开始时间
    NSDate * startDate = [self dateFromeStr_dd:fromDate];
    
    //无时分秒的 结束时间
    NSDate * endDate = [self dateFromeStr_dd:toDate];
    
    //转换成时间戳 计算时间差
    NSTimeInterval startTime = [startDate timeIntervalSince1970];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    
    NSTimeInterval passTime = endTime-startTime;
    
    return passTime/OneDayTime;

}



#pragma mark - 属性字符串处理

//设置行间距字符串
+ (NSAttributedString *)makeString:(NSString *)strText widthRowSpac:(CGFloat)rowSpace
{
    if (!strText) {
        return nil;
    }
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strText];
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     [paragraphStyle setLineSpacing:rowSpace];//调整行间距
     [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strText length])];
    return attributedString;
}

+ (NSAttributedString *)makeString:(NSString *)strText widthRowSpac:(CGFloat)rowSpace attributes:(NSDictionary *)attributes
{
    if (!strText) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strText attributes:attributes];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:rowSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strText length])];
    return attributedString;

}




#pragma mark 字符串－XX 转换
+(NSString *)numberToChinese:(int)number

{
    
    switch (number) {
            
        case 0:
            
            return @"零";
            
            break;
            
        case 1:
            
            return @"一";
            
            break;
            
        case 2:
            
            return @"二";
            
            break;
            
        case 3:
            
            return @"三";
            
            break;
            
        case 4:
            
            return @"四";
            
            break;
            
        case 5:
            
            return @"五";
            
            break;
            
        case 6:
            
            return @"六";
            
            break;
            
        case 7:
            
            return @"七";
            
            break;
            
        case 8:
            
            return @"八";
            
            break;
            
        case 9:
            
            return @"九";
            
            break;
            
        case 10:
            
            return @"十";
            
            break;
            
        case 100:
            
            return @"百";
            
            break;
            
        case 1000:
            
            return @"千";
            
            break;
            
        case 10000:
            
            return @"万";
            
            break;
            
        case 100000000:
            
            return @"亿";
            
            break;
            
        default:
            
            return nil;
            
            break;
            
    }
}



#pragma mark 无数据提示

+ (void)showNoDataView:(UIView *)superView message:(NSString *)msg tag:(NSInteger)tag
{
    UIView * noDataView = [[UIView alloc] initWithFrame:superView.bounds];
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDWidth, 45)];
    message.textAlignment = NSTextAlignmentCenter;
    message.textColor = [UIColor darkGrayColor];
    message.backgroundColor = [UIColor groupTableViewBackgroundColor];
    message.font = [UIFont systemFontOfSize:18];
    message.tag = tag;
    message.text = @"暂无记录";
    
    if (msg) {
        message.text = msg;
    }
    

    [noDataView addSubview:message];
    [superView addSubview:noDataView];
    
}

+ (void)hidNoDataView:(UIView *)superView tag:(NSInteger)tag
{
    UIView * noDataView = [superView viewWithTag:tag];
    if (!noDataView) {
        return;
    }
    [noDataView removeFromSuperview];
}



@end

//@implementation SY_AFNetworking
//
//
//#pragma mark - 网络请求相关
///**
// *  封装的网络请求
// *
// *  @param URLString  url
// *  @param parameters 参数
// *  @param success    请求成功调用的block
// *  @param failure    请求失败调用的block
// *
// *  @注意 弱引用避免循环引用（应该不需要）
// */
//+(void)POST:(NSString *)URLString
// parameters:(id)parameters
//    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
//{
//    XZYAFManager *manager = [XZYAFManager sharedManager];
//    //开始请求
//    [manager POST:URLString parameters:parameters success:success failure:failure];
//    
//}
//
///**
// *  封装的网络请求
// *
// *  @param URLString  url
// *  @param parameters 参数
// *  @param block      组织参数的block
// *  @param success    请求成功调用的block
// *  @param failure    请求失败调用的block
// *
// *  @注意 弱引用避免循环引用（应该不需要）
// */
//+ (void)POST:(NSString *)URLString
//  parameters:(id)parameters
//constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
//     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
//{
//    XZYAFManager *manager = [XZYAFManager sharedManager];
//    //开始请求
//    [manager POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
//    
//}
//
//@end




