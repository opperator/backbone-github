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

  GitHub.Relations = {
    ownedRepos: function(options) {
      var repos;
      repos = new GitHub.Repos;
      repos.url = typeof this.url === "function" ? this.url() : this.url;
      repos.url += "/repos";
      repos.fetch(options);
      return repos;
    },
    ownedOrgs: function(options) {
      var orgs;
      orgs = new GitHub.Organizations;
      orgs.url = typeof this.url === "function" ? this.url() : this.url;
      orgs.url += "/orgs";
      orgs.fetch(options);
      return orgs;
    }
  };

  GitHub.User = GitHub.Model.extend({
    urlRoot: 'https://api.github.com/users/',
    repos: GitHub.Relations.ownedRepos,
    organizations: GitHub.Relations.ownedOrgs
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
    urlRoot: 'https://api.github.com/orgs/',
    repos: GitHub.Relations.ownedRepos
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

  GitHub.Repo = GitHub.Model.extend({
    url: function() {
      return this.get('url') || ("https://api.github.com/repos/" + (this.get('path')));
    }
  }, {
    fetch: function(owner, name, options) {
      var repo;
      repo = new GitHub.Repo({
        path: "" + owner + "/" + name
      });
      repo.fetch(options);
      return repo;
    }
  });

  GitHub.Repos = GitHub.Collection.extend({
    url: 'https://api.github.com/user/repos',
    model: GitHub.Repo
  });

  GitHub.currentUser = new GitHub.User();

  GitHub.currentUser.url = "https://api.github.com/user";

  GitHub.currentUser.urlRoot = null;

}).call(this);
