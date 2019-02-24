# Rack
- We don't want to use our own TCP server to process requests since there are more common and robust web servers out there
- WEBrick is a web server that comes with Ruby- just like we utilize the `Array` class, we're going to take advantage of WEBrick as our web server
  - Working with WEBrick can be cumbersome.
  - There is a library called Rack that will help with connecting to WEBrick for us
- Rack is a generic interface to help application developers connect to web servers, so it works with many other servers besides WEBrick
  - In our Server diagram, we are essentially replacing our TCP server with WEBrick and our Ruby code with a Rack application
  - When working with Rack apps, our entire server is comprised of the Rack application and a web server (WEBrick)
  - Most developers wouldn't write Rack applications except for the simplist of situations

## Demystifying Ruby Apps
- Tannr: https://medium.com/launch-school/demystifying-ruby-applications-ruby-application-servers-and-web-servers-c3d0fd415cb3

- A strong foundation between what it is web apps accomplish behind the scenes is the difference between an "API user" and a "developer"

### TCP and Sockets
- Ruby standard library provides class called TCPSocket
  - Allows Rubyists to utilize the socket API more easily
  - Term API is short for Application Programming Interface
  - Any API is merely a collection of programs that an application can use to access other components of the operating system
  - Therefore, socket API allows apps (like a Ruby app) to make use of sockets

  #### Sockets
  - In web app development, the sockets used to communicate over the web are called TCP sockets
  - TCP is one of the many protocols in the TCP/IP stack, aka "Internet Protocol Suite"
  - IP suite contains a lot of protocols, and they can be divided into the following layers
    1. Network interface layer (link layer)
    2. Internet layer
    3. Transport layer
    4. Application layer
  - TCP is mapped to transport layer which specifies how info is transmitted from one remote system to another in a reliable manner
  - The IP address and port number concatenated together is called a **socket**
  - Sending app doesn't have a way to find out which port receiving app is listening to so we use default ports or "well known" ports as a convention

### Web Servers and Ruby Code
- Instead of developers having to worry about sockets and handling HTTP, its easier to use a prebuilt app make use of the socket API
- Prebuilt app would interface with the socket API of the OS and would be receiving HTTP requests from client
- It would pass HTTP request to our app, would handle multiple requests at once, and would even provide features like killing connections that take too long or serving static files without calling the app itself, so the application truly only needed to be dedicated to producing the dynami content and making server-side changes in response to forwarded HTTP requests
- **Model**  The web server is responsible for using the OS socket API to retreive info in the form of HTTP requests, we then connect the web server to our application code (written in Ruby), and the input to our application will be HTTP-formatted text and other useful info about the request, from the web server rather than the unparsed text from the TCP socket.
  - Therefor, our app isn't receiving HTTP requests directly: it is receiving input from the web server
  - The issue here is that even with the use of web server, the web server doesn't have a way to start application directly.  The web server speaks HTTP and the application doesn't
  - Whatever web app you make, you will need these isues to be resolved in order to make it run on the web successfully and securely
  - So, it makes sense to separate these responsibilities, and make something like an HTTP interface that can translate HTTP requests, forwarded from the web server, into sensible arguments that are then passed to the application
  - This interface would also translate the applications non-HTTP reponse into HTTP that is then passed back to the web server and finally to the client
  - There are many such interfaces and they are appropriately named **Application Servers**

### Putting an Application Server between the Web Server and Ruby App
- The App Server itself is an application and will execute your app just like object calls on another object's method in Ruby
- It contains code that allows it to parse HTTP info into Ruby data structures (turning HTTP request headers from text into hashes)
- It contains code that allows it to interface with a standard web server via socket connections (which utilize the `socket` API of the operating system)
- It contains code that captures the return value of your application and transforms the return value into HTTP formatted text
- It does all of this so the application doesn't have to.
- Application servers provide an HTTP interface for applications and web servers.
  - App server and web server communicate via a socket connection (TCP or Unix socket)
    - Unix sockets replace a host with a file path which is faster since the overhead of routing over a network is removed but only works if the app server and web server are on the same machine
  - App server receives HTTP text from web server, then application server's HTTP parser will format this into Ruby-friendly data structures
  - When the application server is ready to hand thte parsed request to Ruby, it will call your Ruby app with a method, passing in the parsed request as an argument or series of arguments. 
  - The Ruby app will execute, and the application server will store the Ruby app's return value in a variable.
  - It will reformat this variable into an HTTP response that the web server will understand, and then it will send that formatted HTTP response back to the web server via a socket connection
  - From there, the web server sends the HTTP response to the client.
- Exemplifies the modular, separation-of-concerns based approach to development
- Apps no longer need to understand HTTP at all: that is the job of the application server
- Further, our applications no longer have to return HTTP-compliant responses: also the job of the application server.

### Another Interface
- Application Servers are simply an application that provides an HTTP interface- but an interface has atleast two sides.
- It is an interface between a web server and Ruby application
- On the web server side, it is written to handle the type of information web servers send and to successfully return the type of information web servers understand
- On the application side, it is written to call the application and to pass in certain arguments to the application.  Those arguments represent the HTTP request.
- It is also written to capture the return value of calling that application, formatting the return-value into HTTP text, and sending it back to the web server

- What arguments does app server pass to Ruby app? How does it all work? Conventions and protocols!
  - Since many frameworks/many app servers exist, conventions used to prevent compatability issues
  - Specifies which method all app servers should use to call an app, and which method all applications should respond to
  - It would specify which values the application would return (once called) and would therefore specify which values the app server would expect to be returned from the Ruby app (making it much easier to construct a valid HTTP response out of ruby app-returned values)
  - Would also specify the arguments that should be passed into the app when called
  - In short, it would specify a common language or interface that ruby apps and app servers could use to communicate

### Introducing Rack
- Rack is the protocol mentioned above and its called the "Rack Specification"
- Solves the many-frameworks/many-servers problem