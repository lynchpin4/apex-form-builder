{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Common UI Button (Core)
    -------------------

    The pushbutton. Always useful.
###

module.exports =
class Apex.Form.Button extends Apex.Form.Widget

  widgetType: 'button'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    @title = 'Button'
    console.log 'Button initialized'

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @button = $('<button/>')
    @button.text @title
    @button.addClass 'grow'
    @append @button

  # construct the regular view element onto @body
  view: ->
    @button = $('<button/>')
    @button.text @title
    @button.addClass 'grow'
    @button.click => @emit 'click'
    @button.dblclick => @emit 'dblclick'
    @append @button

Apex.widgetResolver.add 'button', Apex.Form.Button
console.log('resolver added button')
