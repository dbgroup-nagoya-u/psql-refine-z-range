CREATE OR REPLACE FUNCTION RefineZOrderRange (
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
  BIT_NUM CONSTANT int4 := bit_size * dim_size;
  BIT_MASK CONSTANT int8 := GenBitMask(bit_size, dim_size);
  current int8 := bb_start;
BEGIN
  IF bb_end < bb_start THEN
    RAISE 'The start point (%) must be smaller than the end point (%)', bb_start, bb_end USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF bit_size < 1 THEN
    RAISE 'Cannot generate z-order code by using zero or minus bits' USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF dim_size < 1 THEN
    RAISE 'Cannot generate z-order code by using zero or minus dimensions' USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF bit_size * dim_size > 63 THEN
    RAISE 'An expected z-order code cannot be expressed by int8: % * %', bit_size, dim_size USING ERRCODE = 'numeric_value_out_of_range';
  END IF;

  s := bb_start;
  current := GetNextJumpOut(current, bb_start, bb_end, bit_size, dim_size, BIT_MASK);
  WHILE current < bb_end AND current >= 0 LOOP
    e := current - 1;
    RETURN NEXT;
    current := GetNextJumpIn(current, bb_start, bb_end, BIT_NUM, BIT_MASK);
    s := current;
    current := GetNextJumpOut(current, bb_start, bb_end, bit_size, dim_size, BIT_MASK);
  END LOOP;
  e := bb_end;
  RETURN NEXT;
  RETURN;
END;
$$ LANGUAGE plpgsql;
