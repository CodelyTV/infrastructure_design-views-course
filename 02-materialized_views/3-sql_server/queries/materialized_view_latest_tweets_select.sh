DB_USER="postgres"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="postgres"
DB_HOST="localhost"
DB_PORT="5432"

export PGPASSWORD=$DB_PASS

psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -c "SELECT * FROM post_view_with_latest_tweets_materialized;"
