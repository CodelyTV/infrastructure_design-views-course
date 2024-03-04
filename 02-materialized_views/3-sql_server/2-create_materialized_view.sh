DB_USER="postgres"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="postgres"
DB_HOST="localhost"
DB_PORT="5432"

export PGPASSWORD=$DB_PASS

psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME <<EOF
CREATE MATERIALIZED VIEW posts_view_materialized AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   COUNT(pl.id) AS total_likes,
	   p.created_at
FROM posts p
		 LEFT JOIN post_likes pl ON p.id = pl.post_id
GROUP BY p.id;
EOF
