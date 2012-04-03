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
        if @model.attributes.project_id
          window.location.hash = "/projects/"+@model.attributes.project_id+"/task_lists"
        else
          window.location.hash = "/task_lists"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    if @options.model.attributes.project_id
      @$("#back").append('<a href="/#/projects/'+@options.model.attributes.project_id+'/task_lists">Back</a>')
    else
      @$("#back").append('<a href="/#/task_lists">Back</a>')

    this.$("form").backboneLink(@model)



    return this
