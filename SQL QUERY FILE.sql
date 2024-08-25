use `songs record`;
select * from spotify_final ;
select sum(`Tiktok Views`+`Spotify Streams`+`YouTube Views`) as `total plays across all platform`,`Album Name`
from spotify_final
group by `Album Name`;
DESCRIBE spotify_final;
SET SQL_SAFE_UPDATES = 0;

UPDATE spotify_final
SET `Spotify Streams` = CAST(`Spotify Streams` AS UNSIGNED)
WHERE `Spotify Streams` REGEXP '^[0-9]+$';


UPDATE spotify_final
SET `YouTube Views` = CAST(`YouTube Views` AS UNSIGNED)
WHERE `YouTube Views` REGEXP '^[0-9]+$';

UPDATE spotify_final
SET `TikTok Views` = CAST(`TikTok Views` AS UNSIGNED)
WHERE `TikTok Views` REGEXP '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `Spotify Streams` INT;

ALTER TABLE spotify_final MODIFY COLUMN `YouTube Views` INT;

ALTER TABLE spotify_final MODIFY COLUMN `TikTok Views` INT;

SELECT count(`Spotify Streams`)
FROM spotify_final
WHERE `Spotify Streams` NOT REGEXP '^[0-9]+$';

CREATE TABLE spotify_final_backup AS SELECT * FROM spotify_final;

UPDATE spotify_final
SET `Spotify Streams` = REPLACE(`Spotify Streams`, ',', '')
WHERE `Spotify Streams` NOT REGEXP '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `Spotify Streams` BIGINT;


UPDATE spotify_final
SET `Spotify Playlist Count` = REPLACE(`Spotify Playlist Count`,',','')
WHERE `Spotify Playlist Count` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `Spotify Playlist Count` BIGINT;

UPDATE spotify_final
SET `Spotify Playlist Reach` = REPLACE(`Spotify Playlist Reach`,',','')
WHERE `Spotify Playlist Reach` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `Spotify Playlist Reach` BIGINT;

UPDATE spotify_final
SET `YouTube Views` = REPLACE(`YouTube Views`,',','')
WHERE `YouTube Views` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `YouTube Views` BIGINT;

UPDATE spotify_final
SET `YouTube Likes` = REPLACE(`YouTube Likes`,',','')
WHERE `YouTube Likes` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `YouTube Likes` BIGINT;

UPDATE spotify_final
SET `YouTube Likes` = REPLACE(`YouTube Likes`,',','')
WHERE `YouTube Likes` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `YouTube Likes` BIGINT;

UPDATE spotify_final
SET `TikTok Posts` = REPLACE(`TikTok Posts`,',','')
WHERE `TikTok Posts` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `TikTok Posts` BIGINT;

UPDATE spotify_final
SET `TikTok Likes` = REPLACE(`TikTok Likes`,',','')
WHERE `TikTok Likes` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `TikTok Likes` BIGINT;

UPDATE spotify_final
SET `TikTok Views` = REPLACE(`TikTok Views`,',','')
WHERE `TikTok Views` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `TikTok Views` BIGINT;

UPDATE spotify_final
SET `YouTube Playlist Reach` = REPLACE(`YouTube Playlist Reach`,',','')
WHERE `YouTube Playlist Reach` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `YouTube Playlist Reach` BIGINT;

UPDATE spotify_final
SET `Deezer Playlist Reach` = REPLACE(`Deezer Playlist Reach`,',','')
WHERE `Deezer Playlist Reach` not regexp '^[0-9]+$';
ALTER TABLE spotify_final MODIFY COLUMN `Deezer Playlist Reach` BIGINT;

ALTER TABLE spotify_final DROP COLUMN `AirPlay Spins`;
ALTER TABLE spotify_final DROP COLUMN `Amazon Playlist Count`;


select count(*) from spotify_final;

/*Calculate the total streams/views for each track across all platforms */
select sum(`Tiktok Views`+`Spotify Streams`+`YouTube Views`) as `total plays across all platform`,`Album Name`
from spotify_final
group by `Album Name`
 ORDER BY `total plays across all platform` DESC;
 
 
-- Find tracks that have high total streams/views but a low All-time rank (potential rising stars) 

SELECT   DISTINCT Artist,
    `ï»¿Track` AS Track, 
    `Album Name`, 
    (`TikTok Views` + `Spotify Streams` + `YouTube Views`) AS `total plays across all platform`,
    `All Time Rank`
