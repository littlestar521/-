//
//  ActivityDetailViewController.m
//  最美周末
//  活动详情
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityView.h"
@interface ActivityDetailViewController ()
{

    NSString *_phoneNumber;
}

@property (strong, nonatomic) IBOutlet ActivityView *activitydetailView;
//@property(nonatomic,strong)



@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    //地图
    [self.activitydetailView.mapBtn addTarget:self action:@selector(makeMapAction:) forControlEvents:UIControlEventTouchUpInside];

    //打电话
    [self.activitydetailView.makeCallBtn addTarget:self action:@selector(makeCallBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self showBackBtn];
    [self getModel];
}
#pragma mark ------ Custom Method
- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activitydetailView.dataDic = successDic;
        }else{
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}
//地图
- (void)makeMapAction:(UIButton *)btn{

}
//打电话
- (void)makeCallBtnAction:(UIButton *)btn{
    //程序外打电话,打完电话之后不返回当前应用程序
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    //程序内打电话,打完电话之后返回当前应用程序
    UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNumber]]];
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
