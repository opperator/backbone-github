# Backbone GitHub is a library that connects to the [GitHub
# API](http://developer.github.com) using Cross Origin Resource 
# Sharing (CORS). That means that you can utilize this library 
# to access the full GitHub API without any server-side code 
# whatsoever.
#
# ## Dependencies
# 
# Backbone GitHub depends on Backbone, so before you can use
# this library you will need to have included Backbone, 
# Underscore, and jQuery on the page.
window.GitHub = {}

# ## GitHub.sync
#
# The GitHub sync method is simply a customized version of the
# default Backbone sync mechanism with two improved properties:
#
# 1. It automatically sets an Accept header compatible with the
#    GitHub v3 API.
# 2. It sets the OAuth 2.0 Authorization header if `GitHub.token`
#    exists.
GitHub.sync = (method, model, options)->
  extendedOptions = _.extend {
    beforeSend: (xhr)->
      xhr.setRequestHeader 'Accept', 'application/vnd.github+json'
      xhr.setRequestHeader 'Authorization', "bearer #{GitHub.token}" if GitHub.token
  }, options
  Backbone.sync(method, model, extendedOptions)

GitHub.Model = Backbone.Model.extend
  sync: GitHub.sync

GitHub.Collection = Backbone.Collection.extend
  sync: GitHub.sync

GitHub.Relations =
  ownedRepos: (options)->
    repos = new GitHub.Repos
    repos.url = if typeof @url == "function" then @url() else @url
    repos.url += "/repos"
    repos.fetch(options)
    repos
  ownedOrgs: (options)->
    orgs = new GitHub.Organizations
    orgs.url = if typeof @url == "function" then @url() else @url
    orgs.url += "/orgs"
    orgs.fetch(options)
    orgs

# ## GitHub.User
# 
# The GitHub User model. For information about specific attributes
# that are available on this model, see GitHub's [Users API](http://developer.github.com/v3/users/)
# documentation.
GitHub.User = GitHub.Model.extend(
  urlRoot: 'https://api.github.com/users/'
  # ### user.repos(options)
  #
  # Fetch associated repositories for this user. Takes
  # a `success` and `error` callback as potential options.
  # Returns a `GitHub.Repos` collection.
  repos: GitHub.Relations.ownedRepos
  # ### user.organizations(options)
  #
  # Fetch associated organizations for this user. Takes
  # a `success` and `error` callback as potential options.
  organizations: GitHub.Relations.ownedOrgs
,
  # ### GitHub.User.fetch(name, options)
  #
  # Retrieve a user by username. Takes `success` and
  # `error` callbacks.
  #
  #     GitHub.User.fetch('mbleigh', {success: function(u){
  #       console.log(u.toJSON());
  #     }});
  fetch: (name, options)->
    user = new GitHub.User(id: name)
    user.fetch(options)
    user
)

# ## GitHub.Organization
# 
# Represents a GitHub organization. See the [Organization
# API](http://developer.github.com/v3/orgs/) docs on GitHub
# for additional information.
GitHub.Organization = GitHub.Model.extend(
  urlRoot: 'https://api.github.com/orgs/'

  # ### org.repos(options)
  # 
  # Fetch the repositories for the instantiated organization.
  # Takes `success` and `error` callbacks. Returns a
  # `GitHub.Repos` collection.
  repos: GitHub.Relations.ownedRepos
,
  # ### GitHub.Organization.fetch(name, options)
  #
  # Fetch an organization by name. Accepts `success`
  # and `error` callbacks.
  #
  #     GitHub.Organization.fetch('opperator', {success: function(o){
  #       console.log(o.toJSON());
  #     }});
  fetch: (name, options)->
    org = new GitHub.Organization(id: name)
    org.fetch(options)
    org
)

# ## GitHub.Organizations
#
# Collection of multiple organizations. By default will
# be associated to the current user's organizations (you
# must set an `GitHub.token` for that to work.)
GitHub.Organizations = GitHub.Collection.extend
  url: 'https://api.github.com/user/orgs'
  model: GitHub.Organization

# ## GitHub.Repo
#
# Repository model. For more information about attributes
# etc, see the [GitHub Repo](http://developer.github.com/v3/repos/)
# API docs.
GitHub.Repo = GitHub.Model.extend(
  url: ()->
    @get('url') || "https://api.github.com/repos/#{@get('path')}"
,
  # ### GitHub.Repo.fetch(owner, name, options)
  #
  # Retrieve a repository knowing its owner and name. Takes
  # `success` and `error` callbacks in options.
  #
  #     GitHub.Repo.fetch('opperator', 'backbone-github', {success: function(r){
  #       console.log(r.toJSON());
  #     }});
  fetch: (owner, name, options)->
    repo = new GitHub.Repo(path: "#{owner}/#{name}")
    repo.fetch(options)
    repo
)

# ## GitHub.Repos
# 
# Collection of Repo models. Defaults to the current user's
# repositories. Must have set `GitHub.token` for current
# user repo fetch to be successful.
GitHub.Repos = GitHub.Collection.extend
  url: 'https://api.github.com/user/repos'
  model: GitHub.Repo

# ## GitHub.currentUser
#
# A `GitHub.User` corresponding to the authenticated user.
# Note that you must set `GitHub.token` to a valid OAuth 2.0
# token to be able to utilize the current user.
#
# The `currentUser` is not fetched by default, you must run
# `GitHub.currentUser.fetch()` before it will be populated
# with data.
GitHub.currentUser = new GitHub.User()
GitHub.currentUser.url = "https://api.github.com/user"
GitHub.currentUser.urlRoot = null