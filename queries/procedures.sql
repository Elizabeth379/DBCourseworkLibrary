-- Procedure: Add new book
CREATE OR REPLACE PROCEDURE add_new_book(
    p_title VARCHAR,
    p_fk_subject_id INT,
    p_fk_genre_id INT,
    p_fk_category_id INT,
    p_page_count INT,
    p_year INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Book (title, fk_subject_id, fk_genre_id, fk_category_id, page_count, year)
    VALUES (p_title, p_fk_subject_id, p_fk_genre_id, p_fk_category_id, p_page_count, p_year);
END;
$$;

-- Procedure: Add new reader
CREATE OR REPLACE PROCEDURE add_new_reader(
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_nickname VARCHAR DEFAULT NULL,
    p_email VARCHAR DEFAULT NULL,
    p_phone VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Reader (first_name, last_name, nickname, email, phone)
    VALUES (p_first_name, p_last_name, p_nickname, p_email, p_phone);
END;
$$;

-- Procedure: Add new exemplar
CREATE OR REPLACE PROCEDURE add_new_exemplar(
    p_fk_book_id INT,
    p_fk_publisher_id INT,
    p_fk_availability_id INT,
    p_isbn INT,
    p_year INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Exemplar (fk_book_id, fk_publisher_id, fk_availability_id, isbn, year)
    VALUES (p_fk_book_id, p_fk_publisher_id, p_fk_availability_id, p_isbn, p_year);
END;
$$;

-- Procedure: Borrow a book
CREATE OR REPLACE PROCEDURE borrow_book(
    p_fk_exemplar_id INT,
    p_fk_reader_id INT,
    p_fk_librarian_id INT,
    p_get_date DATE,
    p_give_back_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Borrow (fk_exemplar_id, fk_reader_id, fk_librarian_id, get_date, give_back_date)
    VALUES (p_fk_exemplar_id, p_fk_reader_id, p_fk_librarian_id, p_get_date, p_give_back_date);
END;
$$;

-- Procedure: Return a book
CREATE OR REPLACE PROCEDURE return_book(
    p_borrow_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Borrow WHERE id = p_borrow_id;
END;
$$;

-- Procedure: Add a fine
CREATE OR REPLACE PROCEDURE add_fine(
    p_fk_borrow_id INT,
    p_amount INT,
    p_reason VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fine (fk_borrow_id, amount, reason)
    VALUES (p_fk_borrow_id, p_amount, p_reason);
END;
$$;

-- Procedure: Add a library card
CREATE OR REPLACE PROCEDURE add_library_card(
    p_fk_reader_id INT,
    p_fk_privilege_id INT,
    p_card_number INT,
    p_receipt_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Library_card (fk_reader_id, fk_privilege_id, card_number, receipt_date)
    VALUES (p_fk_reader_id, p_fk_privilege_id, p_card_number, p_receipt_date);
END;
$$;

-- Procedure: Update book availability
CREATE OR REPLACE PROCEDURE update_availability(
    p_fk_availability_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Availability
    SET quantity = p_quantity
    WHERE id = p_fk_availability_id;
END;
$$;

-- Procedure: Add a rating
CREATE OR REPLACE PROCEDURE add_rating(
    p_fk_book_id INT,
    p_score INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Rating (fk_book_id, score)
    VALUES (p_fk_book_id, p_score);
END;
$$;

-- Procedure: Add a review
CREATE OR REPLACE PROCEDURE add_review(
    p_fk_reader_id INT,
    p_fk_rating_id INT,
    p_date DATE,
    p_text TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Review (fk_reader_id, fk_rating_id, date, text)
    VALUES (p_fk_reader_id, p_fk_rating_id, p_date, p_text);
END;
$$;

-- Procedure: Subscribe a reader
CREATE OR REPLACE PROCEDURE subscribe_reader(
    p_fk_library_card_id INT,
    p_fk_type_id INT,
    p_name VARCHAR,
    p_price INT,
    p_expire_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Subscription (fk_library_card_id, fk_type_id, name, price, expire_date)
    VALUES (p_fk_library_card_id, p_fk_type_id, p_name, p_price, p_expire_date);
END;
$$;

-- ==========================================================================================



--  ====================  Жанр  ====================

-- Получение жанра по id
CREATE OR REPLACE FUNCTION get_genre_by_id(p_id INT)
RETURNS TABLE(id INT, name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, name FROM Genre WHERE id = p_id;
END;
$$;

-- Удаление жанра
CREATE OR REPLACE PROCEDURE delete_genre(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Genre WHERE id = p_id;
END;
$$;

-- ====================  Категория  ====================

-- Получение категории по id
CREATE OR REPLACE FUNCTION get_category_by_id(p_id INT)
RETURNS TABLE(id INT, name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, name FROM Category WHERE id = p_id;
END;
$$;


-- Удаление категории
CREATE OR REPLACE PROCEDURE delete_category(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Category WHERE id = p_id;
END;
$$;

--  ====================  Предмет  ====================

-- Получение предмета по id
CREATE OR REPLACE FUNCTION get_subject_by_id(p_id INT)
RETURNS TABLE(id INT, name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, name FROM Subject WHERE id = p_id;
END;
$$;

-- Удаление предмета
CREATE OR REPLACE PROCEDURE delete_subject(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Subject WHERE id = p_id;
END;
$$;

--  ====================  Издатель  ====================


-- Получение издателя по id
CREATE OR REPLACE FUNCTION get_publisher_by_id(p_id INT)
RETURNS TABLE(id INT, name VARCHAR, city VARCHAR, country VARCHAR, email VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, name, city, country, email FROM Publisher WHERE id = p_id;
END;
$$;

-- Удаление издателя
CREATE OR REPLACE PROCEDURE delete_publisher(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Publisher WHERE id = p_id;
END;
$$;

-- ====================  Автор  ====================

-- Получение автора по id
CREATE OR REPLACE FUNCTION get_author_by_id(p_id INT)
RETURNS TABLE(id INT, last_name VARCHAR, first_name VARCHAR, birthdate DATE, country VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, last_name, first_name, birthdate, country FROM Author WHERE id = p_id;
END;
$$;

-- Обновление автора
CREATE OR REPLACE PROCEDURE update_author(p_id INT, p_last_name VARCHAR, p_first_name VARCHAR, p_birthdate DATE, p_country VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE Author SET last_name = p_last_name, first_name = p_first_name, birthdate = p_birthdate, country = p_country WHERE id = p_id;
END;
$$;

-- Удаление автора
CREATE OR REPLACE PROCEDURE delete_author(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Author WHERE id = p_id;
END;
$$;

--  ====================  Книга  ====================
-- Получение книги по id
CREATE OR REPLACE FUNCTION get_book_by_id(p_id INT)
RETURNS TABLE(id INT, fk_subject_id INT, fk_genre_id INT, fk_category_id INT, title VARCHAR, page_count INT, year INT)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, fk_subject_id, fk_genre_id, fk_category_id, title, page_count, year FROM Book WHERE id = p_id;
END;
$$;

-- Обновление книги
CREATE OR REPLACE PROCEDURE update_book(p_id INT, p_fk_subject_id INT, p_fk_genre_id INT, p_fk_category_id INT, p_title VARCHAR, p_page_count INT, p_year INT)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE Book SET fk_subject_id = p_fk_subject_id, fk_genre_id = p_fk_genre_id, fk_category_id = p_fk_category_id, title = p_title, page_count = p_page_count, year = p_year WHERE id = p_id;
END;
$$;

-- Удаление книги
CREATE OR REPLACE PROCEDURE delete_book(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Book WHERE id = p_id;
END;
$$;

-- Получение авторов книги
CREATE OR REPLACE FUNCTION get_authors_of_book(p_book_id INT)
RETURNS TABLE(author_id INT, last_name VARCHAR, first_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT a.id, a.last_name, a.first_name
    FROM Author a
    JOIN Author_Book ab ON a.id = ab.fk_author_id
    WHERE ab.fk_book_id = p_book_id;
END;
$$;

-- Получение книг автора
CREATE OR REPLACE FUNCTION get_books_of_author(p_author_id INT)
RETURNS TABLE(book_id INT, book_title VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.title
    FROM Book b
    JOIN Author_Book ab ON b.id = ab.fk_book_id
    WHERE ab.fk_author_id = p_author_id;
END;
$$;

-- Получение языков книги
CREATE OR REPLACE FUNCTION get_languages_of_book(p_book_id INT)
RETURNS TABLE(language_id INT, language_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT l.id, l.name
    FROM Language l
    JOIN Book_Language bl ON l.id = bl.fk_language_id
    WHERE bl.fk_book_id = p_book_id;
END;
$$;

-- Получение книг по языку
CREATE OR REPLACE FUNCTION get_books_of_language(p_language_id INT)
RETURNS TABLE(book_id INT, book_title VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.title
    FROM Book b
    JOIN Book_Language bl ON b.id = bl.fk_book_id
    WHERE bl.fk_language_id = p_language_id;
END;
$$;

-- Получение тегов книги
CREATE OR REPLACE FUNCTION get_tags_of_book(p_book_id INT)
RETURNS TABLE(tag_id INT, tag_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.name
    FROM Tag t
    JOIN Book_Tag bt ON t.id = bt.fk_tag_id
    WHERE bt.fk_book_id = p_book_id;
END;
$$;

-- Получение книг по тегу
CREATE OR REPLACE FUNCTION get_books_of_tag(p_tag_id INT)
RETURNS TABLE(book_id INT, book_title VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.title
    FROM Book b
    JOIN Book_Tag bt ON b.id = bt.fk_book_id
    WHERE bt.fk_tag_id = p_tag_id;
END;
$$;

--  ====================  Читатель  ====================

-- Получение читателя по id
CREATE OR REPLACE FUNCTION get_reader_by_id(p_id INT)
RETURNS TABLE(id INT, nickname VARCHAR, first_name VARCHAR, last_name VARCHAR, email VARCHAR, phone VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT id, nickname, first_name, last_name, email, phone FROM Reader WHERE id = p_id;
END;
$$;

-- Обновление читателя
CREATE OR REPLACE PROCEDURE update_reader(p_id INT, p_nickname VARCHAR, p_first_name VARCHAR, p_last_name VARCHAR, p_email VARCHAR, p_phone VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE Reader SET nickname = p_nickname, first_name = p_first_name, last_name = p_last_name, email = p_email, phone = p_phone WHERE id = p_id;
END;
$$;

-- Удаление читателя
CREATE OR REPLACE PROCEDURE delete_reader(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM Reader WHERE id = p_id;
END;
$$;
