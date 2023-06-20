# Intro
This project has been designed as a package that can be read into other dbt projects. Its purpose is to provide generic macros/models that can be recycled and reused within other dbt projects.     
In order to install this package within a dbt project, run `dbt deps` within the project directory. 

# Macros
## Macro 1 - parse_dbt_results
This macro is used to capture results about a project run, such as how long each model takes to run, if tests pass or fail, etc. This macro looks at the results node and returns a dictionary of all the requested results data. It can be ran **on run end** in the `dbt_project.yml` file (see `visitor_events_dbt_model`, for example). 

## Macro 2 - log_dbt_results
This macro runs `parse_dbt_results` (see above) to pull out test results and then constructs an insert into SQL statement to insert these values into the dbt_results table. As noted above, this macro is ran on-run-end of the project in order to capture test results of all models, tests, etc. In order for this to work, ensure that the `dbt_results` model exists in the project. 

