# PL/pgSQL Scripts for Removing Unnecessary Z-Ordered Ranges <!-- omit in toc -->

- [Install](#install)
- [Running Unit Tests](#running-unit-tests)
- [Example Usage](#example-usage)
- [Uninstall](#uninstall)
- [Acknowledgments](#acknowledgments)

## Install

We prepare a script to install all the developed UDFs.

```bash
./bin/install_all_udf.sh <db_name>
```

## Running Unit Tests

We use the [pgTAP](https://pgtap.org/) extension for unit testing.

```bash
sudo apt install sudo apt install postgresql-<pg_ver>-pgtap
psql -d <db_name> -c "CREATE EXTENSION pgtap"
```

After enabling pgTAP, run the following command to run unit tests.

```bash
./bin/run_all_test.sh <db_name>
```

## Example Usage

In the following example, we convert two-dimensional float values to 8-bit Z-order.

```sql
sample_db=# SELECT
sample_db-#   GenZOrderCode(ARRAY[-10, -10], ARRAY[5, 5], 8) AS z_begin,
sample_db-#   GenZOrderCode(ARRAY[10, 10], ARRAY[5, 5], 8) AS z_end
sample_db-# ;
 z_begin | z_end
---------+-------
   16371 | 49155
(1 row)

sample_db=# SELECT
sample_db-#   s AS part_begin,
sample_db-#   e AS part_end
sample_db-# FROM
sample_db-#   RefineZOrderRange(16371, 49155, 8, 2)
sample_db-# ;
 part_begin | part_end
------------+----------
      16371 |    16371
      16374 |    16375
      16377 |    16377
      16379 |    16383
      27298 |    27299
      27304 |    27307
      38225 |    38225
      38227 |    38231
      49152 |    49155
(9 rows)
```

## Uninstall

```bash
psql -f ./uninstall.sql
```

## Acknowledgments

This work is based on results obtained from a project, JPNP16007, commissioned by the New Energy and Industrial Technology Development Organization (NEDO). In addition, this work was supported partly by KAKENHI (JP20K19804, JP21H03555, and JP22H03594).
