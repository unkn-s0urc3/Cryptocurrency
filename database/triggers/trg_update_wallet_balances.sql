CREATE OR REPLACE FUNCTION update_wallet_balances_after_transaction()
RETURNS TRIGGER AS $$
DECLARE
    sender_balance NUMERIC(20,8);
    recipient_balance NUMERIC(20,8);
BEGIN
    SELECT balance INTO sender_balance
    FROM wallet_assets
    WHERE wallet_address = NEW.wallet_address AND blockchain_id = NEW.blockchain_id;

    IF sender_balance IS NULL THEN
        RAISE EXCEPTION 'Sender wallet asset not found for wallet % on blockchain %', NEW.wallet_address, NEW.blockchain_id;
    END IF;

    IF sender_balance < (NEW.amount + NEW.fee) THEN
        RAISE EXCEPTION 'Insufficient balance in sender wallet % on blockchain %', NEW.wallet_address, NEW.blockchain_id;
    END IF;

    UPDATE wallet_assets
    SET balance = balance - (NEW.amount + NEW.fee), updated_at = NOW()
    WHERE wallet_address = NEW.wallet_address AND blockchain_id = NEW.blockchain_id;

    SELECT balance INTO recipient_balance
    FROM wallet_assets
    WHERE wallet_address = NEW.to_address AND blockchain_id = NEW.blockchain_id;

    IF recipient_balance IS NULL THEN
        INSERT INTO wallet_assets(wallet_address, blockchain_id, balance, updated_at)
        VALUES (NEW.to_address, NEW.blockchain_id, 0, NOW());
        recipient_balance := 0;
    END IF;

    UPDATE wallet_assets
    SET balance = balance + NEW.amount, updated_at = NOW()
    WHERE wallet_address = NEW.to_address AND blockchain_id = NEW.blockchain_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_balances_after_insert
AFTER INSERT ON wallet_transactions
FOR EACH ROW
EXECUTE FUNCTION update_wallet_balances_after_transaction();