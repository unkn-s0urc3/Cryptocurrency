CREATE OR REPLACE FUNCTION update_wallets_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_wallets_updated_at
BEFORE UPDATE ON wallets
FOR EACH ROW
EXECUTE FUNCTION update_wallets_updated_at();