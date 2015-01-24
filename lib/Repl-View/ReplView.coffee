fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLOcaml = require '../Repl/ReplOcaml'

module.exports =
class REPLView
  '''
  dealWithInsert :(event) =>
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || @lastBuf.column>buf.column)
      event.cancel()
  '''

  interprete :() =>
    select = @activeTextEditor.getSelectedText()
    console.log(select)
    @repl.writeInRepl(select,true)

  dealWithBuffer :() =>
    buf = @replTextEditor.getCursorBufferPosition()
    #console.log(@lastBuf)
    if(@lastBuf.row<buf.row)
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf],false))
      @lastBuf = buf

  setTextEditor :(textEditor) =>
    self = this
    @replTextEditor = textEditor
    @replTextEditor.onDidStopChanging(@dealWithBuffer)
    #@replTextEditor.onWillInsertText(@dealWithInsert)

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
