{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'
# <includes> - tag for inserting other optional requirements

window.Apex ?= {}
Apex.Form ?= {}

window.Forms ?= {}
module.exports =
class Forms.Default extends View

  Emitter.includeInto @

  @title = "Untitled Form"
  @name = "Default"

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
    @tag 'atom-panel', class: 'form-widget apex-form-widget modal form-widget-floating form-Default', =>
      @raw '<style>atom-panel.form-Default { width: 559px; height: 348px; }</style>'
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', outlet: 'header', =>
          @span "Untitled Form", outlet: 'title'
          @div class:'close-icon', outlet: 'close'
        @div class: 'panel-body padded', outlet: 'contents', =>
          @subview "input1", new Apex.widgetResolver.widgets["input"]({"widgetType":"input","x":12,"y":13,"w":128,"h":23,"value":"Textbox"}).get()
          @subview "button2", new Apex.widgetResolver.widgets["button"]({"widgetType":"button","x":144,"y":11,"w":52,"h":25,"title":"Button"}).get()
          @subview "label3", new Apex.widgetResolver.widgets["label"]({"widgetType":"label","x":15,"y":45,"w":77,"h":22,"title":"Lets go"}).get()

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