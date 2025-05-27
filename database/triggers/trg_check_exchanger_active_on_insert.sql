CREATE OR REPLACE FUNCTION check_exchanger_is_active()
RETURNS TRIGGER AS $$
DECLARE
    exchanger_status VARCHAR;
BEGIN
    SELECT s.status_name INTO exchanger_status
    FROM exchangers e
    JOIN statuses s ON e.status_id = s.id
    WHERE e.id = NEW.exchanger_id;

    IF exchanger_status = 'inactive' THEN
        RAISE EXCEPTION 'Operation not allowed: exchanger % is inactive', NEW.exchanger_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_exchanger_active_on_insert
BEFORE INSERT ON exchanger_transactions
FOR EACH ROW
EXECUTE FUNCTION check_exchanger_is_active();