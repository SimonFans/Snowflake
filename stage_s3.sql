# create a stage to link s3

create or replace stage GainsightS3Stage
url='s3://<S3 bucket name>/'
credentials = (aws_role = '<role name>')
encryption=(type='AWS_SSE_KMS' kms_key_id = '<KMS key id>')
file_format = TSVFORMAT;

# Describe stage:
desc stage <stage name>

# List metadata file path under the stage
list @<stage name>

# Refresh External Tables
alter external table <external table name> refresh;

# Create external table
create or replace external table <external table name> (
  ACCOUNT_ID VARCHAR(16777216) as (value:c1::VARCHAR),
  ACCOUNT_NAME VARCHAR(16777216) as (value:c2::VARCHAR),
  BUDGET NUMBER(38,0) as (value:c3::NUMBER),
  EVENT_DATE DATE as (value:c4::DATE))
  with location = @<stage name>/
  auto_refresh = true
  file_format = TSVFORMAT
  pattern='GainsightTest.*[.]tsv';
