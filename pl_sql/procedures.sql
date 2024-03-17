-- ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';
CREATE OR REPLACE PROCEDURE p_add_log(p_reservation_id in RESERVATION.reservation_id%type,
                                      p_status in RESERVATION.status%type)
    IS
    current_date DATE;
BEGIN
    current_date := SYSDATE;
    INSERT INTO LOG(RESERVATION_ID, LOG_DATE, STATUS) VALUES (p_reservation_id, current_date, p_status);
end;
CREATE OR REPLACE PROCEDURE p_add_reservation(trip_id in VW_TRIP.trip_id%type, person_id in PERSON.person_id%type)
    IS
    trip_date               VW_TRIP.trip_date%type;
    r_reservation           RESERVATION%rowtype;
    inserted_reservation_id RESERVATION.reservation_id%type;
BEGIN
    SELECT v.TRIP_DATE
    into trip_date
    FROM VW_TRIP v
    WHERE v.TRIP_ID = p_add_reservation.trip_id;
    IF trip_date < SYSDATE then
        raise_application_error(-20001, 'Wycieczka się już odbyła');
    end if;
    IF F_GET_AVILABLE_PLACES(trip_id) < 1 then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    r_reservation.trip_id := trip_id;
    r_reservation.person_id := person_id;
    r_reservation.status := 'N';
    INSERT INTO RESERVATION(trip_id, person_id, status)
    VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS)
    returning RESERVATION_ID into inserted_reservation_id;
    p_add_log(inserted_reservation_id, 'N');
end;

-- BEGIN
--     p_add_reservation(2, 4);
-- end;


CREATE OR REPLACE PROCEDURE p_modify_reservation_status(p_reservation_id in RESERVATION.reservation_id%type,
                                                        p_status in RESERVATION.status%type)
    IS
    p_trip_id TRIP.trip_id%type;
    old_status RESERVATION.status%type;
BEGIN
    SELECT trip_id, status into p_trip_id, old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    IF F_GET_AVILABLE_PLACES(p_trip_id) < 1  AND old_status = 'C' AND p_status <> 'C' then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
    p_add_log(p_reservation_id, p_status);
end;

CREATE OR REPLACE PROCEDURE p_modify_max_no_places(p_trip_id TRIP.trip_id%type,
                                                   p_max_no_places in TRIP.max_no_places%type)
    IS
    max_no_places TRIP.max_no_places%type;
BEGIN
    SELECT MAX_NO_PLACES into max_no_places FROM TRIP WHERE TRIP_ID = p_trip_id;
    IF p_max_no_places < max_no_places - F_GET_AVILABLE_PLACES(p_trip_id) then
        raise_application_error(-20001,
                                'Liczba miejsc zarezerwowanych jest wieksza od nowej podanej maksymalnej liczby miejsc');
    end if;
    UPDATE TRIP
    SET MAX_NO_PLACES = p_max_no_places
    WHERE TRIP_ID = p_trip_id;
end;



CREATE OR REPLACE PROCEDURE p_add_reservation_4(trip_id in VW_TRIP.trip_id%type, person_id in PERSON.person_id%type)
    IS
    trip_date               VW_TRIP.trip_date%type;
    r_reservation           RESERVATION%rowtype;
BEGIN
    SELECT v.TRIP_DATE
    into trip_date
    FROM VW_TRIP v
    WHERE v.TRIP_ID = p_add_reservation_4.trip_id;
    IF trip_date < SYSDATE then
        raise_application_error(-20001, 'Wycieczka się już odbyła');
    end if;
    IF F_GET_AVILABLE_PLACES(trip_id) < 1 then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    r_reservation.trip_id := trip_id;
    r_reservation.person_id := person_id;
    r_reservation.status := 'N';
    INSERT INTO RESERVATION(trip_id, person_id, status)
    VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS);
end;




CREATE OR REPLACE PROCEDURE p_modify_reservation_status_4(p_reservation_id in RESERVATION.reservation_id%type,
                                                        p_status in RESERVATION.status%type)
    IS
    p_trip_id TRIP.trip_id%type;
    old_status RESERVATION.status%type;
BEGIN
    SELECT trip_id, STATUS into p_trip_id, status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    IF F_GET_AVILABLE_PLACES(p_trip_id) < 1 AND old_status = 'C' AND p_status <> 'C' then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
end;



CREATE OR REPLACE PROCEDURE p_add_reservation_5(trip_id in VW_TRIP.trip_id%type, person_id in PERSON.person_id%type)
AS
    r_reservation RESERVATION%rowtype;
BEGIN
    r_reservation.trip_id := trip_id;
    r_reservation.person_id := person_id;
    r_reservation.status := 'N';
    INSERT INTO RESERVATION(trip_id, person_id, status)
    VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS);
end;

CREATE OR REPLACE PROCEDURE p_modify_reservation_status_5(p_reservation_id in RESERVATION.reservation_id%type,
                                                          p_status in RESERVATION.status%type) AS
BEGIN
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
end;

-- BEGIN
-- --     p_add_reservation_5(2, 6);
--     p_modify_reservation_status_5(11, 'N');
-- end;
