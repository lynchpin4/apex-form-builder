{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Button Group (Core)
    -------------------

    A group of buttons.
###

module.exports =
class Apex.Form.ButtonGroup extends Apex.Form.Widget

  widgetType: 'btngroup'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    @title = 'Button Group'
    console.log @title + ' initialized'

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @buttonGroup = $('<div class="btn-group"><button class="btn"/><button class="btn"/><button class="btn"/></div>')
    @buttonGroup.find('button').text @title
    @buttonGroup.addClass 'grow'
    @append @buttonGroup

  # construct the regular view element onto @body
  view: ->
    @buttonGroup = $('<div class="btn-group"><button class="btn"/><button class="btn"/><button class="btn"/></div>')
    @buttonGroup.find('button').text @title
    @buttonGroup.addClass 'grow'
    @buttonGroup.click => @emit 'click'
    @buttonGroup.dblclick => @emit 'dblclick'
    @append @buttonGroup

Apex.widgetResolver.add 'buttongroup', Apex.Form.ButtonGroup
console.log('resolver added button group')