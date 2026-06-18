-- Schema version 4: drop the unused estimations.DOfv column.
-- dOFV is always derived at display time against a chosen reference run (see Census.Domain.OfvAnalysis):
-- the parent run in the grid/list, the first selected run in Compare. It is never stored, so this
-- column was always null and could only ever go stale. SQLite >= 3.35 supports DROP COLUMN.
ALTER TABLE estimations DROP COLUMN DOfv;
