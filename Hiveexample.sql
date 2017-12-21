hive>SHOW DATABASES;

hive>USE PRAVEEN;

hive>SHOW  TABLES;

To get the DDL of Hive
-----------------------

show create table <TABLE_name>



Note :- Hive table always in samll letter .
CREATING INTERNAL TABLE
-----------------------
-----------------------

CREATE TABLE IF NOT EXISTS sales 
(
 TRANSACTION_DATE	STRING	
,PRODUCT			STRING	
,PRICE				INT	
,PAYMENT_TYPE		STRING	
,NAME				STRING	
,CITY				STRING	
,STATE				STRING	
,COUNTRY			STRING	
,ACCOUNT_CREATED	STRING	
,LAST_LOGIN			STRING	
,LATITUDE			DOUBLE	
,LONGITUDE			DOUBLE	

)
COMMENT "SALES DETAILS"

ROW FORMAT DELIMITED

FIELDS TERMINATED BY ","

STORED AS TEXTFILE;

LOADING  DATA FROM HDFS
-----------------------
-----------------------

LOAD DATA INPATH "dbfs:/FileStore/tables/6e58v70k1505820322221/SalesJan2009.csv" INTO TABLE sales;

Note:- Since loading the data from hdfs to hive, content from hdfs permanently copied to hive. 
       display(dbutils.fs.ls("dbfs:/user/hive/warehouse/praveen.db/sales"))

DROP TABLES
-----------
-----------

DROP TABLE SALES; 

Note:- Since "SALES" is internal table , data from Hive Warehouse will be deleted permanently after dropping table;

INTERNAL TABLE WITH LOCATION
----------------------------
----------------------------

CREATE  TABLE IF NOT EXISTS salesinternalwithlocation (

TRANSACTION_DATE	STRING	
,PRODUCT			STRING	
,PRICE				INT	
,PAYMENT_TYPE		STRING	
,NAME				STRING	
,CITY				STRING	
,STATE				STRING	
,COUNTRY			STRING	
,ACCOUNT_CREATED	STRING	
,LAST_LOGIN			STRING	
,LATITUDE			DOUBLE	
,LONGITUDE			DOUBLE	


)

COMMENT "SALES DETAILS"

ROW FORMAT DELIMITED

FIELDS TERMINATED BY ","

STORED AS TEXTFILE

LOCATION "dbfs:/FileStore/tables/qeq3e6ow1505821631607"

;


Note:- When creating internal table with location , then content will not copied to hive datawarehouse.
Note :- Creating internal table with location works like extrenal table.

CREATING EXTERNAL TABLE
-----------------------
-----------------------
Note:- It is mandatory to have Location in extrnal table.
Note:- It is directory which contain file where location should point not on file.
Note:- External table is not copied in /user/hive/warehouse/praveen.db/......

CREATE EXTERNAL TABLE IF NOT EXISTS salesext (

TRANSACTION_DATE	STRING	
,PRODUCT			STRING	
,PRICE				INT	
,PAYMENT_TYPE		STRING	
,NAME				STRING	
,CITY				STRING	
,STATE				STRING	
,COUNTRY			STRING	
,ACCOUNT_CREATED	STRING	
,LAST_LOGIN			STRING	
,LATITUDE			DOUBLE	
,LONGITUDE			DOUBLE	


)

COMMENT "SALES DETAILS"

ROW FORMAT DELIMITED

FIELDS TERMINATED BY ","

STORED AS TEXTFILE

LOCATION "dbfs:/FileStore/tables/mheveacv1505820757368"
;

creating another extrenal table salesextbkp from the same file which is used to create extrenal table salesext.
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS salesextbkp (

TRANSACTION_DATE	STRING	
,PRODUCT			STRING	
,PRICE				INT	
,PAYMENT_TYPE		STRING	
,NAME				STRING	
,CITY				STRING	
,STATE				STRING	
,COUNTRY			STRING	
,ACCOUNT_CREATED	STRING	
,LAST_LOGIN			STRING	
,LATITUDE			DOUBLE	
,LONGITUDE			DOUBLE	


)

COMMENT "SALES DETAILS"

ROW FORMAT DELIMITED

FIELDS TERMINATED BY ","

STORED AS TEXTFILE

