util     =   require 'util'
spawn    =   (require 'child_process').spawn
child    =   spawn('python',['-u','-i'])
cmdQueue =   new Array()


handleStdout = (data) ->
  datastr = data.toString('utf8')
  finished = false
  if (datastr.match(/Command Start\n/))
    datastr = datastr.replace(/Command Start\n/,'')

  if (datastr.match(/Command End\n/))
    datastr = datastr.replace(/Command End\n/,'')
    finished = true

  if (cmdQueue.length > 0)
    cmdQueue[0].data+=datastr

  if (finished)
    cmd = cmdQueue.shift()
    if (cmd && cmd.command)
      if (undefined != typeof cmd.callback)
        cmd.callback(null, cmd.data)
        processQueue()


handleStderr = (data) ->
  processQueue()

processQueue = () ->
  if (cmdQueue.length > 0 && cmdQueue[0].state == 'pending')
    cmdQueue[0].state = 'processing'
    child.stdin.write(cmdQueue[0].command, encoding='utf8')


handleExit = (code) ->
  console.log('child process exited with code ' + code)
  process.exit()

shell = (command, callback) ->
  command = 'print "Command Start"; ' + command + '\nprint "Command End"'
  if (command.charAt[command.length-1]!='\n')
    command += '\n'
  cmdQueue.push({'command':command, 'callback':callback, 'data': '', state: 'pending'})
  processQueue()

process.stdin.on('data', (data)->shell(data,(cmd,retour)->console.log(""+retour)))
child.stdout.on('data', handleStdout)
child.stderr.on('data', handleStderr)
child.on('exit', handleExit)
