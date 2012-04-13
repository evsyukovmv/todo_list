TodoList.Views.Tasks ||= {}

class TodoList.Views.Tasks.IndexView extends Backbone.View
  template: JST["backbone/templates/tasks/index"]

  initialize: () ->
    @options.tasks.bind('reset', @addAll)

  addAll: () =>
    @options.tasks.each(@addOne)
    @$("#title").append(' of task list '+@options.task_list.attributes.name)
    @$("#task_new").append('<a href="/#/task_lists/'+@options.task_list.id+'/tasks/new">New task</a>')

  addOne: (task) =>
    view = new TodoList.Views.Tasks.TaskView({model : task})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(tasks: @options.tasks.toJSON() ))
    @addAll()

    return this
