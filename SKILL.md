---
name: labor-rights-wechat-layout
description: |
  法律维权公众号手机端排版。输入已审核正文，输出完整 HTML。
  触发词：公众号排版、排版规范、卡片风、排版自检、排版微调、排一下、做排版、生成HTML、重排、旧版重排、纯白标准
---

# 法律公众号排版

## 职责

输入已通过内容审核的正文，输出可直接推送到公众号草稿箱的完整 HTML。

**可以做**：选模板、拆段落、调标题、编号、卡片、加粗、排图片、装配文末固定模块。

**不可以做**：改事实/法条/金额/判决结论、自行写稿、生图、推送草稿。

## 硬规则（每次排版必须遵守，违反即重排）

### 1. 正文不放文章标题（否则读者看到两个标题）

微信草稿本身有独立的标题字段，推送后会显示在正文上方。**HTML 正文内严禁再放文章大标题卡**，否则手机上会出现两个一样的标题。

```html
<!-- ❌ 禁止：正文开头放标题卡 -->
<section style="...纯白卡..."><h3 style="...">文章标题</h3></section>

<!-- ✅ 正确：全局容器开头直接进钩子纯文字区 -->
<section style="...全局容器...">
<!-- 钩子：纯文字区，不套卡片 -->
<section style="margin:0 0 14px;">
  <p style="margin:0 0 10px;color:#4a3f30;line-height:1.85;">开篇第一段……</p>
```

例外：章节内的 `h3` 小标题（如"一、伤残鉴定怎么做"）照常保留，此规则只针对**文章大标题**。

### 2. 宣纸卡底素材只用 v4 URL

法条引用/重点强调用的宣纸卡底，**统一用下面这个 URL**。两版旧素材已废弃，不得再引用：`mmbiz_png/ysL2dia5FLeCRjAbe1uic…`（v1）、`mmbiz_jpg/ysL2dia5FLeCLxx6mql0Mamx…`（v3，未经用户确认的近似纹理）。

```
http://mmbiz.qpic.cn/sz_mmbiz_jpg/ysL2dia5FLeCroicI0mHMSOOIia51UZV45pY9IyTBTMhRXOd8BACU6pZFNL3PhJaSdKvdlIH3Y6mNGjS61Nm53QS3EZ9QEnJvBVCmGQHgavg9M/0?from=appmsg
```

完整写法：

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#faf6ed url(&quot;上面的URL&quot;);background-size:cover;background-blend-mode:multiply;border-radius:8px;font-size:15px;line-height:1.8;color:#7a5a4a;">
  <p style="margin:0;"><strong>《法条名称》第X条：</strong>法条原文……</p>
