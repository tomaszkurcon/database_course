CREATE OR REPLACE FUNCTION f_get_avilable_places(p_trip_id TRIP.trip_id%type)
    RETURN INT AS
    value int;
BEGIN
    SELECT v.NO_AVAILABLE_PLACES into value FROM VW_TRIP v WHERE v.TRIP_ID = p_trip_id;

    return value;
end;
CREATE OR REPLACE TYPE trip_participant AS OBJECT
(
    reservation_id int,
    country        varchar(50),
    trip_date      DATE,
    trip_name      varchar(100),
    firstname      varchar(50),
    lastname       varchar(50),
    status         CHAR,
    trip_id        INT,
    person_id      INT
);


CREATE OR REPLACE TYPE trip_participants_table IS TABLE OF trip_participant;


CREATE OR REPLACE FUNCTION f_trip_participants(trip_id IN TRIP.trip_id%type)
    RETURN trip_participants_table AS
    result trip_participants_table;
    valid  int;
BEGIN
    SELECT count(*)
    into valid
    from TRIP t
    where t.TRIP_ID = f_trip_participants.trip_id;
    if valid = 0 then
        raise_application_error(-20001, 'Trip ID ' || trip_id || ' nie istnieje.');
    end if;
    SELECT trip_participant(reservation_id, country, trip_date, trip_name, firstname, lastname, status, v.trip_id,
                            person_id) BULK COLLECT
    INTO result
    FROM vw_reservation v
    WHERE v.trip_id = f_trip_participants.trip_id;
    RETURN result;

END;

-- SELECT * FROM F_TRIP_PARTICIPANTS(5)

CREATE OR REPLACE FUNCTION f_person_reservations(person_id IN PERSON.person_id%type)
    RETURN trip_participants_table AS
    result trip_participants_table;
    valid  int;
BEGIN
    SELECT count(*)
    into valid
    from TRIP t
    where t.TRIP_ID = f_person_reservations.person_id;
    if valid = 0 then
        raise_application_error(-20001, 'Person ID ' || person_id || ' nie istnieje.');
    end if;
    SELECT trip_participant(reservation_id, country, trip_date, trip_name, firstname, lastname, status, v.trip_id,
                            person_id) BULK COLLECT
    INTO result
    FROM vw_reservation v
    WHERE v.PERSON_ID = f_person_reservations.person_id;
    RETURN result;
END;

-- SELECT * FROM F_PERSON_RESERVATIONS(1)


CREATE OR REPLACE TYPE trip_info AS OBJECT
(
    trip_id             INT,
    trip_name           varchar(100),
    country             varchar(50),
    trip_date           DATE,
    max_no_places       int,
    no_available_places int
);

CREATE OR REPLACE TYPE trip_info_table IS TABLE OF trip_info;

CREATE OR REPLACE FUNCTION f_available_trips_to(country TRIP.Country%type, date_from Date, date_to Date)
    RETURN trip_info_table as
    result trip_info_table;
    valid  int;
BEGIN
    SELECT count(*)
    into valid
    from VW_TRIP t
    where t.COUNTRY = f_available_trips_to.country;
    if valid = 0 then
        raise_application_error(-20001, 'Nie ma wycieczek do kraju ' || country);
    end if;
    SELECT trip_info(TRIP_ID, trip_name, t.country, trip_date, max_no_places, no_available_places) BULK COLLECT
    INTO result
    FROM VW_TRIP t
    WHERE t.COUNTRY = f_available_trips_to.country
      and TRIP_DATE BETWEEN date_from and date_to
      and t.NO_AVAILABLE_PLACES > 0;

    RETURN result;

end;

-- SELECT * FROM F_AVAILABLE_TRIPS_TO('Polska', '2022-05-02', '2026-05-04')

