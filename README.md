# YouTube API Trending Analysis

## About

This project contains the analysis of YouTube Trending Videos data. Analysis has been done to understand how different categories of videos, regions and the time of the day affects the likes, dislikes, comment count of different videos. 

## Methodology

- [Data_Extraction.ipynb](Data_Extraction.ipynb) - In this, I have extracted data from multiple file formats and have combined them into one csv file using `python`  
- [Data_Insertion.ipynb](Data_Insertion.ipynb) - After the collection of data, it was transfered to `SQL Server [RDBMS]` with the help of `Azure Data Studio`. 
- [Clean.sql](./SQL/Clean.sql) - The data was cleaned using date-time manipulation and string transformation. 
- [Analysis.sql](./SQL/Analysis.sql) - After cleaning of the data, data analysis was performed to solve the different problem statement. 
- The analysis has been visualized using `Tableau` - a business intelligence tool. 

## Tools and Languages Used
- Python
- SQL and SQL Server [RDBMS]
- Azure Data Studio
- Tableau

## Links
- [Kaggle Dataset](https://www.kaggle.com/datasets/datasnaek/youtube-new)
- [Tableau Dashboard](https://public.tableau.com/app/profile/v.kartik/viz/YouTubeAPITrendingAnalysis/YouTubeAPITrendingAnalysis)
