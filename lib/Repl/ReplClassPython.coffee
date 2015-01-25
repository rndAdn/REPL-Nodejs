fs = require 'fs'
child_process = require 'child_process'
REPL  = require './ReplClass'

module.exports =
class ReplPython extends REPL

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
        #@processCmd()
        #@prompt = true

      processErrorData:(data) ->
        #console.log(""+data)
        @print += ""+data
        @retour(@print)
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

      constructor:(@retour) ->
        console.log("JE SUIS LA ")
        self = this
        @processing = true
        cmd = "python"
        args = ["-i"]
        @prompt = ""
        @endSequence = "\n"
        @print = ""
        @cmdQueue =   new Array()
        @replProcess = child_process.spawn(cmd, args)
        @replProcess.stdout.on('data', (data)->self.processOutputData(data))
        @replProcess.stderr.on('data', (data)->self.processErrorData(data))
        @replProcess.on('close', ()->self.closeRepl())
        @retour(@print)

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
