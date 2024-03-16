CREATE OR REPLACE VIEW vw_reservation
AS
    SELECT R.RESERVATION_ID, T.COUNTRY, T.TRIP_DATE, T.TRIP_NAME, P.FIRSTNAME, P.LASTNAME, R.STATUS, T.TRIP_ID, P.PERSON_ID
        FROM TRIP t inner join
        RESERVATION R on t.TRIP_ID = R.TRIP_ID inner join
        PERSON P ON R.PERSON_ID = P.PERSON_ID;


CREATE OR REPLACE VIEW vw_trip
AS
    SELECT
        t.trip_id,
        t.country,
        t.trip_date,
        t.trip_name,
        t.max_no_places,
        (t.MAX_NO_PLACES - SUM(CASE WHEN r.STATUS IN ('N', 'P') THEN 1 ELSE 0 END)) AS no_available_places
    FROM
        trip t
    LEFT JOIN
        reservation r ON t.trip_id = r.trip_id
    GROUP BY
        t.trip_id, t.country, t.trip_date, t.trip_name, t.max_no_places;

CREATE OR REPLACE VIEW vw_available_trip
AS
    SELECT trip_id, country, trip_date, trip_name FROM VW_TRIP
    WHERE no_available_places>0 AND trip_date >= SYSDATE