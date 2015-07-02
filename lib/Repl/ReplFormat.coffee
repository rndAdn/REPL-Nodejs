fs = require 'fs'

module.exports =
class ReplFormat

    constructor:(conf_path) ->
        # TODO: check conf_path exist ?
        require conf_path
        # TODO: check cmd, args ... existe
        @cmd = cmd
        @args = args
        @prompt = prompt
        @endSequence = endSequence
        delete require.cache[require.resolve(conf_path)]
