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
televisions = {}
timeoutId = null

module.exports = (robot) ->
  robot.hear /stop tournaments/i, (msg) ->
  	clearInterval timeoutId

  robot.hear /add tournament (.*) -tvs (.*)/i, (msg) ->
    return msg.send("You don't have permission to do that.") if !isAdmin msg.message.user.name
    tHash = msg.match[1]
    numTVs = msg.match[2]
    t_vs = []
    for x in [1..numTVs]
      t_vs.push ''
    tourney = { name:'', game: '', hash: tHash, matches:[], players: [], tvs: numTVs, tellys: t_vs}
    msg.send('Initializing tournament using Challonge...')
    fetchTournament(msg, tourney)

    timeoutId = setInterval ->
      fetchTournament(msg, t) for t in tournaments
      mapMatches(msg, t) for t in tournaments
    , 20000

    tournaments.push tourney

  isAdmin = (admin) ->
    admins.indexOf(admin) isnt -1

  getMatch = (msg, tournament, identifier) ->
    tournament.matches.filter (match) ->
      match.match.identifier == identifier

  getPlayer = (msg, tournament, userId) ->
    tournament.players.filter (player) ->
      player.participant.id == userId

  fetchTournament = (msg, tournament) ->
    msg.send('Fetching...')
    msg.http(challongeApi+"/tournaments/"+tournament.hash+".json?include_matches=1&include_participants=1")
        .get() (err, res, body) ->
          try
            json = JSON.parse(body)
            tournament.game = json.tournament.game_name
            tournament.name = json.tournament.name
            tournament.matches = json.tournament.matches
            tournament.players = json.tournament.participants
          catch error
            msg.send "Looks like the request failed Senpai. error="+error+" res="+res


  mapMatches = (msg, tournament) ->
    return -1 if !tournament.length
    #Remove completed matches
    for i, id in tournament.tellys then do (id) =>
      if id != ''
        match = getMatch(msg, tournament, id)
        if match[0].match.state == "complete"
          msg.send("Match #{id} on TV #{i} has completed.")
          id = ''
        else
          skippuuuuu = true
      else
        skip = true

    #Determine Queued Matches
    queuedMatches = []
    for match in tournament.matches then do (match) =>
      if match.match.state == "open"
        queuedMatches.push match
      else
        state = match.match.state

    for i, id in tournament.tellys then do (id) =>
      if id == '' and queuedMatches.length > 0
        match = queuedMatches[0]
        playerOne = this.getPlayer(msg, currentMatch[0].match.player1_id)
        leftPlayer = if playerOne[0].participant.name then playerOne[0].participant.name else playerOne[0].participant.username
        playerTwo = this.getPlayer(msg, currentMatch[0].match.player2_id)
        rightPlayer = if playerTwo[0].participant.name then playerTwo[0].participant.name else playerTwo[0].participant.username
        msg.send("Match #{id}: #{leftPlayer} vs. #{rightPlayer} should be put on TV #{i}")
        id = match.match.identifier
        queuedMatches.splice(0, 1)
      else
        skip = true
