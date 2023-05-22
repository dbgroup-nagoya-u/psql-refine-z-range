DROP FUNCTION IF EXISTS
  FindMaxOneBit,
  FindMinOneBit,
  FindMinZeroBit,
  GenBitMask,
  GenOneDimZOrderCode(float8, float4, int4),
  GenOneDimZOrderCode(int8, int4, int4, int4),
  GenZOrderCode(int4[], int4),
  GenZOrderCode(float8[], float4[], int4),
  GenZOrderCode(float8, float8, float8),
  GenZOrderCode(float8, float8),
  GetNextJumpIn,
  GetNextJumpOut,
  IsInBoundingBox,
  LoosenZOrderRange,
  RefineZOrderRange,
  RefineZOrderRangeNaive
;
