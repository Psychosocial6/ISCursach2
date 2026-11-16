TRUNCATE users, sports, teams, team_members, tournaments, referees, 
         tournament_applications, matches, match_games, match_protocols, 
         tournament_results, password_reset_tokens RESTART IDENTITY CASCADE;

BEGIN;

INSERT INTO users (id, username, email, password, name, surname, vk_id)
SELECT 
    i,
    'user_' || i,
    'user_' || i || '@example.com',
    'hash_password_' || i,
    'Name_' || i,
    'Surname_' || i,
    'vk_id_' || i
FROM generate_series(1, 10000) AS i;

INSERT INTO sports (id, name, is_cybersport, supports_faceit)
SELECT 
    i,
    'Sport ' || i,
    (random() > 0.5),
    (random() > 0.5)
FROM generate_series(1, 20) AS i;

INSERT INTO password_reset_tokens (user_id, token, expires_at)
SELECT 
    1 + floor(random() * 10000)::int,
    md5(random()::text),
    NOW() + (random() * interval '7 days')
FROM generate_series(1, 10000) AS i;

INSERT INTO teams (id, captain_id, name, tag, creation_date)
SELECT 
    i,
    1 + floor(random() * 10000)::int,
    'Team ' || i,
    'T' || i,
    NOW() - (random() * interval '365 days')
FROM generate_series(1, 2000) AS i;

INSERT INTO team_members (team_id, user_id)
SELECT 
    1 + floor(random() * 2000)::int,
    1 + floor(random() * 10000)::int
FROM generate_series(1, 15000) AS i;

INSERT INTO tournaments (
    id, admin_id, sport_id, title, regulations, participation_type, 
    format, status, reg_start_date, reg_end_date, start_date, end_date, max_participants
)
SELECT 
    i,
    1 + floor(random() * 10000)::int,
    1 + floor(random() * 20)::int,
    'Tournament #' || i,
    'Regulations text...',
    (ARRAY['SOLO', 'TEAM']::enum_participation_type[])[floor(random() * 2 + 1)],
    (ARRAY['SINGLE_ELIMINATION', 'DOUBLE_ELIMINATION', 'ROUND_ROBIN', 'SWISS']::enum_format[])[floor(random() * 4 + 1)],
    (ARRAY['DRAFT', 'REGISTRATION', 'ONGOING', 'FINISHED', 'CANCELLED']::enum_status_tournaments[])[floor(random() * 5 + 1)],
    NOW() - (random() * interval '30 days'),
    NOW() + (random() * interval '10 days'),
    NOW() + (random() * interval '60 days') - interval '30 days',
    NOW() + (random() * interval '90 days'),
    (ARRAY[8, 16, 32, 64])[floor(random() * 4 + 1)]
FROM generate_series(1, 5000) AS i;

INSERT INTO referees (id, tournament_id, user_id)
SELECT 
    i,
    1 + floor(random() * 5000)::int,
    1 + floor(random() * 10000)::int
FROM generate_series(1, 3000) AS i;

INSERT INTO tournament_applications (id, tournament_id, user_id, team_id, status, creation_date)
SELECT 
    i,
    1 + floor(random() * 5000)::int,
    1 + floor(random() * 10000)::int,
    1 + floor(random() * 2000)::int,
    (ARRAY['PENDING', 'APPROVED', 'REJECTED']::enum_status_applications[])[floor(random() * 3 + 1)],
    NOW() - (random() * interval '30 days')
FROM generate_series(1, 25000) AS i;

INSERT INTO matches (
    id, tournament_id, participant1, participant2, winner_id, 
    bracket_stage, round_number, score1, score2, status, 
    winner_next_match_id, loser_next_match_id, start_date
)
SELECT 
    i,
    1 + floor(random() * 5000)::int,
    1 + floor(random() * 25000)::int,
    1 + floor(random() * 25000)::int,
    1 + floor(random() * 25000)::int,
    'Round 1',
    floor(random() * 5 + 1)::int,
    floor(random() * 3)::int,
    floor(random() * 3)::int,
    (ARRAY['SCHEDULED', 'LIVE', 'FINISHED', 'CANCELLED']::enum_status_match[])[floor(random() * 4 + 1)],
    NULL,
    NULL,
    NOW() + (random() * interval '30 days')
FROM generate_series(1, 25000) AS i;

INSERT INTO match_games (match_id, game_number, score1, score2, winner_id, status, faceit_id)
SELECT 
    1 + floor(random() * 25000)::int,
    floor(random() * 3 + 1)::int,
    floor(random() * 16)::int,
    floor(random() * 16)::int,
    1 + floor(random() * 25000)::int,
    (ARRAY['PENDING', 'LIVE', 'FINISHED']::enum_status_game[])[floor(random() * 3 + 1)],
    md5(random()::text)
FROM generate_series(1, 40000) AS i;

INSERT INTO match_protocols (match_id, event_type, description, created_by, creation_date)
SELECT 
    1 + floor(random() * 25000)::int,
    (ARRAY['TECH_LOSS', 'CANCEL', 'DISQUALIFICATION']::enum_event_type[])[floor(random() * 3 + 1)],
    'Protocol notes',
    1 + floor(random() * 3000)::int,
    NOW() - (random() * interval '10 days')
FROM generate_series(1, 10000) AS i;

INSERT INTO tournament_results (tournament_id, participant_id, place)
SELECT 
    1 + floor(random() * 5000)::int,
    1 + floor(random() * 25000)::int,
    floor(random() * 8 + 1)::int
FROM generate_series(1, 15000) AS i;

SELECT setval('users_id_seq', (SELECT max(id) FROM users));
SELECT setval('sports_id_seq', (SELECT max(id) FROM sports));
SELECT setval('teams_id_seq', (SELECT max(id) FROM teams));
SELECT setval('tournaments_id_seq', (SELECT max(id) FROM tournaments));
SELECT setval('referees_id_seq', (SELECT max(id) FROM referees));
SELECT setval('tournament_applications_id_seq', (SELECT max(id) FROM tournament_applications));
SELECT setval('matches_id_seq', (SELECT max(id) FROM matches));

COMMIT;

ANALYZE users, sports, teams, team_members, tournaments, referees, 
        tournament_applications, matches, match_games, match_protocols, 
        tournament_results, password_reset_tokens;