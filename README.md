# README

Code for the SE31520/CHM5820 CSA (CS Alumni Application).  

This is the main example shown in class. It has plenty of bugs
that you are encouraged to fix. 

* Running
By default it will run in non-ssl mode using rails start. If you want to run in SSL mode see below.
If you want to use with Twitter then you will need to create a
config/local_env.yml file of the form:

TWOAUTH_CONSUMER_KEY: 'YOUR-CONSUMER-KEY-HERE'\
TWOAUTH_CONSUMER_SECRET: 'YOUR-CONSUMER-SECRET-HERE'\
TWOAUTH_ACCESS_TOKEN: 'YOUR-ACCESS-TOKEN-HERE'\
TWOAUTH_ACCESS_SECRET: 'YOUR-ACCESS-SECRET-HERE'

See http://dev.twitter.com/apps for more info. 
Also make sure the file is included in .gitignore so that
you don't expose sensitive information to the world.

This information is used in the initializer: config/initializers/twitter.rb.

There is a simple REST client under the rest_client folder.
This only supports the manipulation of user accounts.

Running in SSL mode
-------------------
If you want SSL edit app/controllers/application_controller.rb and uncomment the 
force_ssl command.

Then if running in SSL mode:
Start using two command line windows:
In one start puma in non-ssl mode, type:

puma

In the other start in ssl mode. Here is an example:

puma -b 'ssl://127.0.0.1:3001?key=/Users/chrisloftus/.ssh/server.key&cert=/Users/chrisloftus/.ssh/server.crt'

To generate self-signed certificates for testing see: https://gist.github.com/tadast/9932075 

* Ruby version
This has been developed with ruby 2.4.1

* Database creation
An example development database is included

* Installation dependencies
ImageMagick must be installed

*  Testing
No extra tests were developed during this workshop, only those generated automatically
or developed in earlier workshops.
