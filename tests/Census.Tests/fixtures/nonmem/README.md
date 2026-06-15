# NONMEM fixture corpus

A small, committed subset of real NONMEM output used as the importer's regression oracle.
These files run on every CI build via `NonmemFixtureCorpusTests` and `NonmemGroundTruthTests`,
which **fail when the corpus is missing** — so the importer cannot silently regress.

## What's here

Three runs across three distinct NONMEM output formats (9 XML files, ~300 KB):

| Run    | Cov step | Notes                          |
|--------|----------|--------------------------------|
| runR001 | yes     | small model (3 theta, 2 eta)   |
| runR027 | yes     | larger model                   |
| runR041 | no       | no covariance step             |

| Folder  | NONMEM version (`nm:version` in the XML) |
|---------|------------------------------------------|
| `nm73`  | 7.3.0                                    |
| `nm743` | 7.4.3                                    |
| `nm750` | 7.5.0                                    |

The "NONMEM 7.6" IQ package emits **byte-identical** 7.5.0 XML, so it is not duplicated here.

Only the `.xml` output is committed. The importer reads the embedded `<control_stream>` for
`$DATA`, so no sibling `.ext`/`.cov`/`.csv` files are needed to parse a run; the large dataset
`.csv` and `.zip` files from the source packages are deliberately excluded.

## Source

Derived from the IQ NONMEM installation-qualification packages
(`NONMEM730_IQ_160323`, `NONMEM743_IQ_180814`, `NONMEM750_IQ_210204`). The full corpus
(~69 runs per package) can be swept locally — point `CENSUS_NONMEM_CORPUS` at its root and run
`RealWorldImporterTests` (an optional supplement, not part of CI coverage).

## The two-layer oracle

1. **Golden snapshot** (`NonmemFixtureCorpusTests.Corpus_Snapshot_MatchesOracle`) — a readable
   table of every value the current importer produces, committed as a `.verified.txt`. Catches
   any change in parser output. To update intentionally: run the tests and accept the new
   `.received.txt` over the `.verified.txt`.

2. **Independent ground truth** (`NonmemGroundTruthTests`) — expected values for runR001 read by
   hand from NONMEM's own raw ancillary files (`.ext` final-estimate/standard-error records and
   `.shk` TYPE 4 shrinkage). These are independent of both Census and the legacy Lazarus app and
   anchor *correctness*, not just stability. Add Lazarus-captured values for more runs here as
   they become available.
