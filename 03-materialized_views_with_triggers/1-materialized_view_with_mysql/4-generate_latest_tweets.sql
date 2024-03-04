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
	  WHERE pl.post_id = '00F036DC-E8B6-4EC3-B767-9216112ADAD0'
	  ORDER BY pl.liked_at DESC
	  LIMIT 3) AS pl;
