# Book Viewing App

## Sinatra and Web Frameworks
- Sinatra is a Rack-based web development framework
  - Comes with a lot of out of the box features that are meant to help make web development easier
  - Ease of use hides a lot of power
  - Sinatra provides conventions for where to place application code
  - Built in capabilities for routing, view templates, and many other convenient features you'd otherwise have to code up yourself
- But at its core, its nothing more than some Ruby connecting to a TCP server, handling requests, and sending back responses all in an HTTP-compliant string format.

## How Routes Work
- One reason Sinatra has become popular tool for building web apps is because of how simple it is to write Ruby code that runs when a user visits a particular URL
- Sinatra provides a DSL for defining routes and these routes are how a developer maps a URL pattern to some Ruby code

## Rendering Templates
- App is currently acting as static file server since its just sending a static file back to users.
- Make app more dynamic by rendering a template instead
- Templates, or view templates, are files that contain text that is converted into HTML before being sent to a users browser in a response
- There are a lot of different templating languages and they all provide different ways to define what HTML to generate and how to embed dynamic values
- To use HTML template in the project as an ERB template perform the following:
  1. Copy code from `public/template.html` to 'views/home.erb`
  2. Add `require "tilt/erubis"` to top of `book_viewer.rb`
  3. Update code inside `get "/"` to `get "/" do; erb :home; end`

## Adding a Table of Contents
- The file `data/toc.txt` is a list of chapters in the book
- Load the contents of the file into an instance variable in the `get "/"` route
- In `views/home.erb`, display the value in the main content and in the table of contents menu sidebar
  - Loop through the instance variable and display in an unordered list in ERB

## Adding a Chapter Page
- When a user vists `/chapters/1`, they should see the contents of the first chapter of the book
- Add a new route  Inside of it, load text from `data/chp1.txt` into an instance variable
  ```ruby
  get "/chapters/1" do
    @title = "Chapter 1"
    @table_of_contents = File.readlines("data/toc.txt")
    @content = File.read("data/chp1.txt")
    
    erb :chapter
  end
  ```
- Make `chapter.erb` file, change it around so the contents displayed is the chapter contents, not TOC in list format
- Reroute CSS files by adding `/` to the path

## Using Layouts
- Lots of duplication between current templates
- Most HTML code that provides basic page structure is shared between all pages
- Sinatra has the concept of layouts which you can think of as view templates that wrap around other view templates
- Its common to put the shared HTML code in a layout so that all thats in a particular view template is code specific to that view
- `erb :index, layout: :post` to define a layout, otherwise sinatra will look for default `views/layout.erb` and use that

## Route Parameters
- We could add a new route for each possible chapter but that would be a tremendously repetitive task
- Use params instead
- `get "/chapters/:number" do` and use `params[:number].to_i` to finish the route
- Clean up title names, chapter names, and all that jazz using `params[:number]`

## Before Filters
- There are things that need to be done on every request to an application (check to see if user is logged in, loading account, etc.)
- We can move common code to a `before` filter so that we only need to define it once in the program
- Sinatra will run the code in a `before` filter before running the code in a matching route, so its a good place to setup globally needed data
- Syntax is `before do` and then write the rest of the method
- If an instance variable is accessed in a `layout`, which is loaded on every view, its a good candidate for a `before` filter
  - Though, this isn't always the case (take `@title` for example), some are loaded on every page but are specific to the route

## View Helpers
- View helpers are methods made available in templates by Sinatra for the purpose of filtering data, processing data, or performing some other functionality
- Here, we want to use it to clean up how the chapters are reading because right now they are reading like a pile of hot garbage
- Sytax is `helpers do` then inside this method, define all your helper methods then `end`

## Redirecting
- `redirect` and `not_found do`

## Adding a Search Form
- Besides parameters extracted from URL, there are two other ways to get data into `params` hash
  1. Using query parameters in the URL
  2. Submitting a form using a POST request
- HTML Forms
  - When a form is submitted, the browser makes an HTTP request
  - The request is made to the path or URL specified in the `action` attribute of the `form` element
  - The `method` attribute of the `form` determines if the request made will use GET or POST
  - The value of any `input` element in the `form` will be sent as parameters.  The keys of these parameters will be determined by the `name` attribute of the corresponding `input` element
- Add new route `/search`, within route render a new template, inside of which should be the following HTML
```html
<h2 class="content-subhead">Search</h2>

<form action="/search" method="get">
  <input name="query" value="<%= params[:query] %>">
  <button type="submit">Search</button>
</form>
```
- We're using a GET method for this form instead of POST because we are just searching, we aren't modifying any data.  If our form submission was modifying data we would use a POST as the form's method.
- Add code to new route that checks if any of the chapters contain whatever text is entered into search form
- When a browser loads a URL that contains an anchor (the part of the URL that starts with a `#`), and that page contains a DOM element with an `id` attribute equal to the anchor, it will automatically scroll the page to display that element.

