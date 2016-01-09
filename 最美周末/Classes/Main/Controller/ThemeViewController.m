

//
//  ThemeViewController.m
//  最美周末
//  活动专题
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityThemeView.h"
@interface ThemeViewController ()
@property(nonatomic,strong)ActivityThemeView *themeView;
@end

@implementation ThemeViewController
- (void)loadView{
    [super loadView];
    self.themeView = [[ActivityThemeView alloc]initWithFrame:self.view.frame];
    self.view = self.themeView;
    [self getModel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark--------Custom Method
//网络请求
- (void)getModel{
    AFHTTPSessionManager * sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityTheme,self.themeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code =[dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"]&&code == 0) {
            self.themeView.dataDic = dic[@"success"];
            self.navigationItem.title = dic[@"success"][@"title"];
            
        }else {
            }
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

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
