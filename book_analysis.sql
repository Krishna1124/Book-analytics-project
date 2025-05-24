/*---------------------------------------------------------------
  1. Total Books Published Per Publisher 
---------------------------------------------------------------*/
SELECT 
    publisher, 
    COUNT(*) AS total_books
FROM 
    Books
GROUP BY 
    publisher
ORDER BY 
    total_books DESC;


/*---------------------------------------------------------------
  2. Top 10 Authors by Average Ratings 
---------------------------------------------------------------*/
SELECT 
    authors, 
    ROUND(AVG(average_rating), 2) AS avg_rating
FROM 
    Books
GROUP BY 
    authors
HAVING 
    COUNT(*) > 5  -- Consider only authors with at least 5 books
ORDER BY 
    avg_rating DESC
LIMIT 10;


/*---------------------------------------------------------------
  3. Highest Rated Book for Each Author 
---------------------------------------------------------------*/
SELECT 
    authors, 
    title, 
    average_rating
FROM (
    SELECT 
        authors, 
        title, 
        average_rating,
        RANK() OVER (PARTITION BY authors ORDER BY average_rating DESC) AS rank_author
    FROM 
        Books
) ranked_books
WHERE 
    rank_author = 1;


/*---------------------------------------------------------------
  4. CTE: Most Popular Books Based on Ratings Count
---------------------------------------------------------------*/
WITH PopularBooks AS (
    SELECT 
        title, 
        authors, 
        ratings_count, 
        RANK() OVER (ORDER BY ratings_count DESC) AS rank_popularity
    FROM 
        Books
)
SELECT 
    title, 
    authors, 
    ratings_count
FROM 
    PopularBooks
WHERE 
    rank_popularity <= 10;


/*---------------------------------------------------------------
  5. Average Ratings Per Language 
---------------------------------------------------------------*/
SELECT 
    language_code, 
    ROUND(AVG(average_rating), 2) AS avg_rating
FROM 
    Books
GROUP BY 
    language_code
ORDER BY 
    avg_rating DESC;


/*---------------------------------------------------------------
  6. Subquery: Books Published Before the Year 2000 with High Ratings
---------------------------------------------------------------*/
SELECT 
    title, 
    authors, 
    publication_date, 
    average_rating
FROM 
    Books
WHERE 
    average_rating > (
        SELECT AVG(average_rating) 
        FROM Books 
        WHERE publication_date < '2000-01-01'
    )
ORDER BY 
    average_rating DESC;


/*---------------------------------------------------------------
  7. Join Query: Books vs. Reviews (Assumed Review Table)
---------------------------------------------------------------*/
SELECT 
    b.title, 
    b.authors, 
    b.publisher, 
    COUNT(r.review_id) AS total_reviews
FROM 
    Books b
LEFT JOIN 
    Reviews r ON b.bookID = r.bookID
GROUP BY 
    b.title, b.authors, b.publisher
ORDER BY 
    total_reviews DESC;

/*---------------------------------------------------------------
  9. Top 5 Publishers with the Highest Average Book Ratings
---------------------------------------------------------------*/
SELECT 
    publisher, 
    ROUND(AVG(average_rating), 2) AS avg_rating, 
    COUNT(*) AS total_books
FROM 
    Books
GROUP BY 
    publisher
HAVING 
    COUNT(*) > 10  -- Consider publishers with at least 10 books
ORDER BY 
    avg_rating DESC
LIMIT 5;


/*---------------------------------------------------------------
  10. Publication Trend Analysis: Number of Books Published Per Year
---------------------------------------------------------------*/
SELECT 
    SUBSTRING(publication_date, 1, 4) AS pub_year, 
    COUNT(*) AS books_published
FROM 
    Books
GROUP BY 
    pub_year
ORDER BY 
    pub_year;


/*---------------------------------------------------------------
  11. CTE: Most Popular Books by Text Reviews Count
---------------------------------------------------------------*/
WITH PopularBooks AS (
    SELECT 
        title, 
        authors, 
        text_reviews_count, 
        RANK() OVER (ORDER BY text_reviews_count DESC) AS rank_reviews
    FROM 
        Books
)
SELECT 
    title, 
    authors, 
    text_reviews_count
FROM 
    PopularBooks
WHERE 
    rank_reviews <= 10;

