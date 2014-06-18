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
  	return msg.send("You are not on the approved list of sudoers. This incident will be reported.") if msg.message.user.name isnt master
    autoBan = !autoBan
    return msg.send("*unsheathes sword*\n\n()==[:::::::::::::>") if autoBan
    return msg.send("*sheathes sword*") if !autoBan