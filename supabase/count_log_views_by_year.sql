-- 農トレ：「経営履歴」を年度ごとに何回開いたかを集計する（分析用・読み取りのみ）
-- ※ 先に add_log_button_clicks.sql を実行しておくこと（記録はゲーム側で自動で保存される）
-- ※ Supabase の SQL Editor に貼り付けて実行し、結果は右上の「Download CSV」で保存できる
-- ※ 'ルームID' の部分を実験で使ったルームIDに書き換える（全ルームを見たいときは WHERE 行を消す）
--
-- button = 'setup'  … 戦略設定画面のボタン（その年度の戦略を決める前に見た回数）
-- button = 'result' … 最終結果画面のボタン（3年間終了後に見た回数。year は 3 になる）
-- 経営履歴ボタンがあるのはログあり群（log_group = 'log'）だけ

-- ① 班 × 年度ごとの回数（0回の年度も 0 として出す）
SELECT
  t.room_id,
  t.player_name                                         AS 班名,
  y.year                                                AS 年度,
  count(c.id) FILTER (WHERE c.button = 'setup')         AS 戦略設定画面で開いた回数,
  count(c.id) FILTER (WHERE c.button = 'result')        AS 最終結果画面で開いた回数,
  count(c.id)                                           AS 合計
FROM (SELECT DISTINCT room_id, player_name FROM yearly_logs WHERE log_group = 'log') t
CROSS JOIN generate_series(1, 3) AS y(year)
LEFT JOIN log_button_clicks c
  ON c.room_id = t.room_id AND c.player_name = t.player_name AND c.year = y.year
WHERE t.room_id = 'ルームID'
GROUP BY t.room_id, t.player_name, y.year
ORDER BY t.room_id, t.player_name, y.year;

-- ② 年度ごとの全班合計・1班あたり平均（戦略設定画面のみ）
-- SELECT year AS 年度,
--        count(*) AS 合計回数,
--        count(DISTINCT player_name) AS 開いた班の数
-- FROM log_button_clicks
-- WHERE room_id = 'ルームID' AND button = 'setup'
-- GROUP BY year ORDER BY year;
