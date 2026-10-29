# 農トレ 比較実験用（ログあり群 / ログなし群）

- `a/` … ログ機能あり版（Supabase の log_group = "log"）
- `b/` … ログ機能なし版（Supabase の log_group = "nolog"）
- 管理者画面: `a/host.html`（`b/host.html` も同じ内容）
- 公開前に `supabase/add_log_group_column.sql` を Supabase の SQL Editor で実行すること

両群とも同じルームIDで実施し、土地番号（1〜6）は事前に抽選して両群に同じ組を配る。
