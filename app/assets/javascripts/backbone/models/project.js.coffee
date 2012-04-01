class TodoList.Models.Project extends Backbone.Model
  paramRoot: 'project'

  defaults: {title: ''}

class TodoList.Collections.ProjectsCollection extends Backbone.Collection
  model: TodoList.Models.Project
  url: '/projects'
