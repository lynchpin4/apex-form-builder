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

    # Currently, we always init as designer (though as indicated above this could change)
    @initDesigner() unless not @isDesigner

    # Create root element
    @element.classList.add('apex-form-widget')

    # Viewhost (Apex form builder - Select does the highlight and property view stuff)
    $(@header).dblclick =>
      if @viewHost then @viewHost?.select? @

    # Todo: update behavior based on state of the model
    @close.click =>
      @destroy()

  initDesigner: ->
    scope = @
    @selectFn = ->
      scope.selectWidget(this)
    $('.apex-widget.selectable').delegate("click", @selectFn)
    $('.apex-widget.selectable .widget-select-mask').delegate("click", @selectFn)

  selectWidget: (el) ->
    console.log 'selecting..'
    console.dir el
    if @viewHost then @viewHost?.select? el

  drag: (ev, ui) ->
    console.log 'drag event: '+ev.type+':'
    console.dir(ev)
    console.dir(ui)

    @ui = ui
    @ev = ev

    @objectX = @ui.offset.left - @offset().left
    @objectY = @ui.offset.top - @offset().top

    if not @interval or @interval = -1
      @interval = window.setInterval ( => if @hover then @hover.position(@ui.offset.left - @offset().left, @ui.offset.left - @offset().top)), 100

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
      if not name or name.length == 0 then name = "widget"
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
    if not name or name.length == 0 then name = "widget"
    type = Apex.widgetResolver.resolve(name)
    widget = new type()
    widget.add @
    widget.position newPosX, newPosY
    @widgets.push widget

  setViewHost: (@viewHost) ->

  # basically more like, editing mode not just resizable..
  setResizable: (status) ->
    $(@element).width(Math.max(250, $('.apex-form-workspace').width()-120))
    $(@element).height(Math.max(250, $('.apex-form-workspace').height()-120))
    $(@element).draggable handle:'.panel-heading', grid: [15, 15]
    $(@element).resizable grid: [15, 15]

    el = $(@element) #.find '.inset-panel'
    el.droppable(
      drag: @drag.bind @
      drop: @drag.bind @
      over: @drag.bind @
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
  getTitle: ->
    return @title.text()
