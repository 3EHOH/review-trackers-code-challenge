
## The Stack

- Language: Ruby
- Framework: [sinatra](http://www.sinatrarb.com/)
- PSQL

## To Run:
- `ruby rtchallenge.rb`

## Requirements:
- `ENV['USER']='user'` user to login with
- `ENV['USER_PW']='password1'` password to login with
- `ENV['PT_TOKEN']='d133a1b130e414e794958136fd6e8a76'`
- `ENV['PT_PROJECTS']='2088251, 2088250'` pivotal projects
- `ENV['RELEASE_LABEL']=''` Name of current release tag by PM.

## Additional Info:

### [Pivotal login](https://www.pivotaltracker.com/signin):
- user: `nate+test1@reviewtrackers.com`
- pw: `Password1!`


## ADDED INSTRUCTIONS TO SETUP:
- set those above-stated environment variables at the command line; you can check them via irb
- launch postgresql 
- `CREATE DATABASE rtchallenge;`
- `rake db:migrate`
- `bundle init` if not done already



Ch-ch-changes:

-----------
CONTROLLERS: 
-----------
- separate controllers/routes into home_, product_owner_, release_, and sprint_ 
- return JSON from API endpoints
- created additional controllers for functionality around product owners and releases
- known issues with ^above^: release endpoints not connecting to database properly, though a release table was added

-----
VIEWS:
-----
- no more generating views in helpers
- extracted css into its own file, also added bootstrap 
- use `layout.erb` in which all other views are populated so we can stay DRY
- separated views into /home, /product_owners, and /sprint_releases subdirectories 
- added headers for clarity of what a user is looking at in these tables 
- created a navigable home page
- added functionality to create, edit, and delete product owners
- known issue with the ^above^: edit and delete routes not working properly, but an effort was made

--------
DATABASE / MODEL:
--------
- added unique constraint to `POID` field
- added a `release` table and model with the intent to allow a user to set the current release so that the `release_label` environment
variable, among other things, could be set
- known issue with the ^above^: was not able to access the release table via the api. May have botched migration.

-------
HELPERS:
-------
- separate into auth_, general_, label_, pivotal_, and sprint_
- condensed and simplified logic around getting stories/owners to populate the original table
- renamed functions/variables for clarity. ex: `owners` to `product_owners`, `update_users` to `populate_owners`,
 `release_tix_html` to `get_combined_stories_and_owners`
- include '/projects/' in the pivotal_url variable, because it was appended every time anyway

----------
ADDITIONAL:
----------
- moved virtually everything out of `rtchallenge.rb` and turned it into a module
- added spaces within functions for increased readability
- created a `base_url` variable to replace `request.host_with_port`
- added documentation, which you're reading



- DOCUMENTATION of the original program:

-----------------
The main workflow:
-----------------

1) The '/' endpoint directs to the `home.erb` template. (It first checks whether a user is authorized, which will be covered
later in this doc.)

2) That in turn calls the `generate_home` helper method, which simply calls `release_tix_html`, which outputs an HTML 
list of stories - their url, name, owners, current state, and points. 

3) The `stories` data it uses comes from a call to `get_release_tickets`.

4) `get_release_tickets` utilizes a `label` variable output from `get_release_label` -- which is populated by the label from
 `ENV['RELEASE_LABEL']` and a project id from `ENV['PT_PROJECTS']`. It iterates over the project ids in the labels, and 
 uses each id and label name to populate a query to the Pivotal `/projects/` endpoint. The `story` data returned from each
 of those calls is inserted into a `stories` array which the `get_release_tickets` method returns, as stated in the above step.
 
-----------------
Additional steps:
-----------------
 
1) The home page has a link to the `/update_sprint` endpoint, which calls `update_current_iteration`.

2) `update_current_iteration` first calls `update_users`. 

3) `update_users` iterates over the elements in `ENV['PT_PROJECTS']`, and uses the `id`s therein to make calls to the 
Pivotal `/projects` endpoint. Those calls return `ownerDatum`, which creates `Owner` records in the Postgres database, 
if they don't already exist.

4) `update_current_iteration` then populates a `projects` variables with `ENV['PT_PROJECTS']`, which is iterated over, and
used to populate a `url` variable with a call to the Pivotal `/projects/` endpoint, which retrieves a `stories` variable. 

5) That `stories` variable is iterated over, and a call to `add_label(project, story, ENV['RELEASE_LABEL'])` is made, which
makes a post request to add a lavel the Pivotal `/projects/` endpoint, if `label_present?` returns false.

---------
Security:
---------
1) Both of the endpoints first utilize the `protected!` function, which calls `authorized?`, which checks credentials based 
on the `[ENV['USER']` and `ENV['USER_PW']` environment variables.