CREATE TYPE "enum_participation_type" AS ENUM (
  'SOLO',
  'TEAM'
);

CREATE TYPE "enum_format" AS ENUM (
  'SINGLE_ELIMINATION',
  'DOUBLE_ELIMINATION',
  'ROUND_ROBIN',
  'SWISS'
);

CREATE TYPE "enum_status" AS ENUM (
  'draft',
  'registration',
  'ongoing',
  'finished',
  'cancelled'
);

CREATE TYPE "enum_status_applications" AS ENUM (
  'pending',
  'approved',
  'rejected'
);

CREATE TYPE "enum_status_match" AS ENUM (
  'scheduled',
  'live',
  'finished',
  'cancelled'
);

CREATE TYPE "enum_status_game" AS ENUM (
  'pending',
  'live',
  'finished'
);

CREATE TYPE "enum_event_type" AS ENUM (
  'reschedule',
  'tech_loss'
);

CREATE TABLE IF NOT EXISTS "users" (
  "id" SERIAL PRIMARY KEY,
  "username" VARCHAR(255) NOT NULL UNIQUE,
  "email" VARCHAR(255) NOT NULL UNIQUE,
  "password" VARCHAR(255) NOT NULL,
  "name" VARCHAR(255),
  "surname" VARCHAR(255),
  "vk_id" VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS "password_reset_tokens" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "token" VARCHAR(255) NOT NULL,
  "expires_at" TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS "sports" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL UNIQUE,
  "is_cybersport" BOOLEAN NOT NULL,
  "supports_faceit" BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS "teams" (
  "id" SERIAL PRIMARY KEY,
  "captain_id" INTEGER NOT NULL,
  "name" VARCHAR(255) NOT NULL UNIQUE,
  "tag" VARCHAR(10) UNIQUE,
  "creation_date" TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS "tournaments" (
  "id" SERIAL PRIMARY KEY,
  "admin_id" INTEGER NOT NULL,
  "sport_id" INTEGER NOT NULL,
  "title" VARCHAR(255),
  "regulations" VARCHAR(255),
  "participation_type" ENUM_PARTICIPATION_TYPE NOT NULL,
  "format" ENUM_FORMAT NOT NULL,
  "status" ENUM_STATUS NOT NULL,
  "reg_start_date" TIMESTAMP NOT NULL,
  "reg_end_date" TIMESTAMP NOT NULL,
  "start_date" TIMESTAMP NOT NULL,
  "end_date" TIMESTAMP NOT NULL,
  "max_participants" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "tournament_applications" (
  "id" SERIAL PRIMARY KEY,
  "tournament_id" INTEGER NOT NULL,
  "user_id" INTEGER,
  "team_id" INTEGER,
  "status" ENUM_STATUS_APPLICATIONS NOT NULL,
  "creation_date" TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS "matches" (
  "id" SERIAL PRIMARY KEY,
  "tournament_id" INTEGER NOT NULL,
  "participant1" INTEGER NOT NULL,
  "participant2" INTEGER NOT NULL,
  "winner_id" INTEGER,
  "bracket_stage" VARCHAR(255),
  "round_number" INTEGER NOT NULL,
  "score1" INTEGER NOT NULL,
  "score2" INTEGER NOT NULL,
  "status" ENUM_STATUS_MATCH NOT NULL,
  "next_match_id" INTEGER,
  "start_date" TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS "match_games" (
  "id" SERIAL PRIMARY KEY,
  "match_id" INTEGER NOT NULL,
  "game_number" INTEGER NOT NULL,
  "score1" INTEGER NOT NULL,
  "score2" INTEGER NOT NULL,
  "winner_id" INTEGER,
  "status" ENUM_STATUS_GAME NOT NULL,
  "faceit_id" VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS "match_protocols" (
  "id" SERIAL PRIMARY KEY,
  "match_id" INTEGER NOT NULL,
  "event_type" ENUM_EVENT_TYPE NOT NULL,
  "description" VARCHAR(255),
  "created_by" INTEGER NOT NULL,
  "creation_date" TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS "tournament_results" (
  "id" SERIAL PRIMARY KEY,
  "tournament_id" INTEGER NOT NULL,
  "participant_id" INTEGER NOT NULL,
  "place" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "referees" (
  "id" SERIAL PRIMARY KEY,
  "tournament_id" INTEGER NOT NULL,
  "user_id" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "team_members" (
  "id" SERIAL PRIMARY KEY,
  "team_id" INTEGER NOT NULL,
  "user_id" INTEGER NOT NULL
);

ALTER TABLE "password_reset_tokens"
ADD CONSTRAINT "fk_prt_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "teams"
ADD CONSTRAINT "fk_teams_captain" FOREIGN KEY ("captain_id") REFERENCES "users" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "tournaments"
ADD CONSTRAINT "fk_tournaments_admin" FOREIGN KEY ("admin_id") REFERENCES "users" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "tournaments"
ADD CONSTRAINT "fk_tournaments_sport" FOREIGN KEY ("sport_id") REFERENCES "sports" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "referees"
ADD CONSTRAINT "fk_referees_tournament" FOREIGN KEY ("tournament_id") REFERENCES "tournaments" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "referees"
ADD CONSTRAINT "fk_referees_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "tournament_applications"
ADD CONSTRAINT "fk_ta_tournament" FOREIGN KEY ("tournament_id") REFERENCES "tournaments" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "tournament_applications"
ADD CONSTRAINT "fk_ta_team" FOREIGN KEY ("team_id") REFERENCES "teams" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "tournament_applications"
ADD CONSTRAINT "fk_ta_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "matches"
ADD CONSTRAINT "fk_matches_tournament" FOREIGN KEY ("tournament_id") REFERENCES "tournaments" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "matches"
ADD CONSTRAINT "fk_matches_participant1" FOREIGN KEY ("participant1") REFERENCES "tournament_applications" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "matches"
ADD CONSTRAINT "fk_matches_participant2" FOREIGN KEY ("participant2") REFERENCES "tournament_applications" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "matches"
ADD CONSTRAINT "fk_matches_winner" FOREIGN KEY ("winner_id") REFERENCES "tournament_applications" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "matches"
ADD CONSTRAINT "fk_matches_next_match" FOREIGN KEY ("next_match_id") REFERENCES "matches" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "match_games"
ADD CONSTRAINT "fk_mg_match" FOREIGN KEY ("match_id") REFERENCES "matches" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "match_games"
ADD CONSTRAINT "fk_mg_winner" FOREIGN KEY ("winner_id") REFERENCES "tournament_applications" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "tournament_results"
ADD CONSTRAINT "fk_tr_tournament" FOREIGN KEY ("tournament_id") REFERENCES "tournaments" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "tournament_results"
ADD CONSTRAINT "fk_tr_participant" FOREIGN KEY ("participant_id") REFERENCES "tournament_applications" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "team_members"
ADD CONSTRAINT "fk_tm_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "team_members"
ADD CONSTRAINT "fk_tm_team" FOREIGN KEY ("team_id") REFERENCES "teams" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "match_protocols"
ADD CONSTRAINT "fk_mp_match" FOREIGN KEY ("match_id") REFERENCES "matches" ("id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "match_protocols"
ADD CONSTRAINT "fk_mp_created_by" FOREIGN KEY ("created_by") REFERENCES "referees" ("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;