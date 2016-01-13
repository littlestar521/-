//
//  DiscoverModel.m
//  最美周末
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.activityId = dic[@"id"];
        self.type = dic[@"type"];
    }
    return self;
}


@end
