{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
{View} = require 'space-pen'
path = require 'path'

Widgets = require './widgets/widgets'

window.Apex ?= {}
Apex.Form ?= {}

###
* Form Toolbox Scripts
* ---------------------
*
* Slightly oversimplifies the logic of previewing a control being dropped onto the form

###

# icons
# .flaticon-ok6 / simple button
# .flaticon-tool7 / box entry
# .flaticon-textbox / textbox
# .flaticon-numbers8 / numeric input
# .flaticon-check30 / checkbox
# .flaticon-mini5 / numbered list
# .flaticon-check50 / radio button
# .flaticon-radio51 / nother' radio
# .flaticon-radio32 / radio wit label
# .flaticon-notes9 / multiline text
# .flaticon-right173 / custom html
# .flaticon-image84 / image
# .flaticon-browser14 / webview / browser
# .flaticon-calendar68 / date time
# .flaticon-calendar146 / date
# .flaticon-http1 / url box
# .flaticon-category2 / ordered tree list
# .flaticon-text146 / simple selct list
# .flaticon-view12 / select list w/ images
# .flaticon-show6 / thumbnail grid
# .flaticon-text38 / label * fonts
# .flaticon-table41 / table
# .flaticon-location35 / leaflet map

# layouts
# .flaticon-design24 / left aligned text, right aligned content layout
#module.exports = {}
#module.exports.Widget = require './apex-widget'
#module.exports.Button = require './apex-button'
#module.exports.Input = require './apex-input'
#module.exports.TextEditor = require './apex-text-editor'
#module.exports.TreeView = require './apex-tree-view'
#module.exports.ListView = require './apex-list-view'
#module.exports.Label = require './apex-label'
#module.exports.ButtonGroup = require './apex-button-group'

# many of these can/shud be extended from input (tho it may require some minor modification to produce the right html)
BUILTIN_WIDGETS = {
  #'widget': {name: 'widget', icon:'flaticon-ok6', tip: 'Base Widget (Test)', widget: Widgets.Widget},
  'button': {name: 'button', icon:'flaticon-ok6', tip: 'Simple and uniform button.', widget: Widgets.Button},
  'buttongroup': {name: 'buttongroup', icon:'flaticon-ok6', tip: 'Simple and uniform button.', widget: Widgets.ButtonGroup},
  'input': {name: 'input', icon:'flaticon-textbox', tip: 'HTML5 Input', widget: Widgets.Input},
  'numeric': {icon:'flaticon-numbers8', tip: 'Numeric only input'}, # todo
  'checkbox': {name: 'checkbox', icon:'flaticon-check30', tip: 'Common checkbox', widget: Widgets.CheckBox}, # todo
  'radio': {icon:'flaticon-radio51', tip: 'Regular radio button'}, # todo
  'radiotext': {icon:'flaticon-radio32', tip: 'Radio button with a label'}, # todo
  'editor': {name: 'editor', icon:'flaticon-notes9', tip: 'Editor text input', widget: Widgets.TextEditor },
  'label': {name: 'label', icon:'flaticon-text38', tip: 'Label', widget: Widgets.Label },
  'date': {icon:'flaticon-calendar146', tip: 'Date entry input'}, # todo
  'datetime': {icon:'flaticon-calendar68', tip: 'Date / Time entry input'},
  'html': {icon:'flaticon-right173', tip: 'Raw HTML'}, # todo
  'image': {icon:'flaticon-image84', tip: 'Image'}, # todo, lol
  'webview': {icon:'flaticon-browser14', tip: 'Embedded browser / Webview'}, # todo both webview / iframe
  'url': {icon:'flaticon-http1', tip: 'URL Entry Box'}, # todo / input
  'listnumbers': {icon:'flaticon-mini5', tip: 'Numeric List'}, # todo
  'treeview': {name: 'treeview', icon:'flaticon-category2', tip: 'Tree View', widget: Widgets.TreeView},
  'listview': {name: 'listview', icon:'flaticon-text146', tip: 'List View', widget: Widgets.ListView}, # list view, still needs select box
  'grid': {icon:'flaticon-show6', tip: 'Grid (Thumbnails)'}, # todo
  'table': {icon:'flaticon-table41', tip: 'Table'}, # todo
  'map': {icon:'flaticon-location35', tip: 'Leaflet Map'}, # todo
  'loadingspinner': {name: 'loadingspinner', icon:'flaticon-location35', tip: 'Loading Spinner', widget: Widgets.LoadingSpinner}, # todo, change w/ actual icon
  #'layout1': {icon:'flaticon-design24'},
}

module.exports =
class Apex.Form.ToolboxView extends View
  Emitter.includeInto @

  @content: ->
    @div class: 'atom-panel toolbox-panel', outlet: 'toolboxPanel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', =>
          @span 'Toolbox'
        @div class: 'panel-body padded', outlet: 'toolbox'

  initialize: (params) ->
    if params.parent then @parent = params.parent
    @toolbox.html '' # clear if we haven't done so already
    items = $ document.createElement('ul')

    for k,v of BUILTIN_WIDGETS
      el = $ document.createElement('li')
      el.attr 'id', 'toolbox_'+k
      el.attr 'data-widget', k
      el.addClass 'toolbox-button'
      el.html "<i class='toolbox-icon #{v.icon}' alt='${k}' />"
      if v.name then el.attr('data-name', v.name)
      if not el.widget
        el.css
          opacity: 0.5
      window.formBuilderDraggable = el
      el.draggable(
        opacity: 0.8
        helper: "clone"
      )
      atom.tooltips.add el, {title: v.tip}
      items.append el

    @toolbox.append items

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    if @element then @element.remove()

  getElement: ->
    @element
  setViewHost: (@viewHost) ->
  getViewClass: -> Apex.Form.ToolboxView
  getView:      -> @
