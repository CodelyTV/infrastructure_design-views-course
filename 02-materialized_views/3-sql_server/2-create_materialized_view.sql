CREATE VIEW rrss.posts_view_materialized
	WITH SCHEMABINDING
AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   COUNT_BIG(*) AS total_rows,
	   COUNT_BIG(pl.id) AS total_likes,
	   p.created_at
FROM rrss.posts p
		 INNER JOIN rrss.post_likes pl ON p.id = pl.post_id
GROUP BY p.id, p.user_id, p.content, p.created_at;

CREATE UNIQUE CLUSTERED INDEX idx_posts_view_materialized ON rrss.posts_view_materialized(id);
