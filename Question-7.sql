CREATE TABLE listings (
    host_id        INT,
    listing_id     INT PRIMARY KEY,
    minimum_nights INT,
    neighborhood   VARCHAR(20),
    price          DECIMAL(10,2),
    room_type      VARCHAR(20)
);

CREATE TABLE reviews (
    review_id   INT PRIMARY KEY,
    listing_id  INT,
    rating      INT,
    review_date DATE,
    FOREIGN KEY (listing_id) REFERENCES listings(listing_id)
);

-- =========================
-- Seed data: LISTINGS
-- =========================
-- Host 101 (3 listings) -> qualifies by count
INSERT INTO listings (host_id, listing_id, minimum_nights, neighborhood, price, room_type) VALUES
(101, 1001, 2, 'Downtown',   150.00, 'Entire home/apt'),
(101, 1002, 1, 'Uptown',     120.00, 'Private room'),
(101, 1003, 3, 'Midtown',    130.00, 'Private room');

-- Host 102 (2 listings) -> qualifies by count
INSERT INTO listings VALUES
(102, 2001, 2, 'Beachside',  200.00, 'Entire home/apt'),
(102, 2002, 2, 'Beachside',  180.00, 'Entire home/apt');

-- Host 103 (1 listing) -> should be excluded (has < 2 listings)
INSERT INTO listings VALUES
(103, 3001, 1, 'Old Town',   110.00, 'Private room');

-- Host 104 (2 listings) -> qualifies by count
INSERT INTO listings VALUES
(104, 4001, 2, 'Midtown',    140.00, 'Entire home/apt'),
(104, 4002, 1, 'Suburb',     100.00, 'Private room');

-- Host 105 (2 listings) -> qualifies by count (designed to be a top performer)
INSERT INTO listings VALUES
(105, 5001, 2, 'Downtown',   220.00, 'Entire home/apt'),
(105, 5002, 2, 'Downtown',   210.00, 'Entire home/apt');

-- Host 106 (2 listings) -> qualifies by count
INSERT INTO listings VALUES
(106, 6001, 1, 'Suburb',      90.00, 'Private room'),
(106, 6002, 2, 'Suburb',     105.00, 'Private room');

-- =========================
-- Seed data: REVIEWS (integer ratings)
-- =========================
-- Host 101 (listings 1001, 1002, 1003)
INSERT INTO reviews (review_id, listing_id, rating, review_date) VALUES
(1, 1001, 5, '2024-05-01'),
(2, 1001, 5, '2024-05-10'),
(3, 1001, 4, '2024-05-20'),
(4, 1002, 5, '2024-06-02'),
(5, 1002, 5, '2024-06-18'),
(6, 1003, 4, '2024-07-05'),
(7, 1003, 4, '2024-07-22');

-- Host 102 (listings 2001, 2002)
INSERT INTO reviews VALUES
(8,  2001, 5, '2024-05-03'),
(9,  2001, 4, '2024-05-15'),
(10, 2002, 5, '2024-06-01'),
(11, 2002, 5, '2024-06-12'),
(12, 2002, 5, '2024-06-25');

-- Host 103 (listing 3001) - single-listing host (excluded by rule)
INSERT INTO reviews VALUES
(13, 3001, 5, '2024-05-08'),
(14, 3001, 5, '2024-05-21'),
(15, 3001, 4, '2024-06-03');

-- Host 104 (listings 4001, 4002)
INSERT INTO reviews VALUES
(16, 4001, 3, '2024-05-04'),
(17, 4001, 4, '2024-05-28'),
(18, 4002, 4, '2024-06-06'),
(19, 4002, 4, '2024-06-20');

-- Host 105 (listings 5001, 5002) - strong ratings (aiming for Top 2)
INSERT INTO reviews VALUES
(20, 5001, 5, '2024-05-02'),
(21, 5001, 5, '2024-05-11'),
(22, 5001, 5, '2024-05-19'),
(23, 5001, 5, '2024-05-27'),
(24, 5002, 5, '2024-06-05'),
(25, 5002, 5, '2024-06-14'),
(26, 5002, 4, '2024-06-22'),
(27, 5002, 5, '2024-06-29');

-- Host 106 (listings 6001, 6002)
INSERT INTO reviews VALUES
(28, 6001, 5, '2024-05-06'),
(29, 6001, 4, '2024-05-18'),
(30, 6001, 3, '2024-05-26'),
(31, 6002, 4, '2024-06-07'),
(32, 6002, 3, '2024-06-21');
 
/*
Suppose you are a data analyst working for a travel company that offers vacation rentals
 similar to Airbnb. Your company wants to identify the top hosts with the highest average ratings
 for their listings. This information will be used to recognize exceptional hosts 
 and potentially offer them incentives to continue providing outstanding service.

Your task is to write an SQL query to find the top 2 hosts 
with the highest average ratings for their listings.
 However, you should only consider hosts who have at least 2 listings, 
 as hosts with fewer listings may not be representative.

Display output in descending order of average ratings and round the average ratings to 2 decimal places.
*/

SELECT host_id,COUNT(DISTINCT l.listing_id) as listingcount,ROUND(AVG(rating),2)
FROM listings l
Join reviews r
ON l.listing_id = r.listing_id
GROUP BY host_id
HAVING listingcount>=2
ORDER BY AVG(rating) DESC
LIMIT 2;
