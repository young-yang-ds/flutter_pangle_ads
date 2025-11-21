# 真机调试指南 - 解决广告无法加载问题

## 🚨 问题：模拟器可以加载广告，真机不行

这是一个非常常见的问题，主要原因是真机和模拟器在权限、网络环境等方面的差异。

---

## ✅ 解决方案

### 1. **请求 IDFA 授权（最重要！）**

**问题原因**：
- iOS 14+ 要求应用必须请求用户授权才能访问 IDFA（广告标识符）
- 模拟器通常自动授权，但真机需要用户手动授权
- 没有 IDFA，广告 SDK 无法正常工作

**解决方法**：

已在 `example/lib/main.dart` 中添加了 IDFA 请求代码：

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';

Future<bool> init() async {
  // iOS 需要请求 IDFA 授权（必须！）
  if (Platform.isIOS) {
    debugPrint('📱 iOS 设备，请求 IDFA 授权...');
    bool idfaResult = await FlutterPangleAds.requestIDFA;
    debugPrint('IDFA 授权结果: ${idfaResult ? '✅ 已授权' : '❌ 拒绝授权'}');
    
    if (!idfaResult) {
      debugPrint('⚠️ 警告：用户拒绝 IDFA 授权，广告可能无法正常加载');
    }
  }
  
  // 初始化广告 SDK
  bool result = await FlutterPangleAds.initAd(AdsConfig.appId);
  return result;
}
```

**验证步骤**：

1. 运行应用
2. 应该会弹出授权对话框：
   ```
   Allow "[Your App]" to track your activity across other companies' apps and websites?
   ```
3. 点击 **"Allow"（允许）**
4. 查看日志，应该显示：
   ```
   📱 iOS 设备，请求 IDFA 授权...
   IDFA 授权结果: ✅ 已授权
   ```

**如果没有弹出授权对话框**：

检查 `Info.plist` 是否包含必要的权限说明：

```xml
<key>NSUserTrackingUsageDescription</key>
<string>我们需要获取您的广告标识符以提供个性化广告</string>
```

---

### 2. **检查网络环境**

**问题原因**：
- 使用 Pangle Global SDK 需要国际网络
- 真机可能没有连接 VPN
- 模拟器可能共享了 Mac 的 VPN 连接

**解决方法**：

**方法 A：在真机上连接 VPN**
1. 在 iPhone 设置中配置 VPN
2. 连接到海外节点（美国、新加坡、日本等）
3. 重新运行应用

**方法 B：测试网络连接**
```dart
// 添加网络检测代码
Future<void> checkNetwork() async {
  try {
    final result = await InternetAddress.lookup('www.pangleglobal.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('✅ 可以访问 Pangle Global 服务器');
    }
  } catch (e) {
    print('❌ 无法访问 Pangle Global 服务器: $e');
    print('⚠️ 请检查网络连接或使用 VPN');
  }
}
```

---

### 3. **检查设备设置**

**限制广告跟踪（LAT）**：

1. 打开 iPhone **设置**
2. **隐私与安全性** → **跟踪**
3. 确保 **"允许 App 请求跟踪"** 是**开启**的
4. 找到您的应用，确保开关是**开启**的

**重置广告标识符**：

1. 打开 iPhone **设置**
2. **隐私与安全性** → **Apple 广告**
3. 点击 **"重置广告标识符"**
4. 重新运行应用并授权

---

### 4. **检查证书和配置文件**

**问题原因**：
- 开发证书或配置文件可能有问题
- 某些权限可能没有正确配置

**解决方法**：

1. **检查 Signing & Capabilities**：
   - 打开 Xcode
   - 选择 Runner target
   - 确保 **Signing & Capabilities** 配置正确
   - 确保使用了有效的开发者证书

2. **清理并重新构建**：
   ```bash
   flutter clean
   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
   flutter run
   ```

---

### 5. **查看真机日志**

**使用 Console.app 查看详细日志**：

1. 连接 iPhone 到 Mac
2. 打开 **Console.app**（在 Applications/Utilities 中）
3. 左侧选择您的 iPhone
4. 搜索 `Runner` 或 `FlutterPangleAds`
5. 运行应用，查看详细错误信息

**常见错误信息**：

| 错误信息 | 原因 | 解决方法 |
|---------|------|---------|
| `SDK stop forcely` (1000) | 地域限制 | 使用 VPN 连接海外节点 |
| `No IDFA` | 未授权 IDFA | 请求 IDFA 授权 |
| `Network error` | 网络问题 | 检查网络连接 |
| `Placement is not bidding type` (40034) | 广告位类型错误 | 使用正确的测试广告位 |

---

## 🔍 调试检查清单

在真机上运行前，请确认：

- [ ] **已添加 IDFA 请求代码**（在 `init()` 方法中）
- [ ] **Info.plist 包含 NSUserTrackingUsageDescription**
- [ ] **真机已连接 VPN**（如果使用 Pangle Global SDK）
- [ ] **iPhone 设置中允许跟踪**
- [ ] **使用了正确的测试 App ID 和广告位 ID**
- [ ] **清理并重新构建了项目**

---

## 📱 完整的真机测试流程

### 步骤 1：准备环境

```bash
# 1. 清理项目
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# 2. 连接真机到 Mac
# 3. 在真机上连接 VPN（如果使用 Global SDK）
```

### 步骤 2：修改代码

确保 `main.dart` 包含 IDFA 请求：

```dart
Future<bool> init() async {
  // iOS 需要请求 IDFA 授权
  if (Platform.isIOS) {
    bool idfaResult = await FlutterPangleAds.requestIDFA;
    print('IDFA 授权: ${idfaResult ? '成功' : '失败'}');
  }
  
  bool result = await FlutterPangleAds.initAd('8025677');
  return result;
}
```

### 步骤 3：运行应用

```bash
# 运行并查看详细日志
flutter run --verbose
```

### 步骤 4：授权 IDFA

1. 应用启动时会弹出授权对话框
2. 点击 **"Allow"（允许）**
3. 查看日志确认授权成功

### 步骤 5：测试广告

1. 点击显示开屏广告
2. 查看日志输出
3. 如果失败，查看错误码和错误信息

---

## 🆚 模拟器 vs 真机对比

| 特性 | 模拟器 | 真机 |
|------|--------|------|
| IDFA 授权 | 自动授权 | 需要用户授权 |
| 网络环境 | 共享 Mac 网络 | 独立网络 |
| VPN | 自动使用 Mac VPN | 需要单独配置 |
| 性能 | 较慢 | 真实性能 |
| 调试日志 | 容易查看 | 需要 Console.app |
| 推送通知 | 不支持 | 支持 |
| 相机/传感器 | 模拟 | 真实硬件 |

---

## 🐛 常见问题排查

### Q1: 授权对话框没有弹出？

**可能原因**：
1. Info.plist 缺少 `NSUserTrackingUsageDescription`
2. 已经授权过（检查设置）
3. 系统版本低于 iOS 14

**解决方法**：
```bash
# 1. 检查 Info.plist
cat ios/Runner/Info.plist | grep NSUserTrackingUsageDescription

