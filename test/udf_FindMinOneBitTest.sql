BEGIN;
SELECT plan(9);

SELECT is(
  FindMinOneBit(0),
  NULL::int4
);

SELECT is(
  FindMinOneBit((2^0)::int8),
  0
);

SELECT is(
  FindMinOneBit((2^1)::int8),
  1
);

SELECT is(
  FindMinOneBit((2^8)::int8),
  8
);

SELECT is(
  FindMinOneBit((2^16)::int8),
  16
);

SELECT is(
  FindMinOneBit((2^32)::int8),
  32
);

SELECT is(
  FindMinOneBit((2^62)::int8),
  62
);

SELECT is(
  FindMinOneBit((2^62)::int8 + (2^15)::int8),
  15
);

-- NULL check

SELECT is(
  FindMinOneBit(NULL),
  NULL
);

SELECT * FROM finish();
ROLLBACK;
