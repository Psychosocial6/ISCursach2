-- 1
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM tournaments WHERE status = 'REGISTRATION';
BEGIN;
  DROP INDEX idx_tournaments_status;
  EXPLAIN (ANALYZE, BUFFERS)
  SELECT * FROM tournaments WHERE status = 'REGISTRATION';
ROLLBACK;


-- 2
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournaments ORDER BY start_date DESC LIMIT 20;
BEGIN;
  DROP INDEX idx_tournaments_start_date;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournaments ORDER BY start_date DESC LIMIT 20;
ROLLBACK;


-- 3
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM matches WHERE tournament_id = 500;
BEGIN;
  DROP INDEX idx_matches_tournament_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM matches WHERE tournament_id = 500;
ROLLBACK;


-- 4.1
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM matches WHERE participant1 = 1200;
BEGIN;
  DROP INDEX idx_matches_participant1;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM matches WHERE participant1 = 1200;
ROLLBACK;
-- 4.2
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM matches WHERE participant2 = 1200;

BEGIN;
  DROP INDEX idx_matches_participant2;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM matches WHERE participant2 = 1200;
ROLLBACK;


-- 5
EXPLAIN (ANALYZE, BUFFERS) 
SELECT count(*) FROM matches WHERE winner_id = 3500;
BEGIN;
  DROP INDEX idx_matches_winner_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT count(*) FROM matches WHERE winner_id = 3500;
ROLLBACK;


-- 6
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM matches WHERE winner_next_match_id = 150;
BEGIN;
  DROP INDEX idx_matches_winner_next_match;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM matches WHERE winner_next_match_id = 150;
ROLLBACK;


-- 7
EXPLAIN (ANALYZE, BUFFERS) 
SELECT count(*) FROM match_games WHERE winner_id = 4500;
BEGIN;
  DROP INDEX idx_match_games_winner_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT count(*) FROM match_games WHERE winner_id = 4500;
ROLLBACK;

-- 8
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournaments WHERE admin_id = 1500;
BEGIN;
  DROP INDEX idx_tournaments_admin_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournaments WHERE admin_id = 1500;
ROLLBACK;


-- 9
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM match_games WHERE match_id = 25000;
BEGIN;
  DROP INDEX idx_match_games_match_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM match_games WHERE match_id = 25000;
ROLLBACK;


-- 10
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM tournaments WHERE sport_id = 12;
BEGIN;
  DROP INDEX idx_tournaments_sport_id;
  DROP INDEX idx_tournaments_sport_status;
  EXPLAIN (ANALYZE, BUFFERS)
  SELECT * FROM tournaments WHERE sport_id = 12;
ROLLBACK;

-- 11
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournament_results WHERE tournament_id = 1500 ORDER BY place ASC;
BEGIN;
  DROP INDEX idx_tournament_results_tournament_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournament_results WHERE tournament_id = 1500 ORDER BY place ASC;
ROLLBACK;


-- 12
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournament_results WHERE participant_id = 3000;
BEGIN;
  DROP INDEX idx_tournament_results_participant_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournament_results WHERE participant_id = 3000;
ROLLBACK;


-- 13
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournament_applications WHERE tournament_id = 2000;
BEGIN;
  DROP INDEX idx_tournament_applications_tournament_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournament_applications WHERE tournament_id = 2000;
ROLLBACK;


-- 14
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournament_applications WHERE user_id = 5500;
BEGIN;
  DROP INDEX idx_tournament_applications_user_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournament_applications WHERE user_id = 5500;
ROLLBACK;


-- 15
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM team_members WHERE user_id = 7000;
BEGIN;
  DROP INDEX idx_team_members_user_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM team_members WHERE user_id = 7000;
ROLLBACK;


-- 16
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM team_members WHERE team_id = 150;
BEGIN;
  DROP INDEX idx_team_members_team_id;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM team_members WHERE team_id = 150;
ROLLBACK;


-- 17
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM match_protocols WHERE created_by = 500;
BEGIN;
  DROP INDEX idx_match_protocols_created_by;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM match_protocols WHERE created_by = 500;
ROLLBACK;


-- 18
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM tournaments WHERE sport_id = 10 AND status = 'REGISTRATION';
BEGIN;
  DROP INDEX idx_tournaments_sport_status;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM tournaments WHERE sport_id = 10 AND status = 'REGISTRATION';
ROLLBACK;


-- 19
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM password_reset_tokens WHERE user_id = 15000;
BEGIN;
  DROP INDEX idx_password_reset_tokens_user_id_hash;
  EXPLAIN (ANALYZE, BUFFERS) 
  SELECT * FROM password_reset_tokens WHERE user_id = 15000;
ROLLBACK;