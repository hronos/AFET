-- Table: users
CREATE TABLE users ( 
    id_user  INTEGER     PRIMARY KEY ON CONFLICT FAIL AUTOINCREMENT
                         NOT NULL,
    username TEXT( 16 )  NOT NULL
                         UNIQUE ON CONFLICT FAIL,
    pass     TEXT( 20 )  NOT NULL,
    email    TEXT( 45 )  NOT NULL,
    id_roles INT         NOT NULL 
);


-- Table: roles
CREATE TABLE roles ( 
    id_roles INTEGER     PRIMARY KEY AUTOINCREMENT
                         NOT NULL,
    role     TEXT( 45 )  NOT NULL 
);


-- Table: results
CREATE TABLE results ( 
    id_result  INTEGER     PRIMARY KEY AUTOINCREMENT
                           NOT NULL,
    id_user    INTEGER     NOT NULL
                           REFERENCES users ( id_user ) ON DELETE CASCADE
                                                        ON UPDATE CASCADE,
    date       DATETIME    NOT NULL,
    time_taken TEXT        NOT NULL,
    ans_ratio  TEXT( 10 )  NOT NULL 
);


-- Table: categories
CREATE TABLE categories ( 
    id_categories INTEGER      PRIMARY KEY AUTOINCREMENT,
    cat_text      TEXT( 100 )  NOT NULL 
);


-- Table: subcat
CREATE TABLE subcat ( 
    id_subcat     INTEGER      PRIMARY KEY AUTOINCREMENT,
    subcat_name   TEXT( 100 )  NOT NULL,
    id_categories INTEGER      NOT NULL
                               REFERENCES categories ( id_categories ) ON DELETE CASCADE
                                                                       ON UPDATE CASCADE 
);


-- Table: custom_test
CREATE TABLE custom_test ( 
    id_test      INTEGER      PRIMARY KEY AUTOINCREMENT,
    id_user      INTEGER      REFERENCES users ( id_user ) ON DELETE CASCADE
                                                           ON UPDATE CASCADE,
    subcat_array TEXT( 255 )  NOT NULL 
);


-- Table: questions
CREATE TABLE questions ( 
    id_quest   INTEGER      PRIMARY KEY AUTOINCREMENT,
    quest_text TEXT( 255 )  NOT NULL,
    ans_a      TEXT( 255 )  NOT NULL,
    ans_b      TEXT( 255 )  NOT NULL,
    ans_c      TEXT( 255 )  NOT NULL,
    ans_d      TEXT( 255 )  NOT NULL,
    right_ans  TEXT( 5 )    NOT NULL,
    id_subcat  INTEGER      NOT NULL
                            REFERENCES subcat ( id_subcat ) ON DELETE CASCADE
                                                            ON UPDATE CASCADE,
    img        BLOB 
);




