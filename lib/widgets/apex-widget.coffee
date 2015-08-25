# {Emitter} = require 'emissary'
{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
{View} = require 'atom-space-pen-views'
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
  name: ''
  x: 0
  y: 0
  w: 0
  h: 0

  emitter: new Emitter

  @content: ->
    @div class: 'apex-widget selectable'

  # perform initialization logic, subclasses should override
  initialize: (params) ->
    @_followTimeout = -1
    @x = 0
    @y = 0
    @params = params or {}
    @properties = ['widgetType', 'string:name', 'int:x', 'int:y', 'int:w', 'int:h']

    @_updateProps()

  # concrete(ish) / class methods...

  _updateProps: ->
    for prop in @properties
      if prop.indexOf(":") != -1
        propType = prop.split(":")[0]
        propName = prop.split(":")[1]

        if @params.hasOwnProperty(propName)
          this[propName] = @params[propName]

  emit: (event, data) -> @emitter.emit event, data

  startEditing: ->
    @selecter.show()

    @x = parseInt @css('left').replace('px', '')
    @y = parseInt @css('top').replace('px', '')
    @w = parseInt @css('width').replace('px', '')
    @h = parseInt @css('height').replace('px', '')

    $(@).resizable(
      handles: 'n, e, s, w',
      stop: =>
        @w = parseInt @width()
        @h = parseInt @height()
    )
    $(@).draggable(
      grid: false,
      stop: =>
        @x = parseInt @css('left').replace('px', '')
        @y = parseInt @css('top').replace('px', '')
    )
    $(@).draggable( "option", "containment", @form.contents )

  stopEditing: ->
    #@selecter.hide()

    $(@).resizable("destroy")
    $(@).draggable("destroy")
    console.log 'stopped editing '+@widgetType

  get: ->
    @_updateProps()
    view = @view()
    @update()
    view

  add: (form) ->
    @view()

    form.contents.append @
    @form = form

    @selecter = $("<div class='widget-select-mask' style='z-index: 999999;' />")
    @append @selecter
    scope = @

    @x = parseInt @css('left').replace('px', '')
    @y = parseInt @css('top').replace('px', '')
    @w = parseInt @css('width').replace('px', '')
    @h = parseInt @css('height').replace('px', '')

    #@selectable()

    @selecter.click =>
      console.dir scope
      if window.apexSelectedWidget != scope
        if window.apexSelectedWidget? then window.apexSelectedWidget.stopEditing()
        console.log 'selecting: '
        console.dir(scope)
        console.dir(@)

        window.apexSelectedWidget = scope
        @form.selectWidget scope
        scope.startEditing()

    @emitter.emit 'added', @

  preview: (form) ->
    @addClass 'preview'
    if @designer then @designer()
    form.contents.append @
    @css
      opacity: 0.5

  select: ->
    if window.apexSelectedWidget != @
      if window.apexSelectedWidget? then window.apexSelectedWidget.stopEditing()
      console.log 'selecting: '
      console.dir(@)

      window.apexSelectedWidget = @
      @form.selectWidget @
      @startEditing()

  # called when properties are updated
  update: ->
    @position @x, @y
    if @w > 0 and @h > 0
      @width @w unless @w is 0
      @height @h unless @h is 0

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
