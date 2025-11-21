# Pangle SDK 地域选择指南

## SDK 版本对比

### Pangle Global SDK（海外版）- 当前使用

**适用地区**：中国大陆以外的所有地区

**特点**：
- ✅ 服务全球市场（除中国大陆）
- ✅ 支持 Server Bidding（服务端竞价）
- ✅ 符合 GDPR、COPPA 等国际隐私法规
- ❌ **在中国大陆无法正常使用**
- ❌ 需要国际网络环境

**依赖配置**：
```ruby
# iOS
s.dependency 'Ads-Global', '6.3.1.0'
```
```gradle
# Android
implementation 'com.pangle.global:ads-sdk:6.3.0.4'
```

### Pangle SDK（国内版）

**适用地区**：中国大陆

**特点**：
- ✅ 专为中国大陆市场优化
- ✅ 支持 Waterfall 和部分竞价功能
- ✅ 无需国际网络
- ❌ 不适用于海外市场
- ❌ 需要在穿山甲国内平台注册

**依赖配置**：
```ruby
# iOS
s.dependency 'Ads-CN', 'x.x.x.x'
```
```gradle
# Android
implementation 'com.bytedance.sdk:pangle-sdk:x.x.x.x'
```

## 错误码 1000 - "SDK stop forcely"

### 原因

当使用 **Pangle Global SDK** 在中国大陆环境时，SDK 会：
1. 检测设备所在地区
2. 检测网络环境
3. 如果检测到在中国大陆且没有使用国际网络
4. **自动停止服务**，返回错误码 1000

这是 Pangle Global 的地域限制和反作弊机制。

### 解决方案

#### 选项 A：继续使用 Pangle Global SDK

**适用场景**：您的应用主要面向海外市场

**步骤**：
1. 使用 VPN 连接到海外节点（美国、新加坡、日本等）
2. 确保 VPN 稳定连接
3. 重新运行应用

**测试代码**：
```dart
// 使用官方测试 App ID
await FlutterPangleAds.initAd('8025677');
await FlutterPangleAds.showSplashAd('890008769', timeout: 5.0);
```

#### 选项 B：切换到 Pangle 国内版 SDK

**适用场景**：您的应用主要面向中国大陆市场

**步骤**：
1. 在穿山甲国内平台注册账号：https://www.pangle.cn/
2. 创建应用和广告位
3. 修改插件依赖为国内版 SDK
4. 使用国内版的测试广告位

## 如何选择 SDK 版本

### 使用 Pangle Global SDK（海外版）的情况：

- ✅ 应用主要面向海外市场
- ✅ 用户主要在中国大陆以外
- ✅ 需要符合 GDPR、COPPA 等国际法规
- ✅ 需要 Server Bidding 功能

### 使用 Pangle SDK（国内版）的情况：

- ✅ 应用主要面向中国大陆市场
- ✅ 用户主要在中国大陆
- ✅ 不需要国际网络环境
- ✅ 已在穿山甲国内平台注册

## 测试建议

### 测试 Pangle Global SDK

**环境要求**：
- 海外网络环境（VPN 或海外服务器）
- 或在海外真实设备上测试

**测试步骤**：
```bash
# 1. 连接 VPN 到海外节点
# 2. 清理项目
flutter clean

# 3. 运行应用
flutter run

# 4. 查看日志
# 应该看到：
# [Pangle] SDK initialized successfully
# 广告应该能正常加载
```

### 测试 Pangle 国内版 SDK

**环境要求**：
- 中国大陆网络环境
- 无需 VPN

**测试步骤**：
```bash
# 1. 确保使用国内网络
# 2. 使用国内版测试广告位
# 3. 运行应用
```

## 常见问题

### Q1: 我可以同时支持国内和海外吗？

**A:** 不建议在同一个 build 中同时集成两个版本的 SDK。建议：
- 为国内市场单独打包，使用国内版 SDK
- 为海外市场单独打包，使用 Global 版 SDK

### Q2: 使用 VPN 测试 Global SDK 安全吗？

**A:** 仅用于开发测试是可以的，但：
- 不要在生产环境中要求用户使用 VPN
- 确保您的应用符合目标市场的法律法规

### Q3: 如何判断 SDK 是否正常工作？

**A:** 查看日志：

**正常情况**：
```
[Pangle] SDK initialized successfully
✅ PAG SDK 初始化成功
广告加载成功
```

**异常情况（地域限制）**：
```
SDK stop forcely (错误码 1000)
```

## 相关链接

- [Pangle Global 官网](https://www.pangleglobal.com/)
- [穿山甲国内版官网](https://www.pangle.cn/)
- [Pangle Global 测试广告位](./PANGLE_GLOBAL_TEST_IDS.md)
- [故障排查指南](./BIDDING_TROUBLESHOOTING.md)
