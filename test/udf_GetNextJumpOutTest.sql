BEGIN;
SELECT plan(12);

-- 二次元の場合

SELECT is(
  GetNextJumpOut(15, 15, 240, 4, 2, GenBitMask(4, 2)),
  16::int8
);

SELECT is(
  GetNextJumpOut(26, 15, 240, 4, 2, GenBitMask(4, 2)),
  28::int8
);

SELECT is(
  GetNextJumpOut(30, 15, 240, 4, 2, GenBitMask(4, 2)),
  32::int8
);

SELECT is(
  GetNextJumpOut(39, 15, 240, 4, 2, GenBitMask(4, 2)),
  40::int8
);

SELECT is(
  GetNextJumpOut(47, 15, 240, 4, 2, GenBitMask(4, 2)),
  64::int8
);

SELECT is(
  GetNextJumpOut(90, 15, 240, 4, 2, GenBitMask(4, 2)),
  91::int8
);

SELECT is(
  GetNextJumpOut(96, 15, 240, 4, 2, GenBitMask(4, 2)),
  113::int8
);

SELECT is(
  GetNextJumpOut(176, 15, 240, 4, 2, GenBitMask(4, 2)),
  178::int8
);

SELECT is(
  GetNextJumpOut(192, 15, 240, 4, 2, GenBitMask(4, 2)),
  209::int8
);

-- 三次元の場合

SELECT is(
  GetNextJumpOut(511, 511, 3640, 4, 3, GenBitMask(4, 3)),
  512::int8
);

SELECT is(
  GetNextJumpOut(950, 511, 3640, 4, 3, GenBitMask(4, 3)),
  952::int8
);

SELECT is(
  GetNextJumpOut(1828, 511, 3640, 4, 3, GenBitMask(4, 3)),
  1832::int8
);

SELECT * FROM finish();
ROLLBACK;
