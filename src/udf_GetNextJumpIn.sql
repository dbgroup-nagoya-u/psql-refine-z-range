CREATE OR REPLACE FUNCTION GetNextJumpIn (
  current int8,
  bb_start int8,
  bb_end int8,
  bit_num int4,
  bit_mask int8
) RETURNS
  int8
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  bit_one int8 := 1::int8 << (bit_num - 1);
  jump_in int8;
BEGIN
  IF current < bb_start OR current > bb_end THEN
    RAISE 'A current z-order coordinate is out of a query range (bb_start: %, bb_end: %, current: %)',
      bb_start,
      bb_end,
      current
      USING ERRCODE = 'numeric_value_out_of_range';
  END IF;

  bit_mask := bit_mask >> 1;
  FOR i IN 1..bit_num LOOP
    -- BIG_MIN process
    IF (current & bit_one) > 0 THEN
      IF (bb_start & bit_one) = 0 THEN
        IF (bb_end & bit_one) > 0 THEN
          bb_start := (bb_start & ~bit_mask) | bit_one;
        ELSE
          RETURN jump_in;
        END IF;
      END IF;
    ELSE
      IF (bb_end & bit_one) > 0 THEN
        IF (bb_start & bit_one) > 0 THEN
          RETURN bb_start;
        ELSE
          jump_in := (bb_start & ~bit_mask) | bit_one;
          bb_end := (bb_end | bit_mask) & ~bit_one;
        END IF;
      END IF;
    END IF;

    bit_one := bit_one >> 1;
    bit_mask := bit_mask >> 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
