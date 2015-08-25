{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
{View} = require 'atom-space-pen-views'
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
    super params
    @title = @title or 'Button'
    console.log 'Button initialized'
    @properties.push 'string:title'

  update: ->
    super
    if @button then @button.text @title

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @button = $('<button class="btn"/>')
    @button.text @title
    @button.addClass 'grow'
    @append @button

  # construct the regular view element onto @body
  view: ->
    @button = $('<button class="btn"/>')
    @button.text @title
    @button.addClass 'grow'
    @button.click => @emit 'click'
    @button.dblclick => @emit 'dblclick'
    @append @button

Apex.widgetResolver.add 'button', Apex.Form.Button
console.log('resolver added button')
