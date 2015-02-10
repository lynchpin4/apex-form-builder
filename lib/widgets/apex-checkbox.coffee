{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    HTML5 Checkbox (Core)
    -------------------

    ...
###

module.exports =
class Apex.Form.CheckBox extends Apex.Form.Widget

  widgetType: 'checkbox'
  w: 25
  h: 25

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    super params
    @value = true
    @properties.push 'bool:value'
    console.log 'Input checkbox initialized'

  update: ->
    super
    if @checkbox then @checkbox.val @value

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @checkbox = $('<input type="checkbox"/>')
    @checkbox.val @value
    @checkbox.addClass 'grow'
    @append @checkbox
    @update()
    @

  # construct the regular view element onto @body
  view: ->
    @checkbox = $('<input type="checkbox"/>')
    @checkbox.addClass 'grow'
    @checkbox.val @value
    @append @checkbox
    @update()

Apex.widgetResolver.add 'checkbox', Apex.Form.CheckBox
console.log('resolver added input')
