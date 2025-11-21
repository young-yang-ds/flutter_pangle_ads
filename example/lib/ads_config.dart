import 'dart:io';

/// 广告配置信息
class AdsConfig {
  /// 获取 Logo 资源名称
  static String get logo {
    if (Platform.isAndroid) {
      return 'flutterads_logo';
    } else {
      return 'LaunchImage';
    }
  }

  /// 获取 Logo 资源名称 2
  static String get logo2 {
    if (Platform.isAndroid) {
      return 'flutterads_logo2';
    } else {
      return 'LaunchImage2';
    }
  }

  /// 获取 App id - Pangle Global 官方测试 App ID
  /// 官方文档: https://www.pangleglobal.com/integration/How-to-Test-Pangle-Ads-with-Ad-ID
  static String get appId => '8025677';

  /// 获取开屏广告位id - Server Bidding (竖屏)
  static String get splashId => '890008769';

  /// 获取开屏广告位id - Server Bidding (横屏)
  static String get splashIdHorizontal => '890008770';

  /// 获取插屏广告位id - Server Bidding (竖屏)
  static String get newInterstitialId => '980088186';

  /// 获取插屏广告位id - Server Bidding (横屏)
  static String get newInterstitialId2 => '980099797';

  /// 获取激励视频广告位id - Server Bidding (竖屏)
  static String get rewardVideoId => '980088190';

  /// 获取激励视频广告位id - Server Bidding (横屏)
  static String get rewardVideoIdHorizontal => '980099800';

  /// 获取全屏视频广告位id (使用插屏广告位)
  static String get fullScreenVideoId => '980088186';

  /// 获取 Banner 广告位id - Server Bidding (320*50)
  static String get bannerId => '980099803';

  /// 获取 Banner 广告位id - Server Bidding (300*250)
  static String get bannerId01 => '980088194';

  /// 获取 Banner 广告位id 02
  static String get bannerId02 => '980099803';

  /// 获取 Feed 信息流广告位id - Server Bidding
  static String get feedId => '980088198';
}
