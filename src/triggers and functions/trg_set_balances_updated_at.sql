CREATE OR REPLACE FUNCTION set_balances_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_balances_updated_at
BEFORE UPDATE ON balances
FOR EACH ROW
EXECUTE FUNCTION set_balances_updated_at();
