{% docs doc_source_extaction_stage %}
 .....
 # this we can reuse documentation via an md file 'docs doc_source_extaction_stage' within jinga
 - Made this stage an ephermeral view in the dbt_project.yml.
 - This view exposes the snowflake tables for down stream processes.
 - minor column name changes.
 - since this view is ephermeral the columns dont seem to appear in the documentaion automatically.
{% enddocs %}