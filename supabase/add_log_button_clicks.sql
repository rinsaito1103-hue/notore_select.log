-- 農トレ：「経営履歴」ボタンを押した記録（分析用）
-- ※ Supabase の SQL Editor で一度実行してください。何回実行しても問題ありません。
--   実行前でもゲームは動きます（記録だけが保存されません）。

CREATE TABLE IF NOT EXISTS log_button_clicks (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room_id     text NOT NULL,
  player_name text NOT NULL,      -- チーム名
  log_group   text,               -- 'log' = ログあり群（ボタンがあるのはこちらだけ）
  year        integer,            -- 押したときの年度（1〜3）
  game_phase  text,               -- 押したときの段階（setup = 戦略設定中 / finished = 3年間終了 など）
  button      text,               -- 'setup' = 戦略設定画面のボタン / 'result' = 最終結果画面のボタン
  clicked_at  timestamptz DEFAULT now()
);

-- ゲーム（匿名キー）から追加・読み取りできるようにする
ALTER TABLE log_button_clicks ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon insert log_button_clicks" ON log_button_clicks;
CREATE POLICY "anon insert log_button_clicks" ON log_button_clicks FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon select log_button_clicks" ON log_button_clicks;
CREATE POLICY "anon select log_button_clicks" ON log_button_clicks FOR SELECT TO anon USING (true);

NOTIFY pgrst, 'reload schema';

-- 分析用の例：チーム・年度ごとの押した回数
-- SELECT room_id, player_name, year, count(*) AS clicks
-- FROM log_button_clicks
-- GROUP BY room_id, player_name, year
-- ORDER BY room_id, player_name, year;
