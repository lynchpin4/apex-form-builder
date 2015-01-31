{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

Apex.Form.WidgetView = require './runtime/apex-form-view'
Apex.Form.PropertiesView = require './apex-form-properties'
Apex.Form.ToolboxView = require './apex-form-toolbox'

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
    @div class:'apex-form-pane', =>
      @div class:'apex-form-toolbox', outlet: 'toolboxContainer', =>
        @subview 'toolbox', new Apex.Form.ToolboxView({parent: @})
        @subview 'formProperties', new Apex.Form.PropertiesView({parent: @})
      @div class:'apex-form-workspace', outlet: 'workspace'

  setParent: -> (@parentClass)
  setState: -> (@state)

  initialize: ->
    # Create root element
    @element.classList.add('apex-form-builder')

    @toolbox.setViewHost @
    @formProperties.setViewHost @

    @form = new Apex.Form.FormView({parent: @})
    @form.setTitle 'Untitled Form'
    # redundant
    @form.setViewHost @
    @form.appendTo @workspace

    @initActions()

    @form.setResizable true
    console.log 'apex form builder initialized'

  #  @formProperties.hide()

  initActions: ->
    # real quick hide properties view
    @formProperties.hide()

  # element requested highlight
  select: (el) ->
    $('.apex-form-pane .selected').removeClass 'selected'
    @highlight(el);

  highlight: (el) ->
    # Highlight a view / show and open property window when available.
    trueEl = $(el).closest('.selectable')
    trueEl.addClass 'selected'
    @formProperties.show trueEl

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    if @element then @element.remove()

  getElement: ->
    @element

  getClass:     -> @parentClass
  getViewClass: -> Apex.Form.BuilderView
  getView:      -> @
  getPath:      -> path.join __dirname, 'examples', 'test.json'

  setTitle: (@title) ->
  getTitle: ->
    return @title || 'Apex Form Builder'

  getLongTitle: -> @getTitle()
