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
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClassfyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *listArray;//全部列表数据
@property(nonatomic,strong)NSMutableArray *activityArray; //推荐活动数据
@property(nonatomic,strong)NSMutableArray *themeArray;//推荐专题
@property(nonatomic,strong)NSMutableArray *adArray;//广告
@property(nonatomic,strong)UIScrollView *carouseView;
@property(nonatomic,strong)UIPageControl *pageControll;
//定时器用于屏幕滚动播放
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIButton *activityBtn;
@property(nonatomic,strong)UIButton *themeBtn;
@property(nonatomic,strong)UIView *tableViewHeaderView;

@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
// 设置navigationBar颜色
    self.navigationController.navigationBar.barTintColor = MineColor;
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
    self.tabBarController.tabBar.hidden = YES;

    [self configTableViewHeaderView];
    //网络请求
    [self requestModel];
    //启动定时器
    [self startTimer];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    mainCell.model = array[indexPath.row];
    return mainCell;

}

#pragma mark------UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
    
}
//自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    UIImageView *sectionView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-160, 5, 320, 16)];
    if (section == 0) {
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
        
    }else{
        sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
       
    }
    [view addSubview:sectionView];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //活动id
    MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityDetailViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
        
        activityVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        themeVC.themeId = mainModel.activityId;
        [self.navigationController pushViewController:themeVC animated:YES];
    
    }
}
#pragma mark-------- Custom Method
//选择城市
- (void)selectCityAction:(UIBarButtonItem *)btn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectCityVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}
//搜索关键字
- (void)searchActivityAction:(UIButton *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//自定义tableview头部
- (void)configTableViewHeaderView{
    
    self.tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 343)];
    self.tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    //添加图片
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 186)];
        [imageView sd_setImageWithURL:self.adArray[i][@"url"] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        [self.carouseView addSubview:imageView];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchADAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouseView addSubview:touchBtn];
    }
    [self.tableViewHeaderView addSubview:self.carouseView];
    self.pageControll.numberOfPages = self.adArray.count;
    [self.tableViewHeaderView addSubview:self.pageControll];
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kScreenWidth / 4, 186, kScreenWidth / 4, kScreenWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableViewHeaderView addSubview:btn];
    }
    [self.tableViewHeaderView addSubview:self.activityBtn];
    [self.tableViewHeaderView addSubview:self.themeBtn];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    
    
}

