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
  
  # perform initialization logic, subclasses should override
  initialize: ->
    super
  
  # constructs a version of the view for designer use (with tools, built-in focus logic)
  designer: ->
    @button = $('<button/>')
  
  # construct the regular view element onto @body
  view: ->
    @button = $('<button/>')
    @button.click => @emit 'click'
    @button.dblclick => @emit 'dblclick'
    