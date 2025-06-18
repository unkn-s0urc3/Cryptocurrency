CREATE OR REPLACE FUNCTION prevent_delete_confirmed_internal_tx()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    status_name TEXT;
BEGIN
    SELECT transaction_status_name
    INTO status_name
    FROM transaction_statuses
    WHERE id = OLD.transaction_status_id;

    IF status_name = 'confirmed' THEN
        RAISE EXCEPTION 'Cannot delete confirmed internal transaction';
    END IF;

    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_prevent_delete_confirmed_internal_tx
BEFORE DELETE ON internal_transactions
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_confirmed_internal_tx();
