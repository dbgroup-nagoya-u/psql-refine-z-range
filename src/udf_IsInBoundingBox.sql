CREATE OR REPLACE FUNCTION IsInBoundingBox (
  current int8,
  bb_start int8,
  bb_end int8,
  dim_size int4,
  bit_mask int8
) RETURNS
  bool
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
BEGIN
  FOR dim IN 1..dim_size LOOP
    IF (current & bit_mask) < (bb_start & bit_mask) THEN
      RETURN false;
    ELSIF (current & bit_mask) > (bb_end & bit_mask) THEN
      RETURN false;
    END IF;
    bit_mask := bit_mask << 1;
  END LOOP;
  RETURN true;
END;
$$ LANGUAGE plpgsql;
