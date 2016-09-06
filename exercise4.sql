{{command, "CREATE TABLE Exercise4 (firstname VARCHAR NOT NULL, lastname VARCHAR NOT NULL, attribute VARCHAR NOT NULL, value DOUBLE, PRIMARY KEY ((firstname, lastname), firstname, lastname, attribute));\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise4 (firstname, lastname, attribute, value) VALUES (\"Alice\", \"Anderson\", \"height\", 170.2);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise4 (firstname, lastname, attribute, value) VALUES (\"Alice\", \"Anderson\", \"weight\", 65.0);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise4 (firstname, lastname, attribute, value) VALUES (\"Alice\", \"Anderson\", \"shoe size\", 3.0);\n"}, {result, ""}}.
{{command, "INSERT INTO Exercise4 (firstname, lastname, attribute, value) VALUES (\"Alice\", \"Anderson\", \"waist\", 28.0);\n"},{result, ""}}.
