//
//  MainViewController.m
//  最美周末
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFHTTPSessionManager.h>
#import "MainModel.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *listArray;//全部列表数据
@property(nonatomic,strong)NSMutableArray *activityArray; //推荐活动数据
@property(nonatomic,strong)NSMutableArray *themeArray;//推荐专题


@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
// 设置navigationBar颜色   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96/255.0 green:185/255.0 blue:191/255.0 alpha:1.0];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage: [UIImage imageNamed: @"btn_search.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarbtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarbtn;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self configTableViewHeaderView];
    //网络请求
    [self requestModel];
    
}
#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *array = self.listArray[indexPath.section];
    MainModel *model = array[indexPath.row];
    mainCell.model = model;
    return mainCell;

}

#pragma mark------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.activityArray.count;
//    }
//    return self.themeArray.count;
//}
////自定义分区头部
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
//    view.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = view;
//    return view;
//}
#pragma mark-------- Custom Method
- (void)selectCityAction:(UIBarButtonItem *)btn{

}
- (void)searchActivityAction:(UIButton *)btn{
}
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
    tableViewHeaderView.backgroundColor = [UIColor cyanColor];
    self.tableView.tableHeaderView = tableViewHeaderView;
}
//网络请求
- (void)requestModel{
    //http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1
    NSString *urlString = @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1";
    AFHTTPSessionManager *sessionManage = [AFHTTPSessionManager manager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManage GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        NSDictionary *dic = resultDic[@"success"];
        NSArray *acDataArray = dic[@"acData"];
        for (NSDictionary *dit in acDataArray) {
            MainModel *model = [[MainModel alloc]initWithDictionary:dit];
            [self.activityArray addObject:model];
            
        }
        [self.listArray addObject:self.activityArray];
        
        NSArray *rcDataArray = dic[@"rcData"];
        for (NSDictionary *dit in rcDataArray) {
            MainModel *model = [[MainModel alloc]initWithDictionary:dit];
            [self.themeArray addObject:model];
            
        }
        [self.listArray addObject:self.themeArray];
        //刷新数据
        [self.tableView reloadData];
//        //广告
//        NSArray *adDataArray = dic[@"adData"];
//        for (NSDictionary *dit in adDataArray) {
//            MainModel *model = [[MainModel alloc]initWithDictionary:dit];
//            [self.themeArray addObject:model];
//            
//        }

        if ([status isEqualToString:@"success"] && code == 0) {
           
            NSArray *adDataArray = dic[@"adData"];
            
            NSString *cityName = dic[@"cityName"];
            //以请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            
        }else{
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
                  
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
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
