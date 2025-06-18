CREATE OR REPLACE FUNCTION update_balances_after_confirmed_internal_tx()
RETURNS TRIGGER AS $$
DECLARE
    new_status VARCHAR;
BEGIN
    -- Получаем новый статус
    SELECT transaction_status_name INTO new_status
    FROM transaction_statuses
    WHERE id = NEW.transaction_status_id;

    -- Обрабатываем только переход в confirmed
    IF new_status = 'confirmed' AND OLD.transaction_status_id <> NEW.transaction_status_id THEN
        -- Списание с отправителя (amount + fee)
        UPDATE balances
        SET amount = amount - (NEW.amount + NEW.fee),
            updated_at = now()
        WHERE wallet_address = NEW.sender_address
          AND token_id = NEW.token_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Sender balance not found for wallet % and token %', NEW.sender_address, NEW.token_id;
        END IF;

        -- Начисление получателю (только amount)
        UPDATE balances
        SET amount = amount + NEW.amount,
            updated_at = now()
        WHERE wallet_address = NEW.recipient_address
          AND token_id = NEW.token_id;

        IF NOT FOUND THEN
            -- Если записи нет, можно создать её, или выбросить ошибку. Здесь выбросим ошибку:
            RAISE EXCEPTION 'Recipient balance not found for wallet % and token %', NEW.recipient_address, NEW.token_id;
        END IF;
    END IF;

    RETURN NULL; -- AFTER триггер
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_balances_after_confirmed_internal_tx
AFTER UPDATE ON internal_transactions
FOR EACH ROW
EXECUTE FUNCTION update_balances_after_confirmed_internal_tx();
