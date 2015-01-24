fs = require 'fs'
child_process = require 'child_process'
#read_line = require 'read_line'

class Repl

    processCmd:()->
      #console.log('2')
      if(@cmdQueue.length > 0)
        cmd = @cmdQueue.shift()
        @print += cmd
        @replProcess.stdin.write(cmd)

    processOutputData:(data) ->
      #console.log(@prompt)
      @print += ""+data
      console.log(@print)
      @print = ""
      if(@prompt)
        @processCmd()
      @prompt = true

    processErrorData:(data) ->
      @print += ""+data
      #console.log(@print)
      @print = ""
      @processCmd()


    closeRepl:(code) ->
      console.log('child process exited with code ' + code)

    writeInRepl:(cmd) ->
      #console.log(s)
      #@replProcess.stdin.write(s)
      @cmdQueue.push(cmd)

    constructor:(cmd,args,prompts) ->
      self = this
      @prompt = false
      @prompts = prompts
      @print = ""
      @cmdQueue =   new Array()
      @replProcess = child_process.spawn(cmd, args)
      @replProcess.stdout.on('data', (data)->self.processOutputData(data))
      @replProcess.stderr.on('data', (data)->self.processErrorData(data))
      @replProcess.on('close', ()->self.closeRepl())
      console.log(@print)

myrepl = new Repl('ocaml',[])
myrepl.writeInRepl("let _ = 2*2;;\n")
myrepl.writeInRepl("let _ = 3*2;;\n")
