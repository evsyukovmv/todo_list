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

    @collection.create(@model.toJSON(),
      success: (task_list) =>
        @model = task_list
        window.location.hash = "/"

      error: (task_list, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
