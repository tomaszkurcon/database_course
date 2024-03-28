-- ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';

CREATE OR REPLACE PROCEDURE p_person_exist(p_id IN PERSON.person_id%type)
IS
tmp char(1);
BEGIN
    select 1 into tmp from PERSON p where p.PERSON_ID = p_id;

    exception
        when NO_DATA_FOUND then
            raise_application_error(-20001, 'Osoba o podanym id nie istnieje');
end;

CREATE OR REPLACE PROCEDURE p_trip_exist(t_id IN TRIP.TRIP_ID%type)
IS
tmp char(1);
BEGIN
    select 1 into tmp from TRIP t where t.TRIP_ID = t_id;

    exception
        when NO_DATA_FOUND then
            raise_application_error(-20001, 'Wycieczka o podanym id nie istnieje');
end;
CREATE OR REPLACE PROCEDURE p_reservation_exist(r_id IN RESERVATION.RESERVATION_ID%type)
IS
tmp char(1);
BEGIN
    select 1 into tmp from RESERVATION r where r.RESERVATION_ID = r_id;

    exception
        when NO_DATA_FOUND then
            raise_application_error(-20001, 'Rezerwacja o podanym id nie istnieje');
end;
CREATE OR REPLACE PROCEDURE p_trip_outdated(t_id IN TRIP.TRIP_ID%Type)
IS
      trip_date VW_TRIP.trip_date%type;
BEGIN
    SELECT v.TRIP_DATE
    into trip_date
    FROM TRIP v
    WHERE v.TRIP_ID = t_id;
    IF trip_date < SYSDATE then
        raise_application_error(-20001, 'Wycieczka się już odbyła');
    end if;
end;

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
    r_reservation           RESERVATION%rowtype;
    inserted_reservation_id RESERVATION.reservation_id%type;
BEGIN
    p_trip_exist(trip_id);
    p_person_exist(person_id);
    p_trip_outdated(trip_id);
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

-- WORK
BEGIN
    p_add_reservation(1, 3);
end;


CREATE OR REPLACE PROCEDURE p_modify_reservation_status(p_reservation_id in RESERVATION.reservation_id%type,
                                                        p_status in RESERVATION.status%type)
    IS
    p_trip_id TRIP.trip_id%type;
    old_status RESERVATION.status%type;
BEGIN
    p_reservation_exist(p_reservation_id);
    SELECT trip_id, status into p_trip_id, old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    IF F_GET_AVILABLE_PLACES(p_trip_id) < 1  AND old_status = 'C' AND p_status <> 'C' then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
    p_add_log(p_reservation_id, p_status);
end;

--WORK
BEGIN
    p_modify_reservation_status(450, 'C');
end;

CREATE OR REPLACE PROCEDURE p_modify_max_no_places(p_trip_id TRIP.trip_id%type,
                                                   p_max_no_places in TRIP.max_no_places%type)
    IS
    max_no_places TRIP.max_no_places%type;
BEGIN
    p_trip_exist(p_trip_id);
    SELECT MAX_NO_PLACES into max_no_places FROM TRIP WHERE TRIP_ID = p_trip_id;
    IF p_max_no_places < max_no_places - F_GET_AVILABLE_PLACES(p_trip_id) then
        raise_application_error(-20001,
                                'Liczba miejsc zarezerwowanych jest wieksza od nowej podanej maksymalnej liczby miejsc');
    end if;
    UPDATE TRIP
    SET MAX_NO_PLACES = p_max_no_places
    WHERE TRIP_ID = p_trip_id;
end;

--Work

BEGIN
    p_modify_max_no_places(3, 12);
end;

CREATE OR REPLACE PROCEDURE p_add_reservation_4(trip_id in VW_TRIP.trip_id%type, person_id in PERSON.person_id%type)
    IS
    r_reservation           RESERVATION%rowtype;
BEGIN
    p_trip_exist(trip_id);
    p_trip_outdated(trip_id);
    IF F_GET_AVILABLE_PLACES(trip_id) < 1 then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    r_reservation.trip_id := trip_id;
    r_reservation.person_id := person_id;
    r_reservation.status := 'N';
    INSERT INTO RESERVATION(trip_id, person_id, status)
    VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS);
end;

--WORK
BEGIN
    p_add_reservation_4(3, 3);
end;

CREATE OR REPLACE PROCEDURE p_modify_reservation_status_4(p_reservation_id in RESERVATION.reservation_id%type,
                                                        p_status in RESERVATION.status%type)
    IS
    p_trip_id TRIP.trip_id%type;
    old_status RESERVATION.status%type;
BEGIN
    p_reservation_exist(p_reservation_id);
    SELECT trip_id, status into p_trip_id, old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    IF F_GET_AVILABLE_PLACES(p_trip_id) < 1  AND old_status = 'C' AND p_status <> 'C' then
        raise_application_error(-20001, 'Brak wolnych miejsc');
    end if;
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
end;
BEGIN
    p_modify_reservation_status_4(200, 'N');
end;
--WORK


--TRIGGER ZAD 4 WORK
-- BEGIN
--     DELETE FROM RESERVATION
--         WHERE RESERVATION_ID = 3;
-- end;

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
    p_reservation_exist(p_reservation_id);
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
end;

BEGIN
--     p_add_reservation_5(3, 6);
    p_modify_reservation_status_5(421, 'N');
end;
