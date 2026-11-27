-- 農トレ：資金不足で次の年度に進めず、資金が自動追加（5000万円単位）された記録（分析用）
-- ※ Supabase の SQL Editor で一度実行してください。何回実行しても問題ありません。
--   実行前でもゲームは動きます（記録だけが保存されません）。

CREATE TABLE IF NOT EXISTS auto_fund_logs (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room_id      text NOT NULL,
  player_name  text NOT NULL,      -- チーム名
  log_group    text,               -- 'log' = ログあり群 / 'nolog' = ログなし群
  year         integer,            -- 追加された年度（1〜3）
  money_before bigint,             -- 追加前の所持資金
  investment   bigint,             -- その年度の投資総額
  added_amount bigint,             -- 今回追加した金額（5000万円 × 回数）
  total_added  bigint,             -- そのゲームでの追加合計
  created_at   timestamptz DEFAULT now()
);

ALTER TABLE auto_fund_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon insert auto_fund_logs" ON auto_fund_logs;
CREATE POLICY "anon insert auto_fund_logs" ON auto_fund_logs FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon select auto_fund_logs" ON auto_fund_logs;
CREATE POLICY "anon select auto_fund_logs" ON auto_fund_logs FOR SELECT TO anon USING (true);

NOTIFY pgrst, 'reload schema';

-- 分析用の例：班ごとの自動追加の回数と合計額（最終資金から差し引いた実力値も出す）
-- SELECT s.room_id, s.player_name, s.log_group, s.final_money,
--        coalesce(sum(f.added_amount), 0)                 AS 追加合計,
--        coalesce(sum(f.added_amount), 0) / 50000000      AS 追加回数,
--        s.final_money - coalesce(sum(f.added_amount), 0) AS 追加分を除いた最終資金
-- FROM scores s
-- LEFT JOIN auto_fund_logs f ON f.room_id = s.room_id AND f.player_name = s.player_name
-- GROUP BY s.room_id, s.player_name, s.log_group, s.final_money
-- ORDER BY s.room_id, s.player_name;
