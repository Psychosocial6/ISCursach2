BEGIN;

TRUNCATE TABLE
    match_protocols,
    match_games,
    matches,
    tournament_results,
    tournament_applications,
    referees,
    team_members,
    teams,
    tournaments,
    sports,
    password_reset_tokens,
    users
RESTART IDENTITY CASCADE;

INSERT INTO users (username, email, password, name, surname, vk_id) VALUES
('admin', 'admin@example.com',  '$2b$12$examplehash', 'Иван',   'Админов',   NULL),
('referee1', 'ref1@example.com',   '$2b$12$examplehash', 'Пётр',   'Судьин',    NULL),
('referee2', 'ref2@example.com',   '$2b$12$examplehash', 'Сергей', 'Реферин',   NULL),
('captain_alpha','alpha@example.com',  '$2b$12$examplehash', 'Алексей','Альфов',    'vk_alpha'),
('captain_beta', 'beta@example.com',   '$2b$12$examplehash', 'Борис',  'Бетов',     'vk_beta'),
('player3', 'p3@example.com',     '$2b$12$examplehash', 'Глеб',   'Третиев',   NULL),
('player4', 'p4@example.com',     '$2b$12$examplehash', 'Дмитрий','Четвёртов', NULL),
('player5', 'p5@example.com',     '$2b$12$examplehash', 'Егор',   'Пятов',     NULL)
('player_klimenkov', 'klimenkov_krutoy@klim.com','$2b$12$examplehash', 'Сергей', 'Клименков' );


INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES
(4, 'test-token-abc123', NOW() + INTERVAL '1 day');

INSERT INTO sports (name, is_cybersport, supports_faceit) VALUES
('Counter-Strike 2', TRUE,  TRUE),
('Dota 2',           TRUE,  FALSE),
('Football',         FALSE, FALSE),
('Basketball',       FALSE, FALSE);

INSERT INTO teams (captain_id, name, tag, creation_date) VALUES
(4, 'Team Alpha', 'ALP', NOW() - INTERVAL '30 days'),
(5, 'Team Beta',  'BET', NOW() - INTERVAL '20 days');

INSERT INTO tournaments
(admin_id, sport_id, title, regulations, participation_type, format, status,
 reg_start_date, reg_end_date, start_date, end_date, max_participants) VALUES
(1, 1, 'CS2 Solo Cup', 'https://example.com/reg1', 'SOLO', 'SINGLE_ELIMINATION',
 'registration',
 NOW() - INTERVAL '5 days',  NOW() + INTERVAL '5 days',
 NOW() + INTERVAL '10 days', NOW() + INTERVAL '15 days', 16),
(1, 1, 'CS2 Team Masters', 'https://example.com/reg2', 'TEAM', 'SINGLE_ELIMINATION',
 'ongoing',
 NOW() - INTERVAL '30 days', NOW() - INTERVAL '20 days',
 NOW() - INTERVAL '10 days', NOW() + INTERVAL '5 days', 8),
(1, 3, 'Football Championship', 'https://example.com/reg3', 'SOLO', 'SINGLE_ELIMINATION',
 'finished',
 NOW() - INTERVAL '60 days', NOW() - INTERVAL '50 days',
 NOW() - INTERVAL '40 days', NOW() - INTERVAL '30 days', 32);

INSERT INTO referees (tournament_id, user_id) VALUES
(2, 2),
(3, 3),
(1, 2);

INSERT INTO tournament_applications (tournament_id, user_id, team_id, status, creation_date) VALUES
(1, 4,    NULL, 'approved', NOW() - INTERVAL '4 days'),
(1, 6,    NULL, 'approved', NOW() - INTERVAL '4 days'),
(1, 7,    NULL, 'approved', NOW() - INTERVAL '3 days'),
(1, 8,    NULL, 'pending',  NOW() - INTERVAL '2 days'),
(2, NULL, 1,    'approved', NOW() - INTERVAL '25 days'),
(2, NULL, 2,    'approved', NOW() - INTERVAL '24 days'),
(3, 4,    NULL, 'approved', NOW() - INTERVAL '55 days'),
(3, 6,    NULL, 'approved', NOW() - INTERVAL '54 days');

INSERT INTO matches
(tournament_id, participant1, participant2, winner_id, bracket_stage, round_number,
 score1, score2, status, next_match_id, start_date) VALUES
(2, 5, 6, 5, 'final', 1, 2, 1, 'finished', NULL, NOW() - INTERVAL '5 days');

INSERT INTO match_games (match_id, game_number, score1, score2, winner_id, status, faceit_id) VALUES
(1, 1, 13, 10, 5, 'finished', 'faceit-game-001'),
(1, 2, 10, 13, 6, 'finished', 'faceit-game-002'),
(1, 3, 13,  7, 5, 'finished', 'faceit-game-003');

INSERT INTO match_protocols (match_id, event_type, description, created_by, creation_date) VALUES
(1, 'reschedule', 'Матч перенесён с 18:00 на 20:00 по просьбе команды Beta', 1, NOW() - INTERVAL '6 days');

INSERT INTO tournament_results (tournament_id, participant_id, place) VALUES
(2, 5, 1),
(2, 6, 2),
(3, 7, 1),
(3, 8, 2);

INSERT INTO team_members (team_id, user_id) VALUES
(1, 4),
(1, 6),
(1, 7),
(2, 5),
(2, 8);

COMMIT;