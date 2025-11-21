//
//  RewardVideoPage.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/8/19.
//

#import "RewardVideoPage.h"

@implementation RewardVideoPage
// 加载广告
- (void)loadAd:(FlutterMethodCall *)call{
    self.customData = call.arguments[@"customData"] ;
    self.userId = call.arguments[@"userId"];
    // 初始化激励视频广告
    PAGRewardedRequest *request = [PAGRewardedRequest request];
    // SDK 会根据广告位配置自动处理，支持 In-App Bidding
    [PAGRewardedAd loadAdWithSlotID:self.posId request:request completionHandler:^(PAGRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"❌ 激励视频广告加载失败");
            NSLog(@"   广告位ID: %@", self.posId);
            NSLog(@"   错误码: %ld", (long)error.code);
            NSLog(@"   错误信息: %@", error.localizedDescription);
            NSLog(@"   错误域: %@", error.domain);
            if (error.userInfo) {
                NSLog(@"   详细信息: %@", error.userInfo);
            }
            [self sendErrorEvent:error.code withErrMsg:error.localizedDescription];
        } else {
            self.rvad = rewardedAd;
            self.rvad.delegate = self;
            [self sendEventAction:onAdLoaded];
            if(self.rvad){
                [self.rvad presentFromRootViewController:self.rootController];
            }
        }
    }];
}


#pragma mark - PAGRewardedAdDelegate

- (void)adDidShow:(PAGRewardedAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告曝光事件
    [self sendEventAction:onAdExposure];
    [self sendEventAction:onAdPresent];
}

- (void)adDidClick:(PAGRewardedAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告点击事件
    [self sendEventAction:onAdClicked];
}

- (void)adDidDismiss:(PAGRewardedAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    // 发送广告关闭事件
    [self sendEventAction:onAdClosed];
    self.rvad = nil;
}

- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userDidEarnReward:(PAGRewardModel *)rewardModel {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"User earned reward: name=%@, amount=%ld", rewardModel.rewardName, (long)rewardModel.rewardAmount);
    // 发送广告完成事件
    [self sendEventAction:onAdComplete];
    // 发送激励事件
    AdRewardEvent *rewardEvent=[[AdRewardEvent alloc] initWithAdId:self.posId rewardType:0 rewardVerify:YES rewardAmount:rewardModel.rewardAmount rewardName:rewardModel.rewardName customData:self.customData userId:self.userId errCode:0 errMsg:@""];
    [self sendEvent:rewardEvent];
}

@end
