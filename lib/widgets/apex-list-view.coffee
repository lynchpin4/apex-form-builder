{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    ListView (Core)
    -------------------

    Simple view for a list with flat rows of items.
###

module.exports =
class Apex.Form.ListView extends Apex.Form.Widget

  widgetType: 'listview'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    super params
    @title = 'Button'
    @properties.push 'string:title'
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

Apex.widgetResolver.add 'listview', Apex.Form.ListView
console.log('resolver added listview')
