CREATE OR REPLACE TRIGGER tr_check_reservation_insert
    BEFORE INSERT
    ON RESERVATION
    FOR EACH ROW
BEGIN
    P_TRIP_EXIST(:new.TRIP_ID);
    P_TRIP_OUTDATED(:new.TRIP_ID);
    P_PERSON_EXIST(:new.PERSON_ID);
    IF F_GET_available_PLACES(:new.trip_id) < 1 then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
end;

CREATE OR REPLACE TRIGGER tr_check_reservation_update
    BEFORE UPDATE
    ON RESERVATION
    FOR EACH ROW
BEGIN
    IF F_GET_available_PLACES(:new.trip_id) < 1 and :old.status = 'C' and :new.status <> 'C' then
        rollback;
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    commit;
end;

CREATE OR REPLACE TRIGGER tr_add_log
    AFTER INSERT OR UPDATE
    ON RESERVATION
    FOR EACH ROW
BEGIN
    p_add_log(:new.RESERVATION_ID, :new.status);
end;


CREATE OR REPLACE TRIGGER tr_prevent_reservation_deletion
    BEFORE DELETE
    ON RESERVATION
BEGIN
    raise_application_error(-20000, 'Nie można usunąć rezerwacji');
end;