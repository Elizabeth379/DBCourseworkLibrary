-- Book
CREATE INDEX idx_book_title_btree ON Book(title);
CREATE INDEX idx_book_fk_genre_id_hash ON Book USING HASH(fk_genre_id);
CREATE INDEX idx_book_fk_category_id_hash ON Book USING HASH(fk_category_id);
CREATE INDEX idx_book_fk_subject_id_hash ON Book USING HASH(fk_subject_id);
CREATE INDEX idx_book_year_btree ON Book(year);

-- Author
CREATE INDEX idx_author_last_name_btree ON Author(last_name);
CREATE INDEX idx_author_first_name_btree ON Author(first_name);
CREATE INDEX idx_author_country_btree ON Author(country);
CREATE INDEX idx_author_birthdate_btree ON Author(birthdate);

-- Reader
CREATE INDEX idx_reader_last_name_btree ON Reader(last_name);
CREATE INDEX idx_reader_first_name_btree ON Reader(first_name);
CREATE INDEX idx_reader_nickname_btree ON Reader(nickname);
CREATE INDEX idx_reader_email_btree ON Reader(email);
CREATE INDEX idx_reader_phone_btree ON Reader(phone);

-- Borrow
CREATE INDEX idx_borrow_fk_exemplar_id_hash ON Borrow USING HASH(fk_exemplar_id);
CREATE INDEX idx_borrow_fk_reader_id_hash ON Borrow USING HASH(fk_reader_id);
CREATE INDEX idx_borrow_fk_librarian_id_hash ON Borrow USING HASH(fk_librarian_id);
CREATE INDEX idx_borrow_get_date_btree ON Borrow(get_date);
CREATE INDEX idx_borrow_give_back_date_btree ON Borrow(give_back_date);

-- Library
CREATE INDEX idx_library_name_btree ON Library(name);
CREATE INDEX idx_library_address_btree ON Library(address);
CREATE INDEX idx_library_open_hours_btree ON Library(open_hours);

-- Exemplar
CREATE UNIQUE INDEX idx_exemplar_isbn ON Exemplar(isbn);
CREATE INDEX idx_exemplar_fk_book_id_hash ON Exemplar USING HASH(fk_book_id);
CREATE INDEX idx_exemplar_fk_publisher_id_hash ON Exemplar USING HASH(fk_publisher_id);
CREATE INDEX idx_exemplar_fk_availability_id_hash ON Exemplar USING HASH(fk_availability_id);
CREATE INDEX idx_exemplar_year_btree ON Exemplar(year);

-- Rating
CREATE INDEX idx_rating_fk_book_id_hash ON Rating USING HASH(fk_book_id);
CREATE INDEX idx_rating_score_btree ON Rating(score);

-- Review
CREATE INDEX idx_review_date_btree ON Review(date);
CREATE INDEX idx_review_text_gin ON Review USING GIN(to_tsvector('english', text));
