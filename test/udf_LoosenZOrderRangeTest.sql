BEGIN;
SELECT plan(2);

SELECT results_eq(
  '
    SELECT *
    FROM LoosenZOrderRange(
      0,
      65535,
      8,
      2
    )
  ',
  $$VALUES( 0::int8, 65535::int8 )$$
);

SELECT results_eq(
  '
    SELECT *
    FROM LoosenZOrderRange(
      0,
      1048320,
      8,
      4
    )
  ',
  $$VALUES( 0::int8, 1048447::int8 )$$
);

SELECT * FROM finish();
ROLLBACK;
