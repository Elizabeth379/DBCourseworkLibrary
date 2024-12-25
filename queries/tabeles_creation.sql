DROP TABLE IF EXISTS Review CASCADE;
DROP TABLE IF EXISTS Rating CASCADE;
DROP TABLE IF EXISTS Subscription CASCADE;
DROP TABLE IF EXISTS Type CASCADE;
DROP TABLE IF EXISTS Library_card CASCADE;
DROP TABLE IF EXISTS Privilege CASCADE;
DROP TABLE IF EXISTS Reader CASCADE;
DROP TABLE IF EXISTS Identification_card CASCADE;
DROP TABLE IF EXISTS Librarian CASCADE;
DROP TABLE IF EXISTS Fine CASCADE;
DROP TABLE IF EXISTS Borrow CASCADE;
DROP TABLE IF EXISTS Reading_room CASCADE;
DROP TABLE IF EXISTS Library CASCADE;
DROP TABLE IF EXISTS Position CASCADE;
DROP TABLE IF EXISTS Exemplar CASCADE;
DROP TABLE IF EXISTS Availability CASCADE;
DROP TABLE IF EXISTS Book_Tag CASCADE;
DROP TABLE IF EXISTS Tag CASCADE;
DROP TABLE IF EXISTS Book_Language CASCADE;
DROP TABLE IF EXISTS Language CASCADE;
DROP TABLE IF EXISTS Format CASCADE;
DROP TABLE IF EXISTS Form CASCADE;
DROP TABLE IF EXISTS Author_Book CASCADE;
DROP TABLE IF EXISTS Book CASCADE;
DROP TABLE IF EXISTS Publisher CASCADE;
DROP TABLE IF EXISTS Subject CASCADE;
DROP TABLE IF EXISTS Genre CASCADE;
DROP TABLE IF EXISTS Category CASCADE;
DROP TABLE IF EXISTS Author CASCADE;


-- Table: Genre
CREATE TABLE Genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: Category
CREATE TABLE Category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: Subject
CREATE TABLE Subject (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: Publisher
CREATE TABLE Publisher (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255),
    country VARCHAR(255),
    email VARCHAR(255)
);

-- Table: Author
CREATE TABLE Author (
    id SERIAL PRIMARY KEY,
    last_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    birthdate DATE,
    country VARCHAR(255)
);

-- Table: Book
CREATE TABLE Book (
    id SERIAL PRIMARY KEY,
    fk_subject_id INT NOT NULL REFERENCES Subject(id),
    fk_genre_id INT NOT NULL REFERENCES Genre(id),
    fk_category_id INT NOT NULL REFERENCES Category(id),
    title VARCHAR(255) NOT NULL,
    page_count INT,
    year INT
);

-- Table: Author_Book
CREATE TABLE Author_Book (
    id SERIAL PRIMARY KEY,
    fk_book_id INT NOT NULL REFERENCES Book(id),
    fk_author_id INT NOT NULL REFERENCES Author(id)
);

-- Table: Form
CREATE TABLE Form (
    id SERIAL PRIMARY KEY,
	fk_book_id INT NOT NULL REFERENCES Book(id),
    name VARCHAR(255) NOT NULL
);

-- Table: Format
CREATE TABLE Format (
    id SERIAL PRIMARY KEY,
	fk_form_id INT NOT NULL REFERENCES Form(id),
    name VARCHAR(255) NOT NULL
);

-- Table: Language
CREATE TABLE Language (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(255)
);

-- Table: Book_Language
CREATE TABLE Book_Language (
    id SERIAL PRIMARY KEY,
    fk_book_id INT NOT NULL REFERENCES Book(id),
    fk_language_id INT NOT NULL REFERENCES Language(id)
);

