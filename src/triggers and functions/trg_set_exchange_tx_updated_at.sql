CREATE OR REPLACE FUNCTION set_exchange_tx_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_exchange_tx_updated_at
BEFORE UPDATE ON exchange_transactions
FOR EACH ROW
EXECUTE FUNCTION set_exchange_tx_updated_at();
