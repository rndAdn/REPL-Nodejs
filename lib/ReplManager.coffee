REPLView = require './Repl-View/ReplView'
dico = require "./ReplList.js"


module.exports =
class ReplManager

  constructor: () ->
    @map = {}
    for k in dico
      @map[k] = null

  interprete : (select,grammarName) ->
    replView = @map[grammarName]
    if(replView?)
      replView.interprete(select)
    else
      console.log("error interprete")

  grammarNameSupport : (grammarName) ->
      return (dico[grammarName]?)


  callBackCreate: (replView,pane) =>
    console.log("in -> callBackCreate")
    pane.onDidActivate(()=>
      if(pane.getActiveItem() == replView.replTextEditor)
        @map[replView.grammarName] = replView
      )
    replView.replTextEditor.onDidDestroy(()=>
      if(@map[replView.grammarName] == replView)
        @map[replView.grammarName] = null
        replView.remove()
      )

  createRepl:(grammarName) =>
    if (@grammarNameSupport(grammarName))
      #console.log(dico[grammarName])
      @map[grammarName] = new REPLView(grammarName,dico[grammarName],@callBackCreate)
      #@map[grammarName] = new REPLView(grammarName,@callBackCreate)
    else
      console.log("grammar error")
