BEGIN;
SELECT plan(10);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[0], ARRAY[1], 2),
    GenZOrderCode(ARRAY[-1], ARRAY[1], 2),
    GenZOrderCode(ARRAY[1], ARRAY[1], 2),
    1,
    GenBitMask(2, 1)
  ),
  true
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[0, 0], ARRAY[1, 1], 2),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 2),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 2),
    2,
    GenBitMask(2, 2)
  ),
  true
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  true
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[-1, 1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  true
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  true
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  true
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[-2, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  false
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[-1, -2], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  false
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[2, 1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  false
);

SELECT is(
  IsInBoundingBox(
    GenZOrderCode(ARRAY[1, 2], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[-1, -1], ARRAY[1, 1], 3),
    GenZOrderCode(ARRAY[1, 1], ARRAY[1, 1], 3),
    2,
    GenBitMask(3, 2)
  ),
  false
);

SELECT * FROM finish();
ROLLBACK;
