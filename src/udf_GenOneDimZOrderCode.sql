CREATE OR REPLACE FUNCTION GenOneDimZOrderCode (
  coord float8,
  cell_size float4,
  bit_size int4
) RETURNS
  int4
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  ONE_BIT CONSTANT int4 := 1;
  z_code int4 := 0;
  r float8 := cell_size;
BEGIN
  IF bit_size < 1 THEN
    RAISE 'Cannot generate z-order code by using zero or minus bits'
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF cell_size <= 0 THEN
    RAISE 'Cannot generate z-order code by using zero or minus cell size'
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF bit_size >= 32 THEN
    RAISE 'An expected z-order code cannot be expressed by int4: %', bit_size
      USING ERRCODE = 'numeric_value_out_of_range';
  END IF;

  r := cell_size * (2 ^ (bit_size - 1));
  FOR i IN 1..bit_size LOOP
    r := r / 2;
    z_code := z_code << 1;
    IF coord > 0 THEN
      z_code := z_code | ONE_BIT;
      coord := coord - r;
    ELSE
      coord := coord + r;
    END IF;
  END LOOP;
  RETURN z_code;
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION GenOneDimZOrderCode (
  full_z_code int8,
  dim int4,
  bit_size int4,
  dim_size int4
) RETURNS
  int4
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  ONE_BIT CONSTANT int8 := 1;
  z_code int4 := 0;
BEGIN
  IF dim < 1 OR dim > dim_size THEN
    RAISE 'The specified dimension is minus or larger than the number of dimensions: %', dim
      USING ERRCODE = 'numeric_value_out_of_range';
  END IF;

  full_z_code := full_z_code >> (dim - 1);
  FOR i IN 1..bit_size LOOP
    IF full_z_code & ONE_BIT > 0 THEN
      z_code := z_code | (1 << (i - 1));
    END IF;
    full_z_code := full_z_code >> dim_size;
  END LOOP;
  RETURN z_code;
END;
$$ LANGUAGE plpgsql;