FROM spotify_final
WHERE 
    (`TikTok Views` + `Spotify Streams` + `YouTube Views`) > (
        SELECT AVG(`TikTok Views` + `Spotify Streams` + `YouTube Views`) 
        FROM spotify_final
    ) 
    AND `All Time Rank` < (SELECT AVG(`All Time Rank`) FROM spotify_final)
ORDER BY `total plays across all platform` DESC
LIMIT 20;

SELECT 
    `ï»¿Track` AS Track,
    `Artist`,
    `Spotify Streams`,
    `YouTube Views`,
    `TikTok Views`,
    CASE
        WHEN `Spotify Streams` > 2 * GREATEST(`YouTube Views`, `TikTok Views`) THEN 'Spotify'
        WHEN `YouTube Views` > 2 * GREATEST(`Spotify Streams`, `TikTok Views`) THEN 'YouTube'
        WHEN `TikTok Views` > 2 * GREATEST(`Spotify Streams`, `YouTube Views`) THEN 'TikTok'
        ELSE 'No significant difference'
    END AS `Dominant Platform`
FROM spotify_final
WHERE 
    CASE
        WHEN `Spotify Streams` > 2 * GREATEST(`YouTube Views`, `TikTok Views`) THEN 1
        WHEN `YouTube Views` > 2 * GREATEST(`Spotify Streams`, `TikTok Views`) THEN 1
        WHEN `TikTok Views` > 2 * GREATEST(`Spotify Streams`, `YouTube Views`) THEN 1
        ELSE 0
    END = 1
ORDER BY 
    GREATEST(`Spotify Streams`, `YouTube Views`, `TikTok Views`) DESC
LIMIT 50;

SELECT 
    `ï»¿Track` AS Track,
    `Artist`,
    `Album Name`,
    `Spotify Streams`,
    `YouTube Views`,
    `TikTok Views`,
    (`Spotify Streams` + `YouTube Views` + `TikTok Views`) AS Total_Views,
    ROUND((`Spotify Streams` / (`Spotify Streams` + `YouTube Views` + `TikTok Views`) * 100), 2) AS Spotify_Percentage,
    ROUND((`YouTube Views` / (`Spotify Streams` + `YouTube Views` + `TikTok Views`) * 100), 2) AS YouTube_Percentage,
    ROUND((`TikTok Views` / (`Spotify Streams` + `YouTube Views` + `TikTok Views`) * 100), 2) AS TikTok_Percentage
FROM spotify_final
WHERE (`Spotify Streams` + `YouTube Views` + `TikTok Views`) > 0  -- Avoid division by zero
ORDER BY Total_Views DESC
LIMIT 20;


-- trending songs in each platform 

(SELECT 
    'Spotify' AS Platform,
    `ï»¿Track` AS Track,
    Artist,
    `Spotify Streams` AS Views,
    1 AS Order_Priority
FROM spotify_final
ORDER BY `Spotify Streams` DESC
LIMIT 10)

UNION ALL

(SELECT 
    'YouTube' AS Platform,
    `ï»¿Track` AS Track,
    Artist,
    `YouTube Views` AS Views,
    2 AS Order_Priority
FROM spotify_final
ORDER BY `YouTube Views` DESC
LIMIT 10)

UNION ALL

(SELECT 
    'TikTok' AS Platform,
    `ï»¿Track` AS Track,
    Artist,
    `TikTok Views` AS Views,
    3 AS Order_Priority
FROM spotify_final
ORDER BY `TikTok Views` DESC
LIMIT 10)

ORDER BY Order_Priority;

-- TRending songs in each platform using CTE 
WITH 
spotify_top AS (
    SELECT 
        'Spotify' AS Platform,
        `ï»¿Track` AS Track,
        Artist,
        `Spotify Streams` AS Views
    FROM spotify_final
    ORDER BY `Spotify Streams` DESC
    LIMIT 10
),
youtube_top AS (
    SELECT 
        'YouTube' AS Platform,
        `ï»¿Track` AS Track,
        Artist,
        `YouTube Views` AS Views
    FROM spotify_final
    ORDER BY `YouTube Views` DESC
    LIMIT 10
),
tiktok_top AS (
    SELECT 
        'TikTok' AS Platform,
        `ï»¿Track` AS Track,
        Artist,
        `TikTok Views` AS Views
    FROM spotify_final
    ORDER BY `TikTok Views` DESC
    LIMIT 10
),
combined_top AS (
    SELECT *, 1 AS Order_Priority FROM spotify_top
    UNION ALL
    SELECT *, 2 AS Order_Priority FROM youtube_top
    UNION ALL
    SELECT *, 3 AS Order_Priority FROM tiktok_top
)
SELECT 
    Platform,
    Track,
    Artist,
    Views
