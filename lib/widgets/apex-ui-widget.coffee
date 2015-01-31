{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
View = View #spacepen
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

  Emitter.includeInto @

  @content: ->
    @div class: 'apex-widget selectable'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    console.log 'widget initialized'
    @_followTimeout = -1
    @x = 0
    @y = 0

  # concrete/ class methods...

  add: (form) ->
    @view()

    form.append @
    if form.isDesigner
      @append $("<div class='widget-select-mask' />")
    @emit 'added', form

  preview: (form) ->
    @addClass 'preview'
    @designer()
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
