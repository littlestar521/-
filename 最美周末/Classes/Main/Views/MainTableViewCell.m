//
//  MainTableViewCell.m
//  最美周末
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "MainTableViewCell.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
