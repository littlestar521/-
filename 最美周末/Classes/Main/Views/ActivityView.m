//
//  ActivityView.m
//  最美周末
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLabel;



@end


@implementation ActivityView

- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityLabel.text = dataDic[@"title"];
    self.activityPhoneLabel.text = dataDic[@"tel"];
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人", dataDic[@"fav"]];
    self.activityPriceLabel.text = dataDic[@"price"];
    self.activityAddressLabel.text = dataDic[@"address"];
    

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
