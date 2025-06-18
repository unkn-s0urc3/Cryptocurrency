CREATE OR REPLACE FUNCTION allow_internal_update_only_if_pending()
RETURNS TRIGGER AS $$
DECLARE
    current_status VARCHAR;
BEGIN
    SELECT transaction_status_name INTO current_status
    FROM transaction_statuses
    WHERE id = OLD.transaction_status_id;

    IF current_status <> 'pending' THEN
        RAISE EXCEPTION 'Internal transaction can only be modified when status is "pending"';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_allow_internal_update_only_if_pending
BEFORE UPDATE ON internal_transactions
FOR EACH ROW
EXECUTE FUNCTION allow_internal_update_only_if_pending();
