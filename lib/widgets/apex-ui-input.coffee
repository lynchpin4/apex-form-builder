{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Common UI Textbox (Core)
    -------------------

    The pushbutton. Always useful.
###

module.exports =
class Apex.Form.Textbox extends Apex.Form.Widget

  widgetType: 'textbox'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    @value = 'Textbox'
    console.log 'Textbox initialized'

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

Apex.widgetResolver.add 'textbox', Apex.Form.Textbox
console.log('resolver added button')
