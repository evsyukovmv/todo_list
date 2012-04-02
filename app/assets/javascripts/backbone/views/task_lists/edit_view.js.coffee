TodoList.Views.TaskLists ||= {}

class TodoList.Views.TaskLists.EditView extends Backbone.View
  template : JST["backbone/templates/task_lists/edit"]

  events :
    "submit #edit-task_list" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (task_list) =>
        @model = task_list
        window.location.hash = "/"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
