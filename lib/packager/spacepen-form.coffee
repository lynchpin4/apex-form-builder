{Emitter} = require 'emissary'
{CompositeDisposable, $, View} = require 'atom'
path = require 'path'

window.Apex ?= {}
Apex.Form ?= {}

###
   Form - Spacepen View Builder
   =====================

   Todo List / Short Term Needs:
    - Copy dirs for runtime? (oo add package window / gui would be great..)
    - ^ Similar to above, copy CSS from main project.
    - Revise the <style> generator to use LESS.
    - All of the above.
###

getIndent = (tmpl) ->
  line = tmpl.substr(0, tmpl.indexOf("<form-widgets")).split("\n").reverse()[0]
  spaces = line.split("")
  length = [1..spaces.length].map( -> 'x').length

  if line.indexOf("\t") == -1
    return (i for i in [1..length]).map( -> ' ').join("")
  else
    tabsCount = 0
    for c in line.split("")
      if c is "\t" then tabsCount++
    return (i for i in [1..tabsCount]).map( -> "\t").join("")

# not spec'd tabs r untested
getSpacing = (tmpl, tabWidth = 2) ->
  line = tmpl.substr(0, tmpl.indexOf("<form-widgets")).split("\n").reverse()[0]
  spaces = line.split("")
  length = [1..spaces.length].map( -> 'x').length

  if line.indexOf("\t") == -1
    return [1..tabWidth].map( -> ' ').join("")
  else
    tabsCount = 1
    return [1..tabsCount].map( -> "\t").join("")

spacepenTemplate = (form, opts={atom: true}) ->
  if not form.name then form.name = 'Default'
  stringify = (input) -> JSON.stringify input

  SPACEPEN_FORM_TEMPLATE = """
  {Emitter} = require 'emissary'
  {CompositeDisposable, $, View} = require 'atom'
  path = require 'path'
  # <includes> - tag for inserting other optional requirements

  window.Apex ?= {}
  Apex.Form ?= {}

  window.Forms ?= {}
  module.exports =
  class Forms.#{form.name} extends View

    Emitter.includeInto @

    @title = #{stringify form.title}
    @name = #{stringify form.name}

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
      @tag 'atom-panel', class: 'form-widget apex-form-widget modal form-widget-floating form-#{form.name}', =>
        @raw '<style>atom-panel.form-#{form.name} { width: #{form.width}px; height: #{form.height}px; }</style>'
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', outlet: 'header', =>
            @span #{stringify form.title}, outlet: 'title'
            @div class:'close-icon', outlet: 'close'
          @div class: 'panel-body padded', outlet: 'contents', =>
            <form-widgets>

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
  """

module.exports =
class Apex.Form.SpacePenBuilder extends View
  Emitter.includeInto @

  constructor: (@params) ->
    # Pass this fucker a form and lets get rolling
    if @params.form
      if typeof @params.form is 'string' then @params.form = JSON.parse @params.form
      @form = @params.form

  build: ->
    @tmpl = spacepenTemplate(@form)
    @spacing = getSpacing(@tmpl)
    @indent = getIndent(@tmpl)

    # find the line with form widgets (to insert the result there)
    lines = @tmpl.split("\n")
    index = lines.indexOf lines.filter((x) -> x.indexOf("<form-widgets>") != -1)[0]

    # compose the result
    result = @compose()
    lines[index] = result

    # return result
    lines[0] = lines[0].trim()
    lines.join("\n")

  compose: ->
    # Compose the actual content (widget lines from spacepen)
    if not @form.widgets then return
    lines = []
    for widget, i in @form.widgets
      name = widget.name or (widget.widgetType + (i+1))
      line = @currentIndent() + "@subview #{JSON.stringify name}, new Apex.widgetResolver.widgets[#{JSON.stringify widget.widgetType}](#{JSON.stringify widget}).get()"
      lines.push line
    lines.join("\n")

  # returns the indentation / spacing
  getSpacing: ->
    if @spacing then return @spacing
    @spacing = getSpacing @tmpl

  getIndent: ->
    if @indent then return @indent
    @indent = getIndent(@tmpl)

  # string representing the current level of indentation
  currentIndent: ->
    if not @levels or @levels is 0
      @levels = 0
      return @getIndent()
    else
      spacer = [0..@levels].map((x) => @getSpacing()).join("")
      return @getIndent() + spacer

  pushIndent: ->
    if not @levels then @levels = 0
    @levels++

  popIndent: ->
    if @levels >= 1
      @levels--

  setForm: (form) ->
    @form = form
  getForm: ->
    @form

#sds = new Apex.Form.SpacePenBuilder({"form":{"title":"Untitled Form","width":438,"height":250,"widgets":[{"widgetType":"input","x":7,"y":8,"w":126,"h":21,"value":"Textbox"},{"widgetType":"button","x":138,"y":4,"w":52,"h":18,"title":"Button"},{"widgetType":"input","x":192,"y":103,"w":126,"h":21,"value":"Textbox"}]}})
#console.log sds.build()
