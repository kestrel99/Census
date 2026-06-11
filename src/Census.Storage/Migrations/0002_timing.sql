-- Census project schema, version 2.
-- Adds NONMEM timing fields: per-estimation elapsed times and run-level
-- start/stop timestamps, total CPU time, and post-processing times.

ALTER TABLE estimations ADD COLUMN EstimationTime REAL;
ALTER TABLE estimations ADD COLUMN CovarianceTime REAL;

ALTER TABLE runs ADD COLUMN StartDateTime          TEXT;
ALTER TABLE runs ADD COLUMN StopDateTime           TEXT;
ALTER TABLE runs ADD COLUMN TotalCpuTime           REAL;
ALTER TABLE runs ADD COLUMN PostElapsedTime        REAL;
ALTER TABLE runs ADD COLUMN FinalOutputElapsedTime REAL;
