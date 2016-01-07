//
//  ActivityView.h
//  最美周末
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeCallBtn;
@property(nonatomic,strong) NSDictionary *dataDic;

@end
