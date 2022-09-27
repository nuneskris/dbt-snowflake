
create or replace database ext_tables;

// ##### Create an external table from csv files located in S3 where we can 

// Step 1: Create an a fileformat 
create or replace file format my_csv_format
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = true;
    

// Step 2: create a stage which bascially maps in a location in the storage
    
create or replace stage my_s3_stage url = 's3://mybucket.nuneskris/SNWFLK'
credentials=(aws_key_id='AKIAYLI7Q37HGCUPN5ZW' aws_secret_key='+swdKa7tfvZx7ty+r+bMf3EBq7sRnZNeZ2KyWHmE')
file_format = my_csv_format;

// for testing I am dumping data into the the location
COPY into @my_s3_stage/HOSTS
from AIRBNB.RAW.RAW_REVIEWS
HEADER=TRUE
OVERWRITE=TRUE;

desc stage my_s3_stage; // desctibes the stage. this will be important for non csv files.

list @my_s3_stage;

// this can be done only for csv I believe.
select t.$1, t.$2, t.$3, t.$4, t.$5 from @my_s3_stage (file_format => 'my_csv_format') t limit 100;

// we can create an external table 
create or replace external table ext_hosts_data(
listing_id varchar AS (value:c1::varchar),
review_date DATETIME AS (value:c2::DATETIME),
reviewer_name varchar AS (value:c3::varchar),
comments varchar AS (value:c4::varchar),
sentiment varchar AS (value:c5::varchar))
with location = @my_s3_stage
auto_refresh = false
file_format = (format_name =  'my_csv_format');

desc table ext_hosts_data;

select * from ext_hosts_data limit 10;

create or replace external table ext_hosts_data_q(
listing_id varchar AS (value:c1::varchar))
with location = @my_s3_stage
auto_refresh = false
file_format = (format_name =  'my_csv_format');

select * from ext_hosts_data_q limit 10;

//#########################   JSON   #######################

CREATE  OR REPLACE  FILE FORMAT  my_json_format TYPE =  JSON ;

create or replace stage my_s3_stage_json url = 's3://awsgluestudy-kris/examples/us-legislators/all'
credentials=(aws_key_id='AKIAYLI7Q37HGCUPN5ZW' aws_secret_key='+swdKa7tfvZx7ty+r+bMf3EBq7sRnZNeZ2KyWHmE')
file_format = my_json_format;

select t.$1 from @my_s3_stage_json (file_format => 'my_json_format') t limit 100; //. we can have only one column for in json. 

desc stage my_s3_stage_json;

Select * from @my_s3_stage_json/events.json limit 1;
//{   "classification": "general election",   "end_date": "1900",   "id": "Q4450263",   "identifiers": [     {       "identifier": "Q4450263",       "scheme": "wikidata"     }   ],   "name": "United States House of Representatives elections, 1900",   "start_date": "1900" }

select * from @my_s3_stage_json; 

select metadata$filename, metadata$file_row_number, parse_json($1) from @my_s3_stage_json;

select parse_json($1):classification 
from @my_s3_stage_json limit 10;