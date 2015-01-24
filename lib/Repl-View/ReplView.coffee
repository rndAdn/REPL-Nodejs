fs = require 'fs'

module.exports =
class REPLView

  dealWithRetour: (data) ->
    @replTextEditor.insertText(""+data)

  constructor: (@activeTextEditor) ->
    self = this
    console.log("Ok")
    #uri = ""+@activeTextEditor.getPath()
    @replTextEditor = atom.workspace.open("REPL",split: 'right')
    streamCmdRepl = fs.createWriteStream("/tmp/Cmd")
    @streamCmd = fs.createReadStream("/tmp/Cmd")
    @streamRetour = fs.createWriteStream("/tmp/Retour")
    streamRetourRepl = fs.createReadStream("/tmp/Retour")

    @streamRetour.on('data',(data)->self.dealWithRetour(data))