FROM combined_top
ORDER BY Order_Priority;

-- Tracks that are performing well in each platform 
WITH SPOTIFY_TOPS AS (
    SELECT `ï»¿Track` AS Track
    FROM spotify_final
    ORDER BY `Spotify Streams` DESC
    LIMIT 500
),
YOUTUBE_TOPS AS (
    SELECT `ï»¿Track` AS Track
    FROM spotify_final
    ORDER BY `YouTube Views` DESC
    LIMIT 500
),
TIKTOK_TOPS AS (
    SELECT `ï»¿Track` AS Track
    FROM spotify_final
    ORDER BY `TikTok Views` DESC
    LIMIT 500
),
COMBO AS (
    SELECT Track FROM SPOTIFY_TOPS
    UNION ALL
    SELECT Track FROM YOUTUBE_TOPS
    UNION ALL
    SELECT Track FROM TIKTOK_TOPS
)
SELECT 
    `ï»¿Track` AS Track,
    `Artist`,
    `Album Name`
FROM spotify_final
WHERE `ï»¿Track` IN (SELECT Track FROM COMBO)
GROUP BY `ï»¿Track`, `Artist`, `Album Name`;

-- PERFOMANCE DIFFERENCE
WITH performance_ranks AS (
    SELECT 
        `ï»¿Track` AS Track,
        Artist,
        `Spotify Streams`,
        `YouTube Views`,
        `TikTok Views`,
        PERCENT_RANK() OVER (ORDER BY `Spotify Streams`) AS spotify_rank,
        PERCENT_RANK() OVER (ORDER BY `YouTube Views`) AS youtube_rank,
        PERCENT_RANK() OVER (ORDER BY `TikTok Views`) AS tiktok_rank
    FROM spotify_final
),
performance_diff AS (
    SELECT 
        Track,
        Artist,
        `Spotify Streams`,
        `YouTube Views`,
        `TikTok Views`,
        spotify_rank,
        youtube_rank,
        tiktok_rank,
        GREATEST(
            ABS(spotify_rank - youtube_rank),
            ABS(spotify_rank - tiktok_rank),
            ABS(youtube_rank - tiktok_rank)
        ) AS max_rank_difference
    FROM performance_ranks
)
SELECT 
    Track,
    Artist,
    `Spotify Streams`,
    `YouTube Views`,
    `TikTok Views`,
    ROUND(spotify_rank * 100, 2) AS spotify_percentile,
    ROUND(youtube_rank * 100, 2) AS youtube_percentile,
    ROUND(tiktok_rank * 100, 2) AS tiktok_percentile,
    ROUND(max_rank_difference * 100, 2) AS max_percentile_difference,
    CASE 
        WHEN spotify_rank > youtube_rank AND spotify_rank > tiktok_rank THEN 'Spotify'
        WHEN youtube_rank > spotify_rank AND youtube_rank > tiktok_rank THEN 'YouTube'
        WHEN tiktok_rank > spotify_rank AND tiktok_rank > youtube_rank THEN 'TikTok'
        ELSE 'Balanced'
    END AS best_performing_platform
FROM performance_diff
WHERE max_rank_difference > 0.5  -- Adjust this threshold as needed
ORDER BY max_rank_difference DESC
LIMIT 50;

-- Compare the performance of explicit vs. non-explicit tracks across different platforms.
WITH platform_averages AS (
    SELECT 
        CASE WHEN `Explicit Track` = 1 THEN 'Explicit' ELSE 'Non-Explicit' END AS Content_Type,
        AVG(`Spotify Streams`) AS Avg_Spotify_Streams,
        AVG(`YouTube Views`) AS Avg_YouTube_Views,
        AVG(`TikTok Views`) AS Avg_TikTok_Views,
        COUNT(*) AS Track_Count
    FROM spotify_final
    GROUP BY `Explicit Track`
)
SELECT 
    Content_Type,
    ROUND(Avg_Spotify_Streams, 0) AS Avg_Spotify_Streams,
    ROUND(Avg_YouTube_Views, 0) AS Avg_YouTube_Views,
    ROUND(Avg_TikTok_Views, 0) AS Avg_TikTok_Views,
    Track_Count
