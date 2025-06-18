CREATE OR REPLACE FUNCTION allow_email_change_only_if_suspended()
RETURNS TRIGGER AS $$
DECLARE
    current_status_name VARCHAR;
BEGIN
    -- Проверяем, изменяется ли email
    IF NEW.email IS DISTINCT FROM OLD.email THEN
        -- Получаем текущее имя статуса
        SELECT status_name INTO current_status_name
        FROM statuses
        WHERE id = OLD.status_id;

        -- Если статус не "suspended", запрещаем изменение email
        IF current_status_name <> 'suspended' THEN
            RAISE EXCEPTION 'Email can only be changed when status is "suspended"';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_email_change_only_if_suspended
BEFORE UPDATE OF email ON users
FOR EACH ROW
EXECUTE FUNCTION allow_email_change_only_if_suspended();
