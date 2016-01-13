
//
//  ActivityThemeView.m
//  最美周末
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ActivityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HWTools.h"
@interface ActivityThemeView ()
{//保存上一个图片底部的高度
    CGFloat _prevousImageBottom;
    //上涨图片的高度
    CGFloat _lastLabelBottom;
}
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIImageView *headImageView;

@end
@implementation ActivityThemeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 6000);
    [self addSubview: self.mainScrollView];
    [self.mainScrollView addSubview:self.headImageView];
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _prevousImageBottom+30);
}
- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc]initWithFrame:self.frame ];
    }
    return _mainScrollView;
}
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 190)];
        
    }
    return _headImageView;
    
}

- (void)drawContentWithArray:(NSArray *)contentArray{
    
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_prevousImageBottom > 200) {//如果图片底部高度没有值(也就是小于500)，也就说明是加载第一个label，那么y的值不应该减去500
            y = 200 + _prevousImageBottom - 200;
        }else{
            y = 200 + _prevousImageBottom;
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
        _lastLabelBottom = label.bottom + 30;
        
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
