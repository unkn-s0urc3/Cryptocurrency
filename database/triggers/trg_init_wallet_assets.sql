CREATE OR REPLACE FUNCTION init_wallet_assets()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO wallet_assets(wallet_address, blockchain_id, balance)
    SELECT NEW.wallet_address, id, 0
    FROM blockchains;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_init_wallet_assets
AFTER INSERT ON wallets
FOR EACH ROW
EXECUTE FUNCTION init_wallet_assets();