TodoList.Views.TaskLists ||= {}

class TodoList.Views.TaskLists.ShowView extends Backbone.View
  template: JST["backbone/templates/task_lists/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
