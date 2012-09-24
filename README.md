Locations API
=============

Install
-------

Dependencies
  * ruby >=1.9.2
  * rails >=3.1.3
  * git

>git clone https://github.com/dmcqueen/Locations.git  
>bundle install  
>rake db:migrate  
>rails s  

Ready to use.

Use
---

http://localhost:3000/api/location?query=sushi&near=San+Francisco

First time a request is given a naked call to Foursquare for data will be returned.
A job then runs to collects data from Google and caches both results for subsequent request on that query.

Testing
------

>rake spec

What this Does
--------------

Rest API for aggregating location data from various services.
