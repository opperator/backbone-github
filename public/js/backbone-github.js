(function() {

  window.GitHub = {};

  GitHub.sync = function(method, model, options) {
    var extendedOptions;
    extendedOptions = _.extend({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('Accept', 'application/vnd.github+json');
        if (GitHub.token) {
          return xhr.setRequestHeader('Authorization', "bearer " + GitHub.token);
        }
      }
    }, options);
    return Backbone.sync(method, model, extendedOptions);
  };

  GitHub.Model = Backbone.Model.extend({
    sync: GitHub.sync
  });

  GitHub.Collection = Backbone.Collection.extend({
    sync: GitHub.sync
  });

  GitHub.User = GitHub.Model.extend({
    urlRoot: 'https://api.github.com/users/'
  }, {
    fetch: function(name, options) {
      var user;
      user = new GitHub.User({
        id: name
      });
      user.fetch(options);
      return user;
    }
  });

  GitHub.Organization = GitHub.Model.extend({
    urlRoot: 'https://api.github.com/orgs/'
  }, {
    fetch: function(name, options) {
      var org;
      org = new GitHub.Organization({
        id: name
      });
      org.fetch(options);
      return org;
    }
  });

  GitHub.Organizations = GitHub.Collection.extend({
    url: 'https://api.github.com/user/orgs',
    model: GitHub.Organization
  });

  GitHub.currentUser = new GitHub.User();

  GitHub.currentUser.url = "https://api.github.com/user";

  GitHub.currentUser.urlRoot = null;

}).call(this);
