CREATE OR REPLACE FUNCTION allow_update_only_if_pending()
RETURNS TRIGGER AS $$
DECLARE
    status_name VARCHAR;
BEGIN
    -- Получаем имя текущего статуса транзакции
    SELECT transaction_status_name INTO status_name
    FROM transaction_statuses
    WHERE id = OLD.transaction_status_id;

    -- Разрешаем изменения только если статус "pending"
    IF status_name <> 'pending' THEN
        RAISE EXCEPTION 'Exchange transaction can only be modified when status is "pending"';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_allow_update_only_if_pending
BEFORE UPDATE ON exchange_transactions
FOR EACH ROW
EXECUTE FUNCTION allow_update_only_if_pending();
