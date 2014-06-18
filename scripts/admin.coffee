# Description:
#   Twitch administrative stuff
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   
#
# Author:
#   Camtendo

master = "camtendo"
autoBan = false

module.exports = (robot) ->
  robot.hear /toggle autoban/i, (msg) ->
    return msg.send("*unsheathes sword\n\n()==[:::::::::::::>")