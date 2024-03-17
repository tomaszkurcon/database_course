-- alter table trip
--     add
--         no_available_places int null;
-- Update every row of TRIP table with no_available_places from vw_trip
BEGIN
    FOR v_trip IN (SELECT * FROM VW_TRIP)
        LOOP
            UPDATE TRIP
            SET NO_AVAILABLE_PLACES = v_trip.NO_AVAILABLE_PLACES
            WHERE TRIP.TRIP_ID = v_trip.TRIP_ID;
        end loop;
end;

CREATE OR REPLACE PROCEDURE p_update_no_available_places(p_trip_id TRIP.trip_id%type,
                                                         old_status RESERVATION.status%type DEFAULT NULL,
                                                         new_status RESERVATION.status%type DEFAULT NULL,
                                                         p_change int DEFAULT NULL)
    IS
    amount int;
BEGIN
    IF p_change IS NOT NULL THEN
        UPDATE TRIP
        SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + p_change
        WHERE TRIP_ID = p_trip_id;
    ELSIF old_status is not null and new_status is not null then
        IF old_status = 'C' and new_status <> 'C' then
            amount := -1;

        ELSIF (old_status IN ('P', 'N') AND new_status IN ('P', 'N')) OR old_status = 'C' and new_status = 'C' then
            amount := 0;
        ELSE
            amount := 1;
        end if;
        UPDATE TRIP
        SET NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + amount
        WHERE TRIP_ID = p_trip_id;
    ELSE
        raise_application_error(-20001, 'Musisz podać p_change lub old_status i new_status rezerwacji');
    end if;
end;
-- CREATE OR REPLACE PROCEDURE p_add_reservation_6a(trip_id in TRIP.trip_id%type, person_id in PERSON.person_id%type)
--     IS
--     trip_date               TRIP.trip_date%type;
--     r_reservation           RESERVATION%rowtype;
--     inserted_reservation_id RESERVATION.reservation_id%type;
--     p_no_available_places   int;
-- BEGIN
--     SELECT v.TRIP_DATE, v.NO_AVAILABLE_PLACES
--     into trip_date, p_no_available_places
--     FROM TRIP v
--     WHERE v.TRIP_ID = p_add_reservation_6a.trip_id;
--     IF trip_date < SYSDATE then
--         raise_application_error(-20001, 'Wycieczka się już odbyła');
--     end if;
--     IF p_no_available_places < 1 then
--         raise_application_error(-20001, 'Brak wolnych miejsc');
--     end if;
--     r_reservation.trip_id := trip_id;
--     r_reservation.person_id := person_id;
--     r_reservation.status := 'N';
--     INSERT INTO RESERVATION(trip_id, person_id, status)
--     VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS)
--     returning RESERVATION_ID into inserted_reservation_id;
--     p_update_no_available_places(trip_id, 'C', 'N');
--     p_add_log(inserted_reservation_id, 'N');
-- end;
--
-- CREATE OR REPLACE PROCEDURE p_modify_reservation_status_6a(p_reservation_id in RESERVATION.reservation_id%type,
--                                                            p_status in RESERVATION.status%type)
--     IS
--     p_trip_id             TRIP.trip_id%type;
--     old_status            RESERVATION.status%type;
--     p_no_available_places int;
-- BEGIN
--     SELECT trip_id, STATUS into p_trip_id, old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
--     SELECT NO_AVAILABLE_PLACES into p_no_available_places FROM TRIP t WHERE t.TRIP_ID = p_trip_id;
--     IF p_no_available_places < 1 AND old_status = 'C' AND p_status <> 'C' then
--         raise_application_error(-20001, 'Brak wolnych miejsc');
--     end if;
--     UPDATE RESERVATION
--     SET STATUS = p_status
--     WHERE RESERVATION_ID = p_reservation_id;
--     p_update_no_available_places(p_trip_id, old_status, p_status);
--     p_add_log(p_reservation_id, p_status);
-- end;
--
-- CREATE OR REPLACE PROCEDURE p_modify_max_no_places_6a(p_trip_id TRIP.trip_id%type,
--                                                       p_max_no_places in TRIP.max_no_places%type)
--     IS
--     max_no_places       TRIP.max_no_places%type;
--     no_available_places int;
-- BEGIN
--     SELECT MAX_NO_PLACES, NO_AVAILABLE_PLACES
--     into max_no_places, no_available_places
--     FROM TRIP
--     WHERE TRIP_ID = p_trip_id;
--     IF p_max_no_places < max_no_places - no_available_places then
--         raise_application_error(-20001,
--                                 'Liczba miejsc zarezerwowanych jest wieksza od nowej podanej maksymalnej liczby miejsc');
--     end if;
--     p_update_no_available_places(p_trip_id, p_change=>p_max_no_places - max_no_places);
--     UPDATE TRIP
--     SET MAX_NO_PLACES = p_max_no_places
--     WHERE TRIP_ID = p_trip_id;
--
-- end;

