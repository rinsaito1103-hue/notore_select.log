-- 農トレ：資金不足で次の年度に進めず、自動で融資（5000万円単位）を受けた記録（分析用）
-- 融資はその年度の決算時に全額返済（資金から差し引き）される
-- ※ Supabase の SQL Editor で一度実行してください。何回実行しても問題ありません。
--   実行前でもゲームは動きます（記録だけが保存されません）。

CREATE TABLE IF NOT EXISTS loan_logs (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room_id      text NOT NULL,
  player_name  text NOT NULL,      -- チーム名
  log_group    text,               -- 'log' = ログあり群 / 'nolog' = ログなし群
  year         integer,            -- 融資を受けた年度（1〜3）。同じ年度の決算で返済
  money_before bigint,             -- 融資前の所持資金
  investment   bigint,             -- その年度の投資総額
  loan_amount  bigint,             -- 今回の融資額（5000万円 × loan_count）
  loan_count   integer,            -- 今回の融資の口数（5000万円単位）
  total_loan   bigint,             -- そのゲームでの融資の累計
  created_at   timestamptz DEFAULT now()
);

ALTER TABLE loan_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon insert loan_logs" ON loan_logs;
CREATE POLICY "anon insert loan_logs" ON loan_logs FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon select loan_logs" ON loan_logs;
CREATE POLICY "anon select loan_logs" ON loan_logs FOR SELECT TO anon USING (true);

NOTIFY pgrst, 'reload schema';

-- 分析用の例：班ごとの融資の回数と合計額（最終資金は返済後の値）
-- SELECT s.room_id, s.player_name, s.log_group, s.final_money,
--        coalesce(sum(l.loan_count), 0)  AS 融資回数,
--        coalesce(sum(l.loan_amount), 0) AS 融資合計
-- FROM scores s
-- LEFT JOIN loan_logs l ON l.room_id = s.room_id AND l.player_name = s.player_name
-- GROUP BY s.room_id, s.player_name, s.log_group, s.final_money
-- ORDER BY s.room_id, s.player_name;
