---
name: labor-rights-wechat-layout
description: Use when 已审核的法律公众号正文需要手机端排版、排版自检、生成 HTML 或修复草稿箱与 Obsidian 预览样式不一致
---

# 法律公众号排版

## 职责

输入已通过内容审核的正文，输出可直接推送到公众号草稿箱的完整 HTML。

**可以做**：选模板、拆段落、调标题、编号、卡片、加粗、排图片、装配文末固定模块。

**不可以做**：改事实/法条/金额/判决结论、自行写稿、生图、推送草稿。

## 全局 CSS 变量（按文章类型切换）

| 类型 | 主色 | 用途 |
|------|------|------|
| 工伤赔偿 | `#c24d76` | 工伤认定、赔偿计算 |
| 交通事故 | `#2f86b7` | 人伤赔偿、事故处理 |
| 工伤鉴定 | `#18a96f` | 伤残等级、劳动能力 |
| 事故责任 | `#b33f69` | 责任划分、维权流程 |
| 伤残鉴定 | `#8b6fd6` | 伤残评定、赔偿标准 |

以下模板中用 `--accent` 代表主色，实际输出时替换为对应类型的值。

## 样式配方（生产级 CSS）

### 外层宣纸纹容器（每篇文章唯一）

固定素材：`assets/xuan-paper.png` 是原始母版；`assets/xuan-paper-wechat.jpg` 是同尺寸、低于微信 2MB 限制的上传版。不得改成纯色或 CSS 模拟纹理。

当前公众号已验证的微信 CDN URL：

`https://mmbiz.qpic.cn/sz_mmbiz_jpg/ysL2dia5FLeACuHdLYEZaCEQAxD9eBuJjZFcB8UibeiblwTYCuo89KR7seEB55q6wsib0OYHnpoHjGvrGmZwYWhnZ56U5Eq9Ez73wqU87pMDTqQ/0?from=appmsg`

直接复用该地址。仅当地址失效或切换公众号时，才用正文图片上传能力重新上传 `xuan-paper-wechat.jpg`；无法取得有效 URL 时停止排版并报告，不能回退到渐变模拟。

```html
<section class="paper-bg" data-paper-asset-sha256="18b9bc813a461cff51d537004b3d1801d961b5b7247d391981776202d74295df" style="padding:10px 8px;background-color:#f5f0e6;background-image:url('https://mmbiz.qpic.cn/sz_mmbiz_jpg/ysL2dia5FLeACuHdLYEZaCEQAxD9eBuJjZFcB8UibeiblwTYCuo89KR7seEB55q6wsib0OYHnpoHjGvrGmZwYWhnZ56U5Eq9Ez73wqU87pMDTqQ/0?from=appmsg');background-repeat:repeat-y;background-position:top center;background-size:100% auto;box-shadow:inset 0 0 0.15mm rgba(88,88,88,.32);">
  <!-- 所有内容放在这个 section 内 -->
</section>
```

`box-shadow` 是整篇外框内边向内渐隐的灰色边缘，宽度固定 `0.15mm`；不得删除、加宽或改成外阴影。Obsidian 预览和公众号草稿必须读取同一份 `final.html`。

### 卡片容器（章节主卡片）

```html
<section style="padding:14px 12px;margin-bottom:10px;background-color:#faf8f3;background-image:repeating-linear-gradient(135deg,transparent 0,transparent 3px,rgba(180,160,130,0.025) 3px,rgba(180,160,130,0.025) 4px),repeating-linear-gradient(45deg,transparent 0,transparent 5px,rgba(180,160,130,0.018) 5px,rgba(180,160,130,0.018) 6px);border-radius:12px;border:1px solid #ebe0cc;box-shadow:0 1px 4px rgba(120,100,70,.08);">
  <!-- 卡片内容 -->
</section>
```

### 正文段落

```html
<p style="font-family:-apple-system,sans-serif;font-size:15px;color:#4a3f30;line-height:1.8;text-align:justify;margin:0 0 0.6em 0;">段落文字</p>
```

末段用 `margin:0` 避免底部多余间距。

### 纯文字区（不需卡片包裹的过渡段）

```html
<section style="margin-bottom:10px;">
  <p style="...(同上)">文字</p>
</section>
```

### 章节标题

```html
<h3 style="font-family:-apple-system,sans-serif;font-size:17px;color:--accent;line-height:1.8;margin:0 0 4px 0;font-weight:bold;">标题文字</h3>
```

`--accent` 替换为文章类型对应的主色。

### 法条引用卡片

