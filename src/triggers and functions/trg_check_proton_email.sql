CREATE OR REPLACE FUNCTION check_proton_email()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверка: email должен оканчиваться на '@proton.me'
    IF RIGHT(NEW.email, 10) <> '@proton.me' THEN
        RAISE EXCEPTION 'Email must be a @proton.me address';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_proton_email
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION check_proton_email();
