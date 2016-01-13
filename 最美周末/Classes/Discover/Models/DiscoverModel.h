//
//  DiscoverModel.h
//  最美周末
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
@property(nonatomic,strong) NSString *activityId;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
