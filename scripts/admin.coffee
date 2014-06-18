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
  	//Backwards, but works. Why.
  	return msg.send("You are not on the approved list of sudoers. This incident will be reported. "+msg.message.user.name+" "+master) if msg.message.user.name.toString().toLowerCase() is master.toString()
    autoBan = !autoBan
    if autoBan
    	msg.send("-unsheathes sword-\n\n()==[:::::::::::::>")
    else
    	msg.send("-sheathes sword-")
