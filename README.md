<h1>Install instructions:</h1>

Clone the repository.

Navigate to the root of the project and execute “composer install”.

Add the following records to your hosts file (Included hosts for static sites):

127.0.0.1	site1.assignment.loc<br>
127.0.0.1	static.site1.assignment.loc<br>
127.0.0.1	site2.assignment.loc<br>
127.0.0.1	static.site2.assignment.loc<br>
127.0.0.1	site3.assignment.loc<br>
127.0.0.1	static.site3.assignment.loc

Execute “lando start” to start up the project.

Import databases for the 3 sites (included in the repository) accordingly and you will have 3 working websites on http://site1.assignment.loc, http://site2.assignment.loc, http://site3.assignment.loc

<h1>Additional scripts:</h1>

Execute “bash create_new_site.sh” to create a website by providing the following details:

Domain<br>
Site name<br>
Default language<br>
Other languages

Execute “bash generate_static_sites.sh” to generate static sites for all available sites. The upper script is responsible for adding all the configurations for a new site, so it will be fully accessible after generation, without any additional configurations and setup.