</section>
```

本地源文件：`assets/宣纸卡底-v4-640.jpg`（640×400，均值 RGB 236/220/194，无任何文字元素）。**这一版由用户于 2026-08-11 提供原图并确认**，源图 `Codex 图像 2026年8月10日 22_01_31.png`（941×1672 竖版），按 640×400 同比例中心横带裁切后缩放，未做提亮或调饱和。

素材更换纪律：不得自行找"看起来差不多"的纹理替代。素材身份由 `成品/素材指纹登记表.json` 的 sha256 + status 锁定，未经用户确认的素材 status 为 `pending_user_confirm`，会被 `audit_visual.py` TS-21 判 FAIL。若 CDN 链接失效，重新上传 assets 里的同一个本地文件换新 URL，并同步更新本节、登记表 cdnUrl、存量 HTML。

### 3. 案例必须二次脱敏（判决书已化名 ≠ 已脱敏）

判决书原文虽已把当事人写成"张某""李某"，但**街道级地址 + 精确日期 + 鉴定机构 + 户籍地组合起来足以定位真实当事人**，属隐私风险。正文区必须做二次脱敏。

**禁止出现**：

| 类型 | ❌ 原文写法 | ✅ 脱敏写法 |
|---|---|---|
| 地址 | 深圳光明区马田街道周家大道碧浪科技园路段 | 深圳……一条主干道 |
| 姓名 | 19岁的张某 / 李某 | 19岁的小伙子 / 伤者 / 本案 |
| 鉴定机构 | 广东龙城司法鉴定所 | 有资质的司法鉴定机构 |
| 户籍地 | 户籍在湖南 | 户籍在外省 |
| 日期 | 2024年8月11日晚上快9点 / 2025年5月15日 | 2024年8月的一个晚上 / 2025年5月 |
| 对照案例金额 | 一审判赔643792.95元 | （删除，或只说争议焦点） |
| 车辆信息 | 深圳M47897号 | （删除） |

**可以保留**：文末来源栏的法院全称 + 案号（合规溯源必需），并注明"已对当事人姓名、事故具体地点等作脱敏处理"。

对应门禁：`audit_visual.py` **TS-22**（正文区出现"街道/路段/大道/科技园/工业园/村委"即 FAIL；来源栏不参与检查）。

### 4. 交通事故赔偿类文章必须交代责任比例

只报"损失总额"而不讲交警责任划分属**误导性遗漏**，读者会误以为"损失总额 = 到手金额"。写交通事故赔偿必须交代三件事：

1. **交警认定的责任划分**（主责 / 次责 / 同责 / 全责），以及对应的赔付比例
2. **责任比例只作用于超出交强险的部分**：交强险在限额内不分责任比例全额先赔（医疗费用分项 18000 元 + 死亡伤残分项 180000 元 = 198000 元，精神损害抚慰金在伤残限额内优先支付），超出部分才按比例进商业三者险
3. **明确区分"损失总额"与"实际到手"**，并在免责声明注明"个案结果不代表同类案件都能拿到同样数额"

实证参考（jtpc-01）：总损失 393104.75 元，读者直觉按"总损失 ×40%"只算出 157241.9 元，实际到手 253041.9 元，**差额 95800 元全部来自交强险不分责先赔的 198000 元**。这个反差本身就是极好的科普素材。

注：**工伤类文章不适用本条**，工伤适用无过错责任，不存在责任比例分摊。

对应门禁：`audit_visual.py` **TS-23**（交通事故 + 含赔偿明细 + 无工伤关键词的文章，若全文无责任划分表述即 FAIL）。

## 全局 CSS 变量（按文章类型切换）

| 类型 | 主色 | 用途 |
|------|------|------|
| 工伤(GSPC) | `#c24d76` | 工伤认定、赔偿计算、劳动能力鉴定程序 |
| 交通事故(JTPC) | `#2f86b7` | 人伤赔偿、事故处理 |
| 工伤+交通事故竞合 | `#8b5cb8` | 两领域交叉（上下班途中等） |

> 注：主题色由文章所属领域决定，不按"鉴定/程序/责任"等题材细分。劳动能力鉴定类文章属工伤领域，统一用 `#c24d76`，与工作流 Skill（labor-rights-workflow）分色规则一致。

以下模板中用 `--accent` 代表主色，实际输出时替换为对应类型的值。

## 样式配方（黄金标准版）

> **视觉规范以《十级工伤赔偿明细，一次性讲清》（2026-07-23发布，读者认可的最佳排版）为唯一基准。**
> 参考原件：`成品/NAS参考/十级工伤-黄金标准.html`
> 核心特征：**纯白卡片、无宣纸纹、16px正文、18px深色标题带左侧色条、14px段距**。

### 全局字体（正文容器）

```html
<section style="font-size:16px;line-height:1.85;color:#4a3f30;letter-spacing:.3px;word-break:break-word;border:1px solid #dcd2bf;border-radius:14px;padding:14px 12px;box-shadow:inset 0 0 0 6px rgba(120,100,70,.06),inset 0 0 16px rgba(120,100,70,.10);">
  <!-- 所有正文内容 -->
</section>
```

> **外层容器外框是强制件**（`1px solid #dcd2bf` + 圆角 + inset 灰描边，即读者说的「外框」）。
> 2026-08-20 教训：此模板曾漏掉外框，导致 gspc-04 重写后外框丢失仍推送。
> 重写/新建 HTML 时，**必须原样保留这行样式，一个字都不能少**。
> 已落门禁 `audit_visual.py` **TS-24**（缺 `dcd2bf` 即 FAIL）。

### 卡片容器（章节主卡片，纯白）

```html
<section style="margin:0 0 14px;padding:22px 20px;background:#fff;border-radius:12px;box-shadow:0 1px 4px rgba(120,100,70,.08);border:1px solid #ebe0cc;">
  <!-- 卡片内容 -->
</section>
```

> 纯白底 `#fff` + 细边框 `#ebe0cc` + 浅阴影。**不用宣纸纹、不用米黄底**。

### 章节标题（h3，左侧色条）

```html
<h3 style="margin:0 0 12px;font-size:18px;color:#3a2a30;border-left:3px solid --accent;padding-left:10px;font-weight:700;">标题文字</h3>
```

> `--accent` 替换为文章主题色（工伤 `#c24d76` / 交通事故 `#2f86b7` / 竞合 `#8b5cb8`）。
> 标题文字用深色 `#3a2a30`，左侧 3px 色条 + 10px 左内边距，**不用整行主题色**。

