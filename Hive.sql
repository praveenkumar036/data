Functions
---------
SHOW FUNCTIONS;
DESCRIBE FUNCTION <function_name>
DESCRIBE FUNCTION EXTENDED <function_name>


Relational Operators.
---------------------

 A = B,
 A != B ,
 A<B ,
 A<=B ,
 A>B ,
 A>=B ,
 A IS NULL,
 A IS NOT NULL,
 A LIKE B ,
 A RLIKE B, --NULL if A or B is NULL, TRUE if any substring of A matches the java regular expression B otherwise FALSE.
 A REGEXP B -- Same as RLIKE

HiveQL DDL Statements are documented here:


. CREATE DATABASE/SCHEMA , TABLE , VIEW , FUNCTION, INDEX
. DROP DATABASE/SCHEMA , TABLE , VIEW , INDEX
. TRUNCATE TABLE
. ALTER DATABASE/SCHEMA , TABLE, VIEW
. MSCK REPAIR TABLE ( or ALTER TABLE RECOVER PARTITIONS)
. SHOW DATABASES/SCHEMAS, TABLES, TBLPROPERTIES, VIEWS, PARTITIONS , FUNCTIONS , INDEX[ES], COLUMNS CREATE TABLE
. DESCRIBE DATABASE/SCHEMA , table_name, view_name

TABLE CREATION
--------------

CREATE [TEMPORARY,EXTERNAL] TABLE [IF NOT EXISTS] <table_name> 
(
<column_name> <data_type> [COMMENT <column_coment>],
<column_name1> <data_type [COMMENT <column comment>]
.....,
[<constraint_specification>] -- PRIMARY KEY (col_name,...) DISABLE NONVALIDATE, CONSTRAINT <constraint_name> FOREIGN KEY (col_name,...) DISABLE NON VALIDATE
)
[COMMENT <table comment>]
[ROW FORMAT <row_format>] --eg:- row format delimited fields separated by "|"
[STORED AS <file_format>] -- file_format : SEQUENCEFILE, TEXTFILE, RCFILE, ORC, PARQUET, AVRO, INPUTFORMAT
[LOCATION hdfs_path]


-- Table, partition and buckets are the parts of HIVE data modeling.


What is partition?

Hive partitions is a way to organizes tables into partitions by dividing tables into different parts based on partition keys.

Link : https://www.guru99.com/hive-partitions-buckets-example.html

Eg:- 

1. CREATE TABLE ALL_STATES
-- create table all_states(state String, District string , Enrolments String)
   row format delimited fields separated by ",";
   
2. LOADING DATA INTO CREATED TABLES ALL STATES

-- LOAD DATA LOCAL INPATH '/home/hduser/Desktop/AllStates.csv' INTO ALL_STATES;

3. CREATION OF PARTITION TABLE

-- create table state_part(District string, Enrolments string) partitioned by (state string)


4. For PARTITION WE HAVE TO SET THIS Property

-- SET HIVE.DYNAMIC.PARTITION.MODE = NONSTRICT


5. LOADING DATA INTO PARTITIONS

-- insert overwrite table state_part partition(state);
-- select district, enrolements, state from allstates;



INTERNAL TABLE
--------------

-> Internal table is tightly coupled in nature. In this type of table first we have to create table and load the data.
-> We can call this one as data on schema.
->By dropping this table,  both data and metdata in schema of this table shall removed.The stored location of this table at /user/hive/warehouse







CRETAE TABLE PAGE_VIEW(
 viewTime int,
 userid bigint,
 page_url string,
 ip string
)
COMMENT 'This is Page View table'
PARTITIONED BY (dt string, country string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\001'
stored as sequencefile;


EXTERNAL TABLE
--------------
--------------

-> External table is loosely coupled in nature. Data will be available in HDFS. This table is going to create on HDFS data.
-> External table is schema on data.
-> At the time of dropping the table it drops only the schema, the data will be still available in HDFS as before.
-> External table provide an option to create multiple schemas for the data stored in HDFS instead of deleting 
   the data every time whenever schema updates.


When to choose external table
-----------------------------


. If processing data available in HDFS.
. Useful when the files are being used outside the hive.


eg: 

 CREATE EXTERNAL TABLE page_view(
 viewTime int,
 userid bigint,
 page_url string,
 reffereer_url string,
 ip string comment 'ip address of the user',
 country string comment 'country of the origination'
 )
 comment 'This is the staging page view table'

 row format delimited fields terminated by '\054'
 stored as textfile
 
location '<location_path.>'



CTAS - Create table as select
-----------------------------

Table can also be created and populated by the result of query in one statement.


CTAS has three restrictions.
----------------------------

. The Target table cannot be a partitioned table.
. The Target table cannot be an extrenal table.
. The target table cannot be list bucketing table.


eg:


  CREATE TABLE new_key_value_store 
  ROW FORMAT SRED "org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe"
  STORED AS RCFile
  AS
	SELECT (key % 1024) new_key, concat(key, value) key_value_pair
	FROM key_value_store
	SORT BY new_key, key_value_pair;

	

CREATE TABLE LIKE EXAMPLE

The like from the CREATE TABLE allows you to copy the existing table definition exactly to new table(without copying its data).
In contrast to CTAS, the statement below creates new table whose definition exactly matches the existing table in all particulars other than 
the name.


CREATE TABLE empty_key_value_store   like key_value_store;



What is Buckets?
----------------

Buckets in hive used for segregrating of hive table-data into multiple files or directories.It is used for efficient querying.

. The data !.e is present in the partitions can be divided further into buckets.
. The division is performed based on hash of particular columns that we selected in the table.
. Bucket use some form of hashing alogorithm at back end to read  each record and place it into buckets.
. In hive we have to enable buckets by using the set.hive.enforce.bucketing = true;

CREATE TABLE page_view(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User')
 COMMENT 'This is the page view table'
 PARTITIONED BY(dt STRING, country STRING)
 CLUSTERED BY (uerid) SORTED BY (viewTime) INTO 32 buckets
  ROW FORMAT DELIMITED
   FIELDS TERMINATED BY '\001'
   COLLECTION ITEMS TERMINATED BY '\002'
   MAP KEYS TERMINATED BY '\003'
 STORED AS SEQUENCEFILE;


set hive.enforce.bucketing = true;  -- (Note: Not needed in Hive 2.x onward)
FROM user_id
INSERT OVERWRITE TABLE user_info_bucketed
PARTITION (ds='2009-02-25')
SELECT userid, firstname, lastname WHERE ds='2009-02-25';
 