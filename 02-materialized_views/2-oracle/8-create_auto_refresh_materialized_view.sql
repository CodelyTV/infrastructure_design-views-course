CREATE MATERIALIZED VIEW LOG ON posts WITH ROWID (id, user_id, created_at) INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON post_likes WITH ROWID (post_id) INCLUDING NEW VALUES;

-- No funciona
CREATE MATERIALIZED VIEW posts_view_materialized_auto_refresh
			BUILD IMMEDIATE
	REFRESH FAST ON COMMIT
AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   pl.total_likes,
	   p.created_at
FROM posts p
		 LEFT JOIN (SELECT post_id,
						   COUNT(post_id) AS total_likes
					FROM post_likes
					GROUP BY post_id) pl ON p.id = pl.post_id;
