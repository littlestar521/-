//
//  HWTools.m
//  最美周末
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools

#pragma mark-------时间转换的相关方法

+ (NSString *)getDataFromString:(NSString *)timestamp{
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
    
}
#pragma mark ------ 根据文字最大显示宽高和文字内容返回文字高度
+ (CGFloat )getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)textFont{
//    CGFloat textHeight;
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]} context:nil];
    return textRect.size.height;

}


@end
