-- Questions

-- 1. Does the hour at which the video gets published has got anything to do with the number of views and comment_count?

-- Divide hours into the following four parts
	-- 05-07 - Early Morning
	-- 08-11 - Morning
	-- 12-16 - Afternoon
	-- 17-19 - Evening
	-- 20-23 - Night
	-- 00-04 - Middle of the Night

WITH time_band_cte(views, comment_count, time_band) AS
(
SELECT
	views, 
	comment_count, 
	CASE 
		WHEN CAST(publishing_hour AS INT) BETWEEN 00 AND 04 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Middle of the Night'
		WHEN CAST(publishing_hour AS INT) BETWEEN 05 AND 07 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Early Morning'
		WHEN CAST(publishing_hour AS INT) BETWEEN 08 AND 11 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Morning'
		WHEN CAST(publishing_hour AS INT) BETWEEN 12 AND 16 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Afternoon'
		WHEN CAST(publishing_hour AS INT) BETWEEN 17 AND 19 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Evening'
		WHEN CAST(publishing_hour AS INT) BETWEEN 20 AND 23 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Night'
		ELSE
			NULL
	END AS time_band
FROM YouTubeAPI..clean_youtube_stats
)

SELECT 
	time_band, 
	AVG(CAST(views AS BIGINT)) AS avg_views, 
	AVG(CAST(comment_count AS BIGINT)) AS avg_comments
FROM time_band_cte
GROUP BY time_band
ORDER BY avg_views DESC

-- 2. What category of videos are people liking or disliking?

SELECT 
	category_title, 
	SUM(CAST(likes AS BIGINT)) AS sum_likes, 
	SUM(CAST(dislikes AS BIGINT)) AS sum_dislikes 
FROM YouTubeAPI..clean_youtube_stats
GROUP BY category_title
ORDER BY sum_likes DESC

-- 3. What category of videos are people watching in different time bands?

WITH time_band_cte(views, comment_count, category_title, time_band) AS
(
SELECT
	views, 
	comment_count, 
	category_title, 
	CASE 
		WHEN CAST(publishing_hour AS INT) BETWEEN 00 AND 04 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Middle of the Night'
		WHEN CAST(publishing_hour AS INT) BETWEEN 05 AND 07 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Early Morning'
		WHEN CAST(publishing_hour AS INT) BETWEEN 08 AND 11 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Morning'
		WHEN CAST(publishing_hour AS INT) BETWEEN 12 AND 16 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Afternoon'
		WHEN CAST(publishing_hour AS INT) BETWEEN 17 AND 19 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Evening'
		WHEN CAST(publishing_hour AS INT) BETWEEN 20 AND 23 AND CAST(publishing_minute AS INT) BETWEEN 00 AND 60
			THEN 'Night'
		ELSE
			NULL
	END AS time_band
FROM YouTubeAPI..clean_youtube_stats
)

SELECT 
	category_title, 
	SUM(CASE WHEN time_band = 'Middle of the Night' THEN 1 ELSE NULL END) AS middle_of_the_night_count, 
	SUM(CASE WHEN time_band = 'Early Morning' THEN 1 ELSE NULL END) AS early_morning_count, 
	SUM(CASE WHEN time_band = 'Morning' THEN 1 ELSE NULL END) AS morning_count, 
	SUM(CASE WHEN time_band = 'Afternoon' THEN 1 ELSE NULL END) AS afternoon_count, 
	SUM(CASE WHEN time_band = 'Evening' THEN 1 ELSE NULL END) AS evening_count,
	SUM(CASE WHEN time_band = 'Night' THEN 1 ELSE NULL END) AS night_count
FROM time_band_cte
GROUP BY category_title

-- 4. How does disabling the comments and ratings affect the views and dislikes?

SELECT 
	comments_disabled, 
	SUM(CAST(views AS BIGINT)) AS views, 
	SUM(CAST(dislikes AS BIGINT)) AS dislikes
FROM YouTubeAPI..clean_youtube_stats
GROUP BY comments_disabled

SELECT 
	ratings_disabled, 
	SUM(CAST(views AS BIGINT)) AS views, 
	SUM(CAST(dislikes AS BIGINT)) AS dislikes
FROM YouTubeAPI..clean_youtube_stats
GROUP BY ratings_disabled

-- 5. How may videos have encountered an error or have been removed per region?

SELECT
	region, 
	SUM(CAST(video_error_or_removed AS INT)) AS faulty_videos
FROM YouTubeAPI..clean_youtube_stats
GROUP BY region
ORDER BY region

-- 6. Amount of Days taken for videos to get trending per category?

WITH days_to_trending(required_days_to_trending, region, category_title) AS
(
SELECT 
	CASE 
		WHEN temp.required_days_to_trending < 0 
			THEN temp.required_days_to_trending + 365
		ELSE
			temp.required_days_to_trending
	END AS required_days_to_trending, 
	temp.region, 
	temp.category_title
FROM
(
	SELECT  
		DATEDIFF(
			day, 
			CONCAT(trending_publishing_year, '-', publishing_month, '-', publishing_day),
			CONCAT(trending_publishing_year, '-', trending_month, '-', trending_day) 
		) AS required_days_to_trending, 
		region, 
		category_title
	FROM YouTubeAPI..clean_youtube_stats
) AS temp
)

SELECT 
	category_title,
	AVG(required_days_to_trending) AS avg_days
FROM days_to_trending
GROUP BY category_title
