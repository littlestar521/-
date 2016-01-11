//
//  HotThemeModel.m
//  最美周末
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HotThemeModel.h"

@implementation HotThemeModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.counts = dic[@"counts"];
        self.img = dic[@"img"];
        self.activityId = dic[@"id"];
    
    }
    return self;
}

@end
