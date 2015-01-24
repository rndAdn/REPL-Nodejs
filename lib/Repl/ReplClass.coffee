fs = require 'fs'
child_process = require 'child_process'
#read_line = require 'read_line'
ReplSh = require './ReplSh'
ReplOcaml = require './ReplOcaml'

module.exports =
class Repl

    processCmd:(write_cmd)->
      #console.log('2')
      if(@processing)
        @retour(@prompt)
      if(@cmdQueue.length > 0)
        @processing = true
        cmd = @cmdQueue.shift()
        if write_cmd = true
            @print += cmd
        @replProcess.stdin.write(cmd)
        console.log(@endSequence)
        if cmd.slice(-@endSequence.length) != @endSequence
            @processing = false
            @processCmd()
      else
        @processing = false

    processOutputData:(data) ->
      console.log(@prompt)
      @print += ""+data
      @retour(@print)
      @print = ""
      @processCmd()
      #@prompt = true

    processErrorData:(data) ->
      #console.log(@prompt)
      @print += ""+data
      process.stderr.write(@print)
      @print = ""
      @processCmd()
      #@prompt = true


    closeRepl:(code) ->
      console.log('child process exited with code ' + code)

    writeInRepl:(cmd, write_cmd) ->
      #console.log(s)
      #@replProcess.stdin.write(s)
      @cmdQueue.push(cmd)
      if(!@processing)
        @processCmd(write_cmd)

    constructor:(r_format, @retour) ->
      self = this
      @processing = true
      cmd = r_format.cmd
      args = r_format.args
      @prompt = r_format.prompt
      @endSequence = r_format.endSequence
      @print = ""
      @cmdQueue =   new Array()
      @replProcess = child_process.spawn(cmd, args)
      @replProcess.stdout.on('data', (data)->self.processOutputData(data))
      @replProcess.stderr.on('data', (data)->self.processErrorData(data))
      @replProcess.on('close', ()->self.closeRepl())
      @retour(@print)
'''
sh = new ReplSh()
ocaml = new ReplOcaml()

myrepl = new Repl(ocaml)
myrepl.writeInRepl('let a l = match l with\n')
myrepl.writeInRepl("| _ -> true;;\n")
#myrepl.writeInRepl("let _ = 3*2;;\n")
'''