```html
<section style="padding:12px 16px;margin:12px 0;background-color:#faf8f3;background-image:repeating-linear-gradient(135deg,transparent 0,transparent 3px,rgba(180,160,130,0.025) 3px,rgba(180,160,130,0.025) 4px),repeating-linear-gradient(45deg,transparent 0,transparent 5px,rgba(180,160,130,0.018) 5px,rgba(180,160,130,0.018) 6px);border-left:4px solid --accent;border-radius:0 8px 8px 0;">
  <p style="font-family:-apple-system,sans-serif;font-size:14px;color:#4a3f30;line-height:1.8;margin:0;">
    <strong>《法条名称》第X条：</strong>法条原文中<strong>关键内容</strong>加粗标注。
  </p>
</section>
```

### 法条速查表格

```html
<section style="...卡片容器样式...">
  <h3 style="...(标题样式)...">关键法条速查</h3>
  <table style="border-collapse:collapse;width:100%;margin:5px 0;font-size:14px;color:#4a3f30;">
    <tr style="font-family:-apple-system,sans-serif;background:#f5eee0;">
      <td style="font-family:-apple-system,sans-serif;padding:8px 10px;border:1px solid #ebe0cc;font-weight:bold;">列头1</td>
      <td style="font-family:-apple-system,sans-serif;padding:8px 10px;border:1px solid #ebe0cc;font-weight:bold;">列头2</td>
    </tr>
    <tr><td style="font-family:-apple-system,sans-serif;padding:8px 10px;border:1px solid #ebe0cc;">内容</td><td style="...(同上)...">内容</td></tr>
    <tr style="background:#faf8f3;"><td style="...">内容</td><td style="...">内容</td></tr>
  </table>
</section>
```

表格行交替 `background:#faf8f3` 做斑马纹。

### 警示提示卡片（橙黄色左边框）

```html
<section style="padding:12px 16px;margin:12px 0;background-color:#faf8f3;background-image:...(宣纸纹);border-left:4px solid #e8943a;border-radius:0 8px 8px 0;">
  <p style="font-family:-apple-system,sans-serif;font-size:14px;color:#7a5a1b;line-height:1.8;margin:0;">
    ⚠️ 警示内容...
  </p>
</section>
```

### 知识提示卡片（绿色左边框）

```html
<section style="padding:12px 16px;margin:12px 0;background-color:#faf8f3;background-image:...(宣纸纹);border-left:4px solid #18a96f;border-radius:0 8px 8px 0;">
  <p style="font-family:-apple-system,sans-serif;font-size:14px;color:#3a5a28;line-height:1.8;margin:0;">
    💡 提示内容...
  </p>
</section>
```

### 居中强调短句

```html
<section style="padding:14px 12px;margin-bottom:10px;background-color:#faf8f3;background-image:...(宣纸纹);border-radius:12px;border:1px solid #ebe0cc;text-align:center;">
  <p style="font-family:-apple-system,sans-serif;font-size:15px;color:--accent;line-height:1.8;margin:0;font-weight:bold;">强调短句</p>
</section>
```

### 配图

```html
<section style="margin-bottom:10px;">
  <img data-src="图片URL/640?from=appmsg" style="display:block;width:100%;height:auto;border-radius:12px;">
</section>
```

配图用 `data-src` 不要 `src`，URL 必须带 `/640?from=appmsg` 后缀。

### 步骤列表（流程排版）

```html
<section style="padding:12px 16px;margin:12px 0;background-color:#faf8f3;background-image:...(宣纸纹);border:1px solid #ebe0cc;border-radius:8px;">
  <p style="font-family:-apple-system,sans-serif;font-size:14px;color:#4a3f30;line-height:1.8;margin:0;">
    ✓ 步骤一<br>
    <span style="font-family:-apple-system,sans-serif;color:#888;font-size:13px;">补充说明</span><br>
    ✓ 步骤二<br>
    ✓ 步骤三
  </p>
</section>
```

## 文末固定模块（每篇必加，顺序不可变）

### 1. 来源标注

```html
<section style="padding:5px 10px;margin:5px 0;text-align:center;">
  <p style="font-family:-apple-system,sans-serif;font-size:13px;color:#999;line-height:1.8;margin:0;">
    来源：本文梳理自《XXX法》、《XXX条例》及相关司法解释现行有效版本。内容仅供信息参考。
  </p>
</section>
```

### 2. 免责声明卡片

```html
<section style="padding:10px 12px;margin:5px 0;background-color:#faf8f3;background-image:repeating-linear-gradient(135deg,transparent 0,transparent 3px,rgba(180,160,130,0.025) 3px,rgba(180,160,130,0.025) 4px),repeating-linear-gradient(45deg,transparent 0,transparent 5px,rgba(180,160,130,0.018) 5px,rgba(180,160,130,0.018) 6px);border-radius:12px;border:1px solid #ebe0cc;">
  <p style="font-family:-apple-system,sans-serif;font-size:13px;color:#999;line-height:1.8;margin:0;">
    <strong>免责声明：</strong>本文仅供信息参考，不构成法律意见。每起XX情况不同，具体处理请以法律规定和实际情况为准。
  </p>
</section>
```

