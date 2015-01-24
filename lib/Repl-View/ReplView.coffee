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

  dealWithBuffer :() =>
    buf = @replTextEditor.getCursorBufferPosition()
    #console.log(@lastBuf)
    if(@lastBuf.row<buf.row)
<<<<<<< HEAD
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf]), false)
=======
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf],true))
      @lastBuf = buf
>>>>>>> e73d7fe4f41880a876a314eccfb33b921a318dff

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
