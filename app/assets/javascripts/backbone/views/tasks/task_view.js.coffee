TodoList.Views.Tasks ||= {}

class TodoList.Views.Tasks.TaskView extends Backbone.View
  template: JST["backbone/templates/tasks/task"]

  events:
    "click .destroy" : "destroy"
    "click .change_state" : "change_state"

  tagName: "tr"

  destroy: () ->
    @model.url = '/task_lists/'+@model.attributes.task_list_id+'/tasks/'+@model.attributes.id
    @model.destroy()
    this.remove()

    return false

  change_state : () ->

    @model.url = '/task_lists/'+@model.attributes.task_list_id+'/tasks/'+@model.attributes.id

    if @model.attributes.state == 'in_process'
      @model.attributes.state = 'done'
    else if @model.attributes.state == 'not_done'
      @model.attributes.state = 'in_process'
    else
      @model.attributes.state = 'not_done'

    @model.save(null,
      success : (task) =>
        @model = task
        window.location.hash = "/task_lists/#{@model.attributes.task_list_id}/tasks"
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
