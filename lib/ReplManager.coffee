REPLView = require './Repl-View/ReplView'

key = ['replBash','CoffeeScript','replOcaml','replR']

module.exports =
class ReplManager

  constructor: () ->
    @map = {}
    for k in key
      @map[k] = null

  grammarNameSupport : (grammarName) ->
    if grammarName in key
      true
    else
      false

  callBackCreate: (replView) =>
    console.log("ici")
    replView.replTextEditor.observeCursors((cursor)=>
      @map[replView.grammarName] = replView
      )
    console.log("ici")
    replView.replTextEditor.onDidDestroy(()=>
      if(@map[replView.grammarName] == replView)
        @map[replView.grammarName] = null
      )

  createRepl:(grammarName) =>
    if (@grammarNameSupport(grammarName))
      @map[grammarName] = new REPLView(grammarName,@callBackCreate)
