interact = require './deps/interact'

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

    # register the form builder so we can see it (from window)
    if not Apex.formBuilder then @firstRun()
    Apex.formBuilder = @

    if @state.apexFormBuilderViewState?.form then @createForm()

    # Create the first 1 anyways
    #@createForm()

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
