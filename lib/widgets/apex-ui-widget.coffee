# {Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
{Emitter} = require 'event-kit'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
  Widget Resolver
  ----------------

  Singleton class to keep track of all the usable UI widgets we've created.
  API: @resolver.addWidget 'widget', Apex.Form.Widget

###
class Apex.Form.WidgetResolver

  widgets: {}

  add: (name, type) -> @addWidget name, type
  addWidget: (name, type) ->
    @widgets[name] = type

  resolve: (name) ->
    return @widgets[name] or Apex.Form.Widget

  lookup: (type) ->
    for k, v in @widgets
      if v == type
        return k

Apex.widgetResolver or= new Apex.Form.WidgetResolver()

###
    Common Form Widget (Abstract Class)
    -------------------

    The core class for any widget, handles logic
    of placing the widget on the surface, and holds
    state including position handling and bindings
    and delegates
###

module.exports =
class Apex.Form.Widget extends View

  widgetType: 'widget'
  x: 0
  y: 0

  emitter: new Emitter

  @content: ->
    @div class: 'apex-widget selectable'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    console.log 'widget initialized'
    @_followTimeout = -1
    @x = 0
    @y = 0

  # concrete(ish) / class methods...

  startEditing: ->
    $(@).resizable()
    $(@).draggable()
    $(@).draggable( "option", "containment", @form.contents )

  add: (form) ->
    @view()

    form.append @
    @form = form
    selecter = $("<div class='widget-select-mask' style='z-index: 999999;' />")
    @append selecter
    scope = @
    selecter.click =>
      console.log 'selecting: '
      console.dir(@)
      @form.selectWidget @
      scope.startEditing()
    @emitter.emit 'added', @

  preview: (form) ->
    @addClass 'preview'
    if @designer then @designer()
    form.append @
    @css
      opacity: 0.5

  follow: (el) ->
    return # broken for now
    # this is a helper for preview, set up a timeout to copy positioning values of the target before drop (WYSIWYG)
    if @_followTimeout != -1
      clearInterval @_followTimeout
    @_followTimeout = setInterval((=> @_updateFollow), 100)
    @_followEl = el

  _updateFollow:
    if not @_followEl
      clearInterval @_followTimeout
    else
      loc = @_followEl.offset()
      @position loc.x, loc.y


  position: (x, y) ->
    @x = x
    @y = y
    @css
      position: 'absolute'
      top: "#{y}px"
      left: "#{x}px"

# Add the new widget
#pex.widgetResolver.add 'widget', Apex.Form.Widget
#console.log('resolver added widget')
