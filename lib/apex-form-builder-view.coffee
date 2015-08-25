{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
{View} = require 'atom-space-pen-views'
path = require 'path'
remote = require 'remote'
Menu = remote.require 'menu'
dialog = remote.require "dialog"

window.Apex ?= {}
Apex.Form ?= {}

Apex.Form.WidgetView = require './runtime/apex-form-view'
Apex.Form.ToolboxView = require './apex-form-toolbox'
Apex.Form.PropertiesView = require './apex-form-properties'

###
    Form Designer for Apex IDE / Atom.io
    ------------------------------------

    This package intends to create new space pen views based on a widget
    designed by the end consumer or coder, easing a couple pain points
    with creating atom plugins and also external UI code.

    It is modeled after many existing form creators and of course,
    the great VS-Like toolkits that came before it.
###

module.exports =
class Apex.Form.BuilderView extends View

  Emitter.includeInto @
  ###
  Original panel example:
  <atom-panel class='top'>
    <div class="padded">
        <div class="inset-panel">
            <div class="panel-heading">An inset-panel heading</div>
            <div class="panel-body padded">Some Content</div>
        </div>
    </div>
</atom-panel>
  ###

  @content: ->
    @div class:'apex-form-pane pane-item', =>
      @div class:'apex-form-toolbox', outlet: 'toolboxContainer', =>
        @subview 'toolbox', new Apex.Form.ToolboxView({parent: @})
        @subview 'formProperties', new Apex.Form.PropertiesView({parent: @})
      @div class:'apex-form-workspace', outlet: 'workspace'

  setParent: -> (@parentClass)
  setState: (@state) ->
    if @state?.form
      @form.inflate @state.form

  initialize: (params) ->
    # Create root element
    @element.classList.add('apex-form-builder')

    @toolbox.setViewHost @
    @formProperties.setViewHost @

    @form = new Apex.Form.FormView({parent: @})
    @form.setTitle 'Untitled Form'
    # redundant
    @form.setViewHost @
    @form.appendTo @workspace
    #@form.mousedown((ev) =>
    #  if ev.which == 2 then @showMenu()
    #)

    atom.commands.add '.apex-form-builder', 'apex-form-builder:delete-widget': => @deleteWidget()

    atom.contextMenu.add {
      '.apex-form-builder': [
        {'label': 'Delete Widget', command: 'apex-form-builder:delete-widget' }
        # {'type': 'seperator'}
      ]
    }

    @initActions()

    @form.setResizable true
    console.log 'apex form builder initialized'

  #  @formProperties.hide()

  deleteWidget: ->
    index = @form.widgets.indexOf(window.apexSelectedWidget)
    console.log index
    if index != -1
      widget = @form.widgets[index]
      console.log 'deleting: '
      console.dir widget
      widget.hide()
      @form.widgets.splice(index, 1)

  showMenu: ->
    template = [
      {'label': 'Delete Widget', click: @deleteWidget.bind @ }
    ]

    menu = Menu.buildFromTemplate(template)
    console.dir menu
    menu.popup(atom.getCurrentWindow())

  initActions: ->
    # real quick hide properties view
    @formProperties.hide()

  # element requested highlight
  select: (el) ->
    @selectWidget = el
    $('.apex-form-pane .selected').removeClass 'selected'
    @highlight(el)

  highlight: (el) ->
    # Highlight a view / show and open property window when available.
    trueEl = $(el).closest('.selectable')
    trueEl.addClass 'selected'
    @formProperties.show @selectWidget

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    @obj = {}
    @obj.form = JSON.parse @form.JSON()
    @obj

  shouldPromptToSave: ->
    false

  save: (path) ->
    if @path
      if @path.indexOf(".") == -1 then @path = @path + '.form'
      fs.writeFileSync @path, JSON.stringify @serialize()
      atom.notifications.addSuccess 'Saved Form At '+@path
      return true
    else
      if path
        @path = path
        @save()
      else
        @saveAs()
    #else
    #  @path = dialog.showSaveDialog({properties:['openFile']})
    #  if @path and @path.length > 2
    #    @save()

  saveAs: (path) ->
    if not path
      @path = dialog.showSaveDialog({properties:['openFile']})
    else
      @path = path
    if @path and @path.length > 2
      return @save(@path)
    else
      return false

  # Tear down any state and detach
  destroy: ->
    if @element then @element.remove()

  getElement: ->
    @element

  getClass:     -> @parentClass
  getViewClass: -> Apex.Form.BuilderView
  getView:      -> @
  getPath:      -> @path
  setPath: (@path) ->

  setTitle: (@title) ->
  getTitle: ->
    return @title || 'Apex Form Builder'

  getLongTitle: -> @getTitle()
