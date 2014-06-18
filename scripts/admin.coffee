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
  robot.hear /inaba/i, (msg) ->
  	msg.send("Yasogami")

  robot.hear /toggle autoban/i, (msg) ->
  	return msg.send("You are not on the approved list of sudoers. This incident will be reported.") if msg.message.user.name.toLowerCase() isnt master
    autoBan = !autoBan
    if autoBan
    	msg.send("-unsheathes sword-\n\n()==[:::::::::::::>")
    else
    	msg.send("-sheathes sword-")
