fs = require 'fs'
REPL  = require '../Repl/ReplClass'
REPLPython  = require '../Repl/ReplClassPython'
REPLFormat = require '../Repl/ReplFormat'
stripAnsi = require 'strip-ansi'
{CompositeDisposable} = require 'event-kit'

module.exports =
class REPLView

  dealWithInsert :(event) =>
    buf = @replTextEditor.getCursorBufferPosition()
    if !@ignore && (@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column > buf.column))
      event.cancel()

  interprete :(select) =>
    #console.log(select)
    @repl.writeInRepl(select,true)

  remove :() =>
    @subscribe.clear()
    @repl.remove()

  dealWithBackspace :() =>
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column >= buf.column))
      @ignore = true
      @replTextEditor.insertText(' ')
      @ignore = false
      return

  dealWithDelete :() =>
    '''Gerer suppression text Selection'''
    buf = @replTextEditor.getCursorBufferPosition()
    if(@lastBuf.row>buf.row || (@lastBuf.row == buf.row && @lastBuf.column > buf.column))
      @ignore = true
      @replTextEditor.insertText(' ')
      @replTextEditor.moveLeft(1)
      @ignore = false
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
    @replTextEditor.moveToEndOfLine()
    buf = @replTextEditor.getCursorBufferPosition()
    @repl.history(true,@replTextEditor.getTextInBufferRange([@lastBuf,buf]))

  dealWithDown:()->
    #console.log('down')
    @replTextEditor.moveToEndOfLine()
    buf = @replTextEditor.getCursorBufferPosition()
    @repl.history(false,@replTextEditor.getTextInBufferRange([@lastBuf,buf]))

  setTextEditor :(textEditor) =>
    @replTextEditor = textEditor
    #@replTextEditor.onDidChangeCursorPosition(@dealWithBuffer)
    #@replTextEditor.onWillInsertText(@dealWithEnter)
    @subscribe.add @replTextEditor.onWillInsertText(@dealWithInsert)
    @subscribe.add textEditorElement = atom.views.getView(@replTextEditor)
    @subscribe.add atom.commands.add textEditorElement, 'editor:newline': => @dealWithEnter()
    @subscribe.add atom.commands.add textEditorElement, 'core:move-up': =>@dealWithUp()
    @subscribe.add atom.commands.add textEditorElement, 'core:move-down': => @dealWithDown()
    @subscribe.add atom.commands.add textEditorElement, 'core:backspace': => @dealWithBackspace()
    @subscribe.add atom.commands.add textEditorElement, 'core:delete': => @dealWithDelete()
    @setGrammar()

  setRepl :(repl) =>
    @repl = repl

  dealWithRetour: (data,append) =>
    if append
    #console.log(@replTextEditor.constructor.name)
      @replTextEditor.insertText(stripAnsi(""+data))
      @lastBuf = @replTextEditor.getCursorBufferPosition()
    else
      '''
      à amélioré , (saut de ligne et string vide etc...)
      '''
      @replTextEditor.moveToBottom()
      @replTextEditor.moveToEndOfLine()
      buf = @replTextEditor.getCursorBufferPosition()
      @replTextEditor.setTextInBufferRange([@lastBuf,buf],(""+data),select = true)
      #@replTextEditor.moveBottom(1)
      #@replTextEditor.selectToBeginningOfLine()
      #console.log(@replTextEditor.getSelectedText())
      #@replTextEditor.moveToEndOfLine()
      #@lastBuf = @replTextEditor.getCursorBufferPosition()

  constructor: (@grammarName,file,callBackCreate) ->
    self = this
    @subscribe = new CompositeDisposable
    format = new REPLFormat("../../Repls/"+file) # new REPLFormat(@key)
    @lastBuf = 0
    @ignore = false
    #@minimaltext = ""
    uri = "REPL: "+@grammarName
    atom.workspace.open(uri,split:'right').done (textEditor) =>
          pane = atom.workspace.getActivePane()
          if(self.grammarName == "Python Console3" || self.grammarName == "Python Console2" || self.grammarName == "Python")
            @grammarName = "Python Console"
            self.setTextEditor(textEditor)
            self.setRepl(new REPLPython(format,self.dealWithRetour))
          else
            self.setTextEditor(textEditor)
            self.setRepl(new REPL(format,self.dealWithRetour))
          callBackCreate(self,pane)
