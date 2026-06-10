-- Census project schema, version 1.
-- Clean design for Microsoft.Data.Sqlite. No backward compatibility with
-- Lazarus-era .cen files is required or attempted.

CREATE TABLE runs (
    Id          INTEGER PRIMARY KEY AUTOINCREMENT,
    RunNo       TEXT    NOT NULL,
    IRunNo      INTEGER NOT NULL,
    ParentNo    TEXT,
    Comment     TEXT,
    KeyRun      INTEGER NOT NULL DEFAULT 0,
    ObsRecs     INTEGER,
    Individuals INTEGER,
    CreatedUtc  TEXT    NOT NULL
);
CREATE INDEX ix_runs_runno ON runs (RunNo);
CREATE UNIQUE INDEX ux_runs_irunno ON runs (IRunNo);

CREATE TABLE estimations (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
    RunId           INTEGER NOT NULL REFERENCES runs (Id) ON DELETE CASCADE,
    Number          INTEGER NOT NULL,
    Method          TEXT,
    Ofv             REAL,
    DOfv            REAL,
    ConditionNumber REAL
);
CREATE INDEX ix_estimations_run ON estimations (RunId);

CREATE TABLE parameters (
    Id            INTEGER PRIMARY KEY AUTOINCREMENT,
    EstimationId  INTEGER NOT NULL REFERENCES estimations (Id) ON DELETE CASCADE,
    Kind          TEXT    NOT NULL,            -- theta | omega | sigma
    "Index"       INTEGER NOT NULL,
    Label         TEXT,
    Estimate      REAL,
    StandardError REAL,
    Shrinkage     REAL
);
CREATE INDEX ix_parameters_estimation ON parameters (EstimationId);

CREATE TABLE warnings (
    Id           INTEGER PRIMARY KEY AUTOINCREMENT,
    EstimationId INTEGER NOT NULL REFERENCES estimations (Id) ON DELETE CASCADE,
    Text         TEXT    NOT NULL
);

CREATE TABLE file_artifacts (
    Id    INTEGER PRIMARY KEY AUTOINCREMENT,
    RunId INTEGER NOT NULL REFERENCES runs (Id) ON DELETE CASCADE,
    Role  TEXT    NOT NULL,
    Path  TEXT    NOT NULL,
    Md5   TEXT
);
CREATE INDEX ix_file_artifacts_run ON file_artifacts (RunId);
