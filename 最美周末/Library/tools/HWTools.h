//
//  HWTools.h
//  最美周末
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject

#pragma mark-------时间转换的相关方法

+ (NSString *)getDataFromString:(NSString *)timestamp;

#pragma mark ------ 根据文字最大显示宽高和文字内容返回文字高度
+ (CGFloat )getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)textFont;

@end
