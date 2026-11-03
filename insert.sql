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

INSERT INTO users (id, username, email, password, name, surname, vk_id, avatar_url) VALUES
(1, 'alex_admin', 'admin@matchflow.ru', '$2a$10$e8w.x7W', 'Алексей', 'Смирнов', NULL, 'https://cdn.matchflow.ru/avatars/admin.png'),
(2, 'ivan_referee', 'referee@matchflow.ru', '$2a$10$k3l.y8Z', 'Иван', 'Дурак', NULL, 'https://cdn.matchflow.ru/avatars/ref.png'),
(3, 's1mple_pro', 's1mple@navi.gg', '$2a$10$a1b.c2D', 'Александр', 'Костылев', '12345678', 'https://cdn.matchflow.ru/avatars/s1mple.png'),
(4, 'device_king', 'device@astralis.dk', '$2a$10$d3e.f4G', 'Николай', 'Ридтц', NULL, 'https://cdn.matchflow.ru/avatars/device.png'),
(5, 'pasha_biceps', 'biceps@vp.com', '$2a$10$h5i.j6K', 'Ярослав', 'Яжомбковский', NULL, 'https://cdn.matchflow.ru/avatars/pasha.png'),
(6, 'blamef_power', 'blamef@fnatic.dk', '$2a$10$l7m.n8O', 'Бенджамин', 'Бремер', NULL, 'https://cdn.matchflow.ru/avatars/blamef.png'),
(7, 'magnus_chess', 'carlsen@chess.com', '$2a$10$p9q.r0S', 'Магнус', 'Карлсен', NULL, 'https://cdn.matchflow.ru/avatars/carlsen.png'),
(8, 'hikaru_speed', 'nakamura@chess.com', '$2a$10$u1v.w2X', 'Хикару', 'Накамура', NULL, 'https://cdn.matchflow.ru/avatars/hikaru.png'),
(9, 'vk_player', 'vk_gamer@mail.ru', NULL, 'Дмитрий', 'Иванов', '87654321', 'https://cdn.matchflow.ru/avatars/vk.png');

INSERT INTO password_reset_tokens (id, user_id, token, expires_at) VALUES
(1, 9, 'a4b1c8d2-9876-4abc-9def-0123456789ab', NOW() + INTERVAL '1 day');

INSERT INTO sports (id, name, is_cybersport, supports_faceit) VALUES
(1, 'Counter-Strike 2', TRUE, TRUE),
(2, 'Dota 2', TRUE, TRUE),
(3, 'Шахматы', FALSE, FALSE);

INSERT INTO teams (id, captain_id, name, tag, creation_date) VALUES
(1, 3, 'Natus Vincere', 'NAVI', NOW() - INTERVAL '30 days'),
(2, 4, 'Astralis', 'AST', NOW() - INTERVAL '25 days'),
(3, 6, 'Fnatic', 'FN', NOW() - INTERVAL '20 days'),
(4, 5, 'Virtus.pro', 'VP', NOW() - INTERVAL '15 days');

INSERT INTO team_members (id, team_id, user_id) VALUES
(1, 1, 3),
(2, 2, 4),
(3, 3, 6),
(4, 4, 5);

