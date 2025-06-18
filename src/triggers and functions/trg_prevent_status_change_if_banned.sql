CREATE OR REPLACE FUNCTION prevent_status_change_if_banned()
RETURNS TRIGGER AS $$
DECLARE
    current_status_name VARCHAR;
BEGIN
    -- Получаем текущее имя статуса пользователя
    SELECT status_name INTO current_status_name
    FROM statuses
    WHERE id = OLD.status_id;

    -- Если текущий статус — "banned", блокируем изменение
    IF current_status_name = 'banned' THEN
        RAISE EXCEPTION 'Cannot change status for banned user';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_status_change_if_banned
BEFORE UPDATE OF status_id ON users
FOR EACH ROW
EXECUTE FUNCTION prevent_status_change_if_banned();
