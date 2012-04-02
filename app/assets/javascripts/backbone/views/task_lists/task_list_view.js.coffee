TodoList.Views.TaskLists ||= {}

class TodoList.Views.TaskLists.TaskListView extends Backbone.View
  template: JST["backbone/templates/task_lists/task_list"]

  events:
    "click .destroy" : "destroy"

  #tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
