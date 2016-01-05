//
//  MainModel.m
//  最美周末
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "MainModel.h"

@interface MainModel()

@end

@implementation MainModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.type = dic[@"type"];
        
        if ([self.type integerValue] == RecommendTypeActivity) {
            //如果是推荐活动
            self.price = dic[@"price"];
            self.address = dic[@"address"];
            self.counts = dic[@"counts"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
        }else{
            //如果是推荐专题
            self.activityDescription = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.activityId = dic[@"id"];
        
        
        
    }
    return self;
}
//- (void)getModelWithDic

@end
