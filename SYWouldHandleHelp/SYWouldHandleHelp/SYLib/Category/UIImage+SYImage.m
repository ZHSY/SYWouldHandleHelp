//
//  UIImage+SYImage.m
//  FreehandAreaGetTest
//
//  Created by zhsy on 16/10/21.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import "UIImage+SYImage.h"

#import "UIColor+SYColor.h"

@implementation UIImage (SYImage)


#pragma mark - 创建

/**
 *  通过颜色来生成一个纯色图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/**
 *  通过颜色来生成一个纯色图片
 */
+ (UIImage *)imageFromImage:(UIImage *)image color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark * 截图
/**
 *  屏幕截图
 */
+ (UIImage *)imageWithScreenContents {
    
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    void *imageBytes = malloc(mainFrame.size.width * mainFrame.size.height * 4);
    
    CGContextRef context = CGBitmapContextCreate(imageBytes, mainFrame.size.width, mainFrame.size.height, 8, mainFrame.size.width * 4, colorspace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorspace);
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGRect bounds = [window bounds];
        CALayer *layer = [window layer];
        CGContextSaveGState(context);
        if ([layer contentsAreFlipped]) {
            CGContextTranslateCTM(context, 0.0f, bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
        }
        [layer renderInContext:(CGContextRef)context];
        CGContextRestoreGState(context);
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *shotImage = [UIImage imageWithCGImage:cgImage];
    
    CGContextRelease(context);
    CGImageRelease(cgImage);
    if (imageBytes)
        free(imageBytes);
    
    return shotImage;
    
}


/**
 *  view截图（只截取view及其subView内容 覆盖其上的同级view不会截取）
 */
+ (instancetype)imageForView:(UIView *)shotView {
    UIGraphicsBeginImageContextWithOptions(shotView.bounds.size, NO, 1.0);  //NO，YES 控制是否透明
    [shotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  view 部分截图（只截取view及其subView内容 覆盖其上的同级view不会截取）
 */
+ (instancetype)imageForView:(UIView *)shotView shotFrame:(CGRect)frame {
    
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 1.0);  //NO，YES 控制是否透明
    [shotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    CGImageRef imageRef = viewImage.CGImage;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, frame);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIGraphicsEndImageContext();
    
    return sendImage;
    
}



#pragma mark - 处理

/**
 *  灰色图片转化
 */
- (UIImage *)getGrayImage {
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}


/**
 *  获取一个点的像素信息 不适合所有信息的获取
 */
- (UIColor *)colorOfPoint:(CGPoint)point {
    
    const UInt32 *pixels = [self getAllImagePixelData];
    
    int index =point.x + point.y * self.size.width;//每个像素由四个分量组成所以要乘以4
    
    UIColor *color = UIColorFromHex((unsigned int)pixels[index]);
    
    
    return color;
}

/**
 *  获取图片的所有像素信息
 *
 *  @return UInt32 * 数组
 */
- (const UInt32 *)getAllImagePixelData {
    UIImage *image = self;
    
    int width = (int)image.size.width;
    int height = (int)image.size.height;
    
    
    unsigned char *cMap = (unsigned char *)malloc(width * height);
    memset(cMap, 0, width * height);
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr(imageData);
    
    CFRelease(imageData);
    //0xff 0x00 is guard for this demo
    
    return pixels;
    
}




/**
 *  获取图片的所有像素信息
 *
 *  @pointRGBAList  *[] 数组 内容为：p[4] 数组指针
 */
- (void)getAllImageRGBData:(int *[])pointRGBAList  {
    
    // 分配内存
    const int imageWidth  = self.size.width;
    const int imageHeight = self.size.height;
    size_t    bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        int bc = ptr[0];// = 透明度
        int gc = ptr[1];// = p
        int rc = ptr[2];// = r
        int ac = ptr[3];
        
        int pointRGBA[] = {rc,gc,bc,ac};
        
        pointRGBAList[i] = pointRGBA;
        
        
    }
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
}

/**
 *  对比获取对应颜色区域得大小
 *
 *  @return [@{@"pointIndex":@(0),@"color":color}]
 */
- (NSInteger)pointCountForColor:(UIColor *)color {
        
    const UInt32 *pixels = [self getAllImagePixelData];
    
    NSInteger count = 0;
    
    for (int j = 0; j < (self.size.width * self.size.height); j++)
    {
        UIColor *pColor = UIColorFromHex((unsigned int)pixels[j]);
        if ([pColor isEqual:color]) {

            count++;

        }
        
    }
    
    return count;
    
}



/**
 *  匹配点的颜色,返回信息数组， 符合YES 不符合NO
 */
- (NSArray *)fixColor:(UIColor *)color {
    
    // 分配内存
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        int bc = ptr[0];// = 透明度
        int gc = ptr[1];// = p
        int rc = ptr[2];// = r
        int ac = ptr[3];
        UIColor *rColor = RGBAColor(rc, gc, bc, ac);
        
        
        BOOL isEquel = [rColor isEqual:color];
        
        [array addObject:@(isEquel)];
        
    }
    
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return array;
    
}



/**
 *  突出points中下标为YES的点 其余点均置为baseColor（baseColor 目前可能无效 默认为白色）
 */
- (UIImage *)extrudePoints:(NSArray *)points baseColor:(UIColor *)baseColor {
    UIImage *image = self;
    
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    
    //处理默认颜色
    CGFloat components[4];
    [baseColor getRGBComponents:components];
    
    int rc = components[0]*255;
    int gc = components[1]*255;
    int bc = components[2]*255;
    int ac = components[3]*255;
    
    // 遍历像素
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < imageWidth * imageHeight; i++, pCurPtr++)
    {
        
        if (![points[i] boolValue]) {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = ac;
            ptr[1] = bc;
            ptr[2] = gc;
            ptr[3] = rc;
            
        }
    }
        

    
    {
        // 将内存转成image
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
        CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
        
        CGDataProviderRelease(dataProvider);
        
        UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
        
        // 释放
        CGImageRelease(imageRef);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
        return resultUIImage;
    }


}


/**
 *  返回一张图片 除points 中下标为YES的点外 其余点均置为baseColor（baseColor 目前可能无效 默认为白色）
 */
- (UIImage *)extrudeWithComponent:(void (^)(uint8_t * pointABGR))component {
    UIImage *image = self;
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
        
    // 遍历像素
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < imageWidth * imageHeight; i++, pCurPtr++)
    {
        
        uint8_t* pointABGR = (uint8_t*)pCurPtr;
    
        
        if (component) {
            component(pointABGR);
        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
    
}



/**
 *  不很明白具体作用，应该是用来释放处理完的data的
 */
/* 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}



/*
 
 uint8_t* ptr = (uint8_t*)pCurPtr;
 
 int ac = ptr[0];// = 透明度
 int bc = ptr[1];// = p
 int gc = ptr[2];// = r
 int rc = ptr[3];
 
 int value = *pCurPtr;//UInt32 *
 
 int r = ((value & 0xFF000000) >> 24);
 int g = ((value & 0xFF0000) >> 16);
 int b = ((value & 0xFF00) >> 8);
 int a = (value & 0xFF);
 
 */




@end
