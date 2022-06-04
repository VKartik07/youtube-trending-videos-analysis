USE YouTubeAPI

DROP TABLE IF EXISTS youtube_stats
CREATE TABLE youtube_stats(
	video_id VARCHAR(MAX),
	trending_date VARCHAR(MAX), 
	channel_title VARCHAR(MAX),
	category_id INT, 
	publish_time VARCHAR(MAX),
	views INT,
	likes INT, 
	dislikes INT, 
	comment_count INT,
	comments_disabled BIT,
	ratings_disabled BIT,
	video_error_or_removed BIT,
	region VARCHAR(MAX),
	category_title VARCHAR(MAX)
)