setx HUBOT_IRC_SERVER "irc.twitch.tv"
setx HUBOT_IRC_ROOMS "#camtendo"
setx HUBOT_IRC_NICK "narukamibot"
setx HUBOT_IRC_UNFLOOD "3000"
setx HUBOT_IRC_PASSWORD "oauth:4aheg71pxqtwucq47iwqk3bprrxkwcw"
xcopy "scripts\*" "node_modules\hubot\src\scripts\" /E /C /H /R /K /O /Y

./bin/hubot -a irc