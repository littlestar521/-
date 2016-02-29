//
//  AppDelegate.m
//  最美周末
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
//1.引入框架
#import <CoreLocation/CoreLocation.h>
//5.遵循代理协议
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,CLLocationManagerDelegate>
{
    //2.框架定位所需要的类的实例对象
    CLLocationManager *_locationManager;
    //创建地理编码对象
    CLGeocoder *_geocoder;
}
@property(nonatomic,strong)UINavigationController *nav;

@property(nonatomic,strong)NSString *wbCurrentUserID;
@property(nonatomic,strong)NSString *wbRefreshToken;


@end
@interface WBBaseRequest ()
- (void)debugPrint;
@end

@interface WBBaseResponse ()
- (void)debugPrint;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //3.初始化定位对象
    _locationManager = [[CLLocationManager alloc]init];
    //初始化地理编码对象
    _geocoder = [[CLGeocoder alloc]init];
    //4.判断定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        MJJLog(@"用户位置服务不可用");
    }
    //6.如果没有授权，请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //6.1设置代理
        _locationManager.delegate = self;
        //6.2设置定位精度，精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //6.3定位频率，每隔多少米定位一次
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        //6.4启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
    //self.self.tabBarVC
    self.tabBarVC = [[UITabBarController alloc]init];
    //创建被管理的视图控制器
    //主页
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainSB.instantiateInitialViewController;
    mainNav.tabBarItem.title = @"主页";
    mainNav.tabBarItem.image = [UIImage imageNamed:@"53-house.png"];
    /*
     UIImage *selectImage = [UIImage imageNamed:@"53-house.png"];
     
     mainNav.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //规定图片显示位置，上左下右的顺序显示
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    */
    
    UIStoryboard *discoverSB = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverSB.instantiateInitialViewController;
    discoverNav.tabBarItem.title = @"发现";
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"71-compass.png"];
    
    UIStoryboard *mineSB = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineSB.instantiateInitialViewController;
    mineNav.tabBarItem.title = @"我";
    mineNav.tabBarItem.image = [UIImage imageNamed:@"28-star.png"];
    
    //添加被管理的视图控制器
    self.tabBarVC.viewControllers = @[mainNav,discoverNav,mineNav];
    self.tabBarVC.tabBar.tintColor = [UIColor orangeColor];
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarVC;
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    //微信
    [WXApi registerApp:@"wx963f2bc6f214e3a9"];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark ------- Share WeiboSDK

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
}
//- (void)onReq:(BaseReq *)req{
//}
//- (void)onResp:(BaseResp *)resp{
//}
/*
 @pragma manager  当前使用的定位对象
 @pragma locations 返回定位的对象是一个数组对象，数组里面元素是CLLocation类型
 */
#pragma mark ------- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    MJJLog(@"%@",locations);
    //从数组中取出第一个定位信息
    CLLocation *location = [locations firstObject];
    //获取坐标
    CLLocationCoordinate2D coordinate = location.coordinate;
    //汉字多了之后就不提示,可在外面写好复制过来
    MJJLog(@"经度：%f  纬度：%f 海拔：%f 航向：%f 行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        MJJLog(@"%@",placeMark.addressDictionary);
    }];
    //如果不需要实时定位，使用完及时关闭定位服务
    [_locationManager stopUpdatingLocation];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
