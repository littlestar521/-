//
//  GoodActivityTableViewCell.m
//  最美周末
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ageImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *loveCountLabel;

@end
@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 95);
}
- (void)setGoodModel:(GoodActivityModel *)goodModel{
    
//    NSLog(@"%@",goodModel.title);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    self.ageLabel.text = goodModel.age;
    self.loveCountLabel.text = [NSString stringWithFormat:@"%@", goodModel.counts];
    self.activityTitleLabel.text = goodModel.title;
    self.activityPriceLabel.text = goodModel.price;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
