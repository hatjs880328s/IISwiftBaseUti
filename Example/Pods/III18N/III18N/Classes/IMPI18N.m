// ==============================================================================
//
// This file is part of the IMP Cloud.
//
// Create by Shiguang <shiguang@richingtech.com>
// Copyright (c) 2016-2017 inspur.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "IMPI18N.h"

@implementation IMPI18N
static NSBundle *bundle = nil;

+ ( NSBundle * )bundle {
    return bundle;
}

+(void)initUserLanguage {
    NSString *string;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"] == nil) {
        //获取系统当前语言版本
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"en"]) {
            //英文
            string = @"en";
        }
        else if ([language hasPrefix:@"zh"]) {
            // 简体中文
            string = @"zh-Hans";
        }
        else {
            //其他语言不支持，默认为简体中文
            string = @"zh-Hans";
        }
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"userLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        string = [self userLanguage];
        if(string.length == 0) {
            //获取系统当前语言版本
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *language = [languages objectAtIndex:0];
            if ([language hasPrefix:@"en"]) {
                //英文
                string = @"en";
            }
            else if ([language hasPrefix:@"zh"]) {
                // 简体中文
                string = @"zh-Hans";
            }
            else {
                //其他语言不支持，默认为简体中文
                string = @"zh-Hans";
            }
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"userLanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    if (path.length == 0) {
        bundle = [NSBundle mainBundle];
    }
    else {
        bundle = [NSBundle bundleWithPath:path];//生成bundle
    }
}

+(NSString *)userLanguage {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
}

+(void)setUserlanguage:(NSString *)language {
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"userLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSLocale *)currentLocal {
     return [[NSLocale alloc] initWithLocaleIdentifier:[self userLanguage]];
}

+(NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tbl {
    return [[self bundle] localizedStringForKey:key value:value table:tbl];
}

+ (NSString *)localizedCurrency:(NSDecimalNumber *)value {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.locale = [self currentLocal];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [currencyFormatter stringFromNumber:value];
}

+ (BOOL)isChina {
    if ([[self userLanguage] rangeOfString:@"zh"].location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)localizedDateString:(NSDate *)date dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    dateformate.locale = [self currentLocal];
    dateformate.dateStyle = dateStyle;
    dateformate.timeStyle = timeStyle;
    return [dateformate stringFromDate:date];
}

@end
