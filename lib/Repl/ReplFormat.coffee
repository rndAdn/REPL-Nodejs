fs = require 'fs'
child_process = require 'child_process'
Repl = require './ReplClass.coffee'
#read_line = require 'read_line'

class ReplFormat extends Repl

    writeInRepl:(cmd) ->
      #console.log(s)
      #@replProcess.stdin.write(s)
      @cmdQueue.push(cmd)
      if(!@processing)
        @processCmd()

    constructor:() ->
      super
      self = this
      #process.stdout.write("azer")
      @cmd = "ocaml"
      @args = ['-noprompt']
      @prompt = "# "
      @endSequence = [";;"]

ocaml = new ReplFormat()
#ocaml.writeInRepl("let a l = match l with\n")
#ocaml.writeInRepl("| _ -> true;;\n")
#ocaml.writeInRepl("let _ = 3*2;;\n")
#ocaml.writeInRepl("let a l = match l with\n\t| _ -> true;;\n")
