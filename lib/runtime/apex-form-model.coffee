{find, compact, extend, last, flatten} = require 'underscore-plus'
{Model} = require 'theorist'
{Emitter, CompositeDisposable} = require 'event-kit'

###
    Form Model 
    -----------
    
    A backing store for data used to draw and maintain the state of the UI widgets
    from the designer to the template compiler. Notice: Implentation still WIP
###

window.Apex ?= {}
Apex.Form ?= {}

class Apex.Form.FormModel extends Model
  
  @properties
    title: undefined
    width: 0
    height: 0
    container: undefined
    activeWidget: undefined
  
  constructor: (params) ->
    super
    
    @emitter = new Emitter
    @widgets = []
    
    @addWidgets(compact(params?.widgets ? []))
  
  getActiveWidgetIndex: ->
    @items.indexOf(@activeWidget)
  
  # Add a single widget if it has not been added before
  
  addWidget: (widget, index=@getActiveWidgetIndex() + 1) ->
    # failsafe
    return if widget in @widgets
    
    # smart
    if typeof item.on is 'function'
      @subscribe item, 'destroyed', => @removeItem(widget, true)

    @widgets.splice(index, 0, widget)
    @emit 'widget-added', widget, index
    @emitter.emit 'did-add-widget', {widget, index}
    @setActiveItem(widget) unless @getActiveItem()?
    widget
  
  # Add a bunch more of widgets without adding any that already exist. Simple and efficient.
  
  addWidgets: (widgets, index=@getActiveWidgetIndex() + 1) ->
    items = widgets.filter (item) => not (widget in @widgets)
    @addWidget(widget, index + i) for widget, i in widgets
    widgets

  removeWidget: (item, destroyed=false) ->
    index = @widgets.indexOf(item)
    return if index is -1
    
    # lean
    if typeof item.on is 'function'
      @unsubscribe item

    #if item is @activeItem
    #  if @items.length is 1
    #    @setActiveItem(undefined)
    #  else if index is 0
    #    @activateNextItem()
    #  else
    #    @activatePreviousItem()
        
    @widgets.splice(index, 1)
    @emit 'widget-removed', item, index, destroyed
    @emitter.emit 'did-remove-widget', {item, index, destroyed}
  
  # Simple event handler / callback pairs
  
  onDidChangeTitle: (callback) ->
    @emitter.on 'did-change-title', callback