//网络请求(包括解析plist)
- (void)requestModel{

    AFHTTPSessionManager *sessionManage = [AFHTTPSessionManager manager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManage GET:kMainDataList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
        
        NSDictionary *dic = resultDic[@"success"];
        
        //推荐活动
        NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dit in acDataArray) {
            MainModel *model = [[MainModel alloc]initWithDictionary:dit];
            [self.activityArray addObject:model];
        }
        [self.listArray addObject:self.activityArray];
        //推荐专题
        NSArray *rcDataArray = dic[@"rcData"];
        for (NSDictionary *dit1 in rcDataArray) {
            MainModel *model = [[MainModel alloc]initWithDictionary:dit1];
            [self.themeArray addObject:model];
            
        }
        [self.listArray addObject:self.themeArray];
        //刷新数据
        [self.tableView reloadData];
        //广告
        NSArray *adDataArray = dic[@"adData"];
         for (NSDictionary *dit2 in adDataArray) {
             NSDictionary *dit3 = @{@"url":dit2[@"url"],@"type":dit2[@"type"],@"id":dit2[@"id"]};
            [self.adArray addObject:dit3];
        }
        //刷新数据
        [self configTableViewHeaderView];
        NSString *cityName = dic[@"cityname"];
        //以请求回来的城市作为导航栏按钮标题
        self.navigationItem.leftBarButtonItem.title = cityName;
            
        }else{
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
                  
}
#pragma mark ------ 懒加载
//懒加载
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
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}
- (UIView *)carouseView{
    if (_carouseView == nil) {
        //添加轮播图
        self.carouseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
        self.carouseView.contentSize = CGSizeMake(self.adArray.count*kScreenWidth, 186);
        self.carouseView.pagingEnabled = YES;//整屏滑
        //不显示水平方向滚动条
        self.carouseView.showsHorizontalScrollIndicator = NO;
        self.carouseView.delegate = self;
    }
    return _carouseView;
}
- (UIButton *)activityBtn{
    if (_activityBtn == nil) {
        //精选活动
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0, 186 + kScreenWidth / 4, kScreenWidth / 2, 343 - 186 - kScreenWidth / 4);
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        [self.activityBtn addTarget:self action:@selector(goodActivity:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _activityBtn;
}
- (UIButton *)themeBtn{
    if (_themeBtn == nil) {
        //热门专题
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake(kScreenWidth / 2, 186 + kScreenWidth / 4, kScreenWidth / 2, 343 - 186 - kScreenWidth / 4);
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        self.themeBtn.tag = 105;
        [self.themeBtn addTarget:self action:@selector(hotActivity:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _themeBtn;
}
- (UIView *)pageControll{
    if (_pageControll == nil) {
        //创建小圆点
        self.pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 156, kScreenWidth, 30)];
        
        self.pageControll.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageControll addTarget:self action:@selector(pageControllAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControll;
}

//点击广告
- (void)touchADAction:(UIButton *)btn{
    //从数组中的字典里取出type类型
    NSString *type = self.adArray[btn.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ActivityDetailViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
        //活动id
        activityVC.activityId = self.adArray[btn.tag - 100][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        themeVC.themeId = self.adArray[btn.tag - 100][@"id"];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}
#pragma mark ----- 六个按钮的实现方法

- (void)mainActivity:(UIButton *)btn{
    ClassfyViewController *classfyVC = [[ClassfyViewController alloc]init];
    classfyVC.classifyListType = btn.tag - 100 + 1;
    [self.navigationController pushViewController:classfyVC animated:YES];
}
- (void)hotActivity:(UIButton *)btn{
    HotActivityViewController *hotVC = [[HotActivityViewController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:hotVC animated:YES];
}
- (void)goodActivity:(UIButton *)btn{
    GoodActivityViewController *goodVC = [[GoodActivityViewController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:goodVC animated:YES];

}

#pragma mark ------首页轮播图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取scollView页面宽度
    CGFloat pageWidth = self.carouseView.frame.size.width;
    //获取scollView停止移动时的偏移量
    CGPoint offset = self.carouseView.contentOffset;
    //通过偏移量计算当前页面数
    NSInteger pageNum = offset.x/pageWidth;
    self.pageControll.currentPage = pageNum;
    
}
//让scrollView的页面跟随pageControl的滚动移动
- (void)pageControllAction:(UIPageControl *)pageControll{
    //第一步：pageControll当前点击的页面
    NSInteger pageNum = pageControll.currentPage;
    //第二步：获取页面的宽度
    CGFloat pageWidth = self.carouseView.frame.size.width;
    //让scrollView滚动到第几页
    self.carouseView.contentOffset = CGPointMake(pageNum*pageWidth, 0);
}
#pragma mark------轮播图之定时器
- (void)startTimer{
    //防止定时器重复创建
    if (_timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//每两秒执行一次,图片自动轮播
- (void)rollAnimation{
    //sel数组个数可能为0，当对0取余时没有意义
    //把page当前页+1
    if (self.adArray.count > 0) {
        NSInteger rollPage = (self.pageControll.currentPage + 1) % self.adArray.count;
        self.pageControll.currentPage = rollPage;
        //计算scollView应该滚动的坐标
        CGFloat offsetX = self.pageControll.currentPage*kScreenWidth;
        [self.carouseView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

//当scollView是手动滑动的时候，定时器依然在计算时间，可能我们刚刚滑到下一页，导致在当前页停留的时间不够两秒。
//解决方案在scollView开始移动的时候结束定时器
//在scollView移动完毕的时候再启动定时器
//scollview将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止计时器
    [self.timer invalidate];
    self.timer = nil;//停止计时器并置为空，再次启动定时器才能正常执行
}
//scollView将要结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
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
