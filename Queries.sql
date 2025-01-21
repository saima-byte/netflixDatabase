-- Netflix Data Analysis using SQL
-- Solutions of business problems
-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows
SELECT 
    rc.type,rc.rating AS most_frequent_rating
FROM (SELECT type,rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
) rc
JOIN (SELECT type,
        MAX(rating_count) AS max_rating_count
    FROM (SELECT type,rating,
            COUNT(*) AS rating_count
        FROM netflix
        GROUP BY type, rating
    ) subquery
    GROUP BY type
) max_rc ON rc.type = max_rc.type
WHERE rc.rating_count = max_rc.max_rating_count
ORDER BY rc.type;



-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix
DELIMITER $$
CREATE PROCEDURE GetTopCountries()
BEGIN
-- Simple query to count occurrences of each country from the comma-separated list in the 'country' column
    SELECT country,
        COUNT(*) AS total_content FROM (
        SELECT 
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS country
        FROM netflix
        JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL 
			SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL 
             SELECT 9 UNION ALL SELECT 10) n
        ON LENGTH(country) - LENGTH(REPLACE(country, ',', '')) >= n.n - 1
        WHERE country IS NOT NULL
    ) AS countries
    GROUP BY country
    ORDER BY total_content DESC
    LIMIT 5;
END$$
DELIMITER ;

CALL GetTopCountries();



-- 5. Identify the longest movie
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;





-- 6. List all TV shows with more than 5 seasons
SELECT * 
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING(duration, 1, LENGTH(duration) - 7) AS UNSIGNED) > 5;




-- 7 . Count the number of content items in each genre
SELECT genre, COUNT(*) AS total_content
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 1), ',', -1)) AS genre FROM netflix
    WHERE listed_in IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 2), ',', -1)) AS genre FROM netflix
    WHERE listed_in IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 3), ',', -1)) AS genre FROM netflix
    WHERE listed_in IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 4), ',', -1)) AS genre FROM netflix
    WHERE listed_in IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', 5), ',', -1)) AS genre FROM netflix
    WHERE listed_in IS NOT NULL
) AS genres
GROUP BY genre
ORDER BY total_content DESC;
-- 8 . Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT 
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id) / SUM(COUNT(show_id)) OVER () * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY avg_release DESC
LIMIT 5;





-- 9. List all movies that are documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';




-- 10. Find all content without a director
SELECT * 
FROM netflix
WHERE director IS NULL;





-- 11. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT actor, COUNT(*) AS movie_count
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(casts, ',', n.n), ',', -1)) AS actor
    FROM netflix
    JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
                 SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) n
    ON LENGTH(casts) - LENGTH(REPLACE(casts, ',', '')) >= n.n - 1
    WHERE country = 'India' AND casts IS NOT NULL
) AS actors
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

/*
Question 12:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
SELECT category,type,COUNT(*) AS content_count
FROM (SELECT *,CASE WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'ELSE 'Good'END AS category
    FROM netflix
) AS categorized_content
GROUP BY category, type
ORDER BY content_count DESC;

-- Triggers
-- Ensure the category column exists
ALTER TABLE netflix
ADD COLUMN category VARCHAR(10);

-- Trigger to update category when a new row is inserted
DELIMITER $$

CREATE TRIGGER update_category_before_insert
BEFORE INSERT ON netflix
FOR EACH ROW
BEGIN
    -- Check if description contains 'kill' or 'violence'
    IF NEW.description LIKE '%kill%' OR NEW.description LIKE '%violence%' THEN
        -- Set category to 'Bad' if keywords are found
        SET NEW.category = 'Bad';
    ELSE
        -- Otherwise, set category to 'Good'
        SET NEW.category = 'Good';
    END IF;
END $$

DELIMITER ;




-- End of reports