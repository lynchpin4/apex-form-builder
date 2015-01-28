Emitter = require('events').EventEmitter
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
    Common Form Widget (Abstract Class)
    -------------------
    
    The core class for any widget, handles logic
    of placing the widget on the surface, and holds
    state including position handling and bindings
    and delegates
###

module.exports = 
class Apex.Form.Widget extends Emitter
  
  # ..
  x: 0
  y: 0
  
  @content: ->
    @div class: 'apex-widget', outlet: 'body'
  
  # perform initialization logic, subclasses should override
  initialize: ->
  
  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    label = $('<label/>')
    label.text 'hello designer'
    label.css
      backgroundColor: 'red',
      color: 'black'
    label.appendTo @element
  
  # construct the regular view element onto @body
  view: ->
    label = $('<label/>')
    label.text 'hello form'
    label.css
      backgroundColor: 'black',
      color: 'red',
      'font-weight': 'bold'
    label.appendTo @element
    @element
    
    # less abstract methods...
    
    add: (form) ->
      @view().appendTo form.element
      @emit 'added', form
    
    preview: (form) ->
      @designer().appendTo form.element
      @element.css
        opacity: 0.5
    
    position: (x, y) ->
      if x and y
        @x = x
        @y = y
      @element.css
        position: 'absolute'
        top: "#{y}px"
        left: "#{x}py"
    