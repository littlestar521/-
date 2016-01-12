//
//  HotThemeTableViewCell.m
//  最美周末
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HotThemeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotThemeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *loveCountLabel;

@end
@implementation HotThemeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setHotModel:(HotThemeModel *)hotModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.img] placeholderImage:nil];
    self.loveCountLabel.text = hotModel.counts;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
