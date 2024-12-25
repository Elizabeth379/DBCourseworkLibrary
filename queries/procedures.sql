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

