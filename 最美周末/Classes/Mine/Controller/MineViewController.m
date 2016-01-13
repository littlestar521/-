//
//  MineViewController.m
//  最美周末
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *headImageBtn;
@property(nonatomic,strong)UILabel *nikeNameLabel;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSMutableArray *titleArray;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存",@"用户反馈",@"分享给好友",@"给我评分",@"当前版本 1.0", nil] ;
    self.imageArray = @[@"icon_ele",@"icon_user",@"list_like_heart",@"icon_msg",@"ac_details_img"];

    [self setUpTableViewHeaderView];
    self.navigationController.navigationBar.barTintColor = MineColor;
    [self.view addSubview:self.headImageBtn];
    [self.view addSubview:self.nikeNameLabel];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存（%.02f）",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
#pragma mark -------------  UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell  = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArray.count;
}
#pragma mark -------------  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {//清除缓存
            NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case 1:
        {//发送邮件（用户反馈）
            [self sendEmail];
        }
            break;
        case 2:
        {//
            
        }
            break;
        case 3:
        {//评分
            NSString *str = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {//检测当前版本
            [ProgressHUD show:@"正在为您检测中···"];
            [self performSelector:@selector(checkAppversion) withObject:nil afterDelay:2.0];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -------------  Custom Method
- (void)setUpTableViewHeaderView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    headView.backgroundColor = MineColor;
    self.tableView.tableHeaderView = headView;
    self.headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headImageBtn.frame = CGRectMake(20, 20, 130, 130);
    [self.headImageBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.headImageBtn setBackgroundColor:[UIColor whiteColor]];
    [self.headImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headImageBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.headImageBtn.layer.cornerRadius = 65;
    self.headImageBtn.clipsToBounds = YES;
}
- (void)login{

}
- (void)sendEmail{
    Class mailClass = NSClassFromString(@"");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
      
    //初始化
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    //设置主题
    [mailVC setSubject:@"用户反馈"];
    
    //设置收件人
    NSArray *receive = [NSArray arrayWithObjects:@"2891529590@qq.com",nil];
    [mailVC setToRecipients:receive];
    //设置发送内容
    NSString *emailBody = @"请留下您宝贵意见";
    [mailVC setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailVC animated:YES completion:nil];
        }else{
            MJJLog(@"未配置邮箱");
        }
    }else{
            MJJLog(@"当前设备不支持");
  }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)checkAppversion{
    [ProgressHUD showSuccess:@"当前已是最新版本。"];
}
#pragma mark -------------  Lazy Loading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44)];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}
- (UILabel *)nikeNameLabel{
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 90, kScreenWidth-200 , 40)];
        self.nikeNameLabel.numberOfLines = 0;
        self.nikeNameLabel.text = @"欢迎来到 最美周末";
        self.nikeNameLabel.textColor = [UIColor whiteColor];
    }
    return _nikeNameLabel;
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
