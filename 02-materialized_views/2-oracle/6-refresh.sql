BEGIN
	dbms_mview.refresh('posts_view_materialized');
END;
