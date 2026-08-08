#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "$0")/.." && pwd)"
asset="$skill_dir/assets/xuan-paper.png"
expected_hash="0bd510533dcc78b24f22c30ae7052dd1308c3dce6320fedc12b54aca077144b9"
wechat_asset="$skill_dir/assets/xuan-paper-wechat.jpg"
wechat_hash="18b9bc813a461cff51d537004b3d1801d961b5b7247d391981776202d74295df"

test -f "$asset"
test "$(shasum -a 256 "$asset" | awk '{print $1}')" = "$expected_hash"
test -f "$wechat_asset"
test "$(shasum -a 256 "$wechat_asset" | awk '{print $1}')" = "$wechat_hash"
test "$(stat -f '%z' "$wechat_asset")" -lt 2097152
grep -Fq '/640?from=appmsg&quot;);background-size:cover' "$skill_dir/SKILL.md"
grep -Fq 'background-blend-mode:multiply' "$skill_dir/SKILL.md"
grep -Fq '宣纸只用于重点模块' "$skill_dir/SKILL.md"
grep -Fq 'box-shadow:inset 0 0 0.15mm rgba(88,88,88,.55)' "$skill_dir/SKILL.md"
grep -Fq '不得见到章节标题就新开一张卡片' "$skill_dir/SKILL.md"
grep -Fq '短篇轻量科普通常只使用 2—3 张正文主卡片' "$skill_dir/SKILL.md"
grep -Fq '核心结论、规则依据、误区提醒、行动步骤' "$skill_dir/SKILL.md"
grep -Fq '存在三个以上不同类型的重点时，不得只使用一次宣纸' "$skill_dir/SKILL.md"
grep -Fq '整篇文章必须使用一个全文外框' "$skill_dir/SKILL.md"
grep -Fq 'class="article-shell"' "$skill_dir/SKILL.md"
grep -Fq 'box-shadow:inset 0 0 1.5mm rgba(88,88,88,.45)' "$skill_dir/SKILL.md"
grep -Fq '全文外框的 1.5mm 内渐变灰边' "$skill_dir/references/typesetting_guide.md"
! grep -Fq '不加整篇内框' "$skill_dir/SKILL.md"

echo 'skill contract: pass'
