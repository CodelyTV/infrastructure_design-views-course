DB_USER="codely"
DB_PASS="C0d3lyS3cr3t"
DB_SERVICE="FREEPDB1"
DB_HOST="localhost"
DB_PORT="1521"

CONNECTION_STRING="$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=$DB_HOST)(Port=$DB_PORT))(CONNECT_DATA=(SERVICE_NAME=$DB_SERVICE)))"
DOCKER_COMMAND_PREFIX="docker exec -i codely_oracle_rrss_database sqlplus -s $CONNECTION_STRING"

echo "SELECT * FROM posts_view_materialized;" | $DOCKER_COMMAND_PREFIX
