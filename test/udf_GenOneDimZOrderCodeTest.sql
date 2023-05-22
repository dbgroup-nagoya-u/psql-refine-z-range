BEGIN;
SELECT plan(21);

-- generate a one-dimensional z-order code

SELECT is(
  GenOneDimZOrderCode(0, 1, 1),
  0
);

SELECT is(
  GenOneDimZOrderCode(1, 1, 1),
  1
);

SELECT is(
  GenOneDimZOrderCode(-1, 1, 2),
  0
);

SELECT is(
  GenOneDimZOrderCode(0, 1, 2),
  1
);

SELECT is(
  GenOneDimZOrderCode(1, 1, 2),
  2
);

SELECT is(
  GenOneDimZOrderCode(2, 1, 2),
  3
);

SELECT is(
  GenOneDimZOrderCode(-3, 1, 3),
  0
);

SELECT is(
  GenOneDimZOrderCode(0, 1, 3),
  3
);

SELECT is(
  GenOneDimZOrderCode(1, 1, 3),
  4
);

SELECT is(
  GenOneDimZOrderCode(4, 1, 3),
  7
);

-- extract a one-dimensional z-order code

-- 36453: 1000 1110 0110 0101
SELECT is(
  GenOneDimZOrderCode(36453, 1, 15, 4),
  1
);

SELECT is(
  GenOneDimZOrderCode(36453, 2, 15, 4),
  6
);

SELECT is(
  GenOneDimZOrderCode(36453, 3, 15, 4),
  7
);

SELECT is(
  GenOneDimZOrderCode(36453, 4, 15, 4),
  12
);

SELECT is(
  GenOneDimZOrderCode(12, 1, 30, 1),
  12
);

-- NULL check

SELECT is(
  GenOneDimZOrderCode(NULL, 1, 1),
  NULL
);

SELECT is(
  GenOneDimZOrderCode(0, NULL, 1),
  NULL
);

SELECT is(
  GenOneDimZOrderCode(0, 1, NULL),
  NULL
);

-- throws an exception if bit_size < 1

SELECT throws_ok(
  'SELECT GenOneDimZOrderCode(0, 1, 0)',
  '22023'
);

-- throws an exception if cell_size <= 0

SELECT throws_ok(
  'SELECT GenOneDimZOrderCode(0, 0, 1)',
  '22023'
);

-- throws an exception if bit_size * dim_size > 63

SELECT throws_ok(
  'SELECT GenOneDimZOrderCode(0, 1, 64)',
  '22003'
);

SELECT * FROM finish();
ROLLBACK;
