//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// IIImageUtility.h
//
// Created by    Noah Shan on 2018/7/9
// InspurEmail   shanwzh@inspur.com
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IIImageUtilityOC : NSObject


+ (UIColor *)colorAtPixel:(CGPoint)point realimage: (UIImage *)image ;

+ (UIImage *)getImage:(UIView *)shareView;

+ (NSPort *)getMachport;

+ (NSDate *)getTime ;

@end
