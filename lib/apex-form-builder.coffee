remote = require 'remote'
Menu = remote.require 'menu'
dialog = remote.require "dialog"
path = require 'path'
vm = require 'vm'

interact = require './deps/interact'
builder = require './packager/spacepen-form'
coffee = require 'coffee-script'
fs = require 'fs'

{CompositeDisposable, $, View} = require 'atom'

# Take advantage of Coffeescript's namespacing shortcuts to keep the Apex.Form
# more organized as a whole.
window.Apex ?= {}
Apex.Form ?= {}
Apex.Form.BuilderView = require './apex-form-builder-view'

###
    Form Designer for Apex IDE / Atom.io
    ------------------------------------

    This package intends to create new space pen views based on a widget
    designed by the end consumer or coder, easing a couple pain points
    with creating atom plugins and also external UI code.

    It is modeled after many existing form creators and of course,
    the great VS-Like toolkits that came before it.
###

module.exports = Apex.Form.Builder =
  hoverValue: require './debug/hovervalue'
  apexFormBuilderView: null
  subscriptions: null
  views: []

  firstRun: ->
    # expose 1 time require
    Apex.interact = interact

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # remember whatever state we had saved
    @state = state

    # Register command that creates a new form view
    @subscriptions.add atom.commands.add 'atom-workspace', 'apex-form-builder:create': => @createForm()
    @subscriptions.add atom.commands.add 'atom-workspace', 'apex-form-builder:open': => @openForm()
    @subscriptions.add atom.commands.add 'atom-workspace', 'apex-form-builder:test': => @testForm()
    @subscriptions.add atom.commands.add 'atom-workspace', 'apex-form-builder:export-spacepen': => @buildSpacepenForm()

    # register the form builder so we can see it (from window)
    if not Apex.formBuilder then @firstRun()
    Apex.formBuilder = @

    if @state.apexFormBuilderViewState?.form then @createForm()

    # Create the first 1 anyways
    #@createForm()

    @addFileMenuItem()

  openForm: ->
    obj = { }
    try
      p = dialog.showOpenDialog({properties:['openFile']})
      obj = JSON.parse(fs.readFileSync(p.toString()).toString())
    catch ex
      atom.notifications.addError(ex.message)
    if not obj?.form?.title then return

    @apexFormBuilderView = new Apex.Form.BuilderView()
    @apexFormBuilderView.setParent Apex.Form.Builder
    @apexFormBuilderView.setState obj

    atom.workspace.activePane.activateItem @apexFormBuilderView

    @view = @apexFormBuilderView # shorthand
    @views.push @view

  testForm: ->
    klass = atom.workspace.getActivePaneItem()
    if klass.form
      build = new Apex.Form.SpacePenBuilder({ form: klass.form.JSON() })
      @output = build.build()
      @js = coffee.compile @output

      vm.runInThisContext(@js)
      name = klass.form.name
      if not name then name = 'Default'
      console.log "Form #{name} now available as window.Form[#{JSON.stringify name}] for testing. Code: Apex.formBuilder.js // Apex.formBuilder.output"

      # test 101
      @test = window.testForm = new window.Forms[name]()
      @test.appendTo document.body

  buildSpacepenForm: ->
    klass = atom.workspace.getActivePaneItem()
    if klass.form
      build = new Apex.Form.SpacePenBuilder({ form: klass.form.JSON() })
      @output = build.build()
      @js = coffee.compile @output

      vm.runInThisContext(@js)
      name = klass.form.name
      if not name then name = 'Default'
      console.log "Form #{name} now available as window.Form[#{JSON.stringify name}] for testing. Code: Apex.formBuilder.js // Apex.formBuilder.output"

      p = dialog.showSaveDialog({properties:['openFile']})
      @path = path.join(path.dirname(p), path.basename(p))
      if @path and @path.length > 2
        fs.writeFileSync @path + '.coffee', @output
        fs.writeFileSync @path + '.js', @js
        atom.notifications.addSuccess("Saved "+@path+".coffee & .js")
      else
        return false

  # add a 'new browser tab' item to the current file menu
  addFileMenuItem: ->
    menu = atom.menu.template[0]
    menu.submenu.splice 2, 0, { label: 'New Form', command: 'apex-form-builder:create' }
    atom.menu.template[0] = menu
    console.dir menu
    atom.menu.update()

  deactivate: ->
    @subscriptions.dispose()
    @apexFormBuilderView.destroy()

  serialize: ->
    apexFormBuilderViewState: @apexFormBuilderView.serialize()

  createForm: ->
    @apexFormBuilderView = new Apex.Form.BuilderView()
    @apexFormBuilderView.setParent Apex.Form.Builder
    @apexFormBuilderView.setState @state.apexFormBuilderViewState

    atom.workspace.activePane.activateItem @apexFormBuilderView

    @view = @apexFormBuilderView # shorthand
    @views.push @view
