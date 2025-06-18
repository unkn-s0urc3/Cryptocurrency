CREATE OR REPLACE FUNCTION set_internal_tx_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_internal_tx_updated_at
BEFORE UPDATE ON internal_transactions
FOR EACH ROW
EXECUTE FUNCTION set_internal_tx_updated_at();
