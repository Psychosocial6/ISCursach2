BEGIN;

ALTER TABLE users
ADD CONSTRAINT chk_users_auth_method 
CHECK (password IS NOT NULL OR vk_id IS NOT NULL);

ALTER TABLE users
ADD CONSTRAINT chk_users_email_format 
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

ALTER TABLE teams
ADD CONSTRAINT chk_teams_tag_length 
CHECK (char_length(tag) >= 2);

ALTER TABLE team_members
ADD CONSTRAINT uq_team_members_team_user 
UNIQUE (team_id, user_id);

ALTER TABLE tournaments
ADD CONSTRAINT chk_tournaments_dates_timeline 
CHECK (
  reg_start_date < reg_end_date AND
  reg_end_date <= start_date AND
  start_date <= end_date
);

ALTER TABLE tournaments
ADD CONSTRAINT chk_tournaments_min_participants 
CHECK (max_participants >= 2);

ALTER TABLE referees
ADD CONSTRAINT uq_referees_tournament_user 
UNIQUE (tournament_id, user_id);

ALTER TABLE tournament_applications
ADD CONSTRAINT chk_ta_participant_xor 
CHECK (
  (user_id IS NOT NULL AND team_id IS NULL) OR
  (user_id IS NULL AND team_id IS NOT NULL)
);

ALTER TABLE matches
ADD CONSTRAINT chk_matches_participants_distinct 
CHECK (participant1 IS NULL OR participant2 IS NULL OR participant1 <> participant2);

ALTER TABLE matches
ADD CONSTRAINT chk_matches_scores_non_negative 
CHECK (
  (score1 IS NULL AND score2 IS NULL) OR 
  (score1 >= 0 AND score2 >= 0)
);

ALTER TABLE matches
ADD CONSTRAINT chk_matches_winner_validity 
CHECK (
  winner_id IS NULL OR 
  (participant1 IS NOT NULL AND winner_id = participant1) OR 
  (participant2 IS NOT NULL AND winner_id = participant2)
);

ALTER TABLE matches
ADD CONSTRAINT chk_matches_round_positive 
CHECK (round_number > 0);

ALTER TABLE match_games
ADD CONSTRAINT uq_mg_match_game_number 
UNIQUE (match_id, game_number);

ALTER TABLE match_games
ADD CONSTRAINT chk_mg_values_valid 
CHECK (game_number > 0 AND score1 >= 0 AND score2 >= 0);

ALTER TABLE match_protocols
ADD CONSTRAINT chk_mp_description_not_empty 
CHECK (length(trim(description)) > 0);

ALTER TABLE tournament_results
ADD CONSTRAINT uq_tr_tournament_participant 
UNIQUE (tournament_id, participant_id);

ALTER TABLE tournament_results
ADD CONSTRAINT chk_tr_place_positive 
CHECK (place > 0);

CREATE OR REPLACE FUNCTION fn_check_tournament_application()
RETURNS TRIGGER AS $$
DECLARE
    v_tournament_status enum_status_tournaments;
    v_tournament_type   enum_participation_type;
    v_registration_end  TIMESTAMP;
BEGIN
    SELECT status, participation_type, reg_end_date
    INTO v_tournament_status, v_tournament_type, v_registration_end
    FROM tournaments
    WHERE id = NEW.tournament_id;

    IF NEW.user_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM tournament_applications 
        WHERE tournament_id = NEW.tournament_id AND user_id = NEW.user_id
    ) THEN
        RAISE EXCEPTION 'Пользователь уже подал заявку на этот турнир';
    END IF;

    IF NEW.team_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM tournament_applications 
        WHERE tournament_id = NEW.tournament_id AND team_id = NEW.team_id
    ) THEN
        RAISE EXCEPTION 'Команда уже подала заявку на этот турнир';
    END IF;

    IF v_tournament_status <> 'REGISTRATION' OR NOW() > v_registration_end THEN
        RAISE EXCEPTION 'Регистрация закрыта: турнир не находится в статусе REGISTRATION или истек срок подачи заявок';
    END IF;

    IF v_tournament_type = 'SOLO' AND NEW.team_id IS NOT NULL THEN
        RAISE EXCEPTION 'Нельзя подать командную заявку на турнир с индивидуальным зачетом';
    END IF;

    IF v_tournament_type = 'TEAM' AND NEW.user_id IS NOT NULL THEN
        RAISE EXCEPTION 'Нельзя подать индивидуальную заявку на командный турнир';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_application ON tournament_applications;
CREATE TRIGGER trg_check_application
BEFORE INSERT ON tournament_applications
FOR EACH ROW
EXECUTE FUNCTION fn_check_tournament_application();


CREATE OR REPLACE FUNCTION fn_check_referee_jurisdiction()
RETURNS TRIGGER AS $$
DECLARE
    v_match_tournament_id   INTEGER;
    v_referee_tournament_id INTEGER;
BEGIN
    SELECT tournament_id INTO v_match_tournament_id FROM matches WHERE id = NEW.match_id;
    SELECT tournament_id INTO v_referee_tournament_id FROM referees WHERE id = NEW.created_by;

    IF v_match_tournament_id <> v_referee_tournament_id THEN
        RAISE EXCEPTION 'Судья (ID: %) не назначен на турнир (ID: %), к которому относится данный матч', 
            NEW.created_by, v_match_tournament_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_referee_jurisdiction ON match_protocols;
CREATE TRIGGER trg_check_referee_jurisdiction
BEFORE INSERT OR UPDATE ON match_protocols
FOR EACH ROW
EXECUTE FUNCTION fn_check_referee_jurisdiction();


CREATE OR REPLACE FUNCTION fn_advance_bracket_winner()
RETURNS TRIGGER AS $$
DECLARE
    v_loser_id INTEGER;
BEGIN
    IF NEW.status = 'FINISHED' AND NEW.winner_id IS NOT NULL AND (OLD.status <> 'FINISHED' OR OLD.winner_id IS NULL) THEN
        
        IF NEW.winner_next_match_id IS NOT NULL THEN
            UPDATE matches
            SET participant1 = CASE WHEN participant1 IS NULL THEN NEW.winner_id ELSE participant1 END,
                participant2 = CASE WHEN participant1 IS NOT NULL AND participant2 IS NULL THEN NEW.winner_id ELSE participant2 END
            WHERE id = NEW.winner_next_match_id;
        END IF;

        IF NEW.loser_next_match_id IS NOT NULL THEN
            v_loser_id := CASE WHEN NEW.winner_id = NEW.participant1 THEN NEW.participant2 ELSE NEW.participant1 END;
            
            IF v_loser_id IS NOT NULL THEN
                UPDATE matches
                SET participant1 = CASE WHEN participant1 IS NULL THEN v_loser_id ELSE participant1 END,
                    participant2 = CASE WHEN participant1 IS NOT NULL AND participant2 IS NULL THEN v_loser_id ELSE participant2 END
                WHERE id = NEW.loser_next_match_id;
            END IF;
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_advance_bracket_winner ON matches;
CREATE TRIGGER trg_advance_bracket_winner
AFTER UPDATE OF status, winner_id ON matches
FOR EACH ROW
EXECUTE FUNCTION fn_advance_bracket_winner();

COMMIT;