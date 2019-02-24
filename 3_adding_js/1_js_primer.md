# JavaScript Primer

## jQuery Videos
- jQuery: Fast, small, feature-rich JavaScript library.  Makes things like HTML document traversal and manipulation, event handling, animation, and ajax muc hsimpler with an easy-to-use API that works across a multitude of browsers
  - Easiest and most popular JavaScript library
- jQuery doesn't do anything, it just gives you the commands so you can write your own
- `<script src="bower_components/jquery/jquery.js"></script>` is how you include jquery in an app
- `$` is how you reference the jQuery library
```javascript
<script>
  $(function() {


  });
</script>
```
- This says: Wait for my whole document to load up before trying to run any javascript
- The real "fun" of JavaScript is doing things based on what the user does- which is dealing with "events" (when they hover do this, when they click do this, etc.)
- DOM: Document Object Model
  - Refers to navigating, targeting, and manipulating the shit you see on the screen via the browser's interpretation of it

# Including Javascript
- Download jQuery and add to project
- Add `<script src="javascripts/jquery-2.1.4.js"></script>` under the css references
- Add `<script src="javascripts/application.js"></script>` under that
- Create that application.js file but add `console.log("this is a test")` to get everything working