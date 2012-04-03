TodoList.Views.TaskLists ||= {}

class TodoList.Views.TaskLists.NewView extends Backbone.View
  template: JST["backbone/templates/task_lists/new"]

  events:
    "submit #new-task_list": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    if @options.project
      @model.attributes.project_id = @options.project.attributes.id

    @collection.create(@model.toJSON(),
      success: (task_list) =>
        @model = task_list
        if @model.attributes.project_id
          window.location.hash = "/projects/"+@model.attributes.project_id+"/task_lists"
        else
          window.location.hash = "/task_lists"

      error: (task_list, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    this.$("form").backboneLink(@model)

    return this
