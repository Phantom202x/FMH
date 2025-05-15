CREATE TYPE IF NOT EXISTS GENDER AS ENUM ('male', 'female');
CREATE TYPE IF NOT EXISTS BLOOD_TYPE AS ENUM ('a+', 'a-', 'b+', 'b-', 'ab+', 'ab-', 'o+', 'o-');

CREATE TABLE IF NOT EXISTS users
(
    uid         VARCHAR,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    dob         DATE NOT NULL,
    nationality VARCHAR,
    gender      GENDER,
    blood_type  BLOOD_TYPE,
    photo       BYTEA,
    
    UNIQUE (first_name, last_name, dob),

    PRIMARY KEY (uid)
);

CREATE TABLE IF NOT EXISTS embeddings
(
    uid         VARCHAR,
    face        JSON NOT NULL,

    FOREIGN KEY (uid) REFERENCES users(uid)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    PRIMARY KEY (uid)
);

CREATE TABLE IF NOT EXISTS reports
(
    rid         VARCHAR,
    author      VARCHAR NOT NULL,
    missing     VARCHAR NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    found       BOOLEAN DEFAULT FALSE,

    UNIQUE (missing),

    FOREIGN KEY (author) REFERENCES users(uid)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    FOREIGN KEY (missing) REFERENCES users(uid)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    PRIMARY KEY (rid)
);
