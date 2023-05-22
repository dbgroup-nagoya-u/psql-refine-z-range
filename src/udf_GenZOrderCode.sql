CREATE OR REPLACE FUNCTION GenZOrderCode (
  one_dim_z_codes int4[],
  bit_size int4
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  ONE_BIT CONSTANT int8 := 1::int8;
  DIM_SIZE CONSTANT int4 := array_length(one_dim_z_codes, 1);
  z_order_code int8 := 0;
  one_dim_code int8;
BEGIN
  FOR dim IN 1..DIM_SIZE LOOP
    one_dim_code := one_dim_z_codes[dim];
    FOR i IN 0..(bit_size - 1) LOOP
      z_order_code := z_order_code | ((ONE_BIT & one_dim_code) << (DIM_SIZE * i + dim - 1));
      one_dim_code := one_dim_code >> 1;
    END LOOP;
  END LOOP;
  RETURN z_order_code;
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION GenZOrderCode (
  coords float8[],
  cell_sizes float4[],
  bit_size int4
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  DIM_SIZE CONSTANT int4 := array_length(coords, 1);
  one_dim_z_codes int4[] := ARRAY[]::int4[];
BEGIN
  IF array_ndims(coords) IS NULL OR array_ndims(cell_sizes) IS NULL THEN
    RAISE 'An empty array is not allowed'
      USING ERRCODE = 'null_value_not_allowed';
  END IF;
  IF array_ndims(coords) > 1 OR array_ndims(cell_sizes) > 1 THEN
    RAISE 'A multi-dimensional array is not allowed'
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
  IF array_length(cell_sizes, 1) != DIM_SIZE THEN
    RAISE 'The arrays of coordinates and cell sizes must have the same number of elements'
      USING ERRCODE = 'invalid_parameter_value';
  END IF;

  /* generates z-order codes for each dimension and merges them */
  FOR dim IN 1..DIM_SIZE LOOP
    one_dim_z_codes := one_dim_z_codes
                       || GenOneDimZOrderCode(coords[dim], cell_sizes[dim], bit_size);
  END LOOP;
  RETURN GenZOrderCode(one_dim_z_codes, bit_size);
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION GenZOrderCode (
  d_1 float8,
  d_2 float8,
  d_3 float8
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  CELL_SIZES CONSTANT float4[] := ARRAY[1, 1, 1]::float4[];
  BIT_SIZE CONSTANT int4 := 20;
BEGIN
  RETURN GenZOrderCode(ARRAY[d_1, d_2, d_3], CELL_SIZES, BIT_SIZE);
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION GenZOrderCode (
  d_1 float8,
  d_2 float8
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  CELL_SIZES CONSTANT float4[] := ARRAY[1, 1]::float4[];
  BIT_SIZE CONSTANT int4 := 30;
BEGIN
  RETURN GenZOrderCode(ARRAY[d_1, d_2], CELL_SIZES, BIT_SIZE);
END;
$$ LANGUAGE plpgsql;
