-- Your SQL goes here
CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    head VARCHAR NOT NULL,
    body TEXT NOT NULL,
    inuse BOOLEAN NOT NULL DEFAULT 'F',
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
)