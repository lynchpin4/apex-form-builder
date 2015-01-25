{CompositeDisposable, $, View} = require 'atom'

# Take advantage of Coffeescript's namespacing shortcuts to keep the Apex.Form
# more organized as a whole.
window.Apex ?= {}

class Apex.Hovervalue
  @hovers: []
  @fns: []

  constructor: ->
    # A minor debugging agent, places floating-fixed labels at given
    # screen coordinates + useful text
    Apex.hoverValue = @
    @hovers = []
    @fns = []

  setData: ->
    i = parseInt $(this).attr('data-index')
    text = Apex.hoverValue.fns[i].call(this)
    if text != $(this).text()
      console.log 'dbg: '+text
      $(this).text(text)

  makeValue: (x,y,template,parent) ->
    if not parent then parent = 'body'
    el = $(document.createElement 'label')
    el.addClass 'hoverValue'
    el.css
      position: 'fixed'
      top: Math.abs(y)+'px'
      left: Math.abs(x)+'px'
      color: '#fff!important'
      display: 'block'
      'min-width': '100px'
      'min-height': '25px'
      'background': '#eee!important'
    el.html '<div id="dot" style="color: red; width: 2px; height: 2px;"></div>'
    el.attr 'data-index', @hovers.length
    el.appendTo $(parent)
    @fns.push template
    @hovers.push el
    console.log 'created hover value: '+(@hovers.length - 1)
    console.dir el
    interval = window.setInterval(@setData.bind(el), 100)
    el.attr 'data-interval', interval
    el

window.hoverValue = new Apex.Hovervalue()
