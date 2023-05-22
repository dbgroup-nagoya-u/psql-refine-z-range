BEGIN;
SELECT plan(12);

SELECT is(
  GenZOrderCode(ARRAY[-1], ARRAY[1], 1),
  0::int8
);

SELECT is(
  GenZOrderCode(ARRAY[-1048575, -1048575, -1048575], ARRAY[1, 1, 1], 21),
  0::int8
);

SELECT is(
  GenZOrderCode(ARRAY[-1], ARRAY[1], 2),
  0::int8
);

-- NULL check

SELECT is(
  GenZOrderCode(NULL, ARRAY[1], 2),
  NULL
);

SELECT is(
  GenZOrderCode(ARRAY[-1], NULL, 2),
  NULL
);

SELECT is(
  GenZOrderCode(ARRAY[-1], ARRAY[1], NULL),
  NULL
);

-- throws an exception if an empty array is input

SELECT throws_ok(
  'SELECT GenZOrderCode(ARRAY[]::float8[], ARRAY[1], 2)',
  '22004'
);

SELECT throws_ok(
  'SELECT GenZOrderCode(ARRAY[0], ARRAY[]::int4[], 2)',
  '22004'
);

-- throws an exception if an multi-dimensional array is input

SELECT throws_ok(
  'SELECT GenZOrderCode(ARRAY[ARRAY[0]], ARRAY[1], 2)',
  '22023'
);

SELECT throws_ok(
  'SELECT GenZOrderCode(ARRAY[0], ARRAY[ARRAY[1]], 2)',
  '22023'
);

-- throws an exception if the sizes of input arrays are different

SELECT throws_ok(
  'SELECT GenZOrderCode(ARRAY[0, 1], ARRAY[1], 2)',
  '22023'
);

SELECT throws_ok(
  'SELECT GenZOrderCode(ARRAY[0], ARRAY[1, 1], 2)',
  '22023'
);

SELECT * FROM finish();
ROLLBACK;
