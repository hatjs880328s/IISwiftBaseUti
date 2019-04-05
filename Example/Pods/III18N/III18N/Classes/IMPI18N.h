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

#import <Foundation/Foundation.h>

#define IMPLocalizedString(key) [IMPI18N localizedStringForKey:key value:@"" table:nil]
#define IMPLocalizedStringFromTable(key, tbl) [IMPI18N localizedStringForKey:(key) value:@"" table:(tbl)]


@interface IMPI18N : NSObject

//初始化语言文件
+(void)initUserLanguage;
//获取应用当前语言
+(NSString *)userLanguage;
//设置当前语言
+(void)setUserlanguage:(NSString *)language;

+ (NSLocale *)currentLocal;

+ (BOOL)isChina;

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tbl;

+ (NSString *)localizedCurrency:(NSDecimalNumber *)value;

+ (NSString *)localizedDateString:(NSDate *)date dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

@end
