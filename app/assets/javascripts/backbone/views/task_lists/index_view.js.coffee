TodoList.Views.TaskLists ||= {}

class TodoList.Views.TaskLists.IndexView extends Backbone.View
  template: JST["backbone/templates/task_lists/index"]

  initialize: () ->
    @options.taskLists.bind('reset', @addAll)

  addAll: () =>
    @options.taskLists.each(@addOne)

  addOne: (taskList) =>
    view = new TodoList.Views.TaskLists.TaskListView({model : taskList})
    @$("#task_list").append(view.render().el)

  render: =>
    $(@el).html(@template(taskLists: @options.taskLists.toJSON() ))
    @addAll()

    return this
