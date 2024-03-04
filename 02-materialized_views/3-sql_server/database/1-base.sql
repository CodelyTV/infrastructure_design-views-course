CREATE SCHEMA rrss;

CREATE TABLE rrss.users (
	id UNIQUEIDENTIFIER PRIMARY KEY,
	name NVARCHAR(255) NOT NULL,
	email NVARCHAR(255) NOT NULL,
	profile_picture NVARCHAR(255) NOT NULL,
	status NVARCHAR(255) NOT NULL CHECK (status IN ('active', 'archived'))
);

CREATE TABLE rrss.posts (
	id UNIQUEIDENTIFIER PRIMARY KEY,
	user_id UNIQUEIDENTIFIER NOT NULL,
	content NVARCHAR(MAX) NOT NULL,
	created_at DATETIMEOFFSET NOT NULL,
	FOREIGN KEY (user_id) REFERENCES rrss.users(id)
);

CREATE TABLE rrss.post_likes (
	id UNIQUEIDENTIFIER PRIMARY KEY,
	post_id UNIQUEIDENTIFIER NOT NULL,
	user_id UNIQUEIDENTIFIER NOT NULL,
	liked_at DATETIMEOFFSET NOT NULL,
	FOREIGN KEY (post_id) REFERENCES rrss.posts(id),
	FOREIGN KEY (user_id) REFERENCES rrss.users(id)
);

CREATE VIEW rrss.posts_view AS
SELECT p.id,
	   p.user_id,
	   p.content,
	   COUNT(pl.id) AS total_likes,
	   p.created_at
FROM rrss.posts p
		 LEFT JOIN rrss.post_likes pl ON p.id = pl.post_id
GROUP BY p.id, p.user_id, p.content, p.created_at;
