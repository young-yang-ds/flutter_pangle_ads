# 错误码 1000 - "SDK stop forcely" 解决方案

## 🚨 错误信息

```
Banner ad load error: SDK stop forcely
Splash ad load failed: PangleAdError(code: 1000, message: SDK stop forcely)
```

## 📋 问题原因

**Pangle Global SDK 检测到您在中国大陆网络环境下使用，自动停止了广告服务。**

这是 Pangle Global SDK 的地域限制机制：
- ✅ Pangle Global SDK 设计用于**海外市场**
- ❌ 在中国大陆环境下会自动停止服务
- 🔒 这是 SDK 内置的反作弊和地域控制机制

## ✅ 解决方案

### 方案 1：使用 VPN 测试（临时方案）

**适用场景**：快速验证 SDK 功能，开发测试阶段

**步骤**：

1. **连接 VPN 到海外节点**
   - 推荐节点：美国、新加坡、日本、香港
   - 确保 VPN 稳定连接

2. **清理并重新运行**
   ```bash
   flutter clean
   flutter run
   ```

3. **验证成功**
   
   日志应该显示：
   ```
   [Pangle] SDK initialized successfully
   ✅ PAG SDK 初始化成功
   广告加载成功（不再出现 "SDK stop forcely"）
   ```

**注意事项**：
- ⚠️ 仅用于开发测试
- ⚠️ 不要在生产环境要求用户使用 VPN
- ⚠️ 确保符合当地法律法规

---

### 方案 2：切换到穿山甲国内版 SDK（生产环境推荐）

**适用场景**：应用主要面向中国大陆用户

#### 步骤 1：注册穿山甲国内版账号

