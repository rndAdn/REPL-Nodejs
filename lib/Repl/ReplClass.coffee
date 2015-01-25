fs = require 'fs'
child_process = require 'child_process'

module.exports =
class Repl

    processCmd:()->
      if(@processing) # show prompt
        @retour(@prompt)
      if(@cmdQueue.length > 0) # list of cmd to execute
        @processing = true
        cmd = @cmdQueue.shift()
        if (cmd[1]) # re-write cmd
            @print += cmd[0]
        @replProcess.stdin.write(cmd[0]) # send cmd to pipe
        if cmd[0].slice(-@endSequence.length) != @endSequence
            '''
            if not ending with end sequence execute next one
            '''
            @processing = false
            @processCmd() #
      else
        @processing = false

    processOutputData:(data) ->
      #console.log(@prompt)
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
      #console.log(cmd)
      #@replProcess.stdin.write(s)

      if write_cmd
        if cmd.slice(-@endSequence.length) != @endSequence
          cmd = cmd+@endSequence
        lines = cmd.split(@endSequence)
        for element in lines
          if(element != "")
            @cmdQueue.push([element+@endSequence,write_cmd])
      else
        console.log("1"+cmd)
        @cmdQueue.push([cmd,write_cmd])
      if(!@processing)
        @processCmd()

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
