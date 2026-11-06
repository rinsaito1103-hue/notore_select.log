-- 農トレ：卒論の比較実験用（ログあり群 / ログなし群）の準備SQL
-- ※ 新しい game.js を公開する「前」に、Supabase の SQL Editor で実行してください。何回実行しても問題ありません。

-- メンバー表を作る（学籍番号・氏名・群）
CREATE TABLE IF NOT EXISTS team_members (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room_id      text NOT NULL,
  team_name    text NOT NULL,
  student_id   text NOT NULL,
  student_name text NOT NULL,
  log_group    text,
  created_at   timestamptz DEFAULT now(),
  UNIQUE (room_id, team_name, student_id)
);

-- すでに team_members 表がある場合にも群の列を追加する
ALTER TABLE team_members ADD COLUMN IF NOT EXISTS log_group text;

-- ゲーム（匿名キー）から追加・読み取りできるようにする
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon insert team_members" ON team_members;
CREATE POLICY "anon insert team_members" ON team_members FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon select team_members" ON team_members;
CREATE POLICY "anon select team_members" ON team_members FOR SELECT TO anon USING (true);

-- 群（'log' = ログあり群 / 'nolog' = ログなし群）の列
ALTER TABLE yearly_logs ADD COLUMN IF NOT EXISTS log_group text;
ALTER TABLE scores      ADD COLUMN IF NOT EXISTS log_group text;

-- 土地の列
ALTER TABLE yearly_logs ADD COLUMN IF NOT EXISTS land_id   text;
ALTER TABLE yearly_logs ADD COLUMN IF NOT EXISTS land_name text;
ALTER TABLE scores      ADD COLUMN IF NOT EXISTS land_id   text;
ALTER TABLE scores      ADD COLUMN IF NOT EXISTS land_name text;

-- 土地の自動割り当て表（同じルームのチーム数を数えて、6種類の土地を偏りなく配るために使う）
CREATE TABLE IF NOT EXISTS team_lands (
  id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room_id    text NOT NULL,
  team_name  text NOT NULL,
  log_group  text,
  land_id    text,
  land_name  text,
  created_at timestamptz DEFAULT now(),
  UNIQUE (room_id, log_group, team_name)
);
ALTER TABLE team_lands ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon insert team_lands" ON team_lands;
CREATE POLICY "anon insert team_lands" ON team_lands FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon select team_lands" ON team_lands;
CREATE POLICY "anon select team_lands" ON team_lands FOR SELECT TO anon USING (true);

-- 同時接続対策の版（2026-11-06）で必要な追加設定：参加登録のあとに土地を書き込むため
ALTER TABLE team_lands ALTER COLUMN land_id DROP NOT NULL;
DROP POLICY IF EXISTS "anon update team_lands" ON team_lands;
CREATE POLICY "anon update team_lands" ON team_lands FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- Supabase に新しい列をすぐ認識させる
NOTIFY pgrst, 'reload schema';
