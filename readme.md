# Backbone GitHub

**NOTE:** Under development, not released yet.

Backbone GitHub is a 100% client-side Javascript library for accessing
the GitHub API using Cross Origin Resource Sharing.

## Basic Usage

In order to use Backbone GitHub simply add it to your page after you
have already added Backbone and jQuery:

```html
<!doctype html>
<html>
  <head>
    <script type='text/javascript' src='http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min.js'></script>
    <script type='text/javascript' src='http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.1/underscore-min.js'></script>
    <script type='text/javascript' src='http://cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min.js'></script>
    <script type='text/javascript' src='js/backbone-github.js'></script>
  </head>
  <body>
    <!-- Build your awesome app now -->
  </body>
</html>
```

Before you can actually use Backbone GitHub, you will need to register
an OAuth application on [your GitHub settings page](https://github.com/settings).
Only domains that correspond to OAuth applications will work with GitHub's
CORS (and `file://` won't cut it). AJAX requests automatically set the `Origin`
header and perform preflight for CORS so if you're running it locally, you will
need to create a separate OAuth app (for instance pointing to 
`http://backbone-github.dev` if you're a [POW](http://pow.cx) user).

Now that you've created your application, you can use the non-authenticated parts
of Backbone GitHub like so:

```javascript
GitHub.User.fetch('mbleigh', {success: function(user) {
  console.log(user);
}});

GitHub.Organization.fetch('opperator', {success: function(org) {
  console.log(org);
}});
```

## Authentication

If you wish to be authenticated, you will need to supply an OAuth 2 token
by setting it as `GitHub.token` like so:

```javascript
GitHub.token = 'youroauth2tokenhere'
```

If you want to obtain a test auth token, you can get one using `curl`:

```sh
curl -d '{"scopes":"user,repo,gist"}' https://username:password@api.github.com/authorizations
```

Once you've set your OAuth 2 token, you will have access to the `currentUser`:

```javascript
GitHub.currentUser.fetch({success: function(user) {
  console.log(user);
}})
```

## License

Copyright (c) 2012 Michael Bleigh and Intridea, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.