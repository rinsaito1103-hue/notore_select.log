-- 農トレ：割り当てられた土地の種類を保存する列を追加
-- ※ game.js を更新・公開する「前」に、Supabase の SQL Editor で実行してください。
--   （列がないまま新しい game.js が動くと、年次ログやスコアの保存が失敗します）

ALTER TABLE yearly_logs ADD COLUMN IF NOT EXISTS land_id   text;  -- lands.js の id（premium / urban / normal / mountain / abandoned / large）
ALTER TABLE yearly_logs ADD COLUMN IF NOT EXISTS land_name text;  -- 表示名（優良農地 など）

ALTER TABLE scores ADD COLUMN IF NOT EXISTS land_id   text;
ALTER TABLE scores ADD COLUMN IF NOT EXISTS land_name text;

-- 分析用の例：アンケート（学籍番号）× 土地 × 最終資金
-- SELECT m.student_id, m.student_name, m.room_id, m.team_name, s.land_id, s.land_name, s.final_money
-- FROM team_members m
-- JOIN scores s ON s.room_id = m.room_id AND s.player_name = m.team_name;
