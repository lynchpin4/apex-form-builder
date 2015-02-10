{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    HTML5 UI Input (Core)
    -------------------

    HTML5 Text Input (Basic Textbox)
###

module.exports =
class Apex.Form.Input extends Apex.Form.Widget

  widgetType: 'input'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    super params
    @value = 'Textbox'
    @properties.push 'string:value'
    console.log 'Input Textbox initialized'

  update: ->
    super
    if @textbox then @textbox.val @value

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @textbox = $('<input type="text"/>')
    @textbox.val @value
    @textbox.addClass 'grow'
    @append @textbox

  # construct the regular view element onto @body
  view: ->
    @textbox = $('<input type="text"/>')
    @textbox.addClass 'grow'
    @textbox.val @value
    @append @textbox

Apex.widgetResolver.add 'input', Apex.Form.Input
console.log('resolver added input')
