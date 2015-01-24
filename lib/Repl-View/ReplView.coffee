fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLOcaml = require '../Repl/ReplOcaml'

module.exports =
class REPLView

  setTextEditor :(textEditor) =>
    @replTextEditor = textEditor

  setRepl :(repl) =>
    @Repl = repl

  dealWithRetour: (data) =>
    console.log(@replTextEditor.constructor.name)
    @replTextEditor.insertText(""+data)

  constructor: (@activeTextEditor) ->
    self = this
    @int = 3
    console.log("Ok")
    atom.workspace.open("REPL",split: 'right').done (textEditor) =>
          console.log "reste"
          console.log(textEditor.constructor.name)
          self.setTextEditor(textEditor)
          self.setRepl(new REPL(new REPLOcaml(),self.dealWithRetour))
