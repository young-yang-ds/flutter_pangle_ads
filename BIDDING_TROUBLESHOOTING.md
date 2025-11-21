# Server Bidding 问题排查指南

> ⭐ **快速解决**：请使用 Pangle Global 官方测试广告位，详见 [PANGLE_GLOBAL_TEST_IDS.md](./PANGLE_GLOBAL_TEST_IDS.md)

## 问题描述

使用穿山甲官方测试广告位时：
- ✅ **Waterfall（瀑布流）模式** - 可以正常展示广告
- ❌ **Server Bidding（服务端竞价）模式** - 无法展示广告，报错：`40034 - Placement is not bidding type`

## 错误代码说明

**错误码 40034**：广告位不是竞价类型

这表示您使用的广告位在穿山甲后台配置为非竞价类型，但代码尝试以竞价模式请求广告。

## 根本原因

### 1. SDK 版本特性

本插件使用的是 **Pangle Global SDK（穿山甲海外版）**：
- iOS: `Ads-Global 6.3.1.0`
- Android: `com.pangle.global:ads-sdk:6.3.0.4`

**Pangle Global SDK 特点：**
- 主要支持 **Server Bidding（服务端竞价）** 模式
- 对 Waterfall 模式支持有限
- 广告位必须在后台配置为竞价类型

### 2. 广告位配置不匹配

您使用的测试广告位可能是：
- 在后台配置为 **Waterfall 类型**
- 但尝试以 **Server Bidding 模式** 请求

## 解决方案

### 方案 1：修改广告位类型（推荐）

1. 登录 [穿山甲国际版后台](https://www.pangleglobal.com/)
2. 进入 **流量管理** → **代码位管理**
3. 找到您的广告位（如 `890118104`）
4. 检查 **流量分组设置**
5. 确保启用 **Server Bidding（服务端竞价）** 功能

### 方案 2：使用正确的测试广告位

联系穿山甲技术支持，获取：
- 支持 Server Bidding 的测试广告位 ID
- 确认您的账号是否有 Server Bidding 权限

### 方案 3：使用 Waterfall 广告位

如果您的业务场景只需要 Waterfall 模式：
- 继续使用当前可以正常展示的广告位
- 不使用 Server Bidding 模式的广告位

## 调试建议

### 1. 查看详细日志

现在代码已经增强了日志输出，运行应用时查看控制台：

```
✅ PAG SDK 初始化成功
📱 SDK 版本: 6.3.1.0
🔧 App ID: your_app_id

❌ 激励视频广告加载失败
   广告位ID: 890118104
   错误码: 40034
   错误信息: Placement is not bidding type
   错误域: com.pangle.ads
   详细信息: {...}
```

### 2. 验证广告位配置

在穿山甲后台确认：
- 广告位类型（Waterfall / Server Bidding）
- 流量分组配置
- 竞价开关状态

### 3. 测试不同广告位

使用穿山甲提供的不同测试 ID，分别测试：
- Waterfall 类型广告位
- Server Bidding 类型广告位

## 常见问题

### Q1: 为什么 Waterfall 能展示，Server Bidding 不能？

**A:** 这是因为：
1. 您使用的测试广告位是 Waterfall 类型
2. Pangle Global SDK 对 Waterfall 做了兼容处理
3. 但 Server Bidding 必须使用竞价类型的广告位

### Q2: 代码中的 `setAllowNonBiddingAds` 有用吗？

**A:** 没有用。这个方法不是 PAG SDK 的官方 API：

```objectivec
// 这段代码实际上不会生效
if ([config respondsToSelector:@selector(setAllowNonBiddingAds:)]) {
    [config performSelector:@selector(setAllowNonBiddingAds:) withObject:@YES];
}
```

PAG SDK 海外版本身就是为竞价设计的，不支持通过配置启用非竞价广告位。

### Q3: 如何判断广告位是哪种类型？

**A:** 在穿山甲后台查看：
1. 进入代码位详情页
2. 查看 **流量分组** 或 **广告源配置**
3. 确认是否启用了 **Server Bidding**

### Q4: 国内版和海外版有什么区别？

**A:** 
- **国内版（Pangle SDK）**: 主要支持 Waterfall，部分支持竞价
- **海外版（Pangle Global SDK）**: 主要支持 Server Bidding

本插件使用的是海外版 SDK。

## 联系支持

如果以上方案都无法解决问题，请联系：

1. **穿山甲技术支持**
   - 邮箱: global_support@bytedance.com
   - 说明您使用的 SDK 版本和问题详情

2. **插件作者**
   - GitHub: https://github.com/FlutterAds/flutter_pangle_ads
   - 提供完整的错误日志和广告位配置信息

## 相关文档

- [Pangle Global 官方文档](https://www.pangleglobal.com/support/doc)
- [Server Bidding 接入指南](https://www.pangleglobal.com/support/doc/server-bidding)
- [错误码对照表](https://www.pangleglobal.com/support/doc/error-codes)