INSERT INTO tournaments (id, admin_id, sport_id, title, regulations, participation_type, format, status, reg_start_date, reg_end_date, start_date, end_date, max_participants) VALUES
(1, 1, 1, 'MatchFlow CS2 Spring Cup 2026', 'Матчи в формате Bo3. Приз 2 пачки кириешек.', 'TEAM', 'DOUBLE_ELIMINATION', 'ONGOING', NOW() - INTERVAL '10 days', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', NOW() + INTERVAL '3 days', 8),
(2, 1, 3, 'Весенний Блиц Турнир', 'Контроль времени: 3+2.', 'SOLO', 'SINGLE_ELIMINATION', 'REGISTRATION', NOW() - INTERVAL '2 days', NOW() + INTERVAL '5 days', NOW() + INTERVAL '6 days', NOW() + INTERVAL '7 days', 16),
(3, 2, 2, 'Dota 2 TI2077', 'Спириты берут TI. Матчи Bo3, финал Bo5.', 'TEAM', 'SINGLE_ELIMINATION', 'FINISHED', NOW() - INTERVAL '20 days', NOW() - INTERVAL '15 days', NOW() - INTERVAL '14 days', NOW() - INTERVAL '10 days', 4);

INSERT INTO referees (id, tournament_id, user_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 3, 2);

INSERT INTO tournament_applications (id, tournament_id, user_id, team_id, status, creation_date) VALUES
(1, 1, NULL, 1, 'APPROVED', NOW() - INTERVAL '5 days'),
(2, 1, NULL, 2, 'APPROVED', NOW() - INTERVAL '4 days'),
(3, 1, NULL, 3, 'APPROVED', NOW() - INTERVAL '3 days'),
(4, 1, NULL, 4, 'APPROVED', NOW() - INTERVAL '3 days'),
(5, 2, 7, NULL, 'APPROVED', NOW() - INTERVAL '1 day'),
(6, 2, 8, NULL, 'PENDING', NOW()),
(7, 3, NULL, 1, 'APPROVED', NOW() - INTERVAL '18 days'),
(8, 3, NULL, 2, 'APPROVED', NOW() - INTERVAL '17 days'),
(9, 3, NULL, 3, 'APPROVED', NOW() - INTERVAL '16 days'),
(10, 3, NULL, 4, 'APPROVED', NOW() - INTERVAL '16 days');

INSERT INTO matches (id, tournament_id, participant1, participant2, winner_id, bracket_stage, round_number, score1, score2, status, winner_next_match_id, loser_next_match_id, start_date) VALUES
(1, 3, 7, 8, 7, 'Полуфинал', 1, 2, 0, 'FINISHED', 3, NULL, NOW() - INTERVAL '13 days'),
(2, 3, 9, 10, 9, 'Полуфинал', 1, 2, 1, 'FINISHED', 3, NULL, NOW() - INTERVAL '13 days'),
(3, 3, 7, 9, 7, 'Гранд-финал', 2, 3, 1, 'FINISHED', NULL, NULL, NOW() - INTERVAL '10 days'),
(4, 1, 1, 2, NULL, 'Верхняя сетка', 1, 1, 0, 'LIVE', 6, 7, NOW() - INTERVAL '1 hour'),
(5, 1, 3, 4, NULL, 'Верхняя сетка', 1, 0, 0, 'SCHEDULED', 6, 7, NOW() + INTERVAL '2 hours'),
(6, 1, NULL, NULL, NULL, 'Финал верхней сетки', 2, 0, 0, 'SCHEDULED', NULL, NULL, NOW() + INTERVAL '1 day'),
(7, 1, NULL, NULL, NULL, 'Нижняя сетка', 1, 0, 0, 'SCHEDULED', NULL, NULL, NOW() + INTERVAL '1 day');

INSERT INTO match_games (id, match_id, game_number, score1, score2, winner_id, status, faceit_id) VALUES
(1, 1, 1, 35, 12, 7, 'FINISHED', NULL),
(2, 1, 2, 28, 15, 7, 'FINISHED', NULL),
(3, 4, 1, 13, 9, 1, 'FINISHED', '1-f89a-4c21-98ab-de0123456789'),
(4, 4, 2, 7, 5, NULL, 'LIVE', '2-a78b-3d12-87cd-ef9876543210');

INSERT INTO match_protocols (id, match_id, event_type, description, created_by, creation_date) VALUES
(1, 5, 'CANCEL', 'Матч перенесен на 2 часа по согласованию сторон из-за технических неполадок с сетью у команды Virtus.pro.', 2, NOW() - INTERVAL '30 minutes');

INSERT INTO tournament_results (id, tournament_id, participant_id, place) VALUES
(1, 3, 7, 1),
(2, 3, 9, 2),
(3, 3, 8, 3),
(4, 3, 10, 4);

COMMIT;