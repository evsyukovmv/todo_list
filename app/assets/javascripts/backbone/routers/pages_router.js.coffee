class TodoList.Routers.PagesRouter extends Backbone.Router
  initialize: (options) ->
    @projects = new TodoList.Collections.ProjectsCollection()
    @projects.reset options.projects

    @task_lists = new TodoList.Collections.TaskListsCollection()
    @task_lists.reset options.task_lists

    @tasks = new TodoList.Collections.TasksCollection()
    @tasks.reset options.tasks

    @task_lists_out = new TodoList.Collections.TaskListsCollection()

  routes:
    "/projects/new"      : "newProject"
    "/projects/index"    : "indexProject"
    "/projects/:id/edit" : "editProject"
    "/projects/:id"      : "showProject"
    "/projects/:id/task_lists"      : "indexProjectTaskList"
    "/projects/:id/task_lists/new"  : "newProjectTaskList"
    "/projects"    : "indexProject"
    "/projects/.*"    : "indexProject"

    "/task_lists/new"      : "newTaskList"
    "/task_lists/index"    : "indexTaskList"
    "/task_lists/:id/edit" : "editTaskList"
    "/task_lists/:id"      : "showTaskList"
    "/task_lists"    : "indexTaskList"
    "/task_lists/.*"    : "indexTaskList"

    "/task_lists/:task_list_id/tasks"    : "indexTaskTaskList"
    "/task_lists/:task_list_id/tasks/new"    : "newTaskTaskList"
    "/task_lists/:task_list_id/tasks/:id/edit"    : "editTaskTaskList"
    "/task_lists/:task_list_id/tasks/:id"    : "showTaskTaskList"
    "/task_lists/:task_list_id/tasks/.*"    : "indexTaskTaskList"

    "/"        : "index"
    ".*"        : "index"

  index: ->

    @task_lists_out.reset  @task_lists.select((project_task_list) -> project_task_list.get("project_id") == null)
    @view = new TodoList.Views.Pages.IndexView(projects: @projects, taskLists: @task_lists_out)
    $("#pages").html(@view.render().el)


################# PROJECT ###################

  indexProject: ->
    @view = new TodoList.Views.Projects.IndexView(projects: @projects)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  newProject: ->
    @view = new TodoList.Views.Projects.NewView(collection: @projects)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  showProject: (id) ->
    project = @projects.get(id)

    @view = new TodoList.Views.Projects.ShowView(model: project)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  editProject: (id) ->
    project = @projects.get(id)

    @view = new TodoList.Views.Projects.EditView(model: project)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  indexProjectTaskList: (id) ->

    project = @projects.get(id)
    project_task_lists = new TodoList.Collections.TaskListsCollection()
    project_task_lists.reset  @task_lists.select((project_task_list) -> project_task_list.get("project_id") == project.attributes.id)
    @view = new TodoList.Views.TaskLists.IndexView(taskLists: project_task_lists, project: project)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/projects/#{project.id}/task_lists/new\">Task list</a>")

  newProjectTaskList: (id) ->
    project = @projects.get(id)
    @view = new TodoList.Views.TaskLists.NewView(collection: @task_lists, project: project)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")



################# TASK LIST ###################

  newTaskList: ->
    @view = new TodoList.Views.TaskLists.NewView(collection: @task_lists)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  indexTaskList: ->
    @task_lists_out.reset  @task_lists.select((project_task_list) -> project_task_list.get("project_id") == null)
    @view = new TodoList.Views.TaskLists.IndexView(taskLists: @task_lists_out)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  showTaskList: (id) ->
    task_list = @task_lists.get(id)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

    @view = new TodoList.Views.TaskLists.ShowView(model: task_list)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

  editTaskList: (id) ->
    task_list = @task_lists.get(id)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

    @view = new TodoList.Views.TaskLists.EditView(model: task_list)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")

################# TASK ###################

  newTaskTaskList: (task_list_id) ->
    task_list =  @task_lists.get(task_list_id)
    @view = new TodoList.Views.Tasks.NewView(collection: @tasks, task_list: @task_lists.get(task_list_id))
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")
    $(".dropdown-menu .task").html("<a href=\"/#/task_lists/#{task_list.id}/tasks/new\">Task</a>")


  indexTaskTaskList: (task_list_id) ->
    task_list =  @task_lists.get(task_list_id)
    task_list_tasks = new TodoList.Collections.TasksCollection()
    task_list_tasks.reset  @tasks.select((task_list_task) -> task_list_task.get("task_list_id") == task_list.attributes.id)
    @view = new TodoList.Views.Tasks.IndexView(tasks: task_list_tasks, task_list: task_list)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")
    $(".dropdown-menu .task").html("<a href=\"/#/task_lists/#{task_list.id}/tasks/new\">Task</a>")

  showTaskTaskList: (task_list_id, id) ->
    task_list =  @task_lists.get(task_list_id)
    task = @tasks.get(id)
    @view = new TodoList.Views.Tasks.ShowView(model: task)
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")
    $(".dropdown-menu .task").html("<a href=\"/#/task_lists/#{task_list.id}/tasks/new\">Task</a>")

  editTaskTaskList: (task_list_id, id) ->
    task_list =  @task_lists.get(task_list_id)
    task = @tasks.get(id)
    @view = new TodoList.Views.Tasks.EditView(model: task, task_list: @task_lists.get(task_list_id))
    $("#pages").html(@view.render().el)
    $(".dropdown-menu .task_list").html("<a href=\"/#/task_lists/new\">Task list</a>")
    $(".dropdown-menu .task").html("<a href=\"/#/task_lists/#{task_list.id}/tasks/new\">Task</a>")