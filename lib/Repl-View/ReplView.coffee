fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLPython  = require '../Repl/ReplClassPython'
REPLFormat = require '../Repl/ReplFormat'
stripAnsi = require 'strip-ansi'
#{CompositeDisposable} = require 'event-kit'

module.exports =
class REPLView

  dealWithInsert :(event) =>
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column > buf.column))
      event.cancel()

  interprete :(select) =>
    #console.log(select)
    @repl.writeInRepl(select,true)

  remove :() =>
    @repl.remove()

  dealWithBackspace :() =>
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column >= buf.column))
      console.log("wrong way")
      @replTextEditor.selectToBufferPosition(buf)
      @replTextEditor.insertText(' ')
      return

  dealWithDelete :() =>
    '''a gerer mais j'ai pas de truc pour tester'''
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column >= buf.column))
      @replTextEditor.insertText(' ')
      return

  dealWithEnter :() =>
    #console.log('enter')
    @replTextEditor.moveToBottom()
    @replTextEditor.moveToEndOfLine()
    buf = @replTextEditor.getCursorBufferPosition()
    #console.log(@replTextEditor.getTextInBufferRange([@lastBuf,buf]))
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

  dealWithUp:()->
    #console.log('up')
    @repl.history(true)

  dealWithDown:()->
    #console.log('down')
    @repl.history(false)

  setTextEditor :(textEditor) =>
    @replTextEditor = textEditor
    #@replTextEditor.onDidChangeCursorPosition(@dealWithBuffer)
    #@replTextEditor.onWillInsertText(@dealWithEnter)
    @replTextEditor.onWillInsertText(@dealWithInsert)
    textEditorElement = atom.views.getView(@replTextEditor)
    atom.commands.add textEditorElement, 'editor:newline': => @dealWithEnter()
    atom.commands.add textEditorElement, 'core:move-up': => @dealWithUp()
    atom.commands.add textEditorElement, 'core:move-down': => @dealWithDown()
    atom.commands.add textEditorElement, 'core:backspace': => @dealWithBackspace()
    atom.commands.add textEditorElement, 'core:delete': => @dealWithDelete()
    @setGrammar()

  setRepl :(repl) =>
    @repl = repl

  dealWithRetour: (data,append) =>
    if append
    #console.log(@replTextEditor.constructor.name)
      @replTextEditor.insertText(stripAnsi(""+data))
      @lastBuf = @replTextEditor.getCursorBufferPosition()
    else
      @replTextEditor.insertText(stripAnsi(""+data),{select:true})
      console.log(@replTextEditor.getSelectedText())
      #@replTextEditor.moveToBottom()
      #@replTextEditor.moveToEndOfLine()
      #@lastBuf = @replTextEditor.getCursorBufferPosition()

  constructor: (@grammarName,file,callBackCreate) ->
    self = this
    #@subscribe = new CompositeDisposable
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
