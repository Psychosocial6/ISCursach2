CREATE OR REPLACE PROCEDURE register_application(
    p_tid  INT,
    p_uid  INT DEFAULT NULL,
    p_tmid INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    t tournaments%ROWTYPE;
    cnt INT;
BEGIN
    SELECT INTO t FROM tournaments WHERE id = p_tid FOR UPDATE;
    
    IF t.status <> 'REGISTRATION' OR NOW() NOT BETWEEN t.reg_start_date AND t.reg_end_date THEN
        RAISE EXCEPTION 'Registration closed';
    END IF;

    SELECT COUNT(*) INTO cnt FROM tournament_applications
    WHERE tournament_id = p_tid AND status = 'APPROVED';
    
    IF cnt >= t.max_participants THEN
        RAISE EXCEPTION 'Participants limit exceeded';
    END IF;

    INSERT INTO tournament_applications(tournament_id, user_id, team_id, status, creation_date)
    VALUES (p_tid, p_uid, p_tmid, 'PENDING', NOW());
END;
$$;

CREATE OR REPLACE PROCEDURE moderate_application(p_app_id INT, p_approve BOOLEAN)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE tournament_applications
    SET status = CASE WHEN p_approve THEN 'APPROVED' ELSE 'REJECTED' END::enum_status_applications
    WHERE id = p_app_id AND status = 'PENDING';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Application % not found or already moderated', p_app_id;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE set_tournament_status(p_tid INT, p_new enum_status_tournaments)
LANGUAGE plpgsql AS $$
DECLARE 
    cur enum_status_tournaments;
BEGIN
    SELECT status INTO cur FROM tournaments WHERE id = p_tid FOR UPDATE;
    
    IF cur IS NULL THEN 
        RAISE EXCEPTION 'Tournament not found'; 
    END IF;
    
    IF NOT (
        (cur = 'DRAFT' AND p_new IN ('REGISTRATION', 'CANCELLED')) OR
        (cur = 'REGISTRATION' AND p_new IN ('ONGOING', 'CANCELLED')) OR
        (cur = 'ONGOING' AND p_new IN ('FINISHED', 'CANCELLED'))
    ) THEN
        RAISE EXCEPTION 'Cannot change status from % to %', cur, p_new;
    END IF;
    
    UPDATE tournaments SET status = p_new WHERE id = p_tid;
END;
$$;