-- Table: Tag
CREATE TABLE Tag (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

-- Table: Book_Tag
CREATE TABLE Book_Tag (
    id SERIAL PRIMARY KEY,
    fk_book_id INT NOT NULL REFERENCES Book(id),
    fk_tag_id INT NOT NULL REFERENCES Tag(id)
);

-- Table: Availability
CREATE TABLE Availability (
    id SERIAL PRIMARY KEY,
    quantity INT NOT NULL
);

-- Table: Exemplar
CREATE TABLE Exemplar (
    id SERIAL PRIMARY KEY,
    fk_book_id INT NOT NULL REFERENCES Book(id),
    fk_availability_id INT NOT NULL REFERENCES Availability(id),
	fk_publisher_id INT NOT NULL REFERENCES Publisher(id),
    isbn INT UNIQUE NOT NULL,
    year INT
);

-- Table: Library
CREATE TABLE Library (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    open_hours VARCHAR(255),
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(255)
);

-- Table: Position
CREATE TABLE Position (
    id SERIAL PRIMARY KEY,
    fk_library_id INT NOT NULL REFERENCES Library(id),
	fk_availability_id INT NOT NULL REFERENCES Availability(id),
    section INT,
    rack INT,
    shelf INT
);

-- Table: Reading_room
CREATE TABLE Reading_room (
    id SERIAL PRIMARY KEY,
    fk_library_id INT NOT NULL REFERENCES Library(id),
    name VARCHAR(255) NOT NULL,
    open_hours VARCHAR(255),
    seats_amount INT,
    phone VARCHAR(255)
);

-- Table: Identification_card
CREATE TABLE Identification_card (
    id SERIAL PRIMARY KEY,
    personal_number INT UNIQUE NOT NULL,
    job_title VARCHAR(255),
    expire_date DATE
);

-- Table: Librarian
CREATE TABLE Librarian (
    id SERIAL PRIMARY KEY,
    fk_identity_card_id INT NOT NULL REFERENCES Identification_card(id),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

-- Table: Reader
CREATE TABLE Reader (
    id SERIAL PRIMARY KEY,
    nickname VARCHAR(255),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(255)
);

-- Table: Privilege
CREATE TABLE Privilege (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Table: Library_card
CREATE TABLE Library_card (
    id SERIAL PRIMARY KEY,
    fk_reader_id INT NOT NULL REFERENCES Reader(id),
    fk_privilege_id INT NOT NULL REFERENCES Privilege(id),
	card_number INT UNIQUE NOT NULL,
    receipt_date DATE NOT NULL
);

-- Table: Type
CREATE TABLE Type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Table: Subscription
CREATE TABLE Subscription (
    id SERIAL PRIMARY KEY,
    fk_library_card_id INT NOT NULL REFERENCES Library_card(id),
	fk_type_id INT NOT NULL REFERENCES Type(id),
	name VARCHAR(255) NOT NULL,
    price INT,
    expire_date DATE
);

-- Table: Borrow
CREATE TABLE Borrow (
    id SERIAL PRIMARY KEY,
    fk_exemplar_id INT NOT NULL REFERENCES Exemplar(id),
    fk_reader_id INT NOT NULL REFERENCES Reader(id),
    fk_librarian_id INT NOT NULL REFERENCES Librarian(id),
    get_date DATE NOT NULL,
    give_back_date DATE NOT NULL
);

-- Table: Fine
CREATE TABLE Fine (
    id SERIAL PRIMARY KEY,
    fk_borrow_id INT NOT NULL REFERENCES Borrow(id),
    amount INT NOT NULL,
    reason VARCHAR(255)
);

-- Table: Rating
CREATE TABLE Rating (
    id SERIAL PRIMARY KEY,
    fk_book_id INT NOT NULL REFERENCES Book(id),
    score INT NOT NULL
);

-- Table: Review
CREATE TABLE Review (
    id SERIAL PRIMARY KEY,
    fk_reader_id INT NOT NULL REFERENCES Reader(id),
    fk_rating_id INT NOT NULL REFERENCES Rating(id),
    date DATE NOT NULL,
    text TEXT
);

