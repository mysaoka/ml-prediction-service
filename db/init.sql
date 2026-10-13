-- Run once on a fresh PostgreSQL instance as postgres.
-- This script is intended for psql.
\set ON_ERROR_STOP on

CREATE DATABASE ml_predictions;

CREATE ROLE ml_app
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE;

-- Enter the password interactively; never store it in Git.
SET password_encryption = 'scram-sha-256';
\password ml_app

REVOKE ALL ON DATABASE ml_predictions FROM PUBLIC;
GRANT CONNECT ON DATABASE ml_predictions TO ml_app;

\connect ml_predictions

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO ml_app;

CREATE TABLE public.predictions (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    input_data JSONB NOT NULL,
    prediction JSONB NOT NULL,
    model_version VARCHAR(50) NOT NULL
);

GRANT SELECT, INSERT ON TABLE public.predictions TO ml_app;
GRANT USAGE ON SEQUENCE public.predictions_id_seq TO ml_app;
