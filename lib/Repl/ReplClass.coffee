fs = require 'fs'
child_process = require 'child_process'
#read_line = require 'read_line'

class Repl

    processCmd:()->
      #console.log('2')
      process.stdout.write(@prompt)
      if(@cmdQueue.length > 0)
        cmd = @cmdQueue.shift()
        @print += cmd
        @replProcess.stdin.write(cmd)

    processOutputData:(data) ->
      #console.log(@prompt)
      @print += ""+data
      process.stdout.write(@print)
      @print = ""
      @processCmd()
      #@prompt = true


    closeRepl:(code) ->
      console.log('child process exited with code ' + code)

    writeInRepl:(cmd) ->
      #console.log(s)
      #@replProcess.stdin.write(s)
      @cmdQueue.push(cmd)

    constructor:(cmd,args,prompt) ->
      self = this
      @prompt = prompt
      @print = ""
      @cmdQueue =   new Array()
      @replProcess = child_process.spawn(cmd, args)
      @replProcess.stdout.on('data', (data)->self.processOutputData(data))
      @replProcess.stderr.on('data', (data)->self.processErrorData(data))
      @replProcess.on('close', ()->self.closeRepl())
      process.stdout.write(@print)

myrepl = new Repl('ocaml',['-noprompt'],"# ")
myrepl.writeInRepl("let _ = 2*2;;\n")
myrepl.writeInRepl("let _ = 3*2;;\n")
