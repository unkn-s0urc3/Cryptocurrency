CREATE OR REPLACE FUNCTION prevent_wallet_status_change_if_banned()
RETURNS TRIGGER AS $$
DECLARE
    current_status_name VARCHAR;
BEGIN
    -- Получаем текущее имя статуса кошелька
    SELECT status_name INTO current_status_name
    FROM statuses
    WHERE id = OLD.status_id;

    -- Если статус "banned", запрещаем менять статус
    IF current_status_name = 'banned' THEN
        RAISE EXCEPTION 'Cannot change status of a banned wallet';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_wallet_status_change_if_banned
BEFORE UPDATE OF status_id ON wallets
FOR EACH ROW
EXECUTE FUNCTION prevent_wallet_status_change_if_banned();
