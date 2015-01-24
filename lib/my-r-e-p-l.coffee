MyREPLView = require './my-r-e-p-l-view'
{CompositeDisposable} = require 'atom'

module.exports = MyREPL =
  myREPLView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @myREPLView = new MyREPLView(state.myREPLViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @myREPLView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @myREPLView.destroy()

  serialize: ->
    myREPLViewState: @myREPLView.serialize()

  toggle: ->
    console.log 'MyREPL was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
