---
name: labor-rights-wechat-layout
description: Use when 已审核的工伤、交通事故、劳动能力鉴定、人身损害伤残鉴定或混合主题文章需要生成微信公众号手机端 HTML，并装配已审核图片和固定文末模块
---

# 法律公众号排版

## 职责边界

输入必须是已经通过内容审核的正文母版和视觉资产包。

本 Skill 可以：

- 选择适合内容的移动端排版模板；
- 拆分过长段落、调整标题层级、编号、卡片、留白和有限加粗；
- 安排已审核图片的位置；
- 装配来源、免责声明、延伸阅读、小程序和公众号名片；
- 生成可交给发布员的完整 HTML。

本 Skill 不可以：

- 改变事实、法律观点、法条、金额、期限、案例结论或行动建议；
- 增删会改变文章含义的正文内容；
- 自行研究、写作、生图、OCR、审核、备份、推送或删除草稿；
- 用固定模板强迫正文改变原有叙事逻辑。

如果排版需要实质修改正文，返回写手修改，修改后的正文必须重新经过法律审核。不得由排版环节直接改写。

## 输入要求

开始前确认输入包至少包含：

- `article_id`
- `source_body_version`
- `approved_body`
- `approved_segments`
- `article_type`
- `planned_inline_image_count`
- `verified_inline_images`
- `verified_image_urls`
- `cover_image`
- `source_list`
- `related_articles`

图片完整性按以下规则判断：

- `planned_inline_image_count > 0` 时，`verified_inline_images` 数量必须与计划一致；
- 每张正文图必须有可用地址或资产引用，并已通过真实图片 OCR 与视觉审核；
- `planned_inline_image_count = 0` 只有在视觉方案明确判定“不需要正文图”时才有效；
- 图片为 `partial`、缺少引用、审核状态不明或数量不一致时，立即退回配图员，不得继续排版；
- 不得把封面图冒充正文图，也不得用占位符通过检查。

## 执行流程

1. 核对正文母版版本和内容审核状态。
2. 核对封面图、正文图计划数、已审核数和资产引用。
3. 使用 B 模式，根据文章内容选择一种主版式，必要时少量组合：
   - 案例叙事；
   - 实操清单；
   - 问答解释；
   - 对比辨析；
   - 轻量科普。
4. 按 `references/typesetting_guide.md` 直接生成完整微信公众号内联样式 HTML 正文片段，不使用固定模板、主题、表面或密度枚举。
5. 按 `references/brand_visual_guide.md` 装配图片和品牌模块。
6. 先登记不可变审核母稿，再把自定义 HTML 和 `verified_image_urls` 交给可信中继；中继必须逐字校验可见文字并生成 `render_id`。
7. 回读 `render_id` 对应的实际 HTML，对照正文母版进行内容、图片与版本一致性检查。
8. 输出排版结果包，交给最终审核员；不得自行推送草稿。

## 硬性规则

- 直接进入正文，不添加文首关注引导。
- 不使用 `---` 或 `<hr>` 分割线，章节通过卡片和间距区分。
- 每段通常不超过 3 句；拆段不得改变语义。
- 加粗只用于标题、法律结论、判决要点和关键法律要件。
- 正文图不加文字，封面文字按视觉方案执行。
- 图片数量由文章内容和已审核视觉方案决定，不机械限定为固定张数。
- 版式必须适合微信公众号手机端，不追求超大图片。
- HTML 只使用内联样式，不得包含 `<style>`、脚本、事件属性、外链样式、本地路径、NAS 地址或内网地址。
- 自定义 HTML 的可见文字必须与 `approved_segments` 逐字一致；只允许标签拆分和样式变化。
- 默认中文输出；只有法规原名、产品名、字段名等确有必要时保留英文。

## 输出格式

```yaml
layout_packet:
  article_id: ""
  source_body_version: ""
  template: ""
  layout_mode: custom_html
  content_lock: ""
  render_id: ""
  html: ""
  planned_inline_image_count: 0
  verified_inline_image_count: 0
  inline_image_refs: []
  verified_image_urls: []
  cover_image_ref: ""
  substantive_content_changed: false
  mobile_layout_checked: true
  status: ready_for_final_review
  return_to: ""
  error:
    stage: ""
    category: ""
    actual_message: ""
```

只有以下条件全部满足时，`status` 才能是 `ready_for_final_review`：

- 正文母版未被实质改写；
- 正文图片计划数、审核通过数和引用数完全一致；
- 封面和所有正文图均可读取；
- 移动端排版自检通过；
- 固定文末模块完整。

否则输出实际错误并设置 `return_to`：

- 正文需要实质修改：`law-writer`
- 图片缺失或不合格：`law-visual`
- 法律或事实疑点：`law-reviewer`

## 规则优先级

本文件是唯一主规则。参考文件只提供排版和视觉细节；如与本文件冲突，以本文件为准。
