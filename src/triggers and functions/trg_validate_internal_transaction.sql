CREATE OR REPLACE FUNCTION validate_internal_transaction()
RETURNS TRIGGER AS $$
DECLARE
    sender_status TEXT;
    recipient_status TEXT;
    available_balance NUMERIC(20, 8);
BEGIN
    -- 1. Нельзя отправлять самому себе
    IF NEW.sender_address = NEW.recipient_address THEN
        RAISE EXCEPTION 'Cannot send tokens to yourself';
    END IF;

    -- 2. Статусы кошельков
    SELECT s.status_name INTO sender_status
    FROM wallets w
    JOIN statuses s ON w.status_id = s.id
    WHERE w.address = NEW.sender_address;

    SELECT s.status_name INTO recipient_status
    FROM wallets w
    JOIN statuses s ON w.status_id = s.id
    WHERE w.address = NEW.recipient_address;

    IF sender_status <> 'active' THEN
        RAISE EXCEPTION 'Sender wallet must be active';
    END IF;

    IF recipient_status <> 'active' THEN
        RAISE EXCEPTION 'Recipient wallet must be active';
    END IF;

    -- 3. Проверка баланса
    SELECT b.amount INTO available_balance
    FROM balances b
    WHERE b.wallet_address = NEW.sender_address
      AND b.token_id = NEW.token_id;

    IF available_balance IS NULL THEN
        RAISE EXCEPTION 'No balance available for sender wallet and token';
    END IF;

    IF NEW.amount + NEW.fee > available_balance THEN
        RAISE EXCEPTION 'Insufficient balance: amount + fee exceeds sender balance';
    END IF;

    -- 4. Проверка комиссии
    IF NEW.fee > NEW.amount * 0.05 THEN
        RAISE EXCEPTION 'Fee cannot exceed 5%% of the amount';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_internal_transaction
BEFORE INSERT OR UPDATE ON internal_transactions
FOR EACH ROW
EXECUTE FUNCTION validate_internal_transaction();
