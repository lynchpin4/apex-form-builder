{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Tree (Core)
    -------------------

    Tree for displaying directories or tree-based models.
###

module.exports =
class Apex.Form.TreeView extends Apex.Form.Widget

  widgetType: 'treeview'

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

Apex.widgetResolver.add 'treeview', Apex.Form.TreeView
console.log('resolver added treeview')
