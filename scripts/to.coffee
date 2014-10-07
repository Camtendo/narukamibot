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
#	add tournament (hash) -tvs (numTVs) - Creates a tournament from a Challonge hash with numTVs
# stop tournaments - Kill autoupdate
# for tournament (tourneyId) set match (id) on TV (number)
#
# Author:
#   Camtendo

Util = require 'util'

#TODO Move to config
admins = ["camtendo","hollyfrass", "t0asterb0t", "grandpajakelol", "milhouse92", "azianman", "ddrsensation", "staphf", "yuuleee", "satisfyler"]

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
    tournaments.push tourney
    clearInterval timeoutId if timeoutId

    timeoutId = setInterval ->
      fetchTournament(msg, t) for t in tournaments
      mapMatches(msg, t) for t in tournaments
    , 15000

  robot.hear /for tournament (.*) set match (.*) on TV (.*)/i, (msg) ->
    tourneyIndex = msg.match[1]
    id = msg.match[2]
    tvIndex = msg.match[3]
    setMatch(msg, tournaments[tourneyIndex-1], id, tvIndex)

  isAdmin = (admin) ->
    admins.indexOf(admin) isnt -1s

  getMatch = (msg, tournament, identifier) ->
    tournament.matches.filter (match) ->
      match.match.identifier == identifier

  getPlayer = (msg, tournament, userId) ->
    tournament.players.filter (player) ->
      player.participant.id == userId

  setMatch = (msg, tournament, id, tvIndex) ->
    return msg.send("That TV doesn't exist!") if tvIndex <=0 or tvIndex > tournament.tellys.length
    return msg.send("That match is already being played!") if tournament.tellys.indexOf(match.match.identifier) isnt -1
    tournament.tellys[tvIndex - 1] = id
    msg.send("Match #{id} is now on TV #{tvIndex}.")

  fetchTournament = (msg, tournament) ->
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
    return -1 if !tournament or !tournament.matches.length
    #Remove completed matches
    for id, i in tournament.tellys then do (id) =>
      if id != ''
        match = getMatch(msg, tournament, id)
        if match != null and match[0] != null and match[0].match.state == "complete"
          msg.send("Match #{id} on TV #{i+1} has completed.")
          id = ''
          tournament.tellys[i] = id
        else
          skippuuuuu = true
      else
        skip = true

    #Determine Queued Matches
    queuedMatches = []
    for match in tournament.matches then do (match) =>
      if match.match.state == "open" and tournament.tellys.indexOf(match.match.identifier) is -1
        queuedMatches.push match
      else
        state = match.match.state

    for id, i in tournament.tellys then do (id) =>
      if id == '' and queuedMatches.length > 0
        match = queuedMatches[0]
        playerOne = getPlayer(msg, tournament, match.match.player1_id)[0]
        leftPlayer = if playerOne.participant.name then playerOne.participant.name else playerOne.participant.username
        playerTwo = getPlayer(msg, tournament, match.match.player2_id)[0]
        rightPlayer = if playerTwo.participant.name then playerTwo.participant.name else playerTwo.participant.username
        id = match.match.identifier
        tournament.tellys[i] = id
        msg.send("Match #{id}: #{leftPlayer} vs. #{rightPlayer} should be put on TV #{i+1}")
        queuedMatches = queuedMatches.slice(1)
      else
        skip = true
