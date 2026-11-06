# 農トレ 比較実験用（ログあり群 / ログなし群）

- `a/` … ログ機能あり版（Supabase の log_group = "log"）
- `b/` … ログ機能なし版（Supabase の log_group = "nolog"）
- 管理者画面: `a/host.html`（`b/host.html` も同じ内容）
- 公開前に `supabase/add_log_group_column.sql` を Supabase の SQL Editor で実行すること

両群とも同じルームIDで実施する。土地はゲーム開始時に自動で割り当てられる（Supabase の team_lands 表）。
自分の群の中で最も少ない土地 → 同数ならもう一方の群で多い土地 → それでも同数ならルームIDごとに決まる順番、の順に
参加順で全チーム分を計算するので（同時にスタートしても偏らない）、
各群で6種類が均等になり、両群の土地構成もそろう。チーム名は両群を通して重複させないこと。
