BEGIN;
SELECT plan(13);

-- 二次元

SELECT is(
  GetNextJumpIn(16, 15, 240, 4*2, GenBitMask(4, 2)),
  26::int8
);

SELECT is(
  GetNextJumpIn(32, 15, 240, 4*2, GenBitMask(4, 2)),
  37::int8
);

SELECT is(
  GetNextJumpIn(91, 15, 240, 4*2, GenBitMask(4, 2)),
  96::int8
);

SELECT is(
  GetNextJumpIn(113, 15, 240, 4*2, GenBitMask(4, 2)),
  114::int8
);

SELECT is(
  GetNextJumpIn(123, 15, 240, 4*2, GenBitMask(4, 2)),
  133::int8
);

SELECT is(
  GetNextJumpIn(166, 15, 240, 4*2, GenBitMask(4, 2)),
  176::int8
);

SELECT is(
  GetNextJumpIn(178, 15, 240, 4*2, GenBitMask(4, 2)),
  180::int8
);

SELECT is(
  GetNextJumpIn(182, 15, 240, 4*2, GenBitMask(4, 2)),
  192::int8
);

-- 三次元

SELECT is(
  GetNextJumpIn(512, 511, 3640, 4*3, GenBitMask(4, 3)),
  950::int8
);

SELECT is(
  GetNextJumpIn(952, 511, 3640, 4*3, GenBitMask(4, 3)),
  958::int8
);

SELECT is(
  GetNextJumpIn(959, 511, 3640, 4*3, GenBitMask(4, 3)),
  1389::int8
);

SELECT is(
  GetNextJumpIn(1406, 511, 3640, 4*3, GenBitMask(4, 3)),
  1828::int8
);

SELECT is(
  GetNextJumpIn(1853, 511, 3640, 4*3, GenBitMask(4, 3)),
  2267::int8
);

SELECT * FROM finish();
ROLLBACK;
