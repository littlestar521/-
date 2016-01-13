
//
//  ClassfyViewController.m
//  最美周末
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ClassfyViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "GoodActivityModel.h"
#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"


@interface ClassfyViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;//定义请求页码
}
@property(nonatomic,strong)PullingRefreshTableView *tableView;
//负责展示的数组
@property(nonatomic,strong)NSMutableArray *showDataArray;
@property(nonatomic, strong) NSMutableArray *showArray;
@property(nonatomic, strong) NSMutableArray *touristArray;
@property(nonatomic, strong) NSMutableArray *studyArray;
@property(nonatomic, strong) NSMutableArray *familyArray;
@property(nonatomic,assign)BOOL refreshing;
@property(nonatomic,strong)VOSegmentedControl *segmentControl;

@end

@implementation ClassfyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackBtn];
    
    self.tabBarController.tabBar.hidden = YES;

    self.showDataArray = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil ] forCellReuseIdentifier:@"cell"];
    //解决多余cell的显示问题
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    
    //根据上一页选择的按钮，确定显示第几页数据
    [self showPreviousSelectBtn];
    [self.tableView launchRefreshing];
    
    [self chooseRequest];
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [self viewWillDisappear:animated];
//    [ProgressHUD dismiss];
//}
#pragma mark  ------------  UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    goodCell.goodModel = self.showDataArray[indexPath.row];
    return goodCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}

#pragma mark ------ UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    GoodActivityModel *goodActivityModel = self.showDataArray[indexPath.row];
    activityVC.activityId = goodActivityModel.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
    
}
#pragma mark--------PullingRefreshDelagate
//tableView下拉刷新开始时调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//tableView上拉加载开始时调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageCount += 1;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark   -------------    Custom Method
- (void)chooseRequest{
    //每次进入列表中，请求接口数据
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFamilyRequest];
            break;
        default:
            break;
    }
}
- (void)getShowRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"拼命加载中···"];
    //typeid = 6
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%lu&typeid=%@",kClassifyList,_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"已为您加载成功。"];
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *acDataArray = dic[@"acData"];
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dit in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc]initWithDictionary:dit];
                [self.showArray addObject:model];
            }
        }
        [self showPreviousSelectBtn];
        //        MJJLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"网络有误%@",error]];
    }];
    
}
- (void)getTouristRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"拼命加载中···"];
    //typeid = 23
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%lu&typeid=%@",kClassifyList,_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"已为您加载成功。"];
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *acDataArray = dic[@"acData"];
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dit in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc]initWithDictionary:dit];
                [self.touristArray addObject:model];
            }
        }
        [self showPreviousSelectBtn];
        //        MJJLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [ProgressHUD showError:[NSString stringWithFormat:@"网络有误%@",error]];
    }];
    
}
- (void)getStudyRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"拼命加载中···"];
    //typeid = 22
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%lu&typeid=%@",kClassifyList,_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"已为您加载成功。"];
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *acDataArray = dic[@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dit in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc]initWithDictionary:dit];
                [self.studyArray addObject:model];
            }
        }
             [self showPreviousSelectBtn];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ProgressHUD showError:[NSString stringWithFormat:@"网络有误%@",error]];
     }];
    
}

- (void)getFamilyRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"拼命加载中···"];
    //typeid = 21
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%lu&typeid=%@",kClassifyList,_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"已为您加载成功。"];
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *acDataArray = dic[@"acData"];
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dit in acDataArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc]initWithDictionary:dit];
                [self.familyArray addObject:model];
            }
        }
            [self showPreviousSelectBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"网络有误%@",error]];
    }];
    
}
- (void)showPreviousSelectBtn{
    if (self.refreshing) {//下拉删除原来的数据
    if (self.showDataArray.count > 0 ) {
        [self.showDataArray removeAllObjects];
       }
    }

    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;

        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;

        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
            
        default:
            break;
    }
    //刷新tableView，它会重新执行tableview的所有代理
    [self.tableView reloadData];
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
#pragma mark   -------------    Lazy Loading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0,40, kScreenWidth, kScreenHeight- 64 -40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}
- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}
- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}
- (NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}
- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}
#pragma mark   -------------    VOSegmentedControl
- (VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"}]];
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.backgroundColor = [UIColor whiteColor];
        self.segmentControl.selectedBackgroundColor = self.segmentControl.backgroundColor;
        self.segmentControl.allowNoSelection = NO;
        self.segmentControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segmentControl.indicatorThickness = 4;
        self.segmentControl.selectedSegmentIndex = self.classifyListType-1;
        //返回点击的是哪个按钮
        [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];    }
    return _segmentControl;
}
- (void)segmentCtrlValuechange:(VOSegmentedControl *)segmentControl{
    self.classifyListType = segmentControl.selectedSegmentIndex + 1 ;
    [self chooseRequest];
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
