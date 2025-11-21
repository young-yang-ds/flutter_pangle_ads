//
//  AdBannerView.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/8/31.
//

#import "AdBannerView.h"
// Banner 广告 View
@interface AdBannerView()<FlutterPlatformView,PAGBannerAdDelegate>
@property (strong,nonatomic) PAGBannerAd *bannerAd;
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
    // PAG SDK Banner 广告加载
    [PAGBannerAd loadAdWithSlotID:self.posId request:nil completionHandler:^(PAGBannerAd * _Nullable bannerAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to load banner ad: %@", error.localizedDescription);
            [self sendErrorEvent:error.code withErrMsg:error.localizedDescription];
        } else {
            self.bannerAd = bannerAd;
            self.bannerAd.delegate = self;
            // 获取 Banner 视图并添加到容器
            UIView *adView = self.bannerAd.bannerView;
            if (adView) {
                [self.bannerView addSubview:adView];
            }
            [self sendEventAction:onAdLoaded];
        }
    }];
}

#pragma mark PAGBannerAdDelegate

- (void)adDidShow:(PAGBannerAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告曝光事件
    [self sendEventAction:onAdExposure];
}

- (void)adDidClick:(PAGBannerAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告点击事件
    [self sendEventAction:onAdClicked];
}

- (void)adDidDismiss:(PAGBannerAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    if(self.autoClose){
        [self.bannerView removeFromSuperview];
    }
    // 发送广告关闭事件
    [self sendEventAction:onAdClosed];
}

@end
