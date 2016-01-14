
//
//  ShareView.m
//  最美周末
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
@interface ShareView ()<WeiboSDKDelegate>
@property(nonatomic,strong)UIView *shareView;
@property(nonatomic,strong)UIView *blackView;
@end
@implementation ShareView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-170, kScreenWidth, 250)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];

    //黑色底部
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-170)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.8;
    [window addSubview:self.blackView];
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(70, 20, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"shareWeibo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(230, 20, 70, 70);
    [weixinBtn setImage:[UIImage imageNamed:@"shareWeixin1"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weixinBtn];
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(150, 20, 70, 70);
    [friendsBtn setImage:[UIImage imageNamed:@"shareFriends"] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(friendsAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendsBtn];
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(20, 110, kScreenWidth-40, 40);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setBackgroundColor:[UIColor redColor]];   
    [removeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:1.0 animations:^{

    }];
  
}
- (void)cancel{
    [UIView animateWithDuration:1.0 animations:^{
    [self.blackView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
    }];
    
}
//微博
- (void)weiboAction{
    [self cancel];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"SSO_From":@"SendMessageToWeiboViewController",@"Other_Info_1":[NSNumber numberWithInt:123],@"Other_Info_2":@[@"obj1",@"obj2"],@"Other_Info_3":@{@"key1":@"obj1",@"key2":@"obj2"}};
    [WeiboSDK sendRequest:request];
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{

}
- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"赶快来和小伙伴们一起度过“最美周末”吧！！！";
    
    return message;
}
//微信
- (void)weixinAction{
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc]init];
    request.text = @"测试内容";
    request.bText = YES;
    request.scene = WXSceneSession;
    [WXApi sendReq:request];
}
//朋友圈
- (void)friendsAction{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"Best周末.jpg"]];
    //缩略图
    WXImageObject *imageObject = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Best周末" ofType:@".jpg"];//图片路径
    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc]init];
    request.bText = NO;
    request.message = message;
    request.scene = WXSceneTimeline;//分享到朋友圈
    [WXApi sendReq:request];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
