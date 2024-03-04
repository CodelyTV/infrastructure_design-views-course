DB_USER="sa"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="master"
DB_HOST="localhost"
DB_PORT="1433"
CONTAINER_NAME="codely_sqlserver_rrss_database"
SCHEMA_NAME="rrss"

QUERY="SELECT * FROM rrss.posts"

total_posts_rows=$(docker exec -i $CONTAINER_NAME bash -c "/opt/mssql-tools/bin/sqlcmd -S localhost -U $DB_USER -P $DB_PASS -d $DB_NAME -Q \"SELECT count(*) FROM rrss.posts\"" | head -n3 | tail -n1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
total_posts_materialized_rows=$(docker exec -i $CONTAINER_NAME bash -c "/opt/mssql-tools/bin/sqlcmd -S localhost -U $DB_USER -P $DB_PASS -d $DB_NAME -Q \"SELECT count(*) FROM rrss.posts_view_materialized\"" | head -n3 | tail -n1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo "Total rows in posts"
echo "→ $total_posts_rows"
echo
echo "Total rows in post_view_with_latest_tweets_materialized"
echo "→ $total_posts_materialized_rows"
