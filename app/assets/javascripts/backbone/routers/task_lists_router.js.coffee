class TodoList.Routers.TaskListsRouter extends Backbone.Router
  initialize: (options) ->
    @taskLists = new TodoList.Collections.TaskListsCollection()
    @taskLists.reset options.taskLists

  routes:
    "/new"      : "newTaskList"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newTaskList: ->
    @view = new TodoList.Views.TaskLists.NewView(collection: @task_lists)
    $("#task_lists").html(@view.render().el)

  index: ->
    @view = new TodoList.Views.TaskLists.IndexView(taskLists: @taskLists)
    $("#task_lists").html(@view.render().el)

  show: (id) ->
    task_list = @task_lists.get(id)

    @view = new TodoList.Views.TaskLists.ShowView(model: task_list)
    $("#task_lists").html(@view.render().el)

  edit: (id) ->
    task_list = @task_lists.get(id)

    @view = new TodoList.Views.TaskLists.EditView(model: task_list)
    $("#task_lists").html(@view.render().el)
