DB_USER="postgres"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="postgres"
DB_HOST="localhost"
DB_PORT="5432"

export PGPASSWORD=$DB_PASS

total_posts_rows=$(psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -t -c "SELECT COUNT(*) FROM posts" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
total_posts_materialized_rows=$(psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -t -c "SELECT COUNT(*) FROM post_view_with_latest_tweets_materialized" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo "Total rows in posts"
echo "→ $total_posts_rows"
echo
echo "Total rows in post_view_with_latest_tweets_materialized"
echo "→ $total_posts_materialized_rows"
