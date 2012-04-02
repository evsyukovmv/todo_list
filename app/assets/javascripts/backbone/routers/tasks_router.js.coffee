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

  newTask: ->
    @view = new TodoList.Views.Tasks.NewView(collection: @tasks)
    $("#tasks").html(@view.render().el)

  index: ->
    @view = new TodoList.Views.Tasks.IndexView(tasks: @tasks)
    $("#tasks").html(@view.render().el)

  show: (id) ->
    task = @tasks.get(id)

    @view = new TodoList.Views.Tasks.ShowView(model: task)
    $("#tasks").html(@view.render().el)

  edit: (id) ->
    task = @tasks.get(id)

    @view = new TodoList.Views.Tasks.EditView(model: task)
    $("#tasks").html(@view.render().el)
