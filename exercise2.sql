{{command, "CREATE TABLE Exercise2(id SINT64 NOT NULL, time TIMESTAMP NOT NULL, temperature DOUBLE, PRIMARY KEY ((id, QUANTUM(time, 365, 'd')), id, time));\n"}, {result, ""}}.
{{command, "SHOW TABLES;\n"}, {result, "+---------+
|  Table  |
+---------+
|Exercise2|
+---------+

"}}.
{{command, "DESCRIBE Exercise2;\n"}, {result, "+-----------+---------+-------+-----------+---------+--------+----+
|  Column   |  Type   |Is Null|Primary Key|Local Key|Interval|Unit|
+-----------+---------+-------+-----------+---------+--------+----+
|    id     | sint64  | false |     1     |    1    |        |    |
|   time    |timestamp| false |     2     |    2    |  365   | d  |
|temperature| double  | true  |           |         |        |    |
+-----------+---------+-------+-----------+---------+--------+----+

"}}.
