CREATE OR REPLACE FUNCTION validate_exchange_transaction()
RETURNS TRIGGER AS $$
DECLARE
    wallet_status_name VARCHAR;
    exchange_status_name VARCHAR;
    available_balance NUMERIC(20, 8);
BEGIN
    -- Проверка статуса кошелька
    SELECT s.status_name INTO wallet_status_name
    FROM wallets w
    JOIN statuses s ON w.status_id = s.id
    WHERE w.address = NEW.wallet_address;

    IF wallet_status_name <> 'active' THEN
        RAISE EXCEPTION 'Wallet must be active for exchange transaction';
    END IF;

    -- Проверка статуса биржи
    SELECT s.status_name INTO exchange_status_name
    FROM exchanges e
    JOIN statuses s ON e.status_id = s.id
    WHERE e.id = NEW.exchange_id;

    IF exchange_status_name <> 'active' THEN
        RAISE EXCEPTION 'Exchange must be active for exchange transaction';
    END IF;

    -- Проверка баланса
    SELECT b.amount INTO available_balance
    FROM balances b
    WHERE b.wallet_address = NEW.wallet_address AND b.token_id = NEW.token_id;

    IF available_balance IS NULL THEN
        RAISE EXCEPTION 'No balance available for this wallet and token';
    END IF;

    IF NEW.amount + NEW.fee > available_balance THEN
        RAISE EXCEPTION 'Insufficient balance: amount + fee exceeds wallet balance';
    END IF;

    -- Проверка комиссии
    IF NEW.fee > NEW.amount * 0.05 THEN
        RAISE EXCEPTION 'Fee cannot exceed 5%% of the amount';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_exchange_transaction
BEFORE INSERT OR UPDATE ON exchange_transactions
FOR EACH ROW
EXECUTE FUNCTION validate_exchange_transaction();
