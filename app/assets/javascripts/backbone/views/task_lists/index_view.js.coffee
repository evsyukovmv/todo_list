TodoList.Views.TaskLists ||= {}

class TodoList.Views.TaskLists.IndexView extends Backbone.View
  template: JST["backbone/templates/task_lists/index"]

  initialize: () ->
    @options.taskLists.bind('reset', @addAll)

  addAll: () =>
    @options.taskLists.each(@addOne)
    if @options.project
      @$("#title").append(' of project '+@options.project.attributes.name)
      @$("#task_list_new").append('<a href="/#/projects/'+@options.project.attributes.id+'/task_lists/new">New Task list</a>')
    else
      @$("#task_list_new").append('<a href="/#/task_lists/new">New Task List</a>')


  addOne: (taskList) =>
    view = new TodoList.Views.TaskLists.TaskListView({model : taskList})
    @$("#task_list").append(view.render().el)

  render: =>
    $(@el).html(@template(taskLists: @options.taskLists.toJSON()))
    @addAll()

    return this