1. 访问 [穿山甲国内版官网](https://www.pangle.cn/)
2. 注册开发者账号
3. 创建应用
4. 创建广告位

#### 步骤 2：修改 iOS 依赖

编辑 `ios/flutter_pangle_ads.podspec`：

**修改前**（Global 版）：
```ruby
s.dependency 'Ads-Global', '6.3.1.0'
```

**修改后**（国内版）：
```ruby
s.dependency 'Ads-CN', '6.5.0.8'  # 使用最新版本
```

#### 步骤 3：修改 Android 依赖

编辑 `android/build.gradle`：

**修改前**（Global 版）：
```gradle
implementation 'com.pangle.global:ads-sdk:6.3.0.4'
```

**修改后**（国内版）：
```gradle
implementation 'com.bytedance.sdk:pangle-sdk:6.5.0.8'  # 使用最新版本
```

并修改 Maven 仓库：
```gradle
repositories {
    maven { url 'https://artifact.bytedance.com/repository/pangle' }
}
```

#### 步骤 4：使用国内版测试广告位

国内版有不同的测试 App ID 和广告位 ID，请参考穿山甲国内版文档。

#### 步骤 5：清理并重新构建

```bash
# 清理项目
flutter clean

# iOS
cd ios
pod deintegrate
pod install
cd ..

# 重新运行
flutter run
```

---

### 方案 3：同时支持国内和海外（高级方案）

**适用场景**：应用需要同时支持国内和海外市场

#### 方案 3A：分别打包

为不同市场打包不同版本：

```bash
# 国内版本
flutter build apk --flavor china

# 海外版本
flutter build apk --flavor global
```

在 `build.gradle` 中配置不同的依赖：
```gradle
android {
    flavorDimensions "market"
    productFlavors {
        china {
            dimension "market"
            // 使用国内版 SDK
        }
        global {
            dimension "market"
            // 使用 Global 版 SDK
        }
    }
}
```

#### 方案 3B：使用 GroMore SDK

GroMore 是穿山甲的聚合广告 SDK，可以同时支持国内外市场：
- 参考：https://github.com/FlutterAds/flutter_gromore_ads

---

## 🔍 如何判断使用哪个版本

### 使用 Pangle Global SDK（海外版）

✅ **适用情况**：
- 应用主要面向海外市场
- 用户主要在中国大陆以外
- 需要符合 GDPR、COPPA 等国际法规
- 需要 Server Bidding 功能

❌ **不适用情况**：
- 应用主要面向中国大陆市场
- 用户主要在中国大陆
- 无法提供国际网络环境

### 使用 Pangle SDK（国内版）

✅ **适用情况**：
- 应用主要面向中国大陆市场
- 用户主要在中国大陆
- 不需要国际网络环境
- 已在穿山甲国内平台注册

❌ **不适用情况**：
- 应用主要面向海外市场
- 需要在海外地区展示广告

---

## 📊 版本对比

| 特性 | Pangle Global（海外版） | Pangle（国内版） |
|------|------------------------|-----------------|
| 适用地区 | 海外 | 中国大陆 |
| 网络要求 | 国际网络 | 国内网络 |
| 注册平台 | pangleglobal.com | pangle.cn |
| Server Bidding | ✅ 完整支持 | ⚠️ 部分支持 |
| Waterfall | ⚠️ 有限支持 | ✅ 完整支持 |
| GDPR/COPPA | ✅ 内置支持 | ❌ 不适用 |
| 在中国大陆使用 | ❌ 会报错 1000 | ✅ 正常工作 |
| 在海外使用 | ✅ 正常工作 | ⚠️ 填充率低 |

---

## 🛠️ 调试技巧

### 1. 检查当前使用的 SDK 版本

**iOS**：
查看 `ios/flutter_pangle_ads.podspec` 中的依赖：
```ruby
s.dependency 'Ads-Global', '6.3.1.0'  # Global 版
# 或
s.dependency 'Ads-CN', 'x.x.x.x'      # 国内版
```

**Android**：
查看 `android/build.gradle` 中的依赖：
```gradle
implementation 'com.pangle.global:ads-sdk:6.3.0.4'  # Global 版
# 或
implementation 'com.bytedance.sdk:pangle-sdk:x.x.x.x'  # 国内版
```

### 2. 测试网络环境

```bash
# 测试是否能访问 Pangle Global
curl https://www.pangleglobal.com

# 测试是否能访问穿山甲国内版
curl https://www.pangle.cn
```

### 3. 查看详细日志

在应用中添加事件监听：
```dart
FlutterPangleAds.onEventListener((event) {
  print('广告事件: ${event.action}');
  if (event.action == 'onAdError') {
    print('错误码: ${event.errCode}');
    print('错误信息: ${event.errMsg}');
    
    if (event.errCode == 1000) {
      print('⚠️ 检测到错误码 1000 - SDK stop forcely');
      print('📝 这是地域限制问题，请参考 ERROR_1000_SOLUTION.md');
    }
  }
});
```

---

## 📚 相关文档

- [Pangle Global 测试广告位](./PANGLE_GLOBAL_TEST_IDS.md)
- [SDK 地域选择指南](./SDK_REGION_GUIDE.md)
- [Server Bidding 故障排查](./BIDDING_TROUBLESHOOTING.md)

---

## ❓ 常见问题

### Q1: 我已经连接了 VPN，为什么还是报错 1000？

**A:** 可能的原因：
1. VPN 连接不稳定
2. VPN 节点被识别为中国大陆
3. 应用缓存了之前的网络状态

**解决方法**：
```bash
# 1. 确保 VPN 稳定连接
# 2. 切换到其他海外节点
# 3. 完全清理项目
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock
cd ios && pod install && cd ..
flutter run
```

### Q2: 我可以在代码中动态切换 SDK 吗？

**A:** 不可以。SDK 是在编译时链接的，无法在运行时切换。需要为不同市场打包不同版本。

### Q3: 使用国内版 SDK 需要修改代码吗？

**A:** 大部分 API 是兼容的，但可能需要：
1. 使用不同的测试广告位 ID
2. 调整部分隐私配置（GDPR/COPPA 等）
3. 参考穿山甲国内版文档

### Q4: 错误码 1000 会影响海外用户吗？

**A:** 不会。错误码 1000 只在中国大陆网络环境下出现。海外用户使用 Pangle Global SDK 不会遇到此问题。

---

## 📞 获取帮助

如果以上方案都无法解决问题，请：

1. **查看完整日志**：提供完整的错误日志
2. **说明环境**：网络环境、设备信息、SDK 版本
3. **联系支持**：
   - Pangle Global: global_support@bytedance.com
   - 穿山甲国内版: 在 pangle.cn 提交工单
   - 插件问题: https://github.com/FlutterAds/flutter_pangle_ads/issues
