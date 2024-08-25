
### **Cross-Platform-Music-Trends-Analyzing-Spotify-YouTube-and-TikTok-Data**

#### **Project Overview:**
This project aims to analyze the performance of music tracks across multiple streaming and social media platforms, including Spotify, YouTube, and TikTok. By aggregating and comparing data from these platforms, the project provides insights into the popularity of albums and tracks, helping to identify trends and patterns in music consumption across different digital mediums.

#### **Objectives:**
- **Analyze Platform-Specific Popularity:** Evaluate the performance of music tracks on individual platforms (Spotify, YouTube, and TikTok) to understand where specific albums or tracks perform best.
- **Cross-Platform Performance Analysis:** Aggregate and compare the total plays/views across all platforms to determine overall popularity and reach of albums.
- **Identify Trends:** Use the data to identify trends in music consumption, such as which platforms are most influential in driving popularity for certain genres or artists.

#### **Data Sources:**
The project utilizes a dataset (`spotify_final`) containing key metrics for music tracks, including:
- `Tiktok Views`: The number of views a track has received on TikTok.
- `Spotify Streams`: The number of streams a track has received on Spotify.
- `YouTube Views`: The number of views a track has received on YouTube.
- `Album Name`: The album to which the track belongs.

#### **Key SQL Queries:**

1. **Total Plays Across All Platforms:**
   - **Query:** 
     ```sql
     SELECT SUM(`Tiktok Views` + `Spotify Streams` + `YouTube Views`) AS `total plays across all platform`, `Album Name`
     FROM spotify_final
     GROUP BY `Album Name`
     ORDER BY `total plays across all platform` DESC;
     ```
   - **Description:** This query calculates the total number of plays across all platforms for each album, providing a comprehensive view of its popularity.

#### **Expected Outcomes:**
- **Album Popularity Rankings:** A ranked list of albums based on their total plays across all platforms.
- **Platform-Specific Insights:** Detailed analysis of which platforms contribute most to the success of specific albums or tracks.
- **Actionable Recommendations:** Insights that can inform marketing strategies for artists and record labels, such as focusing efforts on platforms where certain genres or albums perform best.

#### **Applications:**
- **Music Industry Analysis:** Record labels, artists, and marketers can use these insights to tailor their promotional strategies and focus on platforms where their music is most likely to succeed.
- **Trend Forecasting:** By analyzing current trends in music consumption, stakeholders can anticipate future shifts in platform popularity and audience behavior.