### 3. 公众号名片

```html
<section style="margin:5px 0;">
  <section class="mp_profile_iframe_wrp"><mp-common-profile class="custom_select_card mp_profile_iframe mp_common_widget" data-pluginname="mp-common-profile" data-from="0" data-id="MzcwNDM1NjIxOQ==" data-headimg="https://mmbiz.qpic.cn/mmbiz_png/ysL2dia5FLeDou6Xic7kv7JW65sibMNIpIPrWtDnj3gvT1Hhf8UVUmUVNo0KDXM7j4a2EQ92LBSAHA3l17qFsW01qwdeeibbmpccUwsDYSt4kOs/0?wx_fmt=png" data-nickname="云贸星捷人伤赔偿小知识" data-signature="交通事故·工伤赔偿科普｜企业法律咨询（非律师）｜讲标准、流程、证据｜内容仅供参考，不构成法律意见。" data-service_type="1"></mp-common-profile></section>
</section>
```

`data-id` 是 `__biz` 值，`data-service_type` 订阅号为 `1`。

### 4. 延伸阅读区（草稿阶段就写，数量不限）

**规则（2026-08-02 修订）：**

- **草稿阶段就写延伸阅读**，不用等发布
- **数量不限**：有相关的就加，无硬性上限
- **关联判定（放宽）**：同领域 / 同系列 / 同法条 / 同赔偿项目 / 同人群 / 互相补充说明，沾边即加
- **草稿格式**（无有效 URL，纯文字标题列表）：

```html
<section style="padding:12px 12px;margin:12px 0 4px;background-color:#faf8f3;border-radius:12px;border:1px solid #ebe0cc;">
  <h3 style="font-family:-apple-system,sans-serif;font-size:15px;color:#8a7a5a;line-height:1.8;margin:0 0 6px 0;font-weight:bold;">延伸阅读</h3>
  <p style="font-family:-apple-system,sans-serif;font-size:14px;color:#4a3f30;line-height:1.9;margin:0;">
    《高温中暑算不算工伤？实操指南》<br>
    《十级工伤赔偿明细，一次性讲清》<br>
    《公司给少缴了工伤保险，差额谁补？》
  </p>
</section>
```

- **发布后格式**（补 URL，手动在微信编辑器加超链接）：`<a href="已发布文章链接">文章标题</a>`，一行一条
- 同系列未发布篇也可列入（标注「待发布」），发布顺序上优先发被引用篇

## 排版规则

### 段落

- 每段 ≤ 3 句，超长必须拆分
- 段落间 `margin:0 0 0.6em 0`（末段 `margin:0`）
- 复杂流程拆成编号步骤

### 加粗

**可以**：章节标题、法律结论、判决要点、关键法律要件、法条编号
**不可以**：普通描述文字、情感表达、过渡句、整段加粗

### 编号系统

| 场景 | 格式 | 示例 |
|------|------|------|
| 法规解读分项 | 01/02/03 | **01 医疗费** |
| 维权步骤 | 1. 2. 3. | **第一步，保留证据。** |
| 避坑提醒 | 圆圈数字 | ① 别听信口头忽悠 |
| 列举要点 | 短横线 | - 医疗费 - 伙食补助 |

同一篇不混用编号格式。

### 法条引用

- 法条原文用引用卡片（左边框4px solid --accent）
- 法规名用《》，精确到条、款、项
- 关键内容加粗，后跟大白话解读
- 不连续堆砌 3 条以上

### 配图

- 案例型：案情后1张 + 判决后1张 + 结尾前1张（可选）
- 法规型：总述后1张 + 分项中1张 + 结尾前1张（可选）
- 科普型：概念后1张 + 分级后1张
- 问答型：开头1张 + 结尾前1张
- 封面比例 2.35:1，正文配图 16:9 横图
- 每篇 2-3 张，不超 3 张
- 图片 URL 必须完整（`/640?from=appmsg`）

## 排版自检清单

- 每段 ≤ 3 句？
- 加粗只用在标题/结论/判决要点？
- 编号格式统一？
- 法条用了引用卡片格式（左边框）？
- 配图位置标记正确？
- 没有文首关注引导？
- 文末固定模块齐全（来源+免责+名片）？
- 卡片间距均匀（`margin-bottom:10px`）？
- 外层唯一 `paper-bg` 使用 `assets/xuan-paper-wechat.jpg` 对应的微信 CDN URL？
- 上传版 SHA-256 是 `18b9bc813a461cff51d537004b3d1801d961b5b7247d391981776202d74295df`，且原始 PNG 仍完整保留？
- 整篇外框包含 `box-shadow:inset 0 0 0.15mm rgba(88,88,88,.32)`？
- `--accent` 主色与文章类型匹配？
