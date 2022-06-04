SELECT TOP 10 *
FROM YouTubeAPI..youtube_stats

-- Date Cleaning and Transformation

-- To understand which parts of trending_date and publish_time represenet 
-- 1) Year
-- 2) Month
-- 3) Day
-- 4) Hour
-- 5) Minute
-- 6) Second

SELECT SUBSTRING(trending_date, CHARINDEX('.', trending_date)+1, CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1) - (CHARINDEX('.', trending_date)+1))
FROM YouTubeAPI..youtube_stats
GROUP BY SUBSTRING(trending_date, CHARINDEX('.', trending_date)+1, CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1) - (CHARINDEX('.', trending_date)+1))

-- The above clearly represenets the trending_day [01-31]

SELECT SUBSTRING(trending_date, CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1)+1, LEN(trending_date) - CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1))
FROM YouTubeAPI..youtube_stats
GROUP BY SUBSTRING(trending_date, CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1)+1, LEN(trending_date) - CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1))

-- The above clearly represents the trending_month as the maximum value is 12

SELECT 
	SUBSTRING(trending_date, 1, CHARINDEX('.', trending_date)-1)
FROM YouTubeAPI..youtube_stats
GROUP BY SUBSTRING(trending_date, 1, CHARINDEX('.', trending_date)-1)

-- The above cannot represent year as the corresponding year in the publish_time does not align. 
-- Hence, the trending_year will be taken as the year extracted from publish_time

SELECT 
	SUBSTRING(publish_time, 1, CHARINDEX('-', publish_time)-1)
FROM YouTubeAPI..youtube_stats

-- The above represents the publishing_year and the trending_year

SELECT 
	SUBSTRING(publish_time, CHARINDEX('-', publish_time)+1, CHARINDEX('-', publish_time, CHARINDEX('-', publish_time)+1) - (CHARINDEX('-', publish_time)+1))
FROM YouTubeAPI..youtube_stats

-- The above represents the publishing_month

SELECT 
	SUBSTRING(publish_time, CHARINDEX('-', publish_time, CHARINDEX('-', publish_time)+1)+1, CHARINDEX('T', publish_time) - (CHARINDEX('-', publish_time, CHARINDEX('-', publish_time)+1)+1))
FROM YouTubeAPI..youtube_stats

-- The above reprsents the publishing_day

SELECT 
	SUBSTRING(publish_time, CHARINDEX('T', publish_time)+1, (CHARINDEX(':', publish_time)-1)-CHARINDEX('T', publish_time))
FROM YouTubeAPI..youtube_stats

-- The above represents the publishing_hour

SELECT 
	SUBSTRING(publish_time, CHARINDEX(':', publish_time)+1, CHARINDEX(':', publish_time, CHARINDEX(':', publish_time)+1) - (CHARINDEX(':', publish_time)+1)) 
FROM YouTubeAPI..youtube_stats 

-- The above represents the publishing_minute

SELECT 
	SUBSTRING(publish_time, CHARINDEX(':', publish_time, CHARINDEX(':', publish_time)+1)+1, CHARINDEX('.', publish_time) - (CHARINDEX(':', publish_time, CHARINDEX(':', publish_time)+1)+1))
FROM YouTubeAPI..youtube_stats 

-- The above represents the publishing_second

-- Region Transformation

-- Converting shortnames to fullnames in region

SELECT 
	CASE
		WHEN region = 'CA' THEN 'Canada'
		WHEN region = 'US' THEN 'United States'
		WHEN region = 'GB' THEN 'Great Britain'
		WHEN region = 'DE' THEN 'Germany'
		WHEN region = 'FR' THEN 'France'
		WHEN region = 'RU' THEN 'Russia'
		WHEN region = 'MX' THEN 'Mexico'
		WHEN region = 'KR' THEN 'South Korea'
		WHEN region = 'JP' THEN 'Japan'
		WHEN region = 'IN' THEN 'India'
		ELSE NULL
	END AS region
FROM YouTubeAPI..youtube_stats

-- Now, inserting the clean data into clean_youtube_stats

SELECT 
	video_id, 
	SUBSTRING(publish_time, 1, CHARINDEX('-', publish_time)-1) AS trending_publishing_year, 
	SUBSTRING(trending_date, CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1)+1, LEN(trending_date) - CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1)) AS trending_month, 
	SUBSTRING(trending_date, CHARINDEX('.', trending_date)+1, CHARINDEX('.', trending_date, CHARINDEX('.', trending_date)+1) - (CHARINDEX('.', trending_date)+1)) AS trending_day, 
	SUBSTRING(publish_time, CHARINDEX('-', publish_time)+1, CHARINDEX('-', publish_time, CHARINDEX('-', publish_time)+1) - (CHARINDEX('-', publish_time)+1)) AS publishing_month, 
	SUBSTRING(publish_time, CHARINDEX('-', publish_time, CHARINDEX('-', publish_time)+1)+1, CHARINDEX('T', publish_time) - (CHARINDEX('-', publish_time, CHARINDEX('-', publish_time)+1)+1)) AS publishing_day, 
	SUBSTRING(publish_time, CHARINDEX('T', publish_time)+1, (CHARINDEX(':', publish_time)-1)-CHARINDEX('T', publish_time)) AS publishing_hour, 
	SUBSTRING(publish_time, CHARINDEX(':', publish_time)+1, CHARINDEX(':', publish_time, CHARINDEX(':', publish_time)+1) - (CHARINDEX(':', publish_time)+1)) AS publishing_minute, 
	SUBSTRING(publish_time, CHARINDEX(':', publish_time, CHARINDEX(':', publish_time)+1)+1, CHARINDEX('.', publish_time) - (CHARINDEX(':', publish_time, CHARINDEX(':', publish_time)+1)+1)) AS publishing_second, 
	channel_title, 
	category_id, 
	views, 
	likes, 
	dislikes, 
	comment_count, 
	comments_disabled, 
	ratings_disabled, 
	video_error_or_removed, 
	CASE
		WHEN region = 'CA' THEN 'Canada'
		WHEN region = 'US' THEN 'United States'
		WHEN region = 'GB' THEN 'Great Britain'
		WHEN region = 'DE' THEN 'Germany'
		WHEN region = 'FR' THEN 'France'
		WHEN region = 'RU' THEN 'Russia'
		WHEN region = 'MX' THEN 'Mexico'
		WHEN region = 'KR' THEN 'South Korea'
		WHEN region = 'JP' THEN 'Japan'
		WHEN region = 'IN' THEN 'India'
		ELSE NULL
	END AS region,
	category_title
INTO YouTubeAPI..clean_youtube_stats
FROM YouTubeAPI..youtube_stats

-- First 10 records of clean_youtube_stats
SELECT TOP 10 *
FROM YouTubeAPI..clean_youtube_stats