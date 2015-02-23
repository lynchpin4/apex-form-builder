{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'
# <includes> - tag for inserting other optional requirements

window.Apex ?= {}
Apex.Form ?= {}

window.Forms ?= {}
module.exports =
class Forms.PopupScriptEditor extends View

  Emitter.includeInto @

  @title = "Script Editor"
  @name = "PopupScriptEditor"

  constructor: (params) ->
    if params?.afterSetup then @afterSetup = params.afterSetup

    @attached = =>
      @setup()
    @_appendTo = @appendTo
    @appendTo = (el) =>
      @_appendTo el
      @attached()

    super params

  # modal form-widget-floating aren't neccessary but add cool decoration for floating windows
  @content: ->
    @tag 'atom-panel', class: 'form-widget apex-form-widget modal form-widget-floating form-PopupScriptEditor', =>
      @raw '<style>.form-PopupScriptEditor { width: 438px; height: 319px; }</style>'
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', outlet: 'header', =>
          @span "Script Editor", outlet: 'title'
          @div class:'close-icon', outlet: 'close'
        @div class: 'panel-body padded', outlet: 'contents', =>
          @subview "label1", new Apex.widgetResolver.widgets["label"]({"widgetType":"label","x":7,"y":5,"w":32,"h":23,"title":"Script:"}).get()
          @subview "spinner2", new Apex.widgetResolver.widgets["spinner"]({"widgetType":"spinner","x":53,"y":79,"w":10,"h":15}).get()
          @subview "editor3", new Apex.widgetResolver.widgets["editor"]({"widgetType":"editor","x":7,"y":24,"w":400,"h":194}).get()
          @subview "button4", new Apex.widgetResolver.widgets["button"]({"widgetType":"button","x":353,"y":228,"w":56,"h":29,"title":"Save"}).get()
          @subview "button5", new Apex.widgetResolver.widgets["button"]({"widgetType":"button","x":285,"y":228,"w":60,"h":29,"title":"Cancel"}).get()

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