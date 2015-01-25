MyREPLView = require './my-r-e-p-l-view'
REPLView = require './Repl-View/ReplView'
REPLManager = require './ReplManager'
{CompositeDisposable} = require 'atom'

module.exports = MyREPL =
  myREPLView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log("activate")
    @map = new Array()
    @replManager = new REPLManager()
    @myREPLView = new MyREPLView(state.myREPLViewState)
    @modalPanel = atom.workspace.addRightPanel(item: @myREPLView.getElement(), visible: false)

     #Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

     # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:create': => @create()
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:interprete': => @interprete()

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


  create: (grammarName) ->
    if(!grammarName?)
      if (atom.workspace.getActiveTextEditor()?)
        grammarName = atom.workspace.getActiveTextEditor().getGrammar().name
      else
        grammarName = "bash"
    console.log(grammarName)
    @replManager.createRepl(grammarName)
    #@map.push([txtEditor,new REPLView(txtEditor)])

  interprete: ->
    txtEditor = atom.workspace.getActiveTextEditor()
    if (txtEditor?)
      grammarName = txtEditor.getGrammar().name
      @replManager.interprete(txtEditor.getSelectedText(),grammarName)
    else
      console.log("fuck u 2")
