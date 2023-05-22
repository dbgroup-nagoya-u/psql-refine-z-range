CREATE OR REPLACE FUNCTION LoosenZOrderRange (
  bb_start int8,
  bb_end int8,
  bit_size int4,
  dim_size int4
) RETURNS TABLE (
  loosened_start int8,
  loosened_end int8
)
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE
AS $$
DECLARE
  VOL_THRESHOLD CONSTANT float8 := 500;
  ranges int4[] := ARRAY[]::int4[];
  volumes float8[] := ARRAY[]::float8[];
  volume float8;
  volume_sum float8 := 0;
  idx int4;
  new_range int4;
  ranges_s int4[] := ARRAY[]::int4[];
  ranges_e int4[] := ARRAY[]::int4[];
BEGIN
  -- initialization
  FOR dim IN 1..dim_size LOOP
    ranges := ranges || GenOneDimZOrderCode(bb_start, dim, bit_size, dim_size);
    ranges := ranges || GenOneDimZOrderCode(bb_end, dim, bit_size, dim_size);
    volumes := volumes || ARRAY[0, 0]::float8[];
  END LOOP;

  LOOP
    -- volumesの更新
    FOR i IN 1..dim_size LOOP
      volume := 1;
      FOR j IN 1..dim_size LOOP
        IF j != i THEN
          volume := volume * (ranges[2 * j] - ranges[2 * j - 1]);
        END IF;
      END LOOP;
      volume := volume / (2 ^ (i - 1));
      volumes[2 * i - 1] := volume / (2 ^ ((dim_size - 1) * FindMinOneBit(ranges[2 * i - 1])));
      volumes[2 * i] := volume / (2 ^ ((dim_size - 1) * FindMinZeroBit(ranges[2 * i])));
    END LOOP;

    -- 推定体積が閾値以下になったらbreak
    SELECT sum(v)
      INTO volume_sum
      FROM UNNEST(volumes) AS v;
    EXIT WHEN volume_sum < VOL_THRESHOLD;

    -- 最も超体積の大きい次元を緩和
    SELECT vol.id
      INTO idx
      FROM UNNEST(volumes) WITH ORDINALITY AS vol(v, id)
      ORDER BY vol.v DESC NULLS LAST LIMIT 1;
    IF (idx & 1) = 1 THEN
      -- 始点側なら0埋め
      new_range := ranges[idx] & ((~0) << (FindMinOneBit(ranges[idx]) + 1));
    ELSE
      -- 終点側なら1埋め
      new_range := ranges[idx] | ~((~0) << (FindMinZeroBit(ranges[idx]) + 1));
    END IF;
    ranges[idx] := new_range;
  END LOOP;

  -- 緩和後の問合せ範囲をz-orderに変換し返却
  FOR i IN 1..array_length(ranges, 1) LOOP
    IF (i & 1) = 1 THEN
      ranges_s := ranges_s || ranges[i];
    ELSE
      ranges_e := ranges_e || ranges[i];
    END IF;
  END LOOP;
  loosened_start := GenZOrderCode(ranges_s, bit_size);
  loosened_end := GenZOrderCode(ranges_e, bit_size);
  RETURN NEXT;
  RETURN;
END;
$$ LANGUAGE plpgsql;
