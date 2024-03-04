DB_USER="sa"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="master"
DB_HOST="localhost"
DB_PORT="1433"
CONTAINER_NAME="codely_sqlserver_rrss_database"
SCHEMA_NAME="rrss"

QUERY="SELECT * FROM rrss.posts"

docker exec -i $CONTAINER_NAME bash -c "/opt/mssql-tools/bin/sqlcmd -S localhost -U $DB_USER -P $DB_PASS -d $DB_NAME -Q \"$QUERY\""
