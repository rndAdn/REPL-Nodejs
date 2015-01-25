REPLView = require './Repl-View/ReplView'

<<<<<<< HEAD
dico = {"Shell Session":'replBash','CoffeeScript': "replCoffee" , "OCaml":'replOcaml', "R":'replR', "Python Console":"replPython", "Python":"replPython"}
=======
<<<<<<< HEAD
dico = require "./ReplList.js"
=======
dico = {"Shell Session":'replBash','CoffeeScript': "replCoffee" , "OCaml":'replOcaml', "R":'replR', "Python Console":"not", "Python":"not"}
>>>>>>> e9ba6d7c02d8206fb17cd167cb0c8f30c7698642
>>>>>>> c46348ff65f7a7fc5f996317185ea8955df98577

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
      console.log(dico[grammarName])
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
