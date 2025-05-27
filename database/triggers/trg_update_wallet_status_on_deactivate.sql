CREATE OR REPLACE FUNCTION update_wallet_status_on_deactivate()
RETURNS TRIGGER AS $$
DECLARE
    inactive_status_id SMALLINT;
BEGIN
    SELECT id INTO inactive_status_id FROM statuses WHERE status_name = 'inactive';

    IF inactive_status_id IS NULL THEN
        RAISE EXCEPTION 'Status "inactive" not found in statuses table';
    END IF;

    UPDATE wallets
    SET status_id = inactive_status_id,
        updated_at = NOW()
    WHERE wallet_address = NEW.wallet_address;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_wallet_status_on_deactivate
AFTER INSERT ON inactive_wallets
FOR EACH ROW
EXECUTE FUNCTION update_wallet_status_on_deactivate();