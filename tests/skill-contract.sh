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
grep -Fq "background-image:url('https://mmbiz.qpic.cn/" "$skill_dir/SKILL.md"
grep -Fq 'background-repeat:repeat-y' "$skill_dir/SKILL.md"
grep -Fq 'background-size:100% auto' "$skill_dir/SKILL.md"
grep -Fq 'box-shadow:inset 0 0 0.15mm rgba(88,88,88,.32)' "$skill_dir/SKILL.md"

echo 'skill contract: pass'
