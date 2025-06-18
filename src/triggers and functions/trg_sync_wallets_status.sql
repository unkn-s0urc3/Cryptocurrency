CREATE OR REPLACE FUNCTION sync_wallets_status_with_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверка: если изменился только status_id
    IF NEW.status_id IS DISTINCT FROM OLD.status_id THEN
        -- Обновляем статус всех кошельков пользователя
        UPDATE wallets
        SET status_id = NEW.status_id,
            updated_at = now()
        WHERE user_username = NEW.username;
    END IF;

    RETURN NULL; -- AFTER триггер
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_wallets_status
AFTER UPDATE OF status_id ON users
FOR EACH ROW
EXECUTE FUNCTION sync_wallets_status_with_user();
