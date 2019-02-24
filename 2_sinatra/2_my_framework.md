# My Framework Project
- Project folder: ~/Documents/projects/my_framework

# Part 1

## Preparations
- Build simple web app

## What Makes A Rack Application
- Rack is a specification for connecting our application code to the web server, and also our application to the client.
- It sets and allows us to utilize a standard methodology for communicating HTTP requests and responses between client and server
  - To accommodate this, Rack has some very specific conventions in place

## What We Need
- "rackup" file: a configuration file that specifies what to run and how to run it.  Uses extension `.ru`
- The rack application we use in rackup file must be a Ruby object that respondes to method `call(env)`.  The `call(env)` method takes only one argument, the environment variables for this aplication.

## The `call` method
- Always returns an array with three elements: `[status code, {headers as a hash}, [Body object]`
  - Body object can be anything as long as it can respond to `each` method.  An `Enumerable` object would work, it just can't be a String by itself, but it must yield a String value.  Can just stick it in an array
- Together, these three elements represent the info that will be used to put together the response that is sent back to the client.

## Create `config.ru`
- In root directory
- Require the relative file
- use Rack method `run` on a class of that file

## Run the app
- `bundle exec rackup config.ru -p 9595`
- You can technically use whatever port you want.  Rack will use 9292 by default if not otherwise specified (by using -p flag).
- Ping the server to see if its working correctly
  - `curl localhost:9595 -m 30 -v`

# Part 2 

## Application Environment - env
- We've been working with application response within Rack app, but there is one other component of the `call` method we have been ignoring: the `env` argument
- If you inspect the `env` you will see a long list of environment variables and information related to our HTTP request for the application.
- The `env` contains information regarding HTTP headers as well as specific information about Rack
- It looks like an unorganized mess but its actual crucial information for telling our server side code how to process the request
- For example, `REQUEST_PATH` may tell which resource this request is retrieving and what query parameters are being attached with the request.

## Routing: Adding in other pages to our application
- Create another file to act as storage for dynamnic content (`advice.rb`)
- Make some stuff happen, style some stuff up and use HTML
- Change Content-Type to text/html
- Add some basic routing with a case statement inside the `call(env)` method

# Part 3

## View Templates
- We need a location in our app where we can store and maintain code related to what we want to display- this type of code is called a view template.
- View Templates are separate files that allows us to do some pre-processing on the server-side in a programming language and then translate programming code into a string to return to the client (usually HTML)

## ERB
- Embedded Ruby
- require 'erb'

# Part 4
- Create some helper methods
- Extract them out to a new class (Framework name)
- Require that class in main app file, and make main app class inherit from Framework class
- Now Rack app focuses soley on handling the request and creating and returning a response
  - Anything more general purpose has been moved to our framework 
  - Separation of responsibilities really goes a long way in keeping things easier to manage
  - Helps future-proof our application