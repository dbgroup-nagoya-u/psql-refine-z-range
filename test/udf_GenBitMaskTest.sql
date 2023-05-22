BEGIN;
SELECT plan(10);

SELECT is(
  GenBitMask(1, 1),
  1::int8
);

SELECT is(
  GenBitMask(2, 1),
  3::int8
);

SELECT is(
  GenBitMask(2, 2),
  5::int8
);

SELECT is(
  GenBitMask(2, 3),
  9::int8
);

SELECT is(
  GenBitMask(63, 1),
  9223372036854775807::int8
);

-- NULL check

SELECT is(
  GenBitMask(NULL, 2),
  NULL
);

SELECT is(
  GenBitMask(2, NULL),
  NULL
);

-- throws an exception if bit_size < 0

SELECT throws_ok(
  'SELECT GenBitMask(0, 1)',
  '22023'
);

-- throws an exception if dim_size < 0

SELECT throws_ok(
  'SELECT GenBitMask(1, 0)',
  '22023'
);

-- throws an exception if bit_size * dim_size > 63

SELECT throws_ok(
  'SELECT GenBitMask(64, 1)',
  '22003'
);

SELECT * FROM finish();
ROLLBACK;
