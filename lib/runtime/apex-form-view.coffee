{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'
jq = require('../deps/jquery-ui')($)
window.jqUi = jq;

window.Apex ?= {}
Apex.Form ?= {}

###
   Form / Window Widget
   =====================
   
   Designed primarily for use in the designer view but the design should
   retain enough flexibility to be used as-is in a project if someone wants..
###

module.exports =
class Apex.Form.FormView extends View
  
  Emitter.includeInto @
  
  @content: ->
    @tag 'atom-panel', class: 'form-widget selectable', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', outlet: 'header', => 
          @span '', outlet: 'title'
          @div class:'close-icon', outlet: 'close'
        @div class: 'panel-body padded', outlet: 'contents'
    
  initialize: ->
    @interact = Apex.interact
    
    # Create root element
    @element.classList.add('apex-form-widget')
    
    $(@header).dblclick =>
      if @viewHost then @viewHost?.select? @
      
    
    # Todo: update behavior based on state of the model
    @close.click =>
      @destroy()
      
  setViewHost: (@viewHost) ->
      
  # basically more like, editing mode not just resizable..
  setResizable: (status) ->
    $(@element).width(Math.max(250, $('.apex-form-workspace').width()-120))
    $(@element).height(Math.max(250, $('.apex-form-workspace').height()-120))
    $(@element).draggable handle:'.panel-heading', grid: [15, 15]
    $(@element).resizable grid: [15, 15]
    try
      $(@element).position my: 'center', at: 'center', of: '.apex-form-workspace'
    catch ex
      console.log 'exception positioning el @ .apex-form-workspace:'
      console.log ex.stack
      try
        $(@element).position my: 'center', at: 'center', of: @element.parent()? || $('.apex-form-workspace')
      catch ex2
        console.log ex2 + ' .. a second attempt also failed.'
    
  # get / set backing model for the view (todo: subscribe to widget events)
  setModel: (@model) ->
  getModel: -> 
    @model
    
  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    if @element then @element.remove()

  getElement: ->
    @element
  
  getViewClass: -> Apex.Form.FormView
  getView:      -> @
  
  setTitle: (title) -> 
    @title.text title
  getTitle: ->
    return @title.text()
