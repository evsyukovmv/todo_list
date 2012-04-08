TodoList.Views.Tasks ||= {}

class TodoList.Views.Tasks.EditView extends Backbone.View
  template : JST["backbone/templates/tasks/edit"]

  events :
    "submit #edit-task" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.url = '/task_lists/'+@model.attributes.task_list_id+'/tasks/'+@model.attributes.id

    @model.save(null,
      success : (task) =>
        @model = task
        window.location.hash = "/task_lists/#{@model.attributes.task_list_id}/tasks"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
