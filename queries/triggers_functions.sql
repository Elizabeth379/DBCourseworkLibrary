-- Drop trigger: positive_quantity_check
DROP TRIGGER IF EXISTS positive_quantity_check ON Availability;
DROP FUNCTION IF EXISTS check_positive_quantity();

-- Drop trigger: borrow_dates_check
DROP TRIGGER IF EXISTS borrow_dates_check ON Borrow;
DROP FUNCTION IF EXISTS check_borrow_dates();

-- Drop trigger: unique_isbn_check
DROP TRIGGER IF EXISTS unique_isbn_check ON Exemplar;
DROP FUNCTION IF EXISTS check_unique_isbn();

-- Drop trigger: unique_privilege_name_check
DROP TRIGGER IF EXISTS unique_privilege_name_check ON Privilege;
DROP FUNCTION IF EXISTS check_unique_privilege_name();

-- Drop trigger: valid_rating_score_check
DROP TRIGGER IF EXISTS valid_rating_score_check ON Rating;
DROP FUNCTION IF EXISTS check_rating_score();

-- Drop trigger: positive_subscription_price_check
DROP TRIGGER IF EXISTS positive_subscription_price_check ON Subscription;
DROP FUNCTION IF EXISTS check_subscription_price();

-- Drop trigger: trg_update_availability_on_borrow
DROP TRIGGER IF EXISTS trg_update_availability_on_borrow ON Borrow;
DROP FUNCTION IF EXISTS update_availability_on_borrow();

-- Drop trigger: trg_update_availability_on_return
DROP TRIGGER IF EXISTS trg_update_availability_on_return ON Borrow;
DROP FUNCTION IF EXISTS update_availability_on_return();

-- Drop trigger: trg_check_active_subscription
DROP TRIGGER IF EXISTS trg_check_active_subscription ON Borrow;
DROP FUNCTION IF EXISTS check_active_subscription();

-- Drop trigger: trg_update_fine_on_overdue
DROP TRIGGER IF EXISTS trg_update_fine_on_overdue ON Borrow;
DROP FUNCTION IF EXISTS update_fine_on_overdue();

-- Trigger to ensure positive quantity in Availability table
CREATE OR REPLACE FUNCTION check_positive_quantity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantity < 0 THEN
        RAISE EXCEPTION 'Quantity must be positive';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER positive_quantity_check
BEFORE INSERT OR UPDATE ON Availability
FOR EACH ROW
EXECUTE FUNCTION check_positive_quantity();

-- Trigger to prevent overlapping borrow dates for the same exemplar
CREATE OR REPLACE FUNCTION check_borrow_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Borrow
        WHERE fk_exemplar_id = NEW.fk_exemplar_id
        AND ((NEW.get_date BETWEEN get_date AND give_back_date) OR
             (NEW.give_back_date BETWEEN get_date AND give_back_date))
    ) THEN
        RAISE EXCEPTION 'Borrow dates overlap for the same exemplar';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER borrow_dates_check
BEFORE INSERT OR UPDATE ON Borrow
FOR EACH ROW
EXECUTE FUNCTION check_borrow_dates();

-- Trigger to ensure ISBN uniqueness across Exemplar table
CREATE OR REPLACE FUNCTION check_unique_isbn()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Exemplar WHERE isbn = NEW.isbn AND id <> NEW.id
    ) THEN
        RAISE EXCEPTION 'ISBN must be unique across all exemplars';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unique_isbn_check
BEFORE INSERT OR UPDATE ON Exemplar
FOR EACH ROW
EXECUTE FUNCTION check_unique_isbn();

-- Trigger to ensure privilege name uniqueness in Privilege table
CREATE OR REPLACE FUNCTION check_unique_privilege_name()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Privilege WHERE name = NEW.name AND id <> NEW.id
    ) THEN
        RAISE EXCEPTION 'Privilege name must be unique';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unique_privilege_name_check
BEFORE INSERT OR UPDATE ON Privilege
FOR EACH ROW
EXECUTE FUNCTION check_unique_privilege_name();

-- Trigger to prevent invalid ratings (must be between 1 and 5)
CREATE OR REPLACE FUNCTION check_rating_score()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.score < 1 OR NEW.score > 5 THEN
        RAISE EXCEPTION 'Rating score must be between 1 and 5';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER valid_rating_score_check
BEFORE INSERT OR UPDATE ON Rating
FOR EACH ROW
EXECUTE FUNCTION check_rating_score();

-- Trigger to ensure that a subscription price is non-negative
CREATE OR REPLACE FUNCTION check_subscription_price()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'Subscription price must be non-negative';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER positive_subscription_price_check
BEFORE INSERT OR UPDATE ON Subscription
FOR EACH ROW
EXECUTE FUNCTION check_subscription_price();

-- Trigger for maintaining book availability after a new borrow
CREATE OR REPLACE FUNCTION update_availability_on_borrow() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Availability
    SET quantity = quantity - 1
    WHERE id = NEW.fk_availability_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_availability_on_borrow
AFTER INSERT ON Borrow
FOR EACH ROW
EXECUTE FUNCTION update_availability_on_borrow();

-- Trigger for returning a book and updating availability
CREATE OR REPLACE FUNCTION update_availability_on_return() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Availability
    SET quantity = quantity + 1
    WHERE id = OLD.fk_exemplar_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_availability_on_return
AFTER DELETE ON Borrow
FOR EACH ROW
EXECUTE FUNCTION update_availability_on_return();

-- Trigger to check if a reader's subscription is active before borrowing
CREATE OR REPLACE FUNCTION check_active_subscription() RETURNS TRIGGER AS $$
DECLARE
    active_subscriptions INT;
BEGIN
    SELECT COUNT(*) INTO active_subscriptions
    FROM Subscription
    WHERE fk_library_card_id = (SELECT id FROM Library_card WHERE fk_reader_id = NEW.fk_reader_id)
      AND expire_date > CURRENT_DATE;

    IF active_subscriptions = 0 THEN
        RAISE EXCEPTION 'The reader does not have an active subscription';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_active_subscription
BEFORE INSERT ON Borrow
FOR EACH ROW
EXECUTE FUNCTION check_active_subscription();

-- Trigger to automatically update fine if borrow is overdue
CREATE OR REPLACE FUNCTION update_fine_on_overdue() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.give_back_date < CURRENT_DATE THEN
        INSERT INTO Fine (fk_borrow_id, amount, reason)
        VALUES (NEW.id, 100, 'Overdue book');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_fine_on_overdue
AFTER INSERT ON Borrow
FOR EACH ROW
EXECUTE FUNCTION update_fine_on_overdue();
