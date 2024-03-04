CREATE MATERIALIZED VIEW posts_view_materialized AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   pl.total_likes,
	   p.created_at
FROM posts p
		 LEFT JOIN (SELECT post_id,
						   COUNT(*) AS total_likes
					FROM post_likes
					GROUP BY post_id) pl ON p.id = pl.post_id;
