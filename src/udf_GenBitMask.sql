CREATE OR REPLACE FUNCTION GenBitMask (
  bit_size int4,
  dim_size int4
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  ONE_BIT CONSTANT int8 := 1;
  bit_mask int8 := 0;
BEGIN
  IF bit_size < 1 THEN
    RAISE 'Cannot generate z-order code by using zero or minus bits'
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF dim_size < 1 THEN
    RAISE 'Cannot generate z-order code by using zero or minus dimensions'
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF bit_size * dim_size > 63 THEN
    RAISE 'An expected z-order code cannot be expressed by int8: % * %', bit_size, dim_size
      USING ERRCODE = 'numeric_value_out_of_range';
  END IF;

  FOR cur_bit IN 1..bit_size LOOP
    bit_mask := bit_mask << dim_size;
    bit_mask := bit_mask | ONE_BIT;
  END LOOP;
  RETURN bit_mask;
END;
$$ LANGUAGE plpgsql;
