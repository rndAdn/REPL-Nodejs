ReplFormat = require './ReplFormat'
module.exports =
class ReplOcaml extends ReplFormat

    constructor:() ->
      @cmd = "ocaml"
      @args = ['-noprompt']
      @prompt = "# "
      @endSequence = ";;\n"
