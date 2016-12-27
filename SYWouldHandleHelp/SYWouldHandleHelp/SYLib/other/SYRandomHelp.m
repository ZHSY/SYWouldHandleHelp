//
//  SYRandomHelp.m
//  SQLDbTest
//
//  Created by 夜雨 on 16/9/19.
//  Copyright © 2016年 yeyu. All rights reserved.
//

#import "SYRandomHelp.h"

@implementation SYRandomHelp

+ (int)randomNum
{
    
    
    srand([[NSDate date] timeIntervalSince1970] + arc4random()%1024);
    
    int x = random()%100;
    
    if (x == 0) {
        x = random()%100;
    }
    
    int sum = 0;
    for (int j = 0; j<x; j++) {
        sum += arc4random()/x;
    }
    
    srand(sum);
    
    int num = arc4random();
    int num2 = arc4random();
    
    srand(abs(num + num2 + sum)/3 + [[NSDate date] timeIntervalSince1970]);
    int rNum = rand();
    
    return rNum;
    
}

@end
