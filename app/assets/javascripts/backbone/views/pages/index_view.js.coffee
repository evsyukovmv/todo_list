TodoList.Views.Pages ||= {}

class TodoList.Views.Pages.IndexView extends Backbone.View
  template: JST["backbone/templates/pages/index"]

  initialize: () ->
    @options.projects.bind('reset', @addAll)
    @options.taskLists.bind('reset', @addAll)

  addAll: () =>
    @options.projects.each(@addOneProject)
    @options.taskLists.each(@addOneTaskList)

  addOneProject: (project) =>
    view = new TodoList.Views.Projects.ProjectView({model : project})
    @$("#project").append(view.render().el)

  addOneTaskList: (taskList) =>
    view = new TodoList.Views.TaskLists.TaskListView({model : taskList})
    @$("#task_list").append(view.render().el)

  render: =>
    $(@el).html(@template(projects: @options.projects.toJSON(), task_lists: @options.taskLists.toJSON ))
    @addAll()

    return this