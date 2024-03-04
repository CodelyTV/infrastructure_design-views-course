CREATE TABLE users (
	id uuid PRIMARY KEY,
	name VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
	profile_picture VARCHAR NOT NULL,
	status VARCHAR NOT NULL CHECK (status IN ('active', 'archived'))
);

CREATE TABLE posts (
	id uuid PRIMARY KEY,
	user_id uuid NOT NULL,
	content TEXT NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE post_likes (
	id uuid PRIMARY KEY,
	post_id uuid NOT NULL,
	user_id uuid NOT NULL,
	liked_at TIMESTAMP WITH TIME ZONE NOT NULL,
	FOREIGN KEY (post_id) REFERENCES posts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE VIEW posts_view AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   COUNT(pl.id) AS total_likes,
	   p.created_at
FROM posts p
		 LEFT JOIN post_likes pl ON p.id = pl.post_id
GROUP BY p.id;
