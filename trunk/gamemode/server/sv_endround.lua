-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Web-Stats file
include( "sv_endround_stats.lua" )

local function CheckPlayerDeathNitwits ( pl, attacker, dmginfo )
	local headshot = false
	local attach = pl:GetAttachment(1)
	
	--  Headshots nitwit
	if pl:IsPlayer() and attacker:IsPlayer() then
		if attach then
			headshot = dmginfo:IsBulletDamage() and dmginfo:GetDamagePosition():Distance( pl:GetAttachment(1).Pos ) < 15
			pl.Headshots = pl.Headshots + 1
		end
	end
	
	
end
hook.Add("DoPlayerDeath","CheckNitwits",CheckPlayerDeathNitwits)

--[==[---------------------------------------------------------
	 Send top surivival times to client
---------------------------------------------------------]==]
function GM:SendTopTimes(to)
	local PlayerSorted = {}

	for k, v in pairs(player.GetAll()) do
		if v.SurvivalTime then
			table.insert(PlayerSorted, v)
		end
	end
	
	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		return a.SurvivalTime > b.SurvivalTime
	end)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopTimes", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring( ToMinutesSeconds( pl.SurvivalTime ) ) )
			umsg.End()
		end
	end
end

--[==[---------------------------------------------------------
	 Send top brains eaten to client
---------------------------------------------------------]==]
function GM:SendTopZombies(to)	
	local PlayerSorted = {}

	for k, v in pairs(player.GetAll()) do
		if v.BrainsEaten then
			table.insert(PlayerSorted, v)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.BrainsEaten == b.BrainsEaten then
			return a:Deaths() < b:Deaths()
		end
		return a.BrainsEaten > b.BrainsEaten
	end)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopZombies", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring ( pl.BrainsEaten ) )
			umsg.End()
		end
	end
end

--[==[---------------------------------------------------------
	 Send top damage done by humans
---------------------------------------------------------]==]
function GM:SendTopHumanDamages(to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt and pl.DamageDealt[TEAM_HUMAN] then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_HUMAN] == b.DamageDealt[TEAM_HUMAN] then
			return a:UserID() > b:UserID()
		end
		return a.DamageDealt[TEAM_HUMAN] > b.DamageDealt[TEAM_HUMAN]
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopHumanDamages", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring ( math.ceil( pl.DamageDealt[TEAM_HUMAN] ) ) )
			umsg.End()
		end
	end
end

--[==[---------------------------------------------------------
	 Send top zombies killed
---------------------------------------------------------]==]
function GM:SendTopZombiesKilled (to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.ZombiesKilled then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.ZombiesKilled == b.ZombiesKilled then
			return a:UserID() > b:UserID()
		end
		return a.ZombiesKilled > b.ZombiesKilled
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopZombiesKilled", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring ( math.ceil( pl.ZombiesKilled ) ) )
			umsg.End()
		end
	end
end

--[==[---------------------------------------------------------
	 Send top damage done by zombie
---------------------------------------------------------]==]
function GM:SendTopZombieDamages(to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt and pl.DamageDealt[TEAM_UNDEAD] then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_UNDEAD] == b.DamageDealt[TEAM_UNDEAD] then
			return a:UserID() > b:UserID()
		end
		return a.DamageDealt[TEAM_UNDEAD] > b.DamageDealt[TEAM_UNDEAD]
	end)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopZombieDamages", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String ( tostring ( math.ceil( pl.DamageDealt[TEAM_UNDEAD] ) ) )
			umsg.End()
		end
	end
end

--[==[---------------------------------------------------------
		  Send top healing done (medic only)
---------------------------------------------------------]==]
function GM:SendTopHealing (to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.HealingDone then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.HealingDone == b.HealingDone then
			return a:UserID() > b:UserID()
		end
		return a.HealingDone > b.HealingDone
	end)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopHealing", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring ( math.ceil( pl.HealingDone ) ) )
			umsg.End()
		end
	end
end

--[==[--------------------------------------------------------
	 Receive the chosen map from the client
--------------------------------------------------------]==]
function GetChosenMap( pl, cmd, args )
	if args[1] == nil then 
	   return 
	end
	
	if not ValidEntity ( pl ) then 
	   return 
	end
	
	-- Update server and client votepoints
	UpdateClientVotePoints ( pl, args[1] )
