ReplFormat = require './ReplFormat'
module.exports =
class ReplSh extends ReplFormat

    constructor:() ->
      @cmd = "bash"
      @args = ['-i']
      @prompt = "bash $ "
      @endSequence = '\n'
