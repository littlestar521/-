//
//  GoodActivityModel.m
//  最美周末
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "GoodActivityModel.h"

@implementation GoodActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.age = dict[@"age"];
        self.counts = dict[@"counts"];
        self.price = dict[@"price"];
        self.activityId = dict[@"activityId"];
        self.address = dict[@"address"];
        self.type = dict[@"type"];
//        self.lat = [dict[@"lat"] floatValue];
//        self.lng = [dict[@"lng"] floatValue];
    }
    return self;
}
@end
