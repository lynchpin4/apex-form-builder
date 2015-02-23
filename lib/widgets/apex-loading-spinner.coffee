{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Loading Spinner
    -------------------

    ...
###

module.exports =
class Apex.Form.LoadingSpinner extends Apex.Form.Widget

  widgetType: 'loadingspinner'
  size: 'large'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    super params
    @value = true
    @properties.push 'bool:value'
    @properties.push 'string:size'
    console.log 'Loading spinner initialized'

  update: ->
    super
    if @spinner then @spinner.val @value
    if @spinner
      @spinner.addClass 'loading-spinner-'+@size

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @spinner = $("<span class='loading inline-block'></span>")
    @spinner.addClass 'grow'
    @spinner.addClass 'loading-spinner-'+@size
    @append @spinner
    @update()
    @

  # construct the regular view element onto @body
  view: ->
    @spinner = $("<span class='loading loading-spinner-large inline-block'></span>")
    @spinner.addClass 'grow'
    @spinner.val @value
    @append @spinner
    @update()

Apex.widgetResolver.add 'loadingspinner', Apex.Form.LoadingSpinner
console.log('resolver added LoadingSpinner')
