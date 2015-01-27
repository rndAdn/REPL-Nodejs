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
    '''currentText = @replTextEditor.getText()
    if(currentText.length<@minimaltext.length)
      @replTextEditor.setText(@minimaltext)
      return
    '''
    #console.log(@lastBuf)
    buf = @replTextEditor.getCursorBufferPosition()
    #console.log('las : '+@lastBuf)
    #console.log('buf : '+buf)
    if(@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column > buf.column))
      #console.log("Nop")
      @replTextEditor.setCursorBufferPosition(@lastBuf)
      return
    #console.log(@lastBuf)
    '''
    if(@lastBuf.row<buf.row && !@ignore)
      @replTextEditor.moveToEndOfLine()
      buf = @replTextEditor.getCursorBufferPosition()
      #console.log('buf :[ '+@replTextEditor.getTextInBufferRange([@lastBuf,[buf2,buf.column]])+']')
      #@ignore = true
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf]),false)
      @lastBuf = buf
    '''

  dealWithEnter :(event) =>
    if('\n' in event.text)
      @replTextEditor.moveToEndOfLine()
      buf = @replTextEditor.getCursorBufferPosition()
      #console.log('buf :[ '+@replTextEditor.getTextInBufferRange([@lastBuf,[buf2,buf.column]])+']')
      #@ignore = true
      @repl.writeInRepl(@replTextEditor.getTextInBufferRange([@lastBuf,buf])+'\n',false)
      @lastBuf = buf


  setGrammar : =>
    grammars = atom.grammars.getGrammars()
    #console.log(grammars[0])
    for grammar in grammars
      if (grammar.name ==  @grammarName)
        #console.log(grammar)
        @replTextEditor.setGrammar(grammar)
        return

  setTextEditor :(textEditor) =>
    @replTextEditor = textEditor
    #@replTextEditor.onDidStopChanging(@dealWithBuffer)
    @replTextEditor.onDidChangeCursorPosition(@dealWithBuffer)
    @replTextEditor.onWillInsertText(@dealWithEnter)
    @setGrammar()
    #@replTextEditor.onWillInsertText(@dealWithInsert)

  setRepl :(repl) =>
    @repl = repl

  dealWithRetour: (data) =>
    #console.log(@replTextEditor.constructor.name)
    @ignore = true
    @replTextEditor.insertText(stripAnsi(""+data))
    @ignore = false
    @lastBuf = @replTextEditor.getCursorBufferPosition()

  constructor: (@grammarName,file,callBackCreate) ->
    self = this
    format = new REPLFormat("../../Repls/"+file) # new REPLFormat(@key)
    @lastBuf = 0
    #@ignore = true
    #@minimaltext = ""
    uri = "REPL: "+@grammarName
    atom.workspace.open(uri,split:'right').done (textEditor) =>
          pane = atom.workspace.getActivePane()
          self.setTextEditor(textEditor)
          if(self.grammarName == "Python Console" || self.grammarName == "Python")
            self.setRepl(new REPLPython(format,self.dealWithRetour))
          else
            self.setRepl(new REPL(format,self.dealWithRetour))
          callBackCreate(self,pane)
