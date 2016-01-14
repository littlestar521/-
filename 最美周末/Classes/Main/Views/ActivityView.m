//
//  ActivityView.m
//  最美周末
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HWTools.h"
@interface ActivityView ()

{//保存上一个图片底部的高度
    CGFloat _prevousImageBottom;
    //上涨图片的高度
    CGFloat _lastLabelBottom;
}
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
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 5000);
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    
    //活动标题
    self.activityLabel.text = dataDic[@"title"];
    //活动号码
    self.activityPhoneLabel.text = dataDic[@"tel"];
    
    //已有多少人喜欢
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    
    //活动价格
    self.activityPriceLabel.text = [NSString stringWithFormat:@"价格参考：%@", dataDic[@"pricedesc"]] ;
    
    //活动时间
    NSString *startTime = [HWTools getDataFromString: dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDataFromString: dataDic[@"new_end_date"] ];
    self.activityTimeLabel.text = [NSString stringWithFormat:@"正在进行：%@ - %@",startTime,endTime];

    //活动地址
    self.activityAddressLabel.text = dataDic[@"address"];
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    //拿到数据后，重新设置mainScrollView高度
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _lastLabelBottom);

}

- (void)drawContentWithArray:(NSArray *)contentArray{
    
    for (NSDictionary *dic in contentArray) {
        
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_prevousImageBottom > 500) {//如果图片底部高度没有值(也就是小于500)，也就说明是加载第一个label，那么y的值不应该减去500
            y = 500 + _prevousImageBottom - 500;
        }else{
            y = 500 + _prevousImageBottom;
        }
        //如果标题存在
        NSString *title = dic[@"title"];
        if (title != nil) {//如果标题存在，标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, y, kScreenWidth-20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再+30，也就是标题的高度
            y += 30;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, y, kScreenWidth-20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //保留最后一个label的高度，+64是下边tabBar的高度
        _lastLabelBottom = label.bottom + 10 + 64;
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) {//当某个段落中没有图片时，上次图片的高度使用上次label的底部高度+10
            _prevousImageBottom = label.bottom + 10+10;
        }else{
            CGFloat lastImageBottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不只一张时
                    if (lastImageBottom == 0.0) {
                        if (title != nil) {//有title的算上title的30像素
                            imgY = _prevousImageBottom + label.height + 30 + 5+5;
                        }else{
                            imgY = _prevousImageBottom + label.height + 5+5;
                        }
                    }else{
                        imgY = lastImageBottom + 10;
                    }
                }else{
                //单张图片时
                    imgY = label.bottom+10;
                }
                CGFloat width = [urlDic[@"width"]integerValue];
                CGFloat imageHeight = [urlDic[@"height"]integerValue];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, imgY, kScreenWidth-20, (kScreenWidth-20)/width*imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都留最新的图片底部高度
                _prevousImageBottom = imageView.bottom+10;
                if (urlsArray.count > 1) {
                    lastImageBottom = imageView.bottom;
                   
                }
            }
        }
        //保留最后一个lable的底部高度
        _lastLabelBottom = label.bottom > _prevousImageBottom ? label.bottom+70 :_prevousImageBottom+70;
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
