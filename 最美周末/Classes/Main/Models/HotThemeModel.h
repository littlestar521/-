//
//  HotThemeModel.h
//  最美周末
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotThemeModel : NSObject
@property(nonatomic,assign)NSString *counts;
@property(nonatomic,copy)NSString *activityId;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
