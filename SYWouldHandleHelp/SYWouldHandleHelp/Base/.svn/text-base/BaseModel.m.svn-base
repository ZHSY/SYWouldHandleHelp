//
//  BaseModel.m
//  ECOCondition
//
//  Created by zhsy on 16/10/27.
//  Copyright © 2016年 bjzcx. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel



//当用kvc给模型赋值时，找不到指定的，key对应的属性时会调用此方法

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSString *className = NSStringFromClass([self class]);
    
    NSLog(@"%@ forUndefinedKey: %@",className, key);
    
}
//当用kvc给模型赋值时找不到指定的，key对应的属性时会调用此方法

-(id)valueForUndefinedKey:(NSString *)key{
    
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"%@ valueForUndefinedKey: %@",className, key);
    
    return nil;
}


//当用kvc给模型赋值时，key对应的属性为NSNumber时 空value 设为0
- (void)setNilValueForKey:(NSString *)key
{
    if ([[self valueForKey:key] isKindOfClass:[NSNumber class]]) {
        [self setValue:@0 forKey:key];
    }
}

@end
