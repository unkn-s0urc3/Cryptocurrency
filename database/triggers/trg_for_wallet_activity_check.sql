CREATE OR REPLACE FUNCTION check_wallet_is_active()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM inactive_wallets WHERE wallet_address = NEW.wallet_address
    ) THEN
        RAISE EXCEPTION 'Operation not allowed: wallet % is inactive', NEW.wallet_address;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_wallet_active_on_insert_tx
BEFORE INSERT ON wallet_transactions
FOR EACH ROW
EXECUTE FUNCTION check_wallet_is_active();

CREATE TRIGGER trg_check_wallet_active_on_update_assets
BEFORE UPDATE ON wallet_assets
FOR EACH ROW
EXECUTE FUNCTION check_wallet_is_active();

CREATE TRIGGER trg_check_wallet_active_on_insert_exchanger_tx
BEFORE INSERT ON exchanger_transactions
FOR EACH ROW
EXECUTE FUNCTION check_wallet_is_active();