CREATE OR REPLACE PROCEDURE p_add_reservation_6a(p_trip_id in TRIP.trip_id%type, person_id in PERSON.person_id%type)
    IS
    r_reservation RESERVATION%rowtype;
BEGIN
    r_reservation.trip_id := p_trip_id;
    r_reservation.person_id := person_id;
    r_reservation.status := 'N';
    INSERT INTO RESERVATION(trip_id, person_id, status)
    VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS);
    p_update_no_available_places(p_trip_id, 'C', 'N');
end;

CREATE OR REPLACE PROCEDURE p_modify_reservation_status_6a(p_reservation_id in RESERVATION.reservation_id%type,
                                                           p_status in RESERVATION.status%type)
    IS
    p_trip_id  TRIP.trip_id%type;
    old_status RESERVATION.status%type;
BEGIN
    SELECT trip_id, STATUS into p_trip_id, old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
    p_update_no_available_places(p_trip_id, old_status, p_status);
end;

CREATE OR REPLACE PROCEDURE p_modify_max_no_places_6a(p_trip_id TRIP.trip_id%type,
                                                      p_max_no_places in TRIP.max_no_places%type)
    IS
    max_no_places       TRIP.max_no_places%type;
    no_available_places int;
BEGIN
    SELECT MAX_NO_PLACES, NO_AVAILABLE_PLACES
    into max_no_places, no_available_places
    FROM TRIP
    WHERE TRIP_ID = p_trip_id;
    IF p_max_no_places < max_no_places - no_available_places then
        raise_application_error(-20001,
                                'Liczba miejsc zarezerwowanych jest wieksza od nowej podanej maksymalnej liczby miejsc');
    end if;
    p_update_no_available_places(p_trip_id, p_change=>p_max_no_places - max_no_places);
    UPDATE TRIP
    SET MAX_NO_PLACES = p_max_no_places
    WHERE TRIP_ID = p_trip_id;

end;


CREATE OR REPLACE TRIGGER tr_add_reservation_6b
    AFTER INSERT
    ON RESERVATION
    FOR EACH ROW
BEGIN
    p_update_no_available_places(:new.TRIP_ID, p_change => -1);
end;

CREATE OR REPLACE TRIGGER tr_change_reservation_status_6b
    AFTER UPDATE
    ON RESERVATION
    FOR EACH ROW
BEGIN
    P_UPDATE_NO_AVAILABLE_PLACES(:new.TRIP_ID, :old.STATUS, :new.STATUS);
end;

CREATE OR REPLACE PROCEDURE p_add_reservation_6b(p_trip_id in TRIP.trip_id%type, person_id in PERSON.person_id%type)
    IS
    r_reservation RESERVATION%rowtype;
BEGIN
    r_reservation.trip_id := p_trip_id;
    r_reservation.person_id := person_id;
    r_reservation.status := 'N';
    INSERT INTO RESERVATION(trip_id, person_id, status)
    VALUES (r_reservation.TRIP_ID, r_reservation.PERSON_ID, r_reservation.STATUS);
end;

CREATE OR REPLACE PROCEDURE p_modify_reservation_status_6b(p_reservation_id in RESERVATION.reservation_id%type,
                                                           p_status in RESERVATION.status%type)
    IS
    p_trip_id  TRIP.trip_id%type;
    old_status RESERVATION.status%type;
BEGIN
    SELECT trip_id, STATUS into p_trip_id, old_status FROM RESERVATION WHERE RESERVATION_ID = p_reservation_id;
    UPDATE RESERVATION
    SET STATUS = p_status
    WHERE RESERVATION_ID = p_reservation_id;
end;

BEGIN
--     p_add_reservation_6a(2, 7);
--     p_modify_max_no_places_6a(2, 2);
--     p_modify_reservation_status_6a(11, 'N');
    P_ADD_RESERVATION_6B(2, 2);
--        p_modify_reservation_status_6b(23, 'N');

end;