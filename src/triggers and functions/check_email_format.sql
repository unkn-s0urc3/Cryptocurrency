-- Функция для проверки email формата
CREATE OR REPLACE FUNCTION check_email_format()
RETURNS TRIGGER AS $$
BEGIN
    -- Простой regex для проверки email
    IF NEW.email !~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        RAISE EXCEPTION 'Invalid email format: %', NEW.email;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер, который срабатывает перед вставкой и обновлением в users
CREATE TRIGGER trg_check_email_format
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION check_email_format();
