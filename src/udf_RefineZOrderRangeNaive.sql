CREATE OR REPLACE FUNCTION RefineZOrderRangeNaive (
  bb_start int8,
  bb_end int8,
  bit_size int4,
  dim_size int4
) RETURNS TABLE (
  s int8,
  e int8
)
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  BIT_MASK CONSTANT int8 := GenBitMask(bit_size, dim_size);
  current int8 := bb_start;
BEGIN
  s := bb_start;
  WHILE current < bb_end LOOP
    IF IsInBoundingBox(current, bb_start, bb_end, bit_size, BIT_MASK) THEN
      current := current + 1;
    ELSE
      e := current - 1;
      RETURN NEXT;
      WHILE current <= bb_end LOOP
        current := current + 1;
        IF IsInBoundingBox(current, bb_start, bb_end, bit_size, BIT_MASK) THEN
          s := current;
          EXIT;
        END IF;
      END LOOP;
    END IF;
  END LOOP;
  e := bb_end;
  RETURN NEXT;
  RETURN;
END;
$$ LANGUAGE plpgsql;
