CREATE TABLE posts_projection (
	id CHAR(36) PRIMARY KEY,
	user_id CHAR(36) NOT NULL,
	content TEXT NOT NULL,
	total_likes INT NOT NULL,
	created_at DATETIME NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TRIGGER insert_post_projection_on_post_inserted
	AFTER INSERT
	ON posts
	FOR EACH ROW
BEGIN
	INSERT INTO posts_projection (id, user_id, content, total_likes, created_at)
	VALUES (new.id, new.user_id, new.content, 0, new.created_at);
END;

CREATE TRIGGER recalculate_total_post_projection_likes_on_post_like_inserted
	AFTER INSERT
	ON post_likes
	FOR EACH ROW
BEGIN
	UPDATE posts_projection
	SET total_likes = (SELECT COUNT(*) FROM post_likes WHERE post_id = new.post_id)
	WHERE id = new.post_id;
END
