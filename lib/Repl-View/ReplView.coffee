fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLFormat = require '../Repl/ReplFormat'

module.exports =
class REPLView
  '''
  dealWithInsert :(event) =>
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || @lastBuf.column>buf.column)
      event.cancel()
  '''
  '''
  interprete :() =>
    select = @activeTextEditor.getSelectedText()
    console.log(select)
    @repl.writeInRepl(select,true)
  '''
  remove :() =>
    @repl.remove()

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

  constructor: (@grammarName,callBackCreate) ->
    self = this
    format = new REPLFormat("../../Repls/replOcaml.js") # new REPLFormat(@key)
    @lastBuf = 0
    console.log("Ok")
    uri = "REPL: "+@grammarName
    atom.workspace.open(uri,split:'right').done (textEditor) =>
          pane = atom.workspace.getActivePane()
          self.setTextEditor(textEditor)
          self.setRepl(new REPL(format,self.dealWithRetour))
          callBackCreate(self,pane)
