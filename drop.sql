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

DROP FUNCTION IF EXISTS 
    fn_check_tournament_application,
    fn_check_referee_jurisdiction,
    fn_advance_bracket_winner
CASCADE;

DROP TYPE IF EXISTS 
    enum_event_type,
    enum_status_game,
    enum_status_match,
    enum_status_applications,
    enum_status_tournaments,
    enum_format,
    enum_participation_type
CASCADE;