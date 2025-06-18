CREATE OR REPLACE FUNCTION deduct_balance_if_confirmed()
RETURNS TRIGGER AS $$
DECLARE
    status_name VARCHAR;
BEGIN
    -- Получаем имя нового статуса
    SELECT transaction_status_name INTO status_name
    FROM transaction_statuses
    WHERE id = NEW.transaction_status_id;

    -- Только если статус "confirmed"
    IF status_name = 'confirmed' THEN
        -- Пытаемся обновить баланс
        UPDATE balances
        SET amount = amount - (NEW.amount + NEW.fee),
            updated_at = now()
        WHERE wallet_address = NEW.wallet_address
          AND token_id = NEW.token_id;

        -- Можно добавить проверку, чтобы убедиться, что баланс был найден
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Balance entry not found for wallet % and token %', NEW.wallet_address, NEW.token_id;
        END IF;
    END IF;

    RETURN NULL; -- AFTER-триггер
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_deduct_balance_if_confirmed
AFTER UPDATE ON exchange_transactions
FOR EACH ROW
EXECUTE FUNCTION deduct_balance_if_confirmed();
