BEGIN;
SELECT plan(6);

SELECT is(
  FindMinZeroBit(0),
  0
);

SELECT is(
  FindMinZeroBit((2^0)::int8),
  1
);

SELECT is(
  FindMinZeroBit((2^1)::int8),
  0
);

SELECT is(
  FindMinZeroBit((2^0)::int8 + (2^1)::int8),
  2
);

SELECT is(
  FindMinZeroBit(~(0::int8)),
  NULL::int4
);

-- NULL check

SELECT is(
  FindMinZeroBit(NULL),
  NULL
);

SELECT * FROM finish();
ROLLBACK;
