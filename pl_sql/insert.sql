-- trip
insert into trip(trip_name, country, trip_date, max_no_places)
values ('Wycieczka do Paryza', 'Francja', to_date('2023-09-12', 'YYYY-MM-DD'), 3);
insert into trip(trip_name, country, trip_date, max_no_places)
values ('Piekny Krakow', 'Polska', to_date('2025-05-03','YYYY-MM-DD'), 2);
insert into trip(trip_name, country, trip_date, max_no_places)
values ('Znow do Francji', 'Francja', to_date('2025-05-01','YYYY-MM-DD'), 2);
insert into trip(trip_name, country, trip_date, max_no_places)
values ('Hel', 'Polska', to_date('2025-05-01','YYYY-MM-DD'), 2);
-- person
insert into person(firstname, lastname) values ('Jan', 'Nowak');
insert into person(firstname, lastname) values ('Jan', 'Kowalski');
insert into person(firstname, lastname) values ('Jan', 'Nowakowski');
insert into person(firstname, lastname) values ('Novak', 'Nowak');
insert into person(firstname, lastname) values ('Anna', 'Kowalska');
insert into person(firstname, lastname) values ('Adam', 'Nowak');
insert into person(firstname, lastname) values ('Maria', 'Wiśniewska');
insert into person(firstname, lastname) values ('Piotr', 'Jankowski');
insert into person(firstname, lastname) values ('Katarzyna', 'Woźniak');
insert into person(firstname, lastname) values ('Michał', 'Dąbrowski');

-- reservation
-- trip1
insert into reservation(trip_id, person_id, status)
values (1, 1, 'P');
insert into reservation(trip_id, person_id, status)
values (1, 2, 'N');
insert into reservation(trip_id, person_id, status)
values (1, 8, 'N');
-- trip 2
insert into reservation(trip_id, person_id, status)
values (2, 1, 'P');
insert into reservation(trip_id, person_id, status)
values (2, 4, 'C');
-- trip 3
insert into reservation(trip_id, person_id, status)
values (3, 4, 'P');
insert into reservation(trip_id, person_id, status)
values (3, 8, 'P');

-- trip 4
insert into reservation(trip_id, person_id, status)
values (4, 5, 'P');
insert into reservation(trip_id, person_id, status)
values (4, 6, 'N');
insert into reservation(trip_id, person_id, status)
values (4, 7, 'C');



