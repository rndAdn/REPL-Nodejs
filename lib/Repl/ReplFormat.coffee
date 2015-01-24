fs = require 'fs'
child_process = require 'child_process'
#read_line = require 'read_line'

module.exports =
class ReplFormat

    constructor:() ->
      #process.stdout.write("azer\n")
      @cmd = "ocaml"
      @args = ['-noprompt']
      @prompt = "# "
      @endSequence = [";;"]

#ocaml = new ReplFormat()
#ocaml.writeInRepl("let a l = match l with\n")
#ocaml.writeInRepl("| _ -> true;;\n")
#ocaml.writeInRepl("let _ = 3*2;;\n")
#ocaml.writeInRepl("let a l = match l with\n\t| _ -> true;;\n")
