--[==[
 * HL Log Standard style logging
 * Script written by Clavus (http://steamcommunity.com/id/clavuselite)
 * Free to distribute and use for any purpose
 *
 * Read about the HL Log Standard here (*** RECOMMENDED ***):
 * http://developer.valvesoftware.com/wiki/HL_Log_Standard
 *
 * Usage: call 'require("log")' at the start of your script or gamemode.
 * The following functions can then be called:
	log.InitializeTeamBased( team 1 id, team 1 code, team 2 id, team 2 code, ... )
	log.PlayerKill( attacker, victim, weapon, properties )
	log.PlayerInjured( attacker, victim, weapon, properties )
	log.PlayerSuicide( player, weapon, properties )
	log.PlayerJoinTeam( player, team, properties )
	log.PlayerRoleChange( player, role, properties )
	log.PlayerOnPlayerAction( player, target, action, properties )
	log.PlayerAction( player, action, properties )
	log.TeamAction( team, action, properties )
	log.WorldAction( action, properties )
	log.TeamAlliance( team1, team2, properties )
	log.TeamScoreReport( team, score, numplayers, properties )
	log.PlayerPrivateMessage( sender, receiver, message, properties )
	log.PlayerScore( player, score, properties )
	log.PlayerSelectWeapon( player, weapon, properties )
	log.PlayerAcquireWeapon( player, weapon, properties )
	log.Comment( message )
 * Note that every player argument also accepts the world entity
 *
 * This script exists to help gamemode developers easily
 * log events and actions according to the HL Log Standard,
 * making their gamemode compatible with a variety of statistic
 * tracking services like gameME (http://www.gameme.com/).
 *
 * Garry's Mod already logs all the HL Engine events.
 * GMod also logs several game events:
 * Connection: "Name<uid><wonid><>" connected, address "ip:port"
 * Validation: "Name<uid><wonid><>" STEAM USERID validated
 * Enter Game: "Name<uid><wonid><>" entered the game
 * Disconnection: "Name<uid><wonid><team>" disconnected
 * Kick: "Name<uid><wonid><>" was kicked by "Console" (message "")
 * Say: "Name<uid><wonid><team>" say "message" & "Name<uid><wonid><team>" say_team "message"
 *
 * This script will provide an easy way to log most of the remaining events, 
 * which can be finetuned to adjust to your needs.
 *
 * *** PROPERTIES ***
 * Key names may not contain spaces or parentheses (( or )). A value may not contain double-quotes (").
 * Vectors are automatically formatted.
 * A property with boolean value 'true' will be shortened to just the parenthised property name.
 * Example:
 * --------------------------------
	require("log")
 
	local properties = {}
	properties["headshot"] = true								--  will be shortened to just the key name
	properties["attacker_position"] = Vector(-100, 100, 200.87)	--  will be formatted to 3 signed integers
	properties["custom_kill"] = "nuked"							--  'default' example
	
	log.PlayerKill( attacker, victim, weapon, properties )
 * --------------------------------
 * This will output: 
	"Name<uid><wonid><team>" killed "Name<uid><wonid><team>" with "weapon" (headshot) (attacker_position "-100 100 200") (custom_kill "nuked")
 *
 * *** TEAMS ***
 * Since the team system in Garry's Mod does not use team codes (it applies the team code "Team"
 * by default it seems), you will need to call log.InitializeTeamBased( ... ) first and pass 
 * the desired team codes. For example:
 * Somewhere in your script you created teams using team.SetUp( Integer TeamIndex, String TeamName, Color TeamColor )
   ---------------------------------
   team.SetUp( 2, "Team Red", Color(255,0,0) )
   team.SetUp( 3, "Team Mr. Green", Color(0, 255, 0) )
   ---------------------------------
 * To properly make these show up in the logs, call:
   ---------------------------------
   log.InitializeTeamBased( 2, "Red", 3, "Green" )
   ---------------------------------
 * This way IDs 2 and 3 are tagged "Red" and "Green" respectively, 
 * so a player in Team Red would get logged as:
	"PlayerName<120><STEAM_0:1:12345><Red>"
 *
 * You can also call log.InitializeTeamBased without passing arguments,
 * then the system will use the team ID instead. So in the above example:
	"PlayerName<120><STEAM_0:1:12345><2>"
 *
 * In case log.InitializeTeamBased is not called (in non-teamplay based gamemodes
 * for example), the team code will be the user ID, as dictated by the HL Log Standard:
	"PlayerName<120><STEAM_0:1:12345><120>"
 *
 ]==]

ValidEntity = IsValid
 
--  not needed for clients
if CLIENT then return end

local ValidEntity = ValidEntity
local Error = Error
local string = string
local type = type
local tostring = tostring
local team_based = false
local team_codes = {}

local function formatProperties( tab )

	local output = ""

	for k, v in pairs( tab ) do
		
		--  find all '(', ')' and space characters
		if (string.find(k,"[%(%)%s]")) then Error("Log: Property key name cannot contain spaces or parentheses!") end

		if (type(v) == "boolean" and v) then
			output = output..string.format("(%s) ",tostring(k))
		elseif (type(v) == "Vector") then
			local vector = string.format("%d %d %d",v.x,v.y,v.z)
			output = output..string.format("(%s %q) ",tostring(k),vector)
		else
			--  find the quote character
			if (string.find(v,"\"")) then Error("Log: Property value name cannot contain a quote character!") end
			
			output = output..string.format("(%s %q) ",tostring(k),tostring(v))
		end
	
	end
	
	return output
	
end

local function formatTeam( tm )

	if (team_codes[tm]) then
		return team_codes[tm]
	else
		return tostring(tm)
	end

end

local function formatPlayer( pl )

	if (pl:IsWorld()) then
		return "<-1><><>";
	end

	local pName = pl:Name()
	local pUID = pl:UserID()
	local pSteam = pl:SteamID()
	local pTeam = pl:Team()
	
	if team_based then
		return string.format("%s<%s><%s><%s>", pName, pUID, pSteam, formatTeam(pTeam))
	else
		return string.format("%s<%s><%s><%s>", pName, pUID, pSteam, pUID)
	end
	
end

local function playerValid( pl )

	return (ValidEntity( pl ) and pl:IsPlayer()) or pl:IsWorld()

end

local function Log( str )

	ServerLog( str.."\n" )

end

module("log")

--[==[---------------------------------------------------------
    Name: InitializeTeamBased( team 1 id, team 1 code, team 2 id, team 2 code, ...)
    Desc: Call this function at the start of your script if you want 
		  the logs to make a distinction between teams. 
   Usage: You need to give a team code for every team id that is used
---------------------------------------------------------]==]
function InitializeTeamBased( arg )
	
	--local arg = unpack({...})
	
	team_codes = {}
	
	for i = 1, #arg, 2 do
	
		team_codes[arg[i]] = arg[i+1]
	
	end
	
	team_based = true

end


--[==[---------------------------------------------------------
    Name: PlayerKill(Player attacker, Player victim, String weapon, (optional) Table properties)
    Desc: Logs a kill in the format 
			"Name<uid><wonid><team>" killed "Name<uid><wonid><team>" with "weapon"
   Usage: 
---------------------------------------------------------]==]
function PlayerKill( attacker, victim, weapon, props )

	if (not playerValid( attacker )) then Error("Log: Invalid attacker specified!") end
	if (not playerValid( victim )) then Error("Log: Invalid victim specified!") end
	if (type(weapon) ~= "string") then Error("Log: No weapon specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q killed %q with %q", formatPlayer(attacker), formatPlayer(victim), weapon)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)

end


--[==[---------------------------------------------------------
    Name: PlayerInjured(Player attacker, Player victim, String weapon, (optional) Table properties)
    Desc: Logs a kill in the format 
			"Name<uid><wonid><team>" attacked "Name<uid><wonid><team>" with "weapon"
   Usage: If the injury results in a kill, it's recommended to use
		  log.PlayerKill instead.
		  It's recommended to pass the property (damage "amount") to
		  indicate the amount of health the victim lost.
---------------------------------------------------------]==]
function PlayerInjured( attacker, victim, weapon, props )

	if (not playerValid( attacker )) then Error("Log: Invalid attacker specified!") end
	if (not playerValid( victim )) then Error("Log: Invalid victim specified!") end
	if (type(weapon) ~= "string") then Error("Log: No weapon specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q attacked %q with %q", formatPlayer(attacker), formatPlayer(victim), weapon)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)

