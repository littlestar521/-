//
//  HotActivityViewController.m
//  最美周末
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "HotActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "HotThemeTableViewCell.h"
#import "ThemeViewController.h"
#import "HotThemeModel.h"
#import "HWTools.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface HotActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property(nonatomic,assign)BOOL refreshing;
@property(nonatomic,strong)NSMutableArray *rcArray;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门专题";

    [self showBackBtn];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotThemeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    
}
#pragma mark ------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotThemeTableViewCell *hotCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    hotCell.hotModel = self.rcArray[indexPath.row];
    return hotCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rcArray.count;
}

#pragma mark -------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *themeVC = [[ThemeViewController alloc]init];
    HotThemeModel *hotModel = self.rcArray[indexPath.row];
    themeVC.themeId = hotModel.activityId;
    [self.navigationController pushViewController:themeVC animated:YES];
    
    
}
#pragma mark--------PullingRefreshDelagate
//tableView下拉刷新开始时调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//tableView上拉刷新开始时调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}
//加载数据
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",kHotActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *rcDataArray = dic[@"rcData"];
            self.rcArray = [NSMutableArray new];
            for (NSDictionary *dit in rcDataArray) {
                HotThemeModel *model = [[HotThemeModel alloc]initWithDictionary:dit];
                [self.rcArray addObject:model];
            }
            [self.tableView reloadData];
        }
//                MJJLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                MJJLog(@"%@",error);
    }];
    
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidScroll:scrollView];
}

#pragma mark--------LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth,kScreenHeight-64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 150;
        
    }
    return _tableView;
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