# 2. 卸载应用重新安装
# 3. 在设置中重置隐私权限
```

### Q2: 授权成功但广告还是不加载？

**可能原因**：
1. 网络问题（需要 VPN）
2. 广告位 ID 错误
3. SDK 版本问题

**解决方法**：
```dart
// 添加详细的错误日志
FlutterPangleAds.onEventListener((event) {
  print('广告事件: ${event.action}');
  if (event is AdErrorEvent) {
    print('错误码: ${event.errCode}');
    print('错误信息: ${event.errMsg}');
  }
});
```

### Q3: 真机日志在哪里查看？

**方法 1：Flutter 控制台**
```bash
flutter run --verbose
```

**方法 2：Xcode**
```bash
cd ios
open Runner.xcworkspace
# 然后在 Xcode 中运行，查看控制台
```

**方法 3：Console.app**
1. 连接真机
2. 打开 Console.app
3. 选择设备
4. 搜索 `Runner`

---

## 📚 相关文档

- [错误码 1000 解决方案](./ERROR_1000_SOLUTION.md)
- [Pangle Global 测试广告位](./PANGLE_GLOBAL_TEST_IDS.md)
- [Xcode 调试指南](./XCODE_DEBUG_GUIDE.md)
- [SDK 地域选择指南](./SDK_REGION_GUIDE.md)

---

## 💡 最佳实践

### 开发阶段

1. **先在模拟器测试**：验证基本功能
2. **再在真机测试**：验证权限和网络
3. **使用 VPN**：确保网络环境正确
4. **查看详细日志**：及时发现问题

### 生产环境

1. **优雅处理授权拒绝**：
   ```dart
   if (!idfaResult) {
     // 显示提示，说明为什么需要授权
     showDialog(...);
   }
   ```

2. **添加网络检测**：
   ```dart
   // 检测网络连接
   if (await checkNetwork()) {
     // 加载广告
   } else {
     // 显示网络错误提示
   }
   ```

3. **错误上报**：
   ```dart
   FlutterPangleAds.onEventListener((event) {
     if (event is AdErrorEvent) {
       // 上报到错误监控平台
       reportError(event.errCode, event.errMsg);
     }
   });
   ```

---

## 🎯 快速验证

运行以下命令快速验证真机环境：

```bash
# 1. 清理并重新构建
flutter clean && flutter run --verbose

# 2. 查看日志中的关键信息：
# - "📱 iOS 设备，请求 IDFA 授权..."
# - "IDFA 授权结果: ✅ 已授权"
# - "✅ PAG SDK 初始化成功"
# - 广告加载成功或失败的具体错误信息
```

如果看到 "✅ 已授权" 和 "✅ PAG SDK 初始化成功"，但广告还是不加载，那么问题很可能是**网络环境**（需要 VPN）。
