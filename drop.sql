DROP TABLE IF EXISTS
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
CASCADE;

DROP TYPE IF EXISTS enum_event_type CASCADE;
DROP TYPE IF EXISTS enum_status_game CASCADE;
DROP TYPE IF EXISTS enum_status_match CASCADE;
DROP TYPE IF EXISTS enum_status_applications CASCADE;
DROP TYPE IF EXISTS enum_status CASCADE;
DROP TYPE IF EXISTS enum_format CASCADE;
DROP TYPE IF EXISTS enum_participation_type CASCADE;