### 正文段落

```html
<p style="margin:0 0 10px;color:#4a3f30;line-height:1.85;">段落文字</p>
```

末段用 `margin:0` 避免底部多余间距。

### 纯文字区（不需卡片包裹的过渡段）

```html
<section style="margin:0 0 14px;">
  <p style="...(同上)">文字</p>
</section>
```

### 卡片使用边界（重要，排版前必读）

**只有以下场景可以用卡片背景**：标题卡、案情故事、法条引用、警示提示（⚠️）、知识提示（💡）、表格容器、居中强调短句、步骤列表、免责声明。

**以下内容一律用纯文字区，严禁套卡片背景**：
- 钩子、过渡段、收尾段
- 章节标题 + 引导说明
- 步骤正文（如"01 02 03"行动清单、准备事项逐条罗列）
- 案例叙述
- 配图

判断口诀：**有"强调 / 提示 / 引用"语义才上卡片，正文叙述一律纯文字**。拿不准时就选纯文字区，宁可少一个卡片，不要多一个。

### 章节标题

```html
<h3 style="margin:0 0 12px;font-size:18px;color:#3a2a30;border-left:3px solid --accent;padding-left:10px;font-weight:700;">标题文字</h3>
```

`--accent` 替换为文章类型对应的主色。标题文字深色，左侧色条标识。

### 法条引用卡片

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#fff5e6;border-left:4px solid --accent;border-radius:8px;">
  <p style="margin:0;color:#8a5a1b;font-size:15px;line-height:1.8;">
    <strong>《法条名称》第X条：</strong>法条原文中<strong>关键内容</strong>加粗标注。
  </p>
</section>
```

> 法条引用沿用警示卡底色 `#fff5e6`（浅橙），左边框用主题色。

### 法条速查表格

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#fff;border:1px solid #ebe0cc;border-radius:12px;">
  <h3 style="...(标题样式)...">关键法条速查</h3>
  <table style="width:100%;border-collapse:collapse;font-size:14px;margin:5px 0;">
    <tr style="background:#f5eee0;">
      <td style="padding:8px 10px;border:1px solid #ebe0cc;color:#4a3f30;font-weight:700;">列头1</td>
      <td style="padding:8px 10px;border:1px solid #ebe0cc;color:#4a3f30;font-weight:700;">列头2</td>
    </tr>
    <tr><td style="padding:8px 10px;border:1px solid #ebe0cc;color:#4a3f30;">内容</td><td style="...(同上)...">内容</td></tr>
    <tr style="background:#faf6ed;"><td style="...">内容</td><td style="...">内容</td></tr>
  </table>
</section>
```

表格行交替 `background:#faf6ed` 做斑马纹。

### 警示提示卡片（橙黄色左边框）

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#fff5e6;border-left:4px solid #e8943a;border-radius:8px;">
  <p style="margin:0;color:#8a5a1b;font-size:15px;line-height:1.8;">
    ⚠️ 警示内容...
  </p>
</section>
```

### 知识提示卡片（浅蓝底）

```html
<section style="margin:0 0 14px;padding:18px;background:#f3f8fb;border-radius:8px;">
  <p style="margin:0 0 6px;font-weight:700;color:#165d8f;">小标题</p>
  <p style="margin:0;color:#455a64;font-size:15px;line-height:1.8;">
    提示内容...
  </p>
</section>
```

> 知识卡 = 浅蓝底 `#f3f8fb` + 深蓝小标题 `#165d8f` + 深灰正文 `#455a64`。

### 居中强调短句

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#faf6ed;border-radius:8px;text-align:center;">
  <p style="margin:0;color:#3a2a30;font-size:15px;font-weight:700;">强调短句</p>
</section>
```

> 强调卡用米黄底 `#faf6ed`（无边框无阴影，弱化处理）。

### 配图

```html
<section style="margin:0 0 14px;">
  <img src="图片URL/640?from=appmsg" style="display:block;width:100%;height:auto;border-radius:12px;">
</section>
```

配图用 `src`（不要用 `data-src`），URL 必须带 `/640?from=appmsg` 后缀。推送脚本 push_mcp.py 只替换 `src="本地文件名"` 为微信 CDN URL，用 `data-src` 会导致图片无法替换、微信端不显示。

