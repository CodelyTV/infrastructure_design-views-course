DB_USER="postgres"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="postgres"
DB_HOST="localhost"
DB_PORT="5432"

export PGPASSWORD=$DB_PASS

psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME <<EOF
CREATE VIEW post_view_with_latest_tweets AS
SELECT
	p.id,
	p.user_id,
	p.content,
	COUNT(pl.id) AS total_likes,
	(
		SELECT json_agg(row_to_json(latest_likes.*))
		FROM (
			 SELECT
				 pl.id,
				 pl.user_id AS "userId",
				 u.name AS "userName",
				 u.profile_picture AS "profilePictureUrl",
				 pl.liked_at AS "likedAt"
			 FROM post_likes pl
					  JOIN users u ON pl.user_id = u.id
			 WHERE pl.post_id = p.id
			 ORDER BY pl.liked_at DESC
			 LIMIT 3
		 ) AS latest_likes
	) AS latest_likes,
	p.created_at
FROM posts p
		 LEFT JOIN post_likes pl ON p.id = pl.post_id
GROUP BY p.id;
EOF
