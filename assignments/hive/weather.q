CREATE TABLE IF NOT EXISTS RATING (userID int, movieID int, ratings float, timestamps String)
COMMENT 'Movie Rating details'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/aditi/ml-latest-small/ratings.csv' OVERWRITE INTO TABLE RATING;

SELECT * FROM RATING LIMIT 10;

SELECT rating.ratings, COUNT(*) FROM RATING GROUP BY rating.ratings; 