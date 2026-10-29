-- 農トレ：卒論の比較実験用に「ログあり群 / ログなし群」を記録する列を追加
-- ※ ログあり版・ログなし版の新しい game.js を公開する「前」に、Supabase の SQL Editor で1回実行してください。
--   （列がないまま新しい game.js が動くと、メンバー・年次ログ・スコアの保存が失敗します）

ALTER TABLE team_members ADD COLUMN IF NOT EXISTS log_group text;  -- 'log' = ログあり群 / 'nolog' = ログなし群
ALTER TABLE yearly_logs  ADD COLUMN IF NOT EXISTS log_group text;
ALTER TABLE scores       ADD COLUMN IF NOT EXISTS log_group text;

-- 分析用の例：群 × 土地ごとの最終資金の平均
-- SELECT log_group, land_name, COUNT(*) AS teams, AVG(final_money) AS avg_final_money
-- FROM scores
-- WHERE room_id = 'ここにルームID'
-- GROUP BY log_group, land_name
-- ORDER BY land_name, log_group;
