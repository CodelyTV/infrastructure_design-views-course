CREATE TABLE users (
	id UUID PRIMARY KEY,
	name VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
	profile_picture VARCHAR NOT NULL,
	status VARCHAR NOT NULL CHECK (status IN ('active', 'archived'))
);

CREATE TABLE posts (
	id UUID PRIMARY KEY,
	user_id UUID NOT NULL,
	content TEXT NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE post_likes (
	id UUID PRIMARY KEY,
	post_id UUID NOT NULL,
	user_id UUID NOT NULL,
	liked_at TIMESTAMP WITH TIME ZONE NOT NULL,
	FOREIGN KEY (post_id) REFERENCES posts(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);
