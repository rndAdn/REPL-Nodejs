MyREPLView = require './my-r-e-p-l-view'
REPLView = require './Repl-View/ReplView'
{CompositeDisposable} = require 'atom'

module.exports = MyREPL =
  myREPLView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log("activate")
    @myREPLView = new MyREPLView(state.myREPLViewState)
    @modalPanel = atom.workspace.addRightPanel(item: @myREPLView.getElement(), visible: false)

     #Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

     # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:create': => @create()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @myREPLView.destroy()

  serialize: ->
    myREPLViewState: @myREPLView.serialize()

  toggle: ->
    console.log 'MyREPL was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  create: ->
    console.log 'create'
    new REPLView(atom.workspace.getActivePane())
