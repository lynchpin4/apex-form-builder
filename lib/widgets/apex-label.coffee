{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Label (Core)
    -------------------

    Just your average text label
###

module.exports =
class Apex.Form.Label extends Apex.Form.Widget

  widgetType: 'label'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    @title = 'Button'
    console.log 'Button initialized'

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

Apex.widgetResolver.add 'label', Apex.Form.Label
console.log('resolver added label')