end

--[==[---------------------------------------------------------
    Name: PlayerSuicide(Player player, String weapon, (optional) Table properties)
    Desc: Logs an epic fail in the format 
			"Name<uid><wonid><team>" committed suicide with "weapon"
   Usage: 
---------------------------------------------------------]==]
function PlayerSuicide( player, weapon, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(weapon) ~= "string") then Error("Log: No weapon specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q committed suicide with %q", formatPlayer(player), weapon)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerJoinTeam(Player player, Int team, (optional) Table properties)
    Desc: Logs a team join
			"Name<uid><wonid><team>" joined team "team"
   Usage: 
---------------------------------------------------------]==]
function PlayerJoinTeam( player, team, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(team) ~= "number") then Error("Log: Invalid team ID!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q joined team %q", formatPlayer(player), formatTeam(team))
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerRoleChange(Player player, String role, (optional) Table properties)
    Desc: Logs a role change (like classes in TF2/DoD)
			"Name<uid><wonid><team>" changed role to "role"
   Usage: 
---------------------------------------------------------]==]
function PlayerRoleChange( player, role, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(role) ~= "string") then Error("Log: Invalid role specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q changed role to %q", formatPlayer(player), role)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerOnPlayerAction(Player player, Player target, String action, (optional) Table properties)
    Desc: Logs a player on player action:
			"Name<uid><wonid><team>" triggered "action" against "Name<uid><wonid><team>"
   Usage: 
