class TodoList.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults: {name: ''}

class TodoList.Collections.TasksCollection extends Backbone.Collection
  model: TodoList.Models.Task
  url: '/tasks'
