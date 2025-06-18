CREATE OR REPLACE FUNCTION validate_onion_url()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверка, что url заканчивается на '.onion'
    IF RIGHT(NEW.url, 6) <> '.onion' THEN
        RAISE EXCEPTION 'Exchange URL must be a valid .onion address';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_onion_url
BEFORE INSERT OR UPDATE OF url ON exchanges
FOR EACH ROW
EXECUTE FUNCTION validate_onion_url();
