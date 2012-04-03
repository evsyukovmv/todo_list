class TodoList.Routers.TasksRouter extends Backbone.Router
  initialize: (options) ->
    @tasks = new TodoList.Collections.TasksCollection()
    @tasks.reset options.tasks

  routes:
    "/new"      : "newTask"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newTaskTaskList: ->
    @view = new TodoList.Views.Tasks.NewView(collection: @tasks)
    $("#tasks").html(@view.render().el)

  indexTaskTaskList: ->
    @view = new TodoList.Views.Tasks.IndexView(tasks: @tasks)
    $("#tasks").html(@view.render().el)

  showTaskTaskList: (id) ->
    task = @tasks.get(id)

    @view = new TodoList.Views.Tasks.ShowView(model: task)
    $("#tasks").html(@view.render().el)

  editTaskTaskList: (id) ->
    task = @tasks.get(id)

    @view = new TodoList.Views.Tasks.EditView(model: task)
    $("#tasks").html(@view.render().el)
