# Pangle Global 官方测试广告位 ID

## 官方文档

📚 [How to Test Pangle Ads with Ad ID](https://www.pangleglobal.com/integration/How-to-Test-Pangle-Ads-with-Ad-ID)

## 测试 App ID

```
8025677
```

⚠️ **重要提示**：必须使用官方测试 App ID `8025677` 才能使用以下测试广告位。

## Server Bidding 测试广告位

### 开屏广告（App Open）

| 方向 | Placement ID |
|------|--------------|
| 竖屏 | `890008769` |
| 横屏 | `890008770` |

### 插屏广告（Interstitial）

| 方向 | Placement ID |
|------|--------------|
| 竖屏 | `980088186` |
| 横屏 | `980099797` |

### 激励视频（Rewarded）

| 方向 | Placement ID |
|------|--------------|
| 竖屏 | `980088190` |
| 横屏 | `980099800` |

### Banner 广告

| 尺寸 | Placement ID |
|------|--------------|
| 300×250 | `980088194` |
| 320×50 | `980099803` |

### 原生广告（Native）

| 类型 | Placement ID |
|------|--------------|
| Native | `980088198` |

## Waterfall 测试广告位

如果您需要测试 Waterfall 模式（非竞价），可以使用以下广告位：

### 开屏广告（App Open）

| 方向 | Placement ID |
|------|--------------|
| 竖屏 | `890000078` |
| 横屏 | `890000079` |

### 插屏广告（Interstitial）

| 方向 | Placement ID |
|------|--------------|
| 竖屏 | `980088188` |
| 横屏 | `980099798` |

### 激励视频（Rewarded）

| 方向 | Placement ID |
|------|--------------|
| 竖屏 | `980088192` |
| 横屏 | `980099801` |

### Banner 广告

| 尺寸 | Placement ID |
|------|--------------|
| 300×250 | `980088196` |
| 320×50 | `980099802` |

### 原生广告（Native）

| 类型 | Placement ID |
|------|--------------|
| Native | `980088216` |

## 使用示例

### Flutter 代码

```dart
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';

// 1. 初始化 SDK（使用官方测试 App ID）
await FlutterPangleAds.initAd('8025677');

// 2. 展示开屏广告（Server Bidding - 竖屏）
await FlutterPangleAds.showSplashAd('890008769', timeout: 3.5);

// 3. 展示激励视频（Server Bidding - 竖屏）
await FlutterPangleAds.showRewardVideoAd('980088190');

// 4. 展示插屏广告（Server Bidding - 竖屏）
await FlutterPangleAds.showFullScreenVideoAd('980088186');
```

## 重要说明

### ✅ 使用测试广告位的优势

1. **无地域限制**：全球任何地区都能成功加载广告
2. **稳定可靠**：保证能够预览多种广告样式
3. **无需创建**：不需要在自己账号下创建广告位
4. **避免违规**：避免在测试阶段触发违规惩罚机制

### ⚠️ 注意事项

1. **仅限测试**：这些广告位只能在 SDK 测试状态下使用
2. **无实际收益**：测试广告不会产生实际收益
3. **上线前删除**：应用上线前必须删除/屏蔽测试代码，改用正式广告位
4. **SDK 版本**：确保使用的是 Pangle Global SDK（海外版）

### 🔧 SDK 配置要求

**iOS (Podspec)**:
```ruby
s.dependency 'Ads-Global', '6.3.1.0'
```

**Android (build.gradle)**:
```gradle
implementation 'com.pangle.global:ads-sdk:6.3.0.4'
```

## 故障排查

### 测试广告位无法加载的常见原因

#### 1️⃣ **网络问题**

⚠️ **现象**：广告加载超时或无响应

**解决方案**：
- 检查设备网络连接
- 尝试切换到 Wi-Fi 或 4G/5G
- 检查是否使用了 VPN（某些 VPN 可能影响广告请求）
- 尝试访问 https://www.pangleglobal.com 确认可以访问 Pangle 服务器

#### 2️⃣ **地域限制**

⚠️ **现象**：某些地区可能暂时没有测试广告填充

**解决方案**：
- Pangle Global 主要服务海外市场
- 如果在中国大陆测试，可能需要使用国际网络
- 尝试使用不同的网络环境

#### 3️⃣ **SDK 版本问题**

⚠️ **现象**：旧版本 SDK 可能不支持某些测试广告位

**解决方案**：
- 确认使用的是 Pangle Global SDK（不是国内版）
- 当前插件使用的版本：
  - iOS: `Ads-Global 6.3.1.0`
  - Android: `com.pangle.global:ads-sdk:6.3.0.4`
- 建议更新到最新版本

#### 4️⃣ **隐私权限问题（iOS）**

⚠️ **现象**：iOS 设备上广告无法加载

**解决方案**：
```dart
// 在初始化广告前，请求 IDFA 授权
if (Platform.isIOS) {
  await FlutterPangleAds.requestIDFA;
}
await FlutterPangleAds.initAd('8025677');
```

#### 5️⃣ **需要等待时间**

⚠️ **现象**：首次请求可能需要较长时间

**解决方案**：
- 首次请求可能需要 5-10 秒
- 设置较长的超时时间（如 5 秒）
- 多尝试几次

#### 6️⃣ **广告位 ID 错误**

⚠️ **现象**：报错 40034 - Placement is not bidding type

**解决方案**：
- 确认使用的是本文档中列出的 **Server Bidding** 测试广告位
- 不要使用 Waterfall 类型的广告位（除非你明确需要测试 Waterfall）

### 调试步骤

1. **查看详细日志**

```dart
// 确保启用了调试模式
await FlutterPangleAds.initAd('8025677');
```

iOS 控制台应该显示：
```
🧪 检测到 Pangle Global 官方测试 App ID: 8025677
✅ PAG SDK 初始化成功
📱 SDK 版本: 6.3.1.0
```

2. **测试网络连接**

在浏览器中访问 https://www.pangleglobal.com 确认可以访问。

3. **尝试不同的广告类型**

如果开屏广告不工作，尝试激励视频或 Banner：

```dart
// 激励视频
await FlutterPangleAds.showRewardVideoAd('980088190');

// Banner
// 使用 AdBannerWidget 并设置 posId: '980099803'
```

4. **检查错误信息**

设置广告事件监听，查看详细错误：

```dart
FlutterPangleAds.onEventListener((event) {
  print('广告事件: ${event.action}');
  if (event.action == 'onAdError') {
    print('错误码: ${event.errCode}');
    print('错误信息: ${event.errMsg}');
  }
});
```

## 常见问题

### Q1: 为什么我的测试广告位不工作？

**A:** 请按照上面的“故障排查”章节逐步检查。最常见的原因是：
1. 网络问题（特别是在中国大陆）
2. 没有请求 iOS IDFA 授权
3. 使用了错误的广告位 ID

### Q2: Server Bidding 和 Waterfall 有什么区别？

**A:** 
- **Server Bidding（服务端竞价）**：实时竞价，收益更高，Pangle Global SDK 主要支持此模式
- **Waterfall（瀑布流）**：按优先级顺序请求，传统模式

### Q3: 可以混用不同类型的广告位吗？

**A:** 不建议。应该统一使用 Server Bidding 或 Waterfall，不要混用。

### Q4: 如何切换到正式广告位？

**A:** 
1. 在 Pangle 后台创建正式的广告位
2. 确保广告位类型为 Server Bidding
3. 替换代码中的测试 ID 为正式 ID
4. 使用您自己的 App ID

## 相关链接

- [Pangle Global 官网](https://www.pangleglobal.com/)
- [集成文档](https://www.pangleglobal.com/integration)
- [SDK FAQ](https://www.pangleglobal.com/integration/SDK-FAQ)
- [错误码说明](https://www.pangleglobal.com/integration/error-code)
