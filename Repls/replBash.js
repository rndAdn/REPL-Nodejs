module.exports =
cmd = "bash"
prompt = "bash $ "
args = ['-i']
endSequence = '\n'

/**
@subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:Repl Python': => @launch_Interpreteur("Python")
@subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:Repl Coffee': => @launch_Interpreteur("Coffee")
@subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:Repl Bash': => @createFromFile('Bash')
@subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:Repl Ocaml': => @createFromFile('Ocaml')
@subscriptions.add atom.commands.add 'atom-workspace', 'my-r-e-p-l:Repl R': => @createFromFile('R')
**/
