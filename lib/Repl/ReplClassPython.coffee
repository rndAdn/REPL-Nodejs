fs = require 'fs'
child_process = require 'child_process'
REPL  = require './ReplClass'

module.exports =
class ReplPython extends REPL

      processOutputData:(data) ->
        #console.log(@prompt)
        @print += ""+data
        @retour(@print,true)
        @print = ""
        #@processCmd()
        #@prompt = true

      processErrorData:(data) ->
        #console.log(""+data)
        @print += ""+data
        @retour(@print,true)
        @print = ""
        @processCmd()
        #@prompt = true


  '''
  myrepl = new ReplPython('python',['-i'])
  myrepl.writeInRepl("2*2\n")
  myrepl.writeInRepl("3*2\n")
  '''



'''
    processCmd:()->
      if(@cmdQueue.length > 0)
        cmd = @cmdQueue.shift()
        @print += cmd
        @replProcess.stdin.write(cmd)

    processOutputData:(data) ->
      console.log("result:")
      @print += ""+data
      @output = true

    processErrorData:(data) ->
      if(@output)
        @output = false
        console.log(@print + data)
        @print = ""
        @processCmd()

    closeRepl:(code) ->
      console.log('child process exited with code ' + code)

    writeInRepl:(cmd) ->
      #console.log(s)
      #@replProcess.stdin.write(s)
      @cmdQueue.push(cmd)

    constructor:(cmd,args) ->
      self = this
      @print = ""
      @output = true
      @cmdQueue =   new Array()
      @replProcess = child_process.spawn(cmd, args)
      @replProcess.stdout.on('data', (data)->self.processOutputData(data))
      @replProcess.stderr.on('data', (data)->self.processErrorData(data))
      @replProcess.on('close', ()->self.closeRepl())
      console.log(@print)
'''
'''
myrepl = new ReplPython('python',['-i'])
myrepl.writeInRepl("2*2\n")
myrepl.writeInRepl("3*2\n")
'''
