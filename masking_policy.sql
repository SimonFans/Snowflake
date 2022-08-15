--(1) Currently, you have to add slack user_id manually. In future, you can call Slack API to do this once you set up permission ready. 
create or replace table slack_users as 
select 'Uxxx' as slack_user_ID, 
       'zhao' as slack_user_name, 
       'zhao@xxx.com' as user_email,
       'APAC' as user_region,
       current_timestamp as update_at
union all 
select 'Uxxx' as slack_user_ID, 
       'Niu' as slack_user_name,
       'niu@xxx.com' as user_email,
       'North America' as user_region,
       current_timestamp as update_at

--(2) If you consider slack_user_ID is PII data, you can create a masking policy to hide that. It's only visible to the role owner. 
-- This is the current masking policy in dev. Only role x_ROLE can see the full slack_user_ID. 
create or replace masking policy slack_users_policy as (val string)
returns string -> 
case when current_role() in ('x_ROLE') then val
Else regexp_replace(val,'[a-zA-z]','*')
End; 

--(3) Alter masking policy on other new columns
-- format: alter table <table name> modify column <column name> set masking policy <policy name>;
alter table ODS.SLACK_USERS modify column slack_user_ID set masking policy slack_users_policy;

--(4) Check policy metadata
-- format: select * from table(information_schema.policy_references(policy_name => '<policy name>'));
select * from table(information_schema.policy_references(policy_name => 'ODS.SLACK_USERS_POLICY'));
