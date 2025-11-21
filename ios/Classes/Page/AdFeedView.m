//
//  AdFeedView.m
//  flutter_pangle_ads
//
//  Created by zero on 2021/11/29.
//

#import "AdFeedView.h"
#import "FeedAdManager.h"

@interface AdFeedView()<FlutterPlatformView,PAGLNativeAdDelegate>
@property (strong,nonatomic) UIView *feedView;
@property (strong,nonatomic) PAGLNativeAd *nativeAd;
@property (strong,nonatomic) FlutterMethodChannel *methodChannel;

@end

@implementation AdFeedView

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger plugin:(FlutterPangleAdsPlugin *)plugin{
    if(self==[super init]){
        self.viewId=viewId;
        self.feedView =[[UIView alloc] init];
        self.methodChannel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"%@/%lli",kAdFeedViewId,viewId] binaryMessenger:messenger];
        FlutterMethodCall *call= [FlutterMethodCall methodCallWithMethodName:@"AdFeedView" arguments:args];
        [self showAd:call eventSink:plugin.eventSink];
    }
    NSLog(@"%s %lli",__FUNCTION__,viewId);
    return self;
}

- (UIView *)view{
    return self.feedView;
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 处理消息
- (void) postMsghandler:(NSNotification*) notification{
    NSLog(@"%s postMsghandler name:%@ obj:%@",__FUNCTION__,notification.name,notification.object);
    PAGLNativeAd *nativeAd=notification.object;
    NSDictionary *userInfo=notification.userInfo;
    NSString *event=[userInfo objectForKey:@"event"];
    if([event isEqualToString:onAdExposure]){
        // 渲染成功，设置高度
        UIView *adView = [self getAdViewFromNativeAd:nativeAd];
        if (adView) {
            CGSize size = adView.frame.size;
            [self setFlutterViewSize:size];
        }
    }else if([event isEqualToString:onAdClosed]){
        // 广告关闭移除广告，并且设置大小为 0，隐藏广告
        UIView *adView = [self getAdViewFromNativeAd:nativeAd];
        if (adView) {
            [adView removeFromSuperview];
        }
        [self setFlutterViewSize:CGSizeZero];
    }
}

// 获取原生广告视图
- (UIView *)getAdViewFromNativeAd:(PAGLNativeAd *)nativeAd {
    if ([nativeAd respondsToSelector:@selector(adView)]) {
        return [nativeAd performSelector:@selector(adView)];
    } else if ([nativeAd respondsToSelector:@selector(view)]) {
        return [nativeAd performSelector:@selector(view)];
    }
    return nil;
}
// 设置 FlutterAds 视图宽高
- (void) setFlutterViewSize:(CGSize) size{
    NSNumber *width=[NSNumber numberWithFloat:size.width];
    NSNumber *height=[NSNumber numberWithFloat:size.height];
    NSDictionary *dicSize=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:width,height, nil] forKeys:[NSArray arrayWithObjects:@"width",@"height", nil]];
    UIView *adView = [self getAdViewFromNativeAd:self.nativeAd];
    if (adView) {
        adView.center = self.feedView.center;
    }
    [self.methodChannel invokeMethod:@"setSize" arguments:dicSize];
}

- (void)loadAd:(FlutterMethodCall *)call{
    NSNumber *key=[NSNumber numberWithInteger:[self.posId integerValue]];
    NSString *name=[NSString stringWithFormat:@"%@/%@", kAdFeedViewId, key.stringValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postMsghandler:) name:name object:nil];
    self.nativeAd=[FeedAdManager.share getAd:key];
    self.nativeAd.delegate = self;
    // PAG SDK 使用 rootViewController 属性设置控制器
    if ([self.nativeAd respondsToSelector:@selector(setRootViewController:)]) {
        [self.nativeAd performSelector:@selector(setRootViewController:) withObject:self.rootController];
    }
    UIView *adView = [self getAdViewFromNativeAd:self.nativeAd];
    if (adView) {
        [self.feedView addSubview:adView];
    }
}

#pragma mark - PAGLNativeAdDelegate

- (void)adDidShow:(PAGLNativeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
}

- (void)adDidClick:(PAGLNativeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
}

- (void)adDidDismiss:(PAGLNativeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
}

@end
