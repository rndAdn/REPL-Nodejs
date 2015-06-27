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
