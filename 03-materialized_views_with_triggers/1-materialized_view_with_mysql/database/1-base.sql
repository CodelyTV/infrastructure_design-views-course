CREATE TABLE users (
	id CHAR(36) PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	profile_picture VARCHAR(255) NOT NULL,
	status VARCHAR(255) NOT NULL CHECK (status IN ('active', 'archived'))
);

CREATE TABLE posts (
	id CHAR(36) PRIMARY KEY,
	user_id CHAR(36) NOT NULL,
	content TEXT NOT NULL,
	created_at DATETIME NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE post_likes (
	id CHAR(36) PRIMARY KEY,
	post_id CHAR(36) NOT NULL,
	user_id CHAR(36) NOT NULL,
	liked_at DATETIME NOT NULL,
	FOREIGN KEY (post_id) REFERENCES posts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);
