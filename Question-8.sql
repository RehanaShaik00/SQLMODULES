CREATE TABLE Books (
    BookID    INT PRIMARY KEY,
    BookName  VARCHAR(30),
    Genre     VARCHAR(20)
);

CREATE TABLE Borrowers (
    BorrowerID   INT,
    BorrowerName VARCHAR(10),
    BookID       INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- ===== Seed data: Books =====
INSERT INTO Books (BookID, BookName, Genre) VALUES
(1,  'A Tale of Two Cities', 'Historical'),
(2,  'Brave New World',      'Dystopian'),
(3,  'Catch-22',             'Satire'),
(4,  'Dune',                 'ScienceFic'),
(5,  'Emma',                 'Classic'),
(6,  'Fahrenheit 451',       'Dystopian'),
(7,  'Gone Girl',            'Thriller'),
(8,  'Hamlet',               'Tragedy'),
(9,  'Invisible Man',        'Literary'),
(10, 'Jane Eyre',            'Classic'),
(11, 'Kafka on the Shore',   'Magical'),
(12, 'Les Misérables',       'Classic');

-- ===== Seed data: Borrowers (each row = one borrowed book) =====
-- Alice: 3 books
INSERT INTO Borrowers (BorrowerID, BorrowerName, BookID) VALUES
(101, 'Alice', 2),   -- Brave New World
(101, 'Alice', 4),   -- Dune
(101, 'Alice', 8);   -- Hamlet

-- Bob: 2 books
INSERT INTO Borrowers VALUES
(102, 'Bob', 1),     -- A Tale of Two Cities
(102, 'Bob', 6);     -- Fahrenheit 451

-- Carol: 1 book
INSERT INTO Borrowers VALUES
(103, 'Carol', 10);  -- Jane Eyre

-- David: 4 books
INSERT INTO Borrowers VALUES
(104, 'David', 3),   -- Catch-22
(104, 'David', 5),   -- Emma
(104, 'David', 7),   -- Gone Girl
(104, 'David', 9);   -- Invisible Man

-- Frank: 2 books
INSERT INTO Borrowers VALUES
(106, 'Frank', 12),  -- Les Misérables
(106, 'Frank', 1);   -- A Tale of Two Cities

/*Imagine you're working for a library and 
you're tasked with generating a report on the borrowing habits of patrons.
 You have two tables in your database: Books and Borrowers.
Write an SQL to display the name of each borrower along with a comma-separated list of the books
 they have borrowed in alphabetical order, display the output in ascending order of Borrower Name.
*/

SELECT BorrowerName,GROUP_CONCAT(DISTINCT BookName ORDER BY BookName ASC SEPARATOR ',') as booknames 
FROM borrowers 
JOIN books 
ON borrowers.BookID=books.BookID
GROUP BY BorrowerName
ORDER BY BorrowerName ASC;