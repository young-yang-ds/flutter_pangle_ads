//
//  FeedAdLoad.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/11/29.
//

#import "FeedAdLoad.h"
#import "FeedAdManager.h"
#import "FlutterPangleAdsPlugin.h"

@implementation FeedAdLoad

- (void)loadFeedAdList:(FlutterMethodCall *)call result:(FlutterResult)result eventSink:(FlutterEventSink)events{
    self.result=result;
    // 这里复用整个加载流程
    [self showAd:call eventSink:events];
}

// 加载广告
- (void)loadAd:(FlutterMethodCall *)call{
    int width = [call.arguments[@"width"] intValue];
    int height = [call.arguments[@"height"] intValue];
    int count = [call.arguments[@"count"] intValue];
    // PAG SDK 使用静态方法加载原生广告
    PAGNativeRequest *request = [PAGNativeRequest request];
    // 设置额外信息，支持竞价
    if ([request respondsToSelector:@selector(setExtraInfo:)]) {
        NSDictionary *extraInfo = @{@"is_bidding": @YES};
        request.extraInfo = extraInfo;
    }
    [PAGLNativeAd loadAdWithSlotID:self.posId request:request completionHandler:^(PAGLNativeAd * _Nullable nativeAd, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to load native ad: %@", error.localizedDescription);
            [self sendErrorEvent:error.code withErrMsg:error.localizedDescription];
        } else if (nativeAd) {
            // 单个广告加载成功，打包成数组
            nativeAd.delegate = self;
            NSNumber *key = [NSNumber numberWithInteger:[nativeAd hash]];
            NSMutableArray *adList = [[NSMutableArray alloc] init];
            [adList addObject:key];
            [FeedAdManager.share putAd:key value:nativeAd];
            self.result(adList);
            [self sendEventAction:onAdLoaded];
        }
    }];
}

#pragma mark PAGLNativeAdDelegate

- (void)adDidShow:(PAGLNativeAd *)ad{
    NSLog(@"%s",__FUNCTION__);
    // 发送广告事件
    [self sendEventAction:onAdExposure];
    [self postNotificationMsg:ad userInfo:[NSDictionary dictionaryWithObject:onAdExposure forKey:@"event"]];
}

- (void)adDidClick:(PAGLNativeAd *)ad{
    NSLog(@"%s",__FUNCTION__);
    // 发送广告事件
    [self sendEventAction:onAdClicked];
    [self postNotificationMsg:ad userInfo:[NSDictionary dictionaryWithObject:onAdClicked forKey:@"event"]];
}

- (void)adDidDismiss:(PAGLNativeAd *)ad{
    NSLog(@"%s",__FUNCTION__);
    NSNumber *key=[NSNumber numberWithInteger:[ad hash]];
    // 删除广告缓存
    [FeedAdManager.share removeAd:key];
    // 发送广告事件
    [self sendEventAction:onAdClosed];
    [self postNotificationMsg:ad userInfo:[NSDictionary dictionaryWithObject:onAdClosed forKey:@"event"]];
}

// 发送消息
// 这里发送消息到信息流View，主要是适配信息流 View 的尺寸
- (void) postNotificationMsg:(PAGLNativeAd *) ad userInfo:(NSDictionary *) userInfo{
    NSLog(@"%s",__FUNCTION__);
    NSNumber *key=[NSNumber numberWithInteger:[ad hash]];
    NSString *name=[NSString stringWithFormat:@"%@/%@", kAdFeedViewId, key.stringValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:ad userInfo:userInfo];
}

@end
