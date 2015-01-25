fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLPython  = require '../Repl/ReplClassPython'
REPLFormat = require '../Repl/ReplFormat'
stripAnsi = require 'strip-ansi'

module.exports =
class REPLView
  '''
  dealWithInsert :(event) =>
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || @lastBuf.column>buf.column)
      event.cancel()
  '''
  interprete :(select) =>
    console.log(select)
    @repl.writeInRepl(select,true)

  remove :() =>
    @repl.remove()

  dealWithBuffer :() =>
    currentText = @replTextEditor.getText()
    if(currentText.length<@minimaltext.length)
      @replTextEditor.setText(@minimaltext)
      return
    buf = @replTextEditor.getCursorBufferPosition()
    #console.log(@lastBuf)
    if(@lastBuf.row<buf.row)
      #console.log(currentText.substring(@minimaltext.length,currentText.length))
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf],false))
      @lastBuf = buf

  setGrammar : =>
    grammars = atom.grammars.getGrammars()
    #console.log(grammars[0])
    for grammar in grammars
      if (grammar.name ==  @grammarName)
        console.log(grammar)
        @replTextEditor.setGrammar(grammar)
        return

  setTextEditor :(textEditor) =>
    @replTextEditor = textEditor
    @replTextEditor.onDidStopChanging(@dealWithBuffer)
    @setGrammar()
    #@replTextEditor.onWillInsertText(@dealWithInsert)

  setRepl :(repl) =>
    @repl = repl

  dealWithRetour: (data) =>
    #console.log(@replTextEditor.constructor.name)
    @replTextEditor.insertText(stripAnsi(""+data))
    @lastBuf = @replTextEditor.getCursorBufferPosition()
    @minimaltext = @replTextEditor.getText()

  constructor: (@grammarName,file,callBackCreate) ->
    self = this
<<<<<<< HEAD
    format = new REPLFormat("../../Repls/"+file) # new REPLFormat(@key)
=======
    if(file != "not")
      format = new REPLFormat("../../Repls/"+file+".js") # new REPLFormat(@key)
>>>>>>> e9ba6d7c02d8206fb17cd167cb0c8f30c7698642
    @lastBuf = 0
    @minimaltext = ""
    uri = "REPL: "+@grammarName
    atom.workspace.open(uri,split:'right').done (textEditor) =>
          pane = atom.workspace.getActivePane()
          self.setTextEditor(textEditor)
          if(file != "not")
            #console.log("hereFEFEFF")
            self.setRepl(new REPL(format,self.dealWithRetour))
          else if(self.grammarName == "Python Console")
          #  console.log("hereFEFEFF")
            self.setRepl(new REPLPython(self.dealWithRetour))
          #console.log("hereFEFEFF")
          callBackCreate(self,pane)
