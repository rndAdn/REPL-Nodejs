fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLOcaml = require '../Repl/ReplOcaml'

module.exports =
class REPLView

  dealWithBuffer :() =>
    buf = @replTextEditor.getCursorBufferPosition()
    #console.log(@lastBuf)
    if(@lastBuf.row<buf.row)
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf]))

  setTextEditor :(textEditor) =>
    @replTextEditor = textEditor
    @replTextEditor.onDidStopChanging(@dealWithBuffer)

  setRepl :(repl) =>
    @repl = repl

  dealWithRetour: (data) =>
    #console.log(@replTextEditor.constructor.name)
    @replTextEditor.insertText(""+data)
    @lastBuf = @replTextEditor.getCursorBufferPosition()

  constructor: (@activeTextEditor) ->
    self = this
    @lastBuf = 0
    console.log("Ok")
    uri = "REPL: "+@activeTextEditor.getTitle()
    atom.workspace.open(uri,split:'right').done (textEditor) =>
          #console.log "reste"
          #console.log(textEditor.constructor.name)
          self.setTextEditor(textEditor)
          self.setRepl(new REPL(new REPLOcaml(),self.dealWithRetour))
