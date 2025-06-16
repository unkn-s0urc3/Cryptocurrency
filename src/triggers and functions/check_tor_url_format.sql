CREATE OR REPLACE FUNCTION check_tor_url_format()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем URL, если он содержит .onion
    IF NEW.url ~* '\.onion$' THEN
        -- Проверяем, что имя хоста - base32 (a-z, 2-7), длина 16 или 56 символов, и заканчивается на .onion
        IF NOT NEW.url ~* '^https?://[a-z2-7]{16}\.onion/?$' AND NOT NEW.url ~* '^https?://[a-z2-7]{56}\.onion/?$' THEN
            RAISE EXCEPTION 'Invalid .onion URL format: %', NEW.url;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для проверки URL в exchanges
CREATE TRIGGER trg_check_tor_url_format
BEFORE INSERT OR UPDATE ON exchanges
FOR EACH ROW
EXECUTE FUNCTION check_tor_url_format();
