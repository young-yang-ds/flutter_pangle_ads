//
//  SplashViewController.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/9/12.
//

#import "SplashViewController.h"

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    // logo 判断为空，则全屏展示
    bool fullScreenAd=[self.logo isKindOfClass:[NSNull class]]||[self.logo length]==0;
    // 计算大小
    CGSize size=[[UIScreen mainScreen] bounds].size;
    CGFloat width=size.width;
    CGFloat height=size.height;
    CGFloat adHeight=size.height;// 广告区域的高度
    self.splashView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,width,height)];
    // 非全屏设置 Logo
    if(!fullScreenAd){
        CGFloat logoHeight=112.5;// 这里按照 15% 进行logo 的展示，防止尺寸不够的问题，750*15%=112.5
        adHeight=height-logoHeight;// 广告区域的高度
        // 设置底部 logo
        UIImageView *logoView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:self.logo]];
        logoView.frame=CGRectMake(0, adHeight, width, logoHeight);
        logoView.contentMode=UIViewContentModeCenter;
        // 防止点击 Logo 区域触发 Flutter 层的事件
        logoView.userInteractionEnabled=false;
        [self.splashView addSubview:logoView];
    }
    // 广告请求配置
    PAGAppOpenRequest *request = [PAGAppOpenRequest request];
    // 加载开屏广告
    [PAGLAppOpenAd loadAdWithSlotID:self.posId request:request completionHandler:^(PAGLAppOpenAd * _Nullable appOpenAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to load ad: %@", error.localizedDescription);
            [self dismissPage];
            [self.sp sendErrorEvent:error.code withErrMsg:error.localizedDescription];
        } else {
            self.splashAd = appOpenAd;
            self.splashAd.delegate = self;
            [self.sp sendEventAction:onAdLoaded];
            [self.splashAd presentFromRootViewController:self];
        }
    }];
}

// 销毁页面
- (void) dismissPage{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - PAGLAppOpenAdDelegate

- (void)adDidShow:(PAGLAppOpenAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告曝光事件
    [self.sp sendEventAction:onAdExposure];
    // 设置广告 View
    [self.splashView addSubview:ad.splashView];
    [self.view addSubview:self.splashView];
}

- (void)adDidClick:(PAGLAppOpenAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告点击事件
    [self.sp sendEventAction:onAdClicked];
}

- (void)adDidDismiss:(PAGLAppOpenAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告关闭事件
    [self.sp sendEventAction:onAdClosed];
    [self dismissPage];
}

@end
