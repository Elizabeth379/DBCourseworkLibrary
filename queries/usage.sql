-- Вывести список книг с жанром и категорией

SELECT 
    Book.title AS "Название книги",
    Genre.name AS "Жанр",
    Category.name AS "Категория"
FROM 
    Book
JOIN Genre ON Book.fk_genre_id = Genre.id
JOIN Category ON Book.fk_category_id = Category.id;


--Посчитать общее количество разных (не кол-ва доступных экземпляров) книг в каждой библиотеке

SELECT 
    Library.name AS "Библиотека",
    COUNT(Position.id) AS "Количество книг"
FROM 
    Library
JOIN Position ON Library.id = Position.fk_library_id
GROUP BY 
    Library.name;
	
--Вывести информацию о читателях, их книгах и библиотекарях

SELECT 
    Reader.first_name AS "Имя читателя",
    Reader.last_name AS "Фамилия читателя",
    Book.title AS "Книга",
    Librarian.first_name AS "Имя библиотекаря",
    Librarian.last_name AS "Фамилия библиотекаря"
FROM 
    Borrow
JOIN Reader ON Borrow.fk_reader_id = Reader.id
JOIN Exemplar ON Borrow.fk_exemplar_id = Exemplar.id
JOIN Book ON Exemplar.fk_book_id = Book.id
JOIN Librarian ON Borrow.fk_librarian_id = Librarian.id;

--Вывести книги, опубликованные после 2000 года, с указанием издателя и языка

SELECT 
    Book.title AS "Название книги",
    Publisher.name AS "Издатель",
    Language.name AS "Язык"
FROM 
    Book
JOIN Exemplar ON Book.id = Exemplar.fk_book_id
JOIN Publisher ON Exemplar.fk_publisher_id = Publisher.id
JOIN Book_Language ON Book.id = Book_Language.fk_book_id
JOIN Language ON Book_Language.fk_language_id = Language.id
WHERE 
    Book.year > 2000;

--Найти читателей с общим размером штрафов более 100 - CTE

WITH ReaderFines AS (
    SELECT 
        Reader.id AS reader_id,
        Reader.first_name,
        Reader.last_name,
        SUM(Fine.amount) AS total_fine
    FROM 
        Reader
    JOIN Borrow ON Reader.id = Borrow.fk_reader_id
    JOIN Fine ON Borrow.id = Fine.fk_borrow_id
    GROUP BY Reader.id
)
SELECT 
    first_name AS "Имя",
    last_name AS "Фамилия",
    total_fine AS "Общая сумма штрафов"
FROM 
    ReaderFines
WHERE 
    total_fine > 100;
	
	
SELECT * FROM review;

