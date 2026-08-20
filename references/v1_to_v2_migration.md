# v1 米黄底 → v2 纯白黄金标准 重排作业流程

已连续跑通 3 篇（02 号、03 号、gspc-01），流程与踩坑点固化。**只在处理存量旧版文章时使用**；新文章直接按 SKILL.md 主体规范写。

## 识别 v1 特征（命中任一即需重排）

```
background-color:#f5f0e6                          外层米黄底
repeating-linear-gradient(...)                     CSS 伪宣纸纹（v1 废弃写法）
font-family:-apple-system,sans-serif               表格内冗余字体声明
padding:14px 12px                                  主卡片内边距（v2 应为 22px 20px）
margin-bottom:10px                                 卡片间距（v2 应为 margin:0 0 14px）
background:#faf8f3                                 表格交替行旧底色（v2 用 #fdfbf7）
```

## 六项替换映射

| 部位 | v1 | v2 |
|---|---|---|
| 外层容器 | `background-color:#f5f0e6` | `border:1px solid #dcd2bf;border-radius:14px;padding:14px 12px;box-shadow:inset...` |
| 章节主卡 | 米黄底 / 伪宣纸纹 | `background:#fff;border:1px solid #ebe0cc;border-radius:12px;box-shadow:0 1px 4px rgba(120,100,70,.08)` |
| 卡片内边距 | `padding:14px 12px` | `padding:22px 20px` |
| 卡片间距 | `margin-bottom:10px` | `margin:0 0 14px` |
| 法条卡 | CSS 伪宣纸纹 + 左边框 | v3 宣纸 CDN 素材 + `background-blend-mode:multiply`，**无左边框** |
| 表格交替行 | `#faf8f3` | `#fdfbf7`（表头保留 `#f5eee0`），并删除全部 `font-family` 声明 |

## 执行步骤

1. **先备份**：`.html.bak_v1_YYYYMMDD` 与 `.md.bak_v1_YYYYMMDD`
2. **顺带体检内容层**（重排时最容易一并发现的两类硬伤，见下节）
3. **分块重写 HTML**，Python 合并
4. **跑双门禁** → `audit_content.py` + `audit_visual.py`，直到 0 FAIL
5. **同步索引**（`成品/文章索引.json`），若新引法条先补 `成品/法条与赔偿标准库.json`
6. **推送草稿** → 清理临时文件

## 重排时必须顺带体检的两类内容硬伤

存量 v1 文章往往写于规范定稿之前，重排是唯一的复检窗口：

1. **开篇是否为设问/排比式** → 必须换成真实场景切入（真实时间地点 + 人物动作 + 结果悬念）
2. **是否存在虚构案例** → 包括自标"以下为假设情景，非真实案例"的举例，同样违规，必须用真实判决替换（元典 MCP 检索 + 判决书全文核验 + 二次脱敏）

## 分块 Write 粒度控制（必读）

长 HTML 一次性 `Write` 会触发参数丢失，**连续三篇每篇都复现一次**：

```
Parameter "file_path" expected string, but received undefined
Parameter "content" expected string, but received undefined
```

**解法**：拆成 5 块以内分别写入临时文件，再用 Python 合并。单块过大时继续对半拆。

```python
chunks = ['_a.html','_b.html','_c.html','_d.html','_e.html']
out = [open(c, encoding='utf-8').read().strip('\n') for c in chunks]
open('成品/公众号排版/<id>.html','w',encoding='utf-8').write('\n'.join(out)+'\n')
```

合并后立刻校验 `<section>` 开合平衡，再删临时文件。

## 提取单篇门禁明细

`audit_visual.py` 不支持单篇参数，且输出无固定分隔宽度，`grep -A42` 会截断或串行。按**下一篇标题**定界：

```bash
python audit_visual.py 2>&1 | sed -n '/gspc-01/,/复核文章: gspc-02/p'
```

## 内容门禁高频 FAIL 与改写模板

**否定并列句式「不是…而是」**——重写章节时极易引入：

```
❌ 这时候拒不到场，不是"维持原判"，而是可能连原来的等级都拿不到。
✅ 这时候拒不到场并不等于"维持原判"，反倒可能连原来的等级都拿不到。
```

同类需规避：破折号（——）、"不仅…更是"、"与其说…不如说"。

**新引法条未入库**必 FAIL。注意 `laws[法名].articles` 的 value 是**纯字符串**，不是 dict。

## 完成判据

```
纯白底 ≥ 章节数    宣纸卡 ≥ 2 处    padding22 = 章节数
margin14 ≥ 卡片数   h3 左边条 = h3 数    TS-01~TS-23 全绿
audit_content 0 FAIL（法条全命中、加粗密度合理）
```