LOCATION "dbfs:/FileStore/tables/mheveacv1505820757368"
;

Note :- If Internal table gets created on same file which is reffred by extrenal table,
then file would move hive datawarehouse after internal table get loaded with data from file path . So external table will empty,
since file is not available where location is pointing while creation.


Q.How to Insert Dynamically into Partitioned Hive Table?
--------------------------------------------------------
A.If we want to do manually multi Insert into partitioned table, we need to set the Dynamic partition mode to nonrestrict as
  follows:
  
hive> set hive.exec.dynamic.partition.mode=nonstrict;


PARTITION TABLE
---------------
CREATE TABLE IF NOT EXISTS salespartition (

TRANSACTION_DATE	STRING	
,PRODUCT			STRING	
,PRICE				INT	
,NAME				STRING	
,CITY				STRING	
,STATE				STRING	
,COUNTRY			STRING	
,ACCOUNT_CREATED	STRING	
,LAST_LOGIN			STRING	
,LATITUDE			DOUBLE	
,LONGITUDE			DOUBLE	


);


Note :- Partition table only compatible with textfile
CREATE TABLE STUDENT
(
STD_ID INT,
STD_NAME STRING,
STD_GRADE STRING
)
PARTITIONED BY (COUNTRY STRING, CITY STRING)
row format delimited
fields terminated by ","
STORED AS TEXTFILE;


Truncate table
--------------


truncate table student;


Note: If table is not partitioned then , it will delete file as well from hive warehouse.
      But if table is partitoned , truncate will not delete file from hive warehouse.

Inserting DATA(The Multi  Dynamic Insert Query  to Partitioned table  :)
--------------
--------------

Note: If table is partitioned but while inserting , if partition is not mentioned , it automatically detects the partition.

insert into TABLE STUDENT VALUES 
(101,'ANTO','6TH','USA', 'NEWYORK'),
(101,'kumar','6TH','USA', 'BOSTON'),
(102,'jaak','7TH','USA', 'NewLONDON');
--------------------------------------
OR

INSERT INTO TABLE STUDENT PARTITION(COUNTRY,CITY)
(101,'ANTO','6TH','USA', 'NEWYORK'),
--------------------------------------

insert into TABLE STUDENT partition(country,city) VALUES (101,'kumar','6TH','USA', 'BAHAMAS');




How to Insert statically Into Partitioned Table?

If we would want to insert statically into partitioned table we need to declare Partition value followed by the partition keyword (For Example : PARTITION(COUNTRY=’USA’)) unlike the above one which we have seen as part of dynamic insert into partitioned table.


How to Insert statically Into Partitioned Table?
-------------------------------------------------
-------------------------------------------------
If we would want to insert statically into partitioned table we need to declare Partition value 
followed by the partition keyword (For Example : PARTITION(COUNTRY='INDIA',,CITY='BOXE')) 
unlike the above one which we have seen as part of dynamic insert into partitioned table.
	
INSERT INTO TABLE STUDENT PARTITION(COUNTRY='USA',CITY='BOXE')
VALUES 
(101,'ANTO','6TH'),
(102,'JavaChain'),
(101,'kumar','6TH'),
(102,'jaak','7TH');



************************

When Hive tries to “INSERT OVERWRITE” to a partition of an external table under existing directory, depending on whether the partition definition already exists in the metastore or not, Hive will behave differently:

1) if partition definition does not exist, it will not try to guess where the target partition directories are (either static or dynamic partitions), so it will not be able to delete existing files under those partitions that will be written to

2) if partition definition does exist, it will attempt to remove all files under the target partition directory before writing new data into those directories

************************

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Remember for date column in hive, should pass value as 'yyyy-mm-dd'    !.e '2017-10-29', see below example
------------------------------------------------------------------------------------------------------------

create table if not exists employee(

  employee_name String,
  salary   bigint,
  doj date


)

insert into employee values('Praveen',100000,'2017-10-27');


------------------------


By defuault data in hive stored in textfile


create table if not exists employee(

  employee_name String,
  salary   bigint,
  doj date


)


show create table employee


CREATE TABLE `employee`(`employee_name` string, `salary` bigint, `doj` date) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' WITH SERDEPROPERTIES ( 'serialization.format' = '1' ) 
STORED AS 
INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat' 
TBLPROPERTIES ( 'transient_lastDdlTime' = '1509094832' )


