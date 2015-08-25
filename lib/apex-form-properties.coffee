{Emitter} = require 'emissary'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'
{View} = require 'atom-space-pen-views'
path = require 'path'

###
* Form Properties Widget
###

window.Apex ?= {}
Apex.Form ?= {}

class Apex.Form.PropertiesSegment extends View

  @content: ->
    @div class: 'properties-row', =>
      @div class: 'properties-title', =>
        @label outlet: 'label'
      @div class: 'properties-value native-key-bindings', outlet: 'contents'

  initialize: (params) ->
    if not params then return
    @params = params
    @name = params.name

    parts = @name.split(":")
    @type = parts[0]
    @name = parts[1]

    @label.text @name
    @obj = params.obj
    @createValue()

  createValue: ->
    @value = @obj[@name]

    if @name.indexOf("widgetType") != -1
      @contents.text @value
    if @type.indexOf("int") != -1
      @contents.html "<input type='text' name='#{@name}' value='#{@value}' />"
    if @type.indexOf("string") != -1
      @contents.html "<input type='text' name='#{@name}' value='#{@value}' />"

    el = @contents.find('input')
    if el
      @el = el
      el.change =>
        val = @el.val()
        if @type == 'int' then val = parseInt(val)
        if @type == 'float' then val = parseFloat(val)
        @obj[@name] = val
        @obj.update()

module.exports =
class Apex.Form.PropertiesView extends View
  Emitter.includeInto @

  @content: ->
    @div class: 'tool-window', =>
      @tag 'atom-panel', class: 'toolbox-panel', =>
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', =>
            @span 'Bindings / Delegates'
          @div class: 'panel-body padded', outlet: 'delegates'
      @tag 'atom-panel', class: 'toolbox-panel', =>
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', =>
            @span 'Properties'
          @div class: 'panel-body padded', outlet: 'properties'
      @tag 'atom-panel', class: 'toolbox-panel jqevents-panel', =>
        @div class: 'inset-panel', =>
          @div class: 'panel-heading', =>
            @span 'jQuery Events / CSS'
          @div class: 'panel-body', =>
            @div class: 'jqevents-panel', outlet: 'jquerybox',
            @div class: 'jqevents-buttons', =>
              @subview 'sup', new Apex.Widgets.Button({parent: @, x: 10, y: 10, w: 50, title: 'Add'}).get(),
              @subview 'sup', new Apex.Widgets.Button({parent: @, x: 70, y: 10, w: 80, title: 'Preview'}).get(),

  initialize: (params) ->
    if params.parent
      @parent = params.parent
    @makeVisible = @show
    @show = @showProperties
    @jquerybox.html ''

  createProp: (name, obj) ->
    obj = { name: name, obj: obj }
    if name is 'widgetType' then return

    obj.view = new Apex.Form.PropertiesSegment(obj)
    @props.push obj
    obj.view

    #html = '<label>'+name+':</label>' + "<input type='text' name='#{name}' value='#{prop}' />"
    #el = $(html)

    #el.find('input').change ->
    #  console.log($(this).attr('name') + ': ' + $(this).val())
    #  console.dir obj
    @properties.append obj.view

  showProperties: (obj) ->
    console.log 'showProperties'
    console.dir(obj)
    @makeVisible() # jq show
    @properties.html ''
    @props = []
    if not obj.properties then return

    for prop in obj.properties
      @createProp(prop, obj)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    if @element then @element.remove()

  getElement: ->
    @element
  setViewHost: (@viewHost) ->
  getViewClass: -> Apex.Form.PropertiesView
  getView:      -> @
