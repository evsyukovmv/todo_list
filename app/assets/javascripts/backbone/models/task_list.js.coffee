class TodoList.Models.TaskList extends Backbone.Model
  paramRoot: 'task_list'

  defaults: {name: ''}

class TodoList.Collections.TaskListsCollection extends Backbone.Collection
  model: TodoList.Models.TaskList
  url: '/task_lists'
