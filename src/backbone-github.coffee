window.GitHub = {}

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

GitHub.User = GitHub.Model.extend(
  urlRoot: 'https://api.github.com/users/'
,
  fetch: (name, options)->
    user = new GitHub.User(id: name)
    user.fetch(options)
    user
)

GitHub.Organization = GitHub.Model.extend(
  urlRoot: 'https://api.github.com/orgs/'
,
  fetch: (name, options)->
    org = new GitHub.Organization(id: name)
    org.fetch(options)
    org
)

GitHub.Organizations = GitHub.Collection.extend
  url: 'https://api.github.com/user/orgs'
  model: GitHub.Organization

GitHub.currentUser = new GitHub.User()
GitHub.currentUser.url = "https://api.github.com/user"
GitHub.currentUser.urlRoot = null