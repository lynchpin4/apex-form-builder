{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'
# <includes> - tag for inserting other optional requirements

window.Apex ?= {}
Apex.Form ?= {}

window.Forms ?= {}
module.exports =
class Forms.pos extends View

  Emitter.includeInto @

  @title = "Whateva 4um"
  @name = "pos"

  constructor: (params) ->
    if params.afterSetup then @afterSetup = params.afterSetup

    @attached = =>
      @setup()
    @_appendTo = @appendTo
    @appendTo = (el) =>
      @_appendTo el
      @attached()

    super params

  # modal form-widget-floating aren't neccessary but add cool decoration for floating windows
  @content: ->
    @tag 'atom-panel', class: 'form-widget apex-form-widget modal form-widget-floating form-pos', =>
      @raw '<style>.form-pos { width: 558px; height: 250px; }</style>'
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', outlet: 'header', =>
          @span "Whateva 4um", outlet: 'title'
          @div class:'close-icon', outlet: 'close'
        @div class: 'panel-body padded', outlet: 'contents', =>
          @subview "button1", new Apex.widgetResolver.widgets["button"]({"widgetType":"button","x":7,"y":9,"w":54,"h":24,"title":"STRING"}).get()
          @subview "input2", new Apex.widgetResolver.widgets["input"]({"widgetType":"input","x":63,"y":9,"w":126,"h":23,"value":"Textbox"}).get()
          @subview "label3", new Apex.widgetResolver.widgets["label"]({"widgetType":"label","x":196,"y":5,"w":182,"h":22,"title":"Science be damned.. It's good for the economy"}).get()
          @subview "editor4", new Apex.widgetResolver.widgets["editor"]({"widgetType":"editor","x":9,"y":42,"w":521,"h":141}).get()

  setup: ->
    if @_setup then return
    @_setup = yes

    console.log 'setup '+@name

    # default dragger
    $(@element).draggable handle:'.panel-heading', grid: [15, 15]

    # default position
    @css 'position', 'fixed'
    @css 'z-index', '99999'
    @css 'left', '200px'
    @css 'top', '100px'

    @close.click =>
      @destroy()

    @afterSetup?()

  destroy: ->
    $(@element).remove()