---------------------------------------------------------]==]
function PlayerOnPlayerAction( player, target, action, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (not playerValid( target )) then Error("Log: Invalid target player specified!") end
	if (type(action) ~= "string") then Error("Log: Invalid action specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q triggered %q against %q", formatPlayer(player), action, formatPlayer(target))
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerAction(Player player, Player target, String action, (optional) Table properties)
    Desc: Logs a player action:
			"Name<uid><wonid><team>" triggered "action"
   Usage: 
---------------------------------------------------------]==]
function PlayerAction( player, action, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(action) ~= "string") then Error("Log: Invalid action specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q triggered %q", formatPlayer(player), action)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: TeamAction(Int team, String action, (optional) Table properties)
    Desc: Logs a player on player action:
			Team "team" triggered "action"
   Usage: 
---------------------------------------------------------]==]
function TeamAction( team, action, props )
	
	if (type(team) ~= "number") then Error("Log: Invalid team ID!") end
	if (type(action) ~= "string") then Error("Log: Invalid action specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("Team %q triggered %q", formatTeam(team), action)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: WorldAction(String action, (optional) Table properties)
    Desc: Logs a world action:
			World triggered "action"
   Usage: 
---------------------------------------------------------]==]
function WorldAction( action, props )

	if (type(action) ~= "string") then Error("Log: Invalid action specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("World triggered %q", action)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: TeamAlliance(Int team1, Int team2, (optional) Table properties)
    Desc: Logs a team alliance
			Team "team" formed alliance with team "team"
   Usage: 
---------------------------------------------------------]==]
function TeamAlliance( team1, team2, props )
	
	if (type(team1) ~= "number") then Error("Log: Invalid team1 ID!") end
	if (type(team2) ~= "number") then Error("Log: Invalid team2 ID!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("Team %q formed alliance with team %q", formatTeam(team1), formatTeam(team2))
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: TeamScoreReport(Int team, Int score, Int numplayers, (optional) Table properties)
    Desc: Logs a team score report
			Team "team" scored "score" with "numplayers" players
   Usage: Refer to the HL Log Standard entry on the Source SDK wiki
		  for a description of properties used to extend the report.
---------------------------------------------------------]==]
function TeamScoreReport( team, score, numplayers, props )

	if (type(team) ~= "number") then Error("Log: Invalid team ID!") end
	if (type(score) ~= "number") then Error("Log: Invalid score!") end
	if (type(numplayers) ~= "number") then Error("Log: Invalid player number!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end

	local log = string.format("Team %q scored %q with %q players", formatTeam(team), tostring(score), tostring(numplayers))
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerPrivateMessage(Player sender, Player receiver, String message, (optional) Table properties)
    Desc: Logs a private message:
			"Name<uid><wonid><team>" tell "Name<uid><wonid><team>" message "message"
   Usage: 
---------------------------------------------------------]==]
function PlayerPrivateMessage( sender, receiver, message, props )

	if (not playerValid( sender )) then Error("Log: Invalid sender specified!") end
	if (not playerValid( receiver )) then Error("Log: Invalid receiver specified!") end
	if (type(message) ~= "string") then Error("Log: Invalid message specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q tell %q message %q", formatPlayer(sender), formatPlayer(receiver), message)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerScore(Player player, Int score, (optional) Table properties)
    Desc: Logs a player score report:
			Player "Name<uid><wonid><team>" scored "score"
   Usage: Refer to the HL Log Standard entry on the Source SDK wiki
		  for a description of properties used to extend the report.
---------------------------------------------------------]==]
function PlayerScore( player, score, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(score) ~= "number") then Error("Log: Invalid score specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("Player %q scored %q", formatPlayer(player), tostring(score))
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerSelectWeapon(Player player, String weapon, (optional) Table properties)
    Desc: Logs the player equiping a weapon:
			"Name<uid><wonid><team>" selected weapon "weapon"
   Usage: 
---------------------------------------------------------]==]
function PlayerSelectWeapon( player, weapon, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(weapon) ~= "string") then Error("Log: No weapon specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q selected weapon %q", formatPlayer(player), weapon)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: PlayerAcquireWeapon(Player player, String weapon, (optional) Table properties)
    Desc: Logs the player equiping a weapon:
			"Name<uid><wonid><team>" acquired weapon "weapon"
   Usage: 
---------------------------------------------------------]==]
function PlayerAcquireWeapon( player, weapon, props )

	if (not playerValid( player )) then Error("Log: Invalid player specified!") end
	if (type(weapon) ~= "string") then Error("Log: No weapon specified!") end
	if (props and type(props) ~= "table") then Error("Log: Properties value is not a table!") end
	
	local log = string.format("%q acquired weapon %q", formatPlayer(player), weapon)
	
	if (props) then
	
		log = log.." "..formatProperties( props )
	
	end
	
	Log(log)
	
end

--[==[---------------------------------------------------------
    Name: Comment(String message)
    Desc: Logs a comment:
			--  "message"
   Usage: Should not be parsed by any stat tracking services
		  and is only useful to improve log readability or
		  something.
---------------------------------------------------------]==]
function Comment( message )
	
	if (type(message) ~= "string") then Error("Log: Invalid comment string!") end
	
	Log("--  "..message)

end
	