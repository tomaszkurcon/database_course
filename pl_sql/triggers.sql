CREATE OR REPLACE TRIGGER tr_check_reservation
    BEFORE INSERT OR UPDATE
    ON RESERVATION
    FOR EACH ROW
DECLARE
    pragma autonomous_transaction;
    p_trip_date VW_TRIP.trip_date%type;
    p_status    RESERVATION.status%type;
BEGIN
    SELECT t.TRIP_DATE
    into p_trip_date
    FROM TRIP t
    WHERE t.TRIP_ID = :new.trip_id;
    if :old.status is NULL then
        p_status := 'C';
    else
        p_status := :old.status;
    end if;
    IF p_trip_date < SYSDATE then
        raise_application_error(-20001, 'Wycieczka się już odbyła');
    end if;

    IF F_GET_AVILABLE_PLACES(:new.trip_id) < 1 and p_status = 'C' and :new.status <> 'C' then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
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