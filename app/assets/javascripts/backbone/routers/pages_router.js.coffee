class TodoList.Routers.PagesRouter extends Backbone.Router
  initialize: (options) ->
    @projects = new TodoList.Collections.ProjectsCollection()
    @projects.reset options.projects

    @task_lists = new TodoList.Collections.TaskListsCollection()
    @task_lists.reset options.task_lists

  routes:
    "/projects/new"      : "newProject"
    "/projects/index"    : "indexProject"
    "/projects/:id/edit" : "editProject"
    "/projects/:id"      : "showProject"
    "/projects/:id/task_lists"      : "taskListsProject"
    "/projects"    : "indexProject"
    "/projects/.*"    : "indexProject"

    "/task_lists/new"      : "newTaskList"
    "/task_lists/index"    : "indexTaskList"
    "/task_lists/:id/edit" : "editTaskList"
    "/task_lists/:id"      : "showTaskList"
    "/task_lists"    : "indexTaskList"
    "/task_lists/.*"    : "indexTaskList"

    "/"        : "index"
    ".*"        : "index"

  index: ->
    @view = new TodoList.Views.Pages.IndexView(projects: @projects, taskLists: @task_lists)
    $("#pages").html(@view.render().el)

  indexProject: ->
    @view = new TodoList.Views.Projects.IndexView(projects: @projects)
    $("#pages").html(@view.render().el)

  newProject: ->
    @view = new TodoList.Views.Projects.NewView(collection: @projects)
    $("#pages").html(@view.render().el)

  showProject: (id) ->
    project = @projects.get(id)

    @view = new TodoList.Views.Projects.ShowView(model: project)
    $("#pages").html(@view.render().el)

  editProject: (id) ->
    project = @projects.get(id)

    @view = new TodoList.Views.Projects.EditView(model: project)
    $("#pages").html(@view.render().el)

  taskListsProject: (id) ->

    project = @projects.get(id)
    project_task_lists = new TodoList.Collections.TaskListsCollection()
    project_task_lists.reset project.get('task_lists')

    @view = new TodoList.Views.TaskLists.IndexView(taskLists: project_task_lists)
    $("#pages").html(@view.render().el)


  newTaskList: ->
    @view = new TodoList.Views.TaskLists.NewView(collection: @task_lists)
    $("#pages").html(@view.render().el)

  indexTaskList: ->
    @view = new TodoList.Views.TaskLists.IndexView(taskLists: @task_lists)
    $("#pages").html(@view.render().el)

  showTaskList: (id) ->
    task_list = @task_lists.get(id)

    @view = new TodoList.Views.TaskLists.ShowView(model: task_list)
    $("#pages").html(@view.render().el)

  editTaskList: (id) ->
    task_list = @task_lists.get(id)

    @view = new TodoList.Views.TaskLists.EditView(model: task_list)
    $("#pages").html(@view.render().el)

