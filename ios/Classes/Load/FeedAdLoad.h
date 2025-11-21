//
//  FeedAdLoad.h
//  flutter_pangle_ads
//
//  Created by zero on 2021/11/29.
//

#import <Foundation/Foundation.h>
#import "BaseAdPage.h"

@interface FeedAdLoad : BaseAdPage<PAGLNativeAdDelegate>
@property (strong,nonatomic,nonnull) FlutterResult result;
// 加载信息流广告列表
-(void) loadFeedAdList:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult) result eventSink:(nonnull FlutterEventSink )events;
@end
