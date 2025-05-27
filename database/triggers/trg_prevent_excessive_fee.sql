CREATE OR REPLACE FUNCTION prevent_excessive_fee()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fee > NEW.amount * 0.05 THEN
        RAISE EXCEPTION 'Fee (%.8f) is too high for transaction %. Amount: %.8f', NEW.fee, NEW.transaction_hash, NEW.amount;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_excessive_fee
BEFORE INSERT ON wallet_transactions
FOR EACH ROW
EXECUTE FUNCTION prevent_excessive_fee();