--------------------------
--------------------------
--------------------------

Parquet
-------

Parquet stores binary data in a column-oriented way, where the values of each column are organized so that they are all adjacent, enabling better compression.
It is especially good for queries which read particular columns from a “wide” (with many columns) table
since only needed columns are read and IO is minimized. Read this for more details on Parquet.


****Note : - Date datatype is not allowed in parquet

create table if not exists employeeparquet(

  employee_name String,
  salary   bigint,
  doj String


)

stored as parquet;



show create table employeeparquet

CREATE TABLE `employeeparquet`(`employee_name` string, `salary` bigint, `doj` string) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' WITH SERDEPROPERTIES ( 'serialization.format' = '1' ) 
STORED AS 
INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat' 
TBLPROPERTIES ( 'transient_lastDdlTime' = '1509095578' )

 
Avro
----


Avro is one of the preferred data serialization systems because of its language neutrality.
Due to lack of language portability in Hadoop writable classes, Avro becomes a natural choice because of its ability to handle multiple
 data formats which can be further processed by multiple languages.
Avro is also very much preferred for serializing the data in Hadoop.
It uses JSON for defining data types and protocols and serializes data in a compact binary format.


create table if not exists employeeavro(

  employee_name String,
  salary   bigint,
  doj date


)

stored as AVRO


show create table employeeavro


create table if not exists employeeavro
STORED AS avro
tblproperties(
  
'avro.schema.literal'='{
"name":"myRecord",
"type":"record",
"fields":[
 {"name":"EmployeeName","type":"string"},
 {"name":"salary","type":"int"}, 
 {"name":"doj","type":"string"}                            
]}'
)



Note :- Avro does not have date and bigint data type.


We cannot insert the data into avro table by simple insert statement.

There are two ways two load data into avro
1.
There are 2 methods by which the data can be inserted into an Avro table:
1. If we have a file with extension ‘.avro’ and the schema of the file is the same as what you specified, then you can directly import the file using the command

2. insert overwrite table employeeavro select * from employee


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

ROW FORMAT
-------------------------------------------------------------------------------------------------------


create table if not exists employee(

  employee_name String,
  salary   bigint,
  doj date


)

row format delimited
fields terminated by ','
lines terminated by '\n'

stored as textfile;


CREATE TABLE `employee`(`employee_name` string, `salary` bigint, `doj` date) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' WITH SERDEPROPERTIES ( 'line.delim' = ' ', 'field.delim' = ',', 'serialization.format' = ',' ) 
STORED AS 
INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat' 
TBLPROPERTIES ( 'transient_lastDdlTime' = '1509101445' )


Go and Learn link on iteveristy for -> DataWarehouse using Hadoop Eco System.
-----------------------------------------------------------------------------


Hadoop Eco System.
------------------

Hadoop Core Componenets:
------------------------

1.Hdfs and map reduce
2.Metastore/Driver
3.Hadoop Jar

connect to mysql 
----------------


mysql -u root -p<password>


connect to hive prompt
-----------------------

hive


check directory in hive
------------------------

hive> dfs -ls /user/hive/warehouse/;




--create database if not exists
create database if not exists datasample; 

-- create table 

create table if not exists datasample.deckofcards(
color string,
suit string,
pip string

)
row format delimited 
fields terminated by '|' 
stored as textfile;

-- Load data in table

LOAD DATA LOCAL INPATH '/home/oracle/datasample/deckofcards.txt' INTO table DECKOFCARDS;


--TO CHECK FILE CONTENT IN HIVE TABLE FILES

hive> dfs -cat /user/hive/warehouse/datasample.db/deckofcards/deckofcards.txt;

hive> 
Note :- When we submit qury in hive, it submits as map reduce job.
 -- It generates Java code and compiled as jar file and that is submitted as map - reduce job.
 
 
 Example:\
 
 key     name
--------------
1       name1
2       name2
3       3


select sum(name) from test_table;
Output : 3.0

/*Inside the GenericUDAFEvaluator() you can find case STRING: return new GenericUDAFSumDouble(); 
at line 66 and 67 , which means depending on the primitive type/data type of argument passed, 
respective aggregation is being done. i.e, for name1,name2(strings) corresponding values 
for aggregations are from new DoubleWritable(0);
So => 0.0+0.0+3 = 3.0*/

