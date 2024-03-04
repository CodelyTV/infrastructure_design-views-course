CREATE TABLE users (
	id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
	name VARCHAR2(255) NOT NULL,
	email VARCHAR2(255) NOT NULL,
	profile_picture VARCHAR2(255) NOT NULL,
	status VARCHAR2(255) NOT NULL CHECK (status IN ('active', 'archived'))
);

CREATE TABLE posts (
	id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
	user_id RAW(16) NOT NULL,
	content CLOB NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE post_likes (
	id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
	post_id RAW(16) NOT NULL,
	user_id RAW(16) NOT NULL,
	liked_at TIMESTAMP WITH TIME ZONE NOT NULL,
	FOREIGN KEY (post_id) REFERENCES posts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE VIEW posts_view AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   (SELECT COUNT(*) FROM post_likes pl WHERE p.id = pl.post_id) AS total_likes,
	   p.created_at
FROM posts p;

SELECT * FROM users;
