BEGIN;
SELECT plan(2);

SELECT results_eq(
  'SELECT * FROM RefineZOrderRangeNaive(0, 7, 21, 3)',
  $$VALUES( 0::int8, 7::int8 )$$
);

SELECT results_eq(
  'SELECT * FROM RefineZOrderRangeNaive(15, 240, 21, 2)',
  $$VALUES
    ( 15::int8, 15::int8 ),
    ( 26::int8, 27::int8 ),
    ( 30::int8, 31::int8 ),
    ( 37::int8, 37::int8 ),
    ( 39::int8, 39::int8 ),
    ( 45::int8, 45::int8 ),
    ( 47::int8, 63::int8 ),
    ( 74::int8, 75::int8 ),
    ( 78::int8, 79::int8 ),
    ( 90::int8, 90::int8 ),
    ( 96::int8, 112::int8 ),
    ( 114::int8, 114::int8 ),
    ( 120::int8, 120::int8 ),
    ( 122::int8, 122::int8 ),
    ( 133::int8, 133::int8 ),
    ( 135::int8, 135::int8 ),
    ( 141::int8, 141::int8 ),
    ( 143::int8, 159::int8 ),
    ( 165::int8, 165::int8 ),
    ( 176::int8, 177::int8 ),
    ( 180::int8, 181::int8 ),
    ( 192::int8, 208::int8 ),
    ( 210::int8, 210::int8 ),
    ( 216::int8, 216::int8 ),
    ( 218::int8, 218::int8 ),
    ( 224::int8, 225::int8 ),
    ( 228::int8, 229::int8 ),
    ( 240::int8, 240::int8 )
  $$
);

SELECT * FROM finish();
ROLLBACK;