hive configuration file
-----------------------

cat /etc/hive/conf/hive-site.xml



To login into metastore
-----------------------

mysql -u root -p<password>

hive>use hive;
hive>show tables;
hive>select * from TBLS LIMIT 2;
hive>select * from TBLS where TBL_NAME = 'deckofcards';

Note 1: - command line interface we are using "hive >" is called CLI	
Note 2:- Hue is web interface.


-- Executing hive without CLI

hive -e " use datasample; select * from deckofcards";


--To launch all parameters used by hive

hive> set;

-- change the parameters(for particular session)
hive> set mapreduce.job.redcuces=2;
hive> set mapreduce.job.reduces;

--to modify the parameter of all session used by particular user

1. Go to home directory > cd /home/oracle/
2. vi .hiverc (hidden file ls -a)
>set mapreduce.job.redcuces=2; (write in .hiverc file and save)

Note :- to verify launch again hive and check set mapreduce.job.reduces;(It should be mapreduce.job.redcuces = 2 )


To execute multiple command , without executing CIL
---------------------------------------------------

hive -f " use datasample; 
select * from deckofcards";

Log file in hive
----------------
cat /tmp/oracle/hive.log

Change the hive log
-------------------

cd /etc/hive/conf/hive-log4j.properties

Hive log files properties can be verride
----------------------------------------

-hive.log.dir
-hive.log.file
-hive.querylog.location


Apache Hive - 01 Write and Execute a Hive Query
-----------------------------------------------


Date format in hive
-------------------
INSERT INTO table1 values ('Clerk#0008000', '2016-01-01');




Hive partition table
---------------------

 create table if not exists city(
 city_name string,
 pincode Int
 )
partitioned by (country string ,state string)
row format delimited fields terminated by ','
stored as textfile;


Insert into partitioned table.
-------------------------------


 Method1
 -------
 insert into table city partition (country = 'INDIA',state = 'KA') values('Bangalore',12121);
  
  --This is example of static partition
  
 
 Method2
 -------
 set hive.exec.dynamic.partition.mode= nonstrict  --changing strict to nonstrict because not a single
 --partition was static.

 insert into table city partition (country ,state) values('Palo Alto',24346,'USA','CA');
 
   --This is example of dynamic partition

 
 Note :- 
 
 If there is already country called 'USA' is given , then no need to change the mode to nonstrict.
 
 If a partition column value is given, we call this a static partition, otherwise it is a dynamic partition. Each dynamic partition column has a corresponding input column from the select statement. 
 This means that the dynamic partition creation is determined by the value of the input column.
 

  insert into table city partition (country = 'USA',state) values('Ontario',24346,'CA');

  --This is example of static partition

 
 check the file:- 
 --------------
 hive> dfs -cat /user/hive/warehouse/datasample.db/city/country=INDIA/state=KA/*;

Configuration property 			  Default               Note
----------------------------      -------	            -----
 hive.exec.dynamic.partition       true                 Needs to be set to true to enable dynamic partition inserts.
 
 hive.exec.dynamic.partition.mode   strict              In strict mode, the user must specify at least one static partition in case the user accidentally overwrites all partitions, 
														in nonstrict mode all partitions are allowed to be dynamic
 
 
 */
 
 1.) sqoop-list-databases --connect jdbc:mysql://localhost/sample --username root --password welcome1
 2.) sqoop-list-tables --connect jdbc:mysql://localhost/sample --username root --password welcome1
 3.) sqoop import --connect jdbc:mysql://localhost/sample --username root --password welcome1 --table emp -m 1 --driver com.mysql.jdbc.Driver
 4.) sqoop import --connect jdbc:mysql://localhost/sample --username root -P welcome1 --table emp -m 1 --driver com.mysql.jdbc.Driver
 5.) sqoop import --options-file /home/oracle/datasample/param.txt --table emp -m 1 --driver com.mysql.jdbc.Driver
  
cat param.txt
--connect
jdbc:mysql://localhost/sample
--username
root
--password
welcome1

  
  
    -- It will be created under same user from where sqoop command is getting fired.
	-- If the file with table name already exist , it will through error
    	





 