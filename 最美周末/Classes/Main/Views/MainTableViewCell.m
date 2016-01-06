//
//  MainTableViewCell.m
//  最美周末
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainModel.h"
@interface MainTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(MainModel *)model{
     [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.activityPriceLabel.text = model.price;
    self.nameLabel.text = model.title;
    if ([model.type integerValue] != RecommendTypeActivity) {
        self.activityDistanceBtn.hidden = YES;
    }else{
        self.activityDistanceBtn.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
