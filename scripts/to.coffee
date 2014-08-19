# Description:
#	Easily organize a tournament using automation and the Challonge API
#
# Dependencies:
#   None
#
# Configuration:
#   CHALLONGE_API_KEY
#
# Commands:
#	None
#
# Author:
#   Camtendo

Util = require 'util'

admins = ["camtendo","hollyfrass", "t0asterb0t", "grandpajakelol"]
apiKey = process.env.CHALLONGE_API_KEY
challongeApi = 'https://Camtendo:'+apiKey+'@api.challonge.com/v1'
tournaments = []
televisions = []

module.exports = (robot) ->
  robot.hear /add tournament (.*)/i, (msg) ->
    return msg.send("You don't have permission to do that.") if !isAdmin msg.message.user.name
    tHash = msg.match[1]
    tourney = { name:"", hash: tHash, matches:[], players: [], timeoutId: null}
    
  isAdmin = (term) ->
    admins.indexOf(admin) isnt -1