end
concommand.Add("VoteAddMap",GetChosenMap)

local VotePointTable = {}

function GM:SendVotemaps ( to )
	local VoteMaps = self:GetVoteMaps()
	
	if ( #VoteMaps < 3 ) then 
	   return -- Deluvas; what kind of error handling system is this
	end

	net.Start("ReceiveVoteMaps")
	for i = 1, 3 do 
		local key = VoteMaps[i][1]
		VotePointTable[key] = { Votes = 0, Map = { FileName = VoteMaps[i][1], FriendlyName = VoteMaps[i][2] } }
			
		-- Send the data
		net.WriteString(VotePointTable[key].Map.FileName)
		net.WriteString(VotePointTable[key].Map.FriendlyName)
	end
	net.Broadcast()
end

--Init netmessages
util.AddNetworkString("ReceiveVoteMaps")
util.AddNetworkString("ReceiveVotePoints")

--[==[---------------------------------------------------------
  Update client and server vote points for maps
---------------------------------------------------------]==]
function UpdateClientVotePoints(pl, mapfilename)
	if pl.Voted then 
	   return 
	end
		
	-- Increment voting points for map
	VotePointTable[mapfilename] = VotePointTable[mapfilename] or { Votes = 0 }
	VotePointTable[mapfilename].Votes = VotePointTable[mapfilename].Votes + 1
	
	pl.Voted = true

	UpdateClientVoteMaps(pl)
end

--[==[---------------------------------------------------------
	Proper Server to client votemap 
		   update for one player
---------------------------------------------------------]==]
function UpdateClientVoteMaps(pl)
	if not ValidEntity(pl) then
		return
	end
	
	-- Send change to all players
	net.Start("ReceiveVotePoints")
	for k,v in pairs(VotePointTable) do
		net.WriteString(k)
		net.WriteDouble(v.Votes)
	end
	net.Send(pl)
end	
	
--[==[---------------------------------------------------------
		Main Endgame Function
---------------------------------------------------------]==]
function GM:OnEndRound ( winner )
	if ENDROUND then return end
	ENDROUND = true
	ENDTIME = CurTime()
	WinnerMap = ""
	
	--  logging
	log.WorldAction("Round_End")
	
	if (winner == TEAM_UNDEAD) then
		log.WorldAction("Undead_Win")
	elseif (winner == TEAM_HUMAN) then
		log.WorldAction("Survivor_Win")
	end
	
	hook.Remove("SetupPlayerVisibility", "AddCratesToPVS")
	
	-- Enable all talk
	RunConsoleCommand ( "sv_alltalk", "1" )
		
	-- Get nextmap in case voting fails
	local NextMap = GAMEMODE:GetMapNext()
	
	timer.Simple(VOTE_TIME, function()
		for k,pl in pairs (player.GetAll()) do
			if pl:Team() ~= TEAM_SPECTATOR then
				if not pl.Voted then 
					UpdateClientVotePoints( pl, table.RandomEx( VotePointTable ).Map.FileName )
					pl:SendLua ("MySelf.HasVotedMap = true")
				end
			end
		end
		
		--- Calculate the map with most points
		local MaximumPoint = -100
		WinnerMap = "Unknown"
		
		-- Find winner map
		for k, v in pairs ( VotePointTable ) do
			if v.Votes > MaximumPoint then
				MaximumPoint = v.Votes
				WinnerMap = v.Map.FileName
				WinnerMapName = v.Map.FriendlyName				
				NextMap = WinnerMap
			end
		end
		
		-- Deluvas; what in Clavus' name is this
		if NextMap == nil then 
			NextMap = "zs_noir" 
			WinnerMap = "zs_noir" 
		end
		
		--TODO: Use net messages
		gmod.BroadcastLua("SetWinnerMap('"..WinnerMap.."','"..WinnerMapName.."')")
	end)
		
	-- Change level after intermission time runs out
	timer.Simple(INTERMISSION_TIME, function()
		game.ConsoleCommand("changelevel "..NextMap.."\n");
	end)
	
	-- We don't want to respawn anymore 
	function self:PlayerDeathThink(pl)
	end
	
	ROUNDWINNER = winner
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_HUMAN then
			if pl.SpawnedTime then
				pl.SurvivalTime = CurTime() - pl.SpawnedTime
			end
		
			if LASTHUMAN and pl.LastHumanTime then
				pl:UnlockAchievement("survivor")
			end
			if LASTHUMAN  then
				pl:UnlockAchievement("klinator")
			end
			if pl.TookHit == false then
				pl:UnlockAchievement("dancingqueen")
			end
				
			-- For the last 2 levels, the second achievment is to survive.
			if team.NumPlayers (TEAM_HUMAN) + team.NumPlayers(TEAM_UNDEAD) > 11 then
				if not pl:IsBot() then
					if pl:Alive() then
						if self:IsRetroMode() then
							pl:AddXP(8000)
						else
							pl:AddXP(6000)
						end
					end
				end
			end
		end
	end

	-- Send the information payload to the client ( all of them :o )
	GAMEMODE:SendTopTimes()
	GAMEMODE:SendTopZombies()
	GAMEMODE:SendTopHumanDamages()
	GAMEMODE:SendTopZombieDamages()
	GAMEMODE:SendVotemaps()
	GAMEMODE:SendTopHealing()
	GAMEMODE:SendTopZombiesKilled ()
	
	--MapExploitWrite()
	--Send the information to the player that joined in the intermission
	hook.Add("PlayerReady", "LateJoin", function ( pl )
		--Send all the info the that late join player
		GAMEMODE:SendTopTimes(pl)
		GAMEMODE:SendTopZombies(pl)
		GAMEMODE:SendTopHumanDamages(pl)
		GAMEMODE:SendTopZombieDamages(pl)
		GAMEMODE:SendVotemaps(pl)
		GAMEMODE:SendTopHealing (pl)
		GAMEMODE:SendTopZombiesKilled (pl)
		
		--Delay this so it doesn't give errors
		timer.Simple(0.2, function() 
			if ValidEntity ( pl ) then
				local TimeLeft = INTERMISSION_TIME - ( CurTime() - ENDTIME )
				pl:SendLua( "Intermission('"..GAMEMODE:GetMapNext().."', "..ROUNDWINNER..", "..TimeLeft.." )" )
				
				--Update his votemaps
				UpdateClientVoteMaps(pl)
				if TimeLeft < INTERMISSION_TIME - VOTE_TIME then
					pl:SendLua("SetWinnerMap( '"..WinnerMap.."' )")
					pl:SendLua("MySelf.HasVotedMap = true")
				end
				
				timer.Simple(0.4, function()
					if IsValid( pl ) then
						pl:DrawViewModel ( false )
						pl:Lock()
					end 
				end)
			end
		end)
	end)
	
	-- Send the actual panel in delay
	timer.Simple(0.2, function()
		gmod.BroadcastLua("Intermission('"..NextMap.."', "..winner..", "..INTERMISSION_TIME.." )")
	end)
	
	local playerCount = #player.GetAll()

	local DamageUndead = 0
	local DamageHuman = 0
	for _, pl in ipairs( player.GetAll() ) do
	
		-- Don't draw the weapon viewmodel for artistic purposes.
		pl:DrawViewModel(false)
		
		--Lock the player and make him unable to spawn
		pl.NextSpawn = CurTime()+500

		pl:Lock()
	
		if pl.DamageDealt then
			if pl.DamageDealt[TEAM_HUMAN] then
				DamageUndead = DamageUndead + pl.DamageDealt[TEAM_HUMAN]
			end
			if pl.DamageDealt[TEAM_UNDEAD] then
				DamageHuman = DamageHuman + pl.DamageDealt[TEAM_UNDEAD]
			end
		end
		
		-- Saving data/stats over time
		timer.Simple( _ * ( ( INTERMISSION_TIME - 3 ) / playerCount ), function()
			if not IsValid( pl ) then
				return 
			end
			
			-- Most stats/class data
			pl:WriteDataSQL()

			-- Greencoins
			pl:SaveGreenCoins()
		end )
	end
end

Debug ( "[MODULE] Loaded End-Round file." )