### 步骤列表（流程排版）

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#fff;border:1px solid #ebe0cc;border-radius:12px;">
  <p style="margin:0 0 6px;color:#4a3f30;font-size:15px;line-height:1.85;">
    ✓ 步骤一<br>
    <span style="color:#888;font-size:13px;">补充说明</span><br>
    ✓ 步骤二<br>
    ✓ 步骤三
  </p>
</section>
```

## 文末固定模块（每篇必加，顺序不可变）

> **顺序：延伸阅读 → 来源标注 → 免责声明 → 公众号名片**（延伸阅读在来源之前；用户2026-08-03确认规范）
> 若文章无延伸阅读，则顺序为 来源标注 → 免责声明 → 公众号名片。

### 0. 延伸阅读（可选，有则放最前）

```html
<section style="margin:0 0 14px;padding:22px 20px;background:#fff;border-radius:12px;box-shadow:0 1px 4px rgba(120,100,70,.08);border:1px solid #ebe0cc;">
  <h3 style="margin:0 0 12px;font-size:18px;color:#3a2a30;border-left:3px solid --accent;padding-left:10px;font-weight:700;">延伸阅读</h3>
  <p style="margin:0 0 8px;color:#4a3f30;line-height:1.8;font-size:15px;"><a href="https://mp.weixin.qq.com/s/xxxx" style="color:#c24d76;text-decoration:underline;">《文章标题》</a> — 一句话说明</p>
</section>
```

> 标题用深色（与正文标题一致），链接用主题色下划线，每条后跟" — 一句话说明"。

### 1. 来源标注

```html
<section style="margin:0 0 14px;padding:14px 16px;background:rgba(120,100,70,.06);border-radius:8px;color:#607d8b;font-size:13px;line-height:1.75;">
  <p style="margin:0;">
    来源：本文梳理自《XXX法》、《XXX条例》及相关司法解释现行有效版本。内容仅供信息参考。
  </p>
</section>
```

> 来源卡 = 半透明浅灰底 `rgba(120,100,70,.06)` + 灰字 `#607d8b`，13px 小字。

### 2. 免责声明卡片

```html
<section style="margin:0 0 14px;padding:14px 16px;background:#fff5e6;border-left:4px solid #e8943a;border-radius:8px;">
  <p style="margin:0;color:#8a5a1b;font-size:13px;line-height:1.8;">
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

## 排版规则

### 段落

- 每段 ≤ 3 句，超长必须拆分
- 段落间 `margin:0 0 10px`（末段 `margin:0`）
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
- 封面比例 1.565:1（1216×777，已去水印），正文配图 16:9 横图
- 每篇 2-3 张，不超 3 张
- 图片 URL 必须完整（`/640?from=appmsg`）

## 排版自检清单

- **正文内没有文章大标题卡（避免两个标题）？**
- **宣纸卡底用的是 v4 URL（`sz_mmbiz_jpg/ysL2dia5FLeCroicI0mHMSOO…`），无 v1/v3 旧素材残留？**
- **案例已二次脱敏（无街道/路段级地址、无当事人姓名含化名、无鉴定机构名、无户籍地、日期只到年月）？**
- **交通事故赔偿类文章已交代责任比例，并讲清"责任比例只作用于超出交强险的部分"？**
- 每段 ≤ 3 句？
- 加粗只用在标题/结论/判决要点？
- 编号格式统一？
- 法条用了引用卡片格式（左边框或宣纸卡底）？
- 配图位置标记正确？
- 没有文首关注引导？
- 文末固定模块齐全（延伸阅读→来源+免责+名片，延伸阅读在来源之前）？
- **外层容器外框存在（`border:1px solid #dcd2bf`，TS-24，缺即 FAIL）？**
- **章节白卡数与 h3 章节数匹配（白卡 ≥ 章节数-1，TS-25）？** 重写后若章节被拆成裸文字区，门禁必须拦住
- 卡片间距均匀（`margin:0 0 14px`）？
- 章节主卡为纯白 `#fff` 无宣纸纹（宣纸纹只用于法条/强调卡底）？
- `--accent` 主色与文章类型匹配？

## 存量旧版文章重排

处理 v1 米黄底旧版文章（特征：`background-color:#f5f0e6`、`repeating-linear-gradient` 伪宣纸纹、`padding:14px 12px`）时，读 `references/v1_to_v2_migration.md`——含六项替换映射、分块 Write 粒度控制（长 HTML 一次写入会参数丢失）、单篇门禁明细提取命令、内容门禁高频 FAIL 改写模板。

**重排是内容复检的唯一窗口**，必须顺带查两项：① 开篇是否为设问式（应为真实场景切入）② 是否存在虚构案例（含自标"假设情景"的举例，同样违规）。
