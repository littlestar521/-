//
//  GoodActivityModel.h
//  最美周末
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodActivityModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *counts;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *activityId;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,assign)CGFloat *lat;
@property(nonatomic,assign)CGFloat *lng;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
