#MyREPLView = require './Repl-view'
REPLView = require './Repl-View/ReplView'
REPLManager = require './ReplManager'
{CompositeDisposable} = require 'atom'

module.exports = MyREPL =

config:
    bash:
      title: 'Bash'
      type: 'string'
      default: 'bash'
      description: 'path to bash ex: /usr/bin/bash'
    coffee:
      type: 'string'
      title: 'Coffee'
      default: 'coffee'
      description: 'path to coffee'
    gdb:
      type: 'string'
      title: 'Gdb'
      default: 'gdb'
      description: 'path to gdb'
    node:
      type: 'string'
      title: 'Node.js'
      default: 'node'
      description: 'path to node'
     ocaml:
      type: 'string'
      title: 'Ocaml'
      default: 'ocaml'
      description: 'path to ocaml'
    python2:
      type: 'string'
      title: 'Python 2'
      default: 'python2'
      description: 'path to python2'
    python3:
      type: 'string'
      title: 'Python 3'
      default: 'python3'
      description: 'path to python3'
    r:
      type: 'string'
      title: 'R'
      default: 'R'
      description: 'path to R'

  #myREPLView: null
  #modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log("activate Repl")
    @map = new Array()
    @replManager = new REPLManager()
    #@myREPLView = new MyREPLView(state.myREPLViewState)
    #@modalPanel = atom.workspace.addRightPanel(item: @myREPLView.getElement(), visible: false)

     #Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

     # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Python2': => @create("Python Console2")
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Python3': => @create("Python Console3")
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Coffee': => @create("CoffeeScript")
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Bash': => @create('Shell Session')
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Ocaml': => @create('OCaml')
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl R': => @create('R')
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Node': => @create('Node')
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:Repl Gdb': => @create('C')

    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:create': => @create()
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:interpreteSelect': => @interpreteSelect()
    @subscriptions.add atom.commands.add 'atom-workspace', 'Repl:interpreteFile': => @interpreteFile()
    #@subscriptions.add atom.commands.add 'REPL', 'Repl:up': => @up()

  deactivate: ->
    #@modalPanel.destroy()
    @subscriptions.clear()
    @subscriptions.dispose()
    #@myREPLView.destroy()

  serialize: ->
    #myREPLViewState: @myREPLView.serialize()

  create: (grammarName) ->
    if(!grammarName?)
      if (atom.workspace.getActiveTextEditor()?)
        grammarName = atom.workspace.getActiveTextEditor().getGrammar().name
      else
        console.log("erreur1")
        grammarName = 'Shell Session'

    @replManager.createRepl(grammarName)
    #@map.push([txtEditor,new REPLView(txtEditor)])

  interpreteSelect: ->
    txtEditor = atom.workspace.getActiveTextEditor()
    if (txtEditor?)
      grammarName = txtEditor.getGrammar().name
      #@replManager.createRepl(grammarName)
      @replManager.interprete(txtEditor.getSelectedText(),grammarName)
    else
      console.log("error interpreteSelect")

  interpreteFile: ->
    txtEditor = atom.workspace.getActiveTextEditor()
    if (txtEditor?)
      grammarName = txtEditor.getGrammar().name
      #@replManager.createRepl(grammarName)
      @replManager.interprete(txtEditor.getText(),grammarName)

    else
      console.log("error interpreteFile")
