//
//  FullScreenVideoPage.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/8/24.
//

#import "FullScreenVideoPage.h"

@implementation FullScreenVideoPage
// 加载广告
- (void)loadAd:(FlutterMethodCall *)call{
    PAGInterstitialRequest *request = [PAGInterstitialRequest request];
    [PAGLInterstitialAd loadAdWithSlotID:self.posId request:request completionHandler:^(PAGLInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad: %@", error.localizedDescription);
            [self sendErrorEvent:error.code withErrMsg:error.localizedDescription];
        } else {
            self.fsad = interstitialAd;
            self.fsad.delegate = self;
            [self sendEventAction:onAdLoaded];
            if(self.fsad){
                [self.fsad presentFromRootViewController:self.rootController];
            }
        }
    }];
}

#pragma mark - PAGLInterstitialAdDelegate

- (void)adDidShow:(PAGLInterstitialAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告曝光事件
    [self sendEventAction:onAdExposure];
    [self sendEventAction:onAdPresent];
}

- (void)adDidClick:(PAGLInterstitialAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告点击事件
    [self sendEventAction:onAdClicked];
}

- (void)adDidDismiss:(PAGLInterstitialAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告关闭事件
    [self sendEventAction:onAdClosed];
    // 发送广告完成事件
    [self sendEventAction:onAdComplete];
    self.fsad = nil;
}
@end
