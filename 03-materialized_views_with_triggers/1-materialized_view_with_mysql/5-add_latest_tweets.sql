ALTER TABLE posts_projection
	ADD COLUMN latest_likes JSON;

CREATE TRIGGER recalculate_post_projection_latest_likes_on_post_like_inserted
	AFTER INSERT
	ON post_likes
	FOR EACH ROW
BEGIN
	UPDATE posts_projection
	SET latest_likes = (
		SELECT JSON_ARRAYAGG(
					   JSON_OBJECT(
							   'id', pl.id,
							   'user_id', pl.user_id,
							   'username', pl.name,
							   'profile_picture_url', pl.profile_picture,
							   'liked_at', pl.liked_at
					   )
			   ) AS json_result
		FROM (SELECT pl.id,
					 pl.user_id,
					 u.name,
					 u.profile_picture,
					 pl.liked_at
			  FROM post_likes pl
					   JOIN users u ON pl.user_id = u.id
			  WHERE pl.post_id = new.post_id
			  ORDER BY pl.liked_at DESC
			  LIMIT 3) AS pl
		)
	WHERE id = new.post_id;
END
