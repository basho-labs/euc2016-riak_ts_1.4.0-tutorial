Riak Time Series Tutorial
-------------------------

This is a tutorial for using Riak Time Series 1.4.0 - written for the Erlang User Conference 2016 tutorial track.

You can view this document as a prezzo at: http://remarkjs.com/remarkise

---

What you will learn
-------------------

This tutorial is all about:
* creating quantised tables
* writing data to them
* querying them

You will learn about:
* quantisation and data modeling
* writing data
* queries
  * SELECT
  * aggregation functions
     * COUNT
     * AVG/MEAN
     * etc
  * GROUP BY functions

The tutorial will use `riak-shell` to interact with riak

---

What you will not learn
-----------------------

You will not learn:
* how to install riak
* how to setup a riak cluster
* how to use the various clients (Erlang, Java, C#, NodeJS, etc, etc)

Full documentation can be found here:
http://docs.basho.com

---

Pre-requisites
--------------

To do this tutorial you need to have installed riak ts 1.4.0

There is a vagrant install which will create a scratch ubuntu virtual machine for you to use:
https://github.com/basho-labs/vagrant-riak-ts-1.4.0-plus-tutorial

Installation instructions for all platforms are here:
http://docs.basho.com/riak/ts/1.4.0/setup/installing/

If you are building from source please make devrels:
```bash
cd where/the/source/code/is
make devrels
```

Please also install this tutorial on your local machine - the tutorial uses scripted setup
```bash
git clone https://github.com/basho-labs/euc2016-riak_ts_1.4.0-tutorial.git
```

---

Start riak TS and `riak-shell`
------------------------------

In this tutorial we will be running a single node of riak to learn what the query systems does.

If you are using the vagrant box, or have installed riak TS 1.4.0 as a package simply type:
```bash
sudo riak start
sudo riak-shell
```

If you have built from source you:
```bash
/path/to/your/devrels/dev/dev1/bin/riak start
/path/to/your/devrels/dev/dev1/bin/riak-shell
```

You should see the command prompt:
```sql
Erlang R16B02_basho10 (erts-5.10.3) [source] [64-bit] [smp:2:2] [async-threads:10] [hipe] [kernel-poll:false] [frame-pointer]

version "riak_shell 1.4/sql compiler 2", use 'quit;' or 'q;' to exit or 'help;' for help
Connected...
riak-shell(1)>
```

We are ready to start.


----

Overview of `riak-shell`
------------------------

The documentation for `riak-shell` is here:
http://docs.basho.com/riak/ts/1.4.0/using/riakshell/

If you are using the vagrant setup please set the connection prompt on:

```sql
riak-shell(1)>connection_prompt on;
Connection Prompt turned on
✅ riak-shell(2)>
```

Not all shell's display unicode which is why the default is off.

We will be using a lot of `riak-shell` to make this tutorial easier.

---

`riak-shell` basics
-------------------

`riak-shell` commands have help built in.

```sql
✅ riak-shell(2)>help;
The following functions are available

Extension 'connection':
    connect, connection_prompt, ping, reconnect, show_connection, show_cookie
    show_nodes

Extension 'debug':
    load, observer

Extension 'history':
    clear_history, h, history, show_history

Extension 'log':
    date_log, log, logfile, regression_log, replay_log, show_log_status

Extension 'shell':
    about, q, quit, show_config, show_version

You can get more help by calling help with the
extension name and function name like 'help shell quit;'
✅ riak-shell(3)>
```

---

`riak-shell` help
-----------------

Let us see help for the `connection_prompt` command that we have used:
```sql
✅ riak-shell(3)>help connection connection_prompt;
Type `connection_prompt on;` to display the connection status in
the prompt, or `connection_prompt off;` to disable it.

Unicode support in your terminal is highly recommended.
✅ riak-shell(4)>
```

---

`riak-shell` history
--------------------

The history of the current shell is kept. You can display the history with:
```sql
✅ riak-shell(4)>show_history;
The history contains:
- 1: connection_prompt on;
- 2: help;
- 3: help connection connection_prompt;

✅ riak-shell(5)>
```

---

User Exercise 1 - `riak-shell` and history
------------------------------------------

Use the help system to explore all the functions in the history extension for `riak-shell`.

Use the `h` or `history` commands to replay a previous command.

**Hint**: `riak-shell` supports the use of up and down arrows.

---

`riak-shell` logging
--------------------

Using riak TS entirely from the shell would be a bit tedious as every piece of data that you want to query would need to be typed in.

We will use a the logging/replay feature of `riak-shell` to obviate that. It allows us to script and automate the creation of tables and loading of data.

```sql
✅ riak-shell(6)>help log;
The following functions are available

Extension 'log':
    date_log, log, logfile, regression_log, replay_log, show_log_status

You can get more help by calling help with the
extension name and function name like 'help log date_log;'
✅ riak-shell(7)>
```

---

Riak Time Series - Getting Started
----------------------------------

There are 3 essential things about TS and its query language that we are going to learn in this tutorial:
* creating tables
* inserting data
* running queries against the data

---

Creating tables
---------------

There are 4 things you need to do to create a table in riak TS:
* give it a name (tables can't be dropped yet - so **beware**)
* define a set of fields
* select some fields to go into the partition key
* select some fields to go into the local key

This is is the table we will create:

```sql
CREATE TABLE Exercise2
(
   id           SINT64    NOT NULL,
   time         TIMESTAMP NOT NULL,
   temperature  DOUBLE,
   PRIMARY KEY (
     (id, QUANTUM(time, 365, 'd')),
      id, time
   )
);
```

The main documentation can be found here:
http://docs.basho.com/riak/ts/1.4.0/using/planning/

---

Creating tables - tablename
---------------------------

```sql
CREATE TABLE Exercise2
...
```

The table has to have a name - at the moment tables **CANNOT** be deleted so be careful with the names you choose!

---

Creating tables - fields
------------------------

```sql
...
   id           SINT64    NOT NULL,
   time         TIMESTAMP NOT NULL,
   temperature  DOUBLE,
...
```

The field has a `name` and `type` and declaration if it can be left null.

The valid types are:
* `SINT64`
* `DOUBLE`
* `BOOLEAN`
* `VARCHAR`
* `TIMESTAMP`

Timestamps are milliseconds since the Unix Epoch - 1st Jan 1970.

---

Creating tables - keys
----------------------

```sql
...
   PRIMARY KEY (
     (id, QUANTUM(time, 365, 'd')),
      id, time
   )
...
```
The key is two parts - the first set of brackets is the **partition key** and the trailing set of parameters is the **local key**.

Here the **partition key** is `(id, QUANTUM(time, 365, 'd'))`. All data whose time field (the timestamp) is in a given year will be written to the same node.

And the **local key** is `id, time`.

**NOTE**: the key fields must be `NOT NULL`.

---

Creating tables - choosing your keys
------------------------------------

To protect the cluster from over-heavy queries the number of quanta's that a query spans is limited (the default is 5 - but you can configure this).

The max memory that a query will require is `no-of-rows-per-quanta` times `avg-size-of-row` times `max-no-of-quantas`.

We are using a quantum of 365 days here because it makes the queries easier to type - and the tutorial more pleasant.

We will look at more complex key structures later in this tutorial.

---

Exercise 2a `CREATE TABLE`
--------------------------

Create the table:
```sql
CREATE TABLE Exercise2
(
   id           SINT64    NOT NULL,
   time         TIMESTAMP NOT NULL,
   temperature  DOUBLE,
   PRIMARY KEY (
     (id, QUANTUM(time, 365, 'd')),
      id, time
   )
);
```
Then use the shell commands `SHOW TABLES;` and `DESCRIBE Exercise2;` to examine it.

if you have used vagrant run 
```sql
replay_log "/home/vagrant/tutorial/exercise2.sql";
```

(you will need to use a different path if you have installed from source.)

---

Exercise 2b `INSERT` data
-------------------------

There are two ways to insert data:
* `INSERT` statements with explicit column names
* `INSERT` statements with implicit columns based on the position of the values

```sql
INSERT INTO Exercise2 (id, time, temperature) VALUES (123, '2016-01-01', 4.5);
```

```sql
INSERT INTO Exercise2 VALUES (124, '2016-01-01', 8.5);
```

---

Exercise 2c `SELECT` data
-------------------------

```sql
SELECT * FROM Exercise WHERE id=123 AND time >= '2015' AND time =< '2017';
```

You should see:
```sql
+---+--------------------+--------------------------+
|id |        time        |       temperature        |
+---+--------------------+--------------------------+
|123|2016-01-01T00:00:00Z|4.50000000000000000000e+00|
+---+--------------------+--------------------------+
```

**Note**: the `WHERE` clause **must** cover the whole partition key with an upper and lower bound on the timestamp field.

---

**Short prezzo on Riak TS quantas and data access paths**

---

Time handling
-------------

Under the covers riak TS uses microseconds since the epoch for its timestamps.

If you try and use a time < 0 you will get an error:
```sql
riak-shell(7)>INSERT INTO Exercise2 VALUES (124, '1969-01-01', 8.5);
Error (1003): Invalid data found at row index(es) 1
riak-shell(8)>INSERT INTO Exercise2 VALUES (124, '1970-01-01', 8.5);
Error (1003): Invalid data found at row index(es) 1
riak-shell(9)>INSERT INTO Exercise2 VALUES (124, '1971-01-01', 8.5);
riak-shell(10)>
```

As well as specifying data in [ISO-8601](http://docs.basho.com/riak/ts/1.4.0/using/timerepresentations/#iso-8601-guidelines) format you can use plain microseconds since the epoch. 

These two statements are equivalent:
```sql
INSERT INTO Exercise2 (id, time, temperature) VALUES (123, '2016-01-01',  4.5);
INSERT INTO Exercise2 (id, time, temperature) VALUES (123, 1451606400000, 4.5)
```

You can find more details here:
http://docs.basho.com/riak/ts/1.4.0/using/timerepresentations/

---

Arithmetic operations
---------------------

You can perform a limited number of arithmetic operators on the data you return:
* `+`
* `-` (and negation)
* `*`
* `/`
* `(` and `)`

All of these can modify a single column at a time. 

---

Aggregation operations
----------------------

In addition you can summarise and roll up data using aggregation functions in riak TS.

The aggregation functions supported are:

* `COUNT`
* `SUM`
* `MEAN` or `AVG`
* `MIN`
* `MAX`
* `STDDEV` or `STDDEV_SAMP`
* `STDDEV_POP`

---

Using `GROUP BY` functionality
------------------------------

We can also use a `GROUP BY` clause with aggregation functions to perform analysis of the data that we return.

Details of the `GROUP BY` clause can be found here:
http://docs.basho.com/riak/ts/1.4.0/using/querying/select/group-by

Pay particular attention to the discussion of using `GROUP BY` on keyfields.

---

Exercise 3a - load data
-----------------------

Load up the exercise data in riak shell by using the replay log functionality:
```sql
replay_log "/home/vagrant/tutorial/exercise3.sql";
```

Examine the structure of the table using `SHOW TABLES;` and then `DESCRIBE sometablename;`.

See the data with the following 2 select queries:
```sql
SELECT * FROM Exercise3 WHERE id = 1 AND time >= '2015' AND time <= '2017';
SELECT * FROM Exercise3 WHERE id = 2 AND time >= '2015' AND time <= '2017';
```

Discuss the key structure.

---

The data for Exercise 3
-----------------------

This is the data that has been inserted (for reference only).

```sql
CREATE TABLE Exercise3( id SINT64 NOT NULL, time TIMESTAMP NOT NULL, place VARCHAR NOT NULL, temperature DOUBLE, pressure DOUBLE, atsealevel BOOLEAN, PRIMARY KEY ( (id, QUANTUM(time, 365, 'd')), id, time, place ));
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-01-01', "Linlithgow", 5.2, 1.01, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-02-01', "Linlithgow", 6.4, 1.02, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-01', "Linlithgow", 11.4, 1.15, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-09', "Linlithgow", 16.2, 0.98, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-04-15', "Linlithgow", 14.5, 1.0, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-01-02', "Bo'ness", 5.1, 1.02, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-02-01', "Bo'ness", 6.6, 1.07, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-01', "Bo'ness", 10.2, 1.13, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-03-07', "Bo'ness", 16.5, 0.99, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (1, '2016-04-15', "Bo'ness", 14.0, 1.01, true);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-02-14', " Slamannan", 9.6, 1.0, false);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-02-28', " Slamannan", 10.2, 1.03, false);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-03-11', " Slamannan", 16.3, 0.92, false);
INSERT INTO Exercise3 (id, time, place, temperature, pressure, atsealevel) VALUES (2, '2016-04-03', " Slamannan", 18.0, 0.99, false);
```

---

Exercise 3b Arithmetic
----------------------

Convert the pressure values from **bar** to **lb/sq inch**:
```sql
SELECT id, place, 14.5 * pressure FROM Exercise3 WHERE id = 1 AND time >= '2015' AND time <= '2017';
``` 

Read about the limitations and options of arithmetic here and have a go yourself:
http://docs.basho.com/riak/ts/1.4.0/using/querying/select/arithmetic-operations/

Now run some more arithmetic operations on the example data.

---

Exercise 3c Aggregation
-----------------------

Aggregation functions are used in the `SELECT` clause of a SQL statement:
```sql
SELECT COUNT(id) from Exercise3 WHERE id = 1 and time >= '2015' and time <= '2017';
```

Read about the limitations and options of using aggregation functions here:
http://docs.basho.com/riak/ts/1.4.0/using/querying/select/aggregate-functions/

Now run some more aggregration functions on the data

---

Exercise 3d `GROUP BY`
----------------------

```sql
SELECT place, AVG(temperature) FROM Exercise3 WHERE id = 1 AND time >= '2015' AND time <= '2017' GROUP BY place;
```

Read about the limitations and options of using `GROUP BY` here:
http://docs.basho.com/riak/ts/1.4.0/using/querying/select/group-by/

Pay particular attention to the data modeling aspects.

---

Exercise 4 - non-time quantised keys
------------------------------------

Load the data by running:
```sql
replay_log "/home/vagrant/tutorial/exercise4.sql";
```

Examine the table structure using `SHOW TABLES` and `DESCRIBE Exercise4`.

Run the SQL:
```sql
SELECT * FROM Exercise5 WHERE firstname = 'Alice' AND lastname = 'Anderson';
```

**Discussion Question**: think about what could go wrong with a data model based on unquantised data.

Final exercise
--------------

Design a data model for a personal use case. Things to consider are:
* what fields are in the partition and local keys
   * are they the same?
* what functions will you use?
* do you need to group results?
* how will the data hotspot?

---

FIN
