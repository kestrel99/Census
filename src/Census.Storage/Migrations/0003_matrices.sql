-- Census project schema, version 3.
-- Stores the variance-covariance and correlation matrices of the estimates as JSON,
-- since they are read and displayed whole rather than queried per-element.

ALTER TABLE estimations ADD COLUMN CovarianceJson  TEXT;
ALTER TABLE estimations ADD COLUMN CorrelationJson TEXT;
