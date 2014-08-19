# Description:
#   Report status on things when Reesaybot isn't available
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Reesaybot will listen for joins and parts and report them.
#
# Author:
#   Camtendo

module.exports = (robot) ->
  robot.enter (msg) ->
    msg.send "Hello. I am Elizabeth, The Velvet Room's personal tournament organizer. "+msg.robot.commands.length+" commands were loaded. Twitch Build Hash = "+uniqueId(16) if msg.message.user.name.toLowerCase() is robot.name.toLowerCase()

  robot.leave (msg) ->
      if msg.message.user.name.toLowerCase() is 'reesaybot'
        msg.send "Warning. Rise Kujikawa has gone offline."

  uniqueId = (length=8) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length