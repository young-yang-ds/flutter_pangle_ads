//
//  AdBannerView.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/8/31.
//

#import "AdBannerView.h"
// Banner 广告 View
@interface AdBannerView()<FlutterPlatformView,PAGLBannerAdDelegate>
@property (strong,nonatomic) PAGLBannerAd *bannerAd;
@property (strong,nonatomic) UIView *bannerView;
@property bool autoClose;
@end
// Banner 广告 View
@implementation AdBannerView
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                       plugin:(FlutterPangleAdsPlugin*) plugin{
    if (self = [super init]) {
        FlutterMethodCall *call=[FlutterMethodCall methodCallWithMethodName:@"AdBannerView" arguments:args];
        [self showAd:call eventSink:plugin.eventSink];
    }
    return self;
}

- (UIView*)view {
    return self.bannerView;
}
// 加载广告
- (void)loadAd:(FlutterMethodCall *)call{
    // 刷新间隔
    int interval=[call.arguments[@"interval"] intValue];
    int width = [call.arguments[@"width"] intValue];
    int height = [call.arguments[@"height"] intValue];
    self.autoClose = [call.arguments[@"autoClose"] boolValue];
    // 创建 Banner 容器
    self.bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    // 配置 Banner 广告请求
    PAGBannerRequest *request = [PAGBannerRequest request];
    PAGBannerAdSize bannerSize = PAGBannerAdSizeBanner;
    // 加载 Banner 广告
    [PAGLBannerAd loadAdWithSlotID:self.posId request:request adSize:bannerSize completionHandler:^(PAGLBannerAd * _Nullable bannerAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to load banner ad: %@", error.localizedDescription);
            [self sendErrorEvent:error.code withErrMsg:error.localizedDescription];
        } else {
            self.bannerAd = bannerAd;
            self.bannerAd.delegate = self;
            self.bannerAd.rootViewController = self.rootController;
            // PAG SDK Banner 广告使用 presentFromRootViewController 自动展示
            // 如果需要获取视图，检查是否有 view 属性
            if ([self.bannerAd respondsToSelector:@selector(view)]) {
                UIView *adView = [self.bannerAd performSelector:@selector(view)];
                if (adView) {
                    [self.bannerView addSubview:adView];
                }
            }
            [self sendEventAction:onAdLoaded];
        }
    }];
}

#pragma mark PAGLBannerAdDelegate

- (void)adDidShow:(PAGLBannerAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告曝光事件
    [self sendEventAction:onAdExposure];
}

- (void)adDidClick:(PAGLBannerAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告点击事件
    [self sendEventAction:onAdClicked];
}

- (void)adDidDismiss:(PAGLBannerAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    if(self.autoClose){
        [self.bannerView removeFromSuperview];
    }
    // 发送广告关闭事件
    [self sendEventAction:onAdClosed];
}

@end
