{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
console.dir($)
window.$ = $
window.jQuery = $

{View} = require 'atom-space-pen-views'
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
  @properties = []
  @windowTitle = 'Untitled Form'

  @name = ''

  @content: ->
    @div class: 'form-widget selectable', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', outlet: 'header', =>
          @span '', outlet: 'title'
          @div class:'close-icon', outlet: 'close'
        @div class: 'panel-body padded', outlet: 'contents'

  initialize: (params) ->
    if params.parent
      @parent = params.parent

    @hover = false
    @widgets = []

    # may be accompanied by a more integrated form runtime, but the first / preferable
    # option would be to generate view classes in Spacepen, HTML / CSS (LESS)
    @isDesigner = true
    @isRuntime = false # not implemented.

    Apex.apexCurrentDevForm = @
    @properties = ['string:name', 'string:windowTitle']

    # Starting runtime generator
    if params.isRuntime then @isDesigner = false
    if params.isRuntime then @isRuntime = true

    # Currently, we always init as designer (though as indicated above this could change)
    @initDesigner() unless not @isDesigner

    # Create root element
    @element.classList.add('apex-form-widget')

    # floating glass style
    @element.classList.add('modal')
    @element.classList.add('form-widget-floating')

    @selectList = []

    # Viewhost (Apex form builder - Select does the highlight and property view stuff)
    $(@header).dblclick =>
      if @viewHost then @viewHost?.select? @

    # Todo: update behavior based on state of the model
    @close.click =>
      @destroy()

  select: ->
    #@selectable( "option", "disabled", true )
    if @viewHost then @viewHost?.select? @

  initDesigner: ->
    scope = @
    @selectFn = ->
      scope.selectWidget(this)
    #$('.apex-widget.selectable').delegate("click", @selectFn)
    #$('.apex-widget.selectable .widget-select-mask').delegate("click", @selectFn)
    jq(@contents).selectable(
      unselected: (event, ui) =>
        if ui.unselected
          if ui.unselected.spacePenView?
            if @selectList.indexOf(ui.unselected) != -1
              @selectList.splice(@selectList.indexOf(ui.unselected), 1)

            $(ui.unselected).closest('.selectable').removeClass 'selected'

      selected: (event, ui) =>
        if ui.selected
          if ui.selected.spacePenView?
            if @selectList.indexOf(ui.selected) == -1
              @selectList.unshift(ui.selected)

            if @selectList.length == 1
              ui.selected.spacePenView.select?()

            $(ui.selected).closest('.selectable').addClass 'selected'

          console.dir ui.selected
          window.lastSelected = ui.selected
          #@selectable( "option", "disabled", false )
        else
          console.dir ui
    )

  selectWidget: (el) ->
    console.log 'selecting..'
    console.dir el
    if @viewHost then @viewHost?.select? el

  over: (event, ui) ->
    window.lastEvent = event
    window.lastUI = ui
    # only process draggable here if its from the toolbox
    if ui.draggable[0].tagName != "LI" then return
    $(ui.draggable).draggable( "option", "containment", @contents )
    $(ui.draggable).draggable({ grid: [5, 5], drag: @drag.bind @ })
    @drag(event, ui)

  out: (event, ui) ->
    window.lastEvent = event
    window.lastUI = ui
    if ui.draggable[0].tagName != "LI" then return
    $(window.formBuilderDraggable).draggable("option", "grid", false)
    @drag(event, ui)

  drag: (ev, ui) ->
    window.lastEvent = event
    window.lastUI = ui
    console.log 'drag event: '+ev.type+':'
    console.dir(ev)
    console.dir(ui)

    @ui = ui
    @ev = ev

    @objectX = @ui.offset.left - @offset().left
    @objectY = @ui.offset.top - @offset().top

  #  if not @interval or @interval = -1
    #  @interval = window.setInterval ( => if @hover then @hover.position(@ui.offset.left - @offset().left, @ui.offset.left - @offset().top)), 100

    if @hover
      @hover.position @objectX, @objectY

    # check by type event type
    if ev.type is 'dropover'
      @createDropover(ev)

    if ev.type is 'drop'
      @finishDrop(ev)

  createDropover: (ev) ->
    @ev = ev
    if @interval
      window.clearInterval @interval
      @interval = -1

    if not @hover
      # put the designer widget here
      #@hover = Apex.hoverValue.makeValue(@ev.pageX, @ev.pageY, @updateText.bind @, 'atom-panel.ui-resizable .inset-panel')
      name = $(@ui.draggable.context).attr('data-name')
      if not name or name.length == 0 then return
      type = Apex.widgetResolver.resolve(name)
      if not type
        console.log 'undefined widget type: '+name
        return

      @hover = new type()
      @hover.preview @
      #hover.follow $(@ui.draggable.context)
      #@contents.append @hover
      # extensive..
      # Apex.formBuilder.view.workspace.views()[0].form

    if @hover
      @hover.position @objectX, @objectY

  finishDrop: (ev) ->
    # finish / create
    newPosX = @ui.offset.left - @offset().left;
    newPosY = @ui.offset.top - @offset().top;

    if @interval
      window.clearInterval @interval
      @interval = -1

    if @hover
      @hover.position newPosX, newPosY

      # reset hover
      @hover.remove()
      @hover = null

    # create new widget
    name = $(@ui.draggable.context).attr('data-name')
    if not name or name.length == 0 then return

    type = Apex.widgetResolver.resolve(name)
    widget = new type()
    widget.add @
    widget.position newPosX, newPosY
    @widgets.push widget

  update: ->
    if @windowTitle then @title.text @windowTitle

  inflate: (obj) ->
    @title.text obj.title
    $(@).width obj.width
    $(@).height obj.height
    if obj.name then @name = obj.name
    for w in obj.widgets
      type = Apex.widgetResolver.resolve(w.widgetType)
      widget = new type()
      widget.add @
      widget.position w.x, w.y
      for prop in Object.keys(w)
        widget[prop] = w[prop]
      widget.update()
      @widgets.push widget

  JSON: ->
    @w = parseInt @css('width').replace('px', '')
    @h = parseInt @css('height').replace('px', '')

    obj = {name: @name, title: @windowTitle, width: @w, height: @h, widgets: [] }
    for widget in @widgets
      widgetObject = {}
      for prop in widget.properties
        name = prop
        if prop.indexOf(":") != -1 then name = prop.split(':')[1]
        if name is 'name' and widget.name.length == 0 then continue
        widgetObject[name] = widget[name]
      obj.widgets.push widgetObject
    JSON.stringify obj

  setViewHost: (@viewHost) ->

  # basically more like, editing mode not just resizable..
  setResizable: (status) ->
    $(@element).width(Math.max(250, $('.apex-form-workspace').width()-120))
    $(@element).height(Math.max(250, $('.apex-form-workspace').height()-120))
    $(@element).draggable handle:'.panel-heading', grid: [15, 15]
    $(@element).resizable { grid: [15, 15], handles: 'n, e, s, w' }

    el = $(@element) #.find '.inset-panel'
    el.droppable(
      drag: @drag.bind @
      drop: @drag.bind @
      over: @over.bind @
      out: @out.bind @
    )

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
    @windowTitle = title
  getTitle: ->
    return @title.text()
