CREATE OR REPLACE FUNCTION prevent_delete_confirmed_exchange_tx()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    status_name TEXT;
BEGIN
    -- Получаем текстовое имя статуса
    SELECT transaction_status_name
    INTO status_name
    FROM transaction_statuses
    WHERE id = OLD.transaction_status_id;

    IF status_name = 'confirmed' THEN
        RAISE EXCEPTION 'Cannot delete confirmed exchange transaction';
    END IF;

    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_prevent_delete_confirmed_exchange_tx
BEFORE DELETE ON exchange_transactions
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_confirmed_exchange_tx();