FROM platform_averages
ORDER BY Content_Type;
    
    
-- Analyze the correlation between a track's performance on different platforms:
-- This query calculates the Pearson correlation coefficient between the performance metrics of different platforms. 
-- The result will be between -1 and 1, where 1 indicates a strong positive correlation, -1 indicates a strong negative correlation, and 0 indicates no correlation.
WITH performance_data AS (
    SELECT 
        LOG(`Spotify Streams` + 1) AS log_spotify,
        LOG(`YouTube Views` + 1) AS log_youtube,
        LOG(`TikTok Views` + 1) AS log_tiktok
    FROM spotify_final
    WHERE `Spotify Streams` > 0 AND `YouTube Views` > 0 AND `TikTok Views` > 0
)
SELECT 
    ROUND(
        (COUNT(*) * SUM(log_spotify * log_youtube) - SUM(log_spotify) * SUM(log_youtube)) /
        SQRT((COUNT(*) * SUM(log_spotify * log_spotify) - SUM(log_spotify) * SUM(log_spotify)) *
             (COUNT(*) * SUM(log_youtube * log_youtube) - SUM(log_youtube) * SUM(log_youtube)))
    , 4) AS Correlation_Spotify_YouTube,
    ROUND(
        (COUNT(*) * SUM(log_spotify * log_tiktok) - SUM(log_spotify) * SUM(log_tiktok)) /
        SQRT((COUNT(*) * SUM(log_spotify * log_spotify) - SUM(log_spotify) * SUM(log_spotify)) *
             (COUNT(*) * SUM(log_tiktok * log_tiktok) - SUM(log_tiktok) * SUM(log_tiktok)))
    , 4) AS Correlation_Spotify_TikTok,
    ROUND(
        (COUNT(*) * SUM(log_youtube * log_tiktok) - SUM(log_youtube) * SUM(log_tiktok)) /
        SQRT((COUNT(*) * SUM(log_youtube * log_youtube) - SUM(log_youtube) * SUM(log_youtube)) *
             (COUNT(*) * SUM(log_tiktok * log_tiktok) - SUM(log_tiktok) * SUM(log_tiktok)))
    , 4) AS Correlation_YouTube_TikTok
FROM performance_data;

-- Compare engagement metrics across platforms:
-- This query calculates engagement rates (likes per view) for YouTube and TikTok, compares them, and identifies which platform has higher engagement for each track.
WITH engagement_metrics AS (
    SELECT 
        `ï»¿Track` AS Track,
        Artist,
        `YouTube Views`,
        `YouTube Likes`,
        `TikTok Views`,
        `TikTok Likes`,
        (`YouTube Likes` / NULLIF(`YouTube Views`, 0)) * 100 AS YouTube_Engagement_Rate,
        (`TikTok Likes` / NULLIF(`TikTok Views`, 0)) * 100 AS TikTok_Engagement_Rate
    FROM spotify_final
    WHERE `YouTube Views` > 0 OR `TikTok Views` > 0
)
SELECT 
    Track,
    Artist,
    `YouTube Views`,
    `YouTube Likes`,
    ROUND(YouTube_Engagement_Rate, 2) AS YouTube_Engagement_Rate,
    `TikTok Views`,
    `TikTok Likes`,
    ROUND(TikTok_Engagement_Rate, 2) AS TikTok_Engagement_Rate,
    CASE 
        WHEN YouTube_Engagement_Rate > TikTok_Engagement_Rate THEN 'YouTube'
        WHEN TikTok_Engagement_Rate > YouTube_Engagement_Rate THEN 'TikTok'
        ELSE 'Equal'
    END AS Higher_Engagement_Platform
FROM engagement_metrics
WHERE YouTube_Engagement_Rate IS NOT NULL AND TikTok_Engagement_Rate IS NOT NULL
ORDER BY GREATEST(YouTube_Engagement_Rate, TikTok_Engagement_Rate) DESC
LIMIT 20;

SELECT * FROM spotify_final;
    
    
    