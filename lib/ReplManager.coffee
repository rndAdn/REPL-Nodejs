REPLView = require './Repl-View/ReplView'

key = {'replBash':"",'CoffeeScript': "ReplCoffee" , 'replOcaml': "", 'replR':""}

module.exports =
class ReplManager

  constructor: () ->
    @map = {}
    for k,v in key
      @map[k] = null

  grammarNameSupport : (grammarName) ->
      for k,v in key
        if grammarName == k
          true
      false

  callBackCreate: (replView,pane) =>
    console.log("ici")
    pane.onDidActivate(()=>
      if(pane.getActiveItem() == replView.replTextEditor)
        console.log('now')
        @map[replView.grammarName] = replView
      )
    console.log("ici")
    replView.replTextEditor.onDidDestroy(()=>
      if(@map[replView.grammarName] == replView)
        @map[replView.grammarName] = null
      )

  createRepl:(grammarName) =>
    if (@grammarNameSupport(grammarName))
      console.log("createRepl")
      @map[grammarName] = new REPLView(grammarName,key[grammarName],@callBackCreate)
