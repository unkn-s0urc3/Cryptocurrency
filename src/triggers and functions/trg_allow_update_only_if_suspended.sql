CREATE OR REPLACE FUNCTION public.allow_exchange_update_only_if_suspended()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
    current_status_name VARCHAR;
BEGIN
    -- Получаем имя текущего статуса
    SELECT status_name INTO current_status_name
    FROM statuses
    WHERE id = OLD.status_id;

    -- Если меняется что-то кроме status_id
    IF NEW.status_id = OLD.status_id THEN
        IF current_status_name <> 'suspended' THEN
            RAISE EXCEPTION 'Only status_id can be updated unless status is "suspended"';
        END IF;
    END IF;

    RETURN NEW;
END;
$function$;

CREATE TRIGGER trg_allow_update_only_if_suspended
BEFORE UPDATE ON exchanges
FOR EACH ROW
EXECUTE FUNCTION allow_exchange_update_only_if_suspended();
