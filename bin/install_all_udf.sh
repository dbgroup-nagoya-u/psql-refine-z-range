#!/bin/bash
set -ue

########################################################################################
# Documents
########################################################################################

WORKSPACE_DIR=$(cd $(dirname ${BASH_SOURCE:-${0}})/.. && pwd)

usage() {
  cat 1>&2 << EOS
Usage:
  ${BASH_SOURCE:-${0}} <db_name>

Description:
  Install all the UDFs in PostgreSQL.
Arguments:
  <db_name>: A DB name for installing UDFs.
Options:
  -h: Display this message and exit.
EOS
  exit 1
}

########################################################################################
# Parse options
########################################################################################

while getopts h OPT
do
  case ${OPT} in
    h) usage
      ;;
    \?) usage
      ;;
  esac
done

########################################################################################
# Parse arguments
########################################################################################

if [ ${#} != 1 ]; then
  usage
fi
DB_NAME=${1}

# check if the given DB exists
if ! psql -q -d ${DB_NAME} -c "\q" > /dev/null 2>&1; then
  echo "There is no database: ${DB_NAME}"
  exit 1
fi

########################################################################################
# Install UDFs
########################################################################################

# concatenate all CREATE FUNCTIONs
SQL="SET client_min_messages TO WARNING;"
SQL+=`cat ${WORKSPACE_DIR}/uninstall.sql`
SQL+="SET client_min_messages TO NOTICE;"
SQL+=`ls ${WORKSPACE_DIR}/src/*.sql | xargs cat`

echo "${SQL}" |\
  psql -q -d ${DB_NAME}
