{{command, "CREATE TABLE Exercise3( id SINT64 NOT NULL, time TIMESTAMP NOT NULL, place VARCHAR NOT NULL, temperature DOUBLE, pressure DOUBLE, atsealevel BOOLEAN, PRIMARY KEY ( (id, QUANTUM(time, 365, 'd')), id, time, place ));\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-01-01', \"Linlithgow\", 5.2, 1.01, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-02-01', \"Linlithgow\", 6.4, 1.02, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-01', \"Linlithgow\", 11.4, 1.15, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-09', \"Linlithgow\", 16.2, 0.98, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-04-15', \"Linlithgow\", 14.5, 1.0, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-01-02', \"Bo'ness\", 5.1, 1.02, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-02-01', \"Bo'ness\", 6.6, 1.07, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-01', \"Bo'ness\", 10.2, 1.13, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-07', \"Bo'ness\", 16.5, 0.99, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-04-15', \"Bo'ness\", 14.0, 1.01, true);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-02-14', \" Slamannan\", 9.6, 1.0, false);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-02-28', \" Slamannan\", 10.2, 1.03, false);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-03-11', \" Slamannan\", 16.3, 0.92, false);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-04-03', \" Slamannan\", 18.0, 0.99, false);\n"}, {result, ""}}.
