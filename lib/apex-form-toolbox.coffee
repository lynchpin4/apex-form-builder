{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
* Form Properties Widget
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

BUILTIN_WIDGETS = {
  'button': {icon:'flaticon-ok6', tip: 'Simple and uniform button.'},
  'textbox': {icon:'flaticon-textbox', tip: 'Simple textbox'},
  'numeric': {icon:'flaticon-numbers8', tip: 'Numeric only input'},
  'checkbox': {icon:'flaticon-check30', tip: 'Common checkbox'},
  'radio': {icon:'flaticon-radio51', tip: 'Regular radio button'},
  'radiotext': {icon:'flaticon-radio32', tip: 'Radio button with a label'},
  'multilinetextbox': {icon:'flaticon-notes9', tip: 'Multiline text input'},
  'label': {icon:'flaticon-text38', tip: 'Label'},
  'date': {icon:'flaticon-calendar146', tip: 'Date entry input'},
  'datetime': {icon:'flaticon-calendar68', tip: 'Date / Time entry input'},
  'html': {icon:'flaticon-right173', tip: 'Raw HTML'},
  'image': {icon:'flaticon-image84', tip: 'Image'},
  'webview': {icon:'flaticon-browser14', tip: 'Embedded browser / Webview'},
  'url': {icon:'flaticon-http1', tip: 'URL Entry Box'},
  'listnumbers': {icon:'flaticon-mini5', tip: 'Numeric List'},
  'tree': {icon:'flaticon-category2', tip: 'Tree List'},
  'list': {icon:'flaticon-text146', tip: 'Simple List'},
  'grid': {icon:'flaticon-show6', tip: 'Grid (Thumbnails)'},
  'table': {icon:'flaticon-table41', tip: 'Table'},
  'map': {icon:'flaticon-location35', tip: 'Leaflet Map'},
  #'layout1': {icon:'flaticon-design24'},
}

module.exports =
class Apex.Form.ToolboxView extends View
  Emitter.includeInto @
  
  @content: ->
    @tag 'atom-panel', class: 'toolbox-panel', outlet: 'toolboxPanel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', => 
          @span 'Toolbox'
        @div class: 'panel-body padded', outlet: 'toolbox'
    
  initialize: ->
    @toolbox.html '' # clear if we haven't done so already
    items = $ document.createElement('ul')
    
    for k,v of BUILTIN_WIDGETS
      el = $ document.createElement('li')
      el.attr 'id', 'toolbox_'+k
      el.attr 'data-widget', k
      el.html "<i class='#{v.icon}' alt='${k}' />"
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
  
  getViewClass: -> Apex.Form.ToolboxView
  getView:      -> @