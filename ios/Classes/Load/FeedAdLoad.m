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
    // 配置广告请求
    PAGNativeRequest *request = [PAGNativeRequest request];
    request.adString = self.posId;
    if(!self.adLoader){
        self.adLoader = [[PAGLNativeAdLoader alloc] initWithSlotID:self.posId];
    }
    self.adLoader.delegate = self;
    // 加载广告
    [self.adLoader loadAdWithCount:count];
}

#pragma mark PAGLNativeAdLoadDelegate

- (void)adLoader:(PAGLNativeAdLoader *)adLoader didFailWithError:(NSError *)error{
    NSLog(@"%s",__FUNCTION__);
    // 发送广告错误事件
    [self sendErrorEvent:error.code withErrMsg:error.localizedDescription];
}

- (void)adLoader:(PAGLNativeAdLoader *)adLoader didReceiveNativeAds:(NSArray<PAGLNativeAd *> *)nativeAds{
    NSLog(@"%s",__FUNCTION__);
    if (nativeAds.count) {
        // 广告列表，用于返回 Flutter 层
        NSMutableArray *adList= [[NSMutableArray alloc] init];
        [nativeAds enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PAGLNativeAd *nativeAd = obj;
            nativeAd.delegate = self;
            // 通过hash 来标识不同的原生广告
            NSNumber *key=[NSNumber numberWithInteger:[obj hash]];
            NSLog(@"FeedAdLoad idx:%lu obj:%p hash:%@",(unsigned long)[obj hash],obj,key);
            // 添加到返回列表中
            [adList addObject:key];
            // 添加到缓存广告列表中
            [FeedAdManager.share putAd:key value:obj];
        }];
        // 返回广告列表
        self.result(adList);
    }
    // 发送广告事件
    [self sendEventAction:onAdLoaded];
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
