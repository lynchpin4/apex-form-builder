{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
{View} = require 'atom-space-pen-views'
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
    super params
    @title = 'Label'
    console.log 'label initialized'
    @properties.push 'string:title'

  update: ->
    super
    if @label then @label.text @title

  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @label = $('<label/>')
    @label.text @title
    @label.addClass 'label-text-widget'
    @label.addClass 'grow'
    @append @label

  # construct the regular view element onto @body
  view: ->
    @label = $('<label />')
    @label.text @title
    @label.addClass 'grow'
    @label.addClass 'label-text-widget'
    @label.click => @emit 'click'
    @label.dblclick => @emit 'dblclick'
    @append @label

Apex.widgetResolver.add 'label', Apex.Form.Label
console.log('resolver added label')
