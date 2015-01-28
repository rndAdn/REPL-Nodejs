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
      console.log("fuck u 1")

  grammarNameSupport : (grammarName) ->
      return (dico[grammarName]?)


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
        replView.remove()
      )

  createRepl:(grammarName) =>
    if (@grammarNameSupport(grammarName))
      #console.log(dico[grammarName])
      @map[grammarName] = new REPLView(grammarName,dico[grammarName],@callBackCreate)
      #@map[grammarName] = new REPLView(grammarName,@callBackCreate)
    else
      console.log("erreur2")
