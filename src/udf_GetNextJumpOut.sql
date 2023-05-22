CREATE OR REPLACE FUNCTION GetNextJumpOut (
  current int8,
  bb_start int8,
  bb_end int8,
  bit_size int4,
  dim_size int4,
  mask_dim int8
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  BIT_NUM CONSTANT int4 := bit_size * dim_size;
  mask_one int8 := 1::int8;
  mask_full int8 := ~(0::int8);
  jump_out int8;
  out_bound int8;
  min_jump_out int8 := bb_end;
BEGIN
  IF current < bb_start OR current > bb_end THEN
    RAISE 'A current z-order coordinate is out of a query range (bb_start: %, bb_end: %, current: %)',
      bb_start,
      bb_end,
      current
      USING ERRCODE = 'numeric_value_out_of_range';
  END IF;

  -- get an initial answer by sliding positions
  FOR dim IN 0..(dim_size - 1) LOOP
    IF (bb_end | ~(mask_dim << dim)) = mask_full THEN
      -- cannot slide because bb_end reaches the boundary of z-order space
      CONTINUE;
    END IF;
    out_bound := ((bb_end | ~(mask_dim << dim)) + 1) & (mask_dim << dim);
    jump_out := (current & ~(mask_dim << dim)) | out_bound;
    IF jump_out < min_jump_out THEN
      min_jump_out := jump_out;
    END IF;
  END LOOP;

  mask_one := mask_one << 1;
  mask_full := mask_full << 1;
  FOR i IN 2..BIT_NUM LOOP
    IF current & mask_one = 0 THEN
      jump_out := (current & mask_full) | mask_one;
      IF jump_out >= min_jump_out THEN
        RETURN min_jump_out;
      ELSIF NOT IsInBoundingBox(jump_out, bb_start, bb_end, bit_size, mask_dim) THEN
        RETURN jump_out;
      END IF;
    END IF;
    mask_one := mask_one << 1;
    mask_full := mask_full << 1;
  END LOOP;

  RETURN min_jump_out;
END;
$$ LANGUAGE plpgsql;
