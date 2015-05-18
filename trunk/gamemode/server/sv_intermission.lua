-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Get nextmap in case voting fails
local NextMap = "zs_fortress_mod"

local function CheckPlayerDeathNitwits(pl, attacker, dmginfo)	
	--Headshots nitwit
	if pl:IsPlayer() and attacker:IsPlayer() then
		--local headshot = false
		local attach = pl:GetAttachment(1)
		if attach then
			--headshot = dmginfo:IsBulletDamage() and dmginfo:GetDamagePosition():Distance( pl:GetAttachment(1).Pos ) < 15
			pl.Headshots = pl.Headshots + 1
		end
	end
end
hook.Add("DoPlayerDeath","CheckNitwits",CheckPlayerDeathNitwits)


--[[---------------------------------------------------------
	 Send top greencoins ( both teams)
---------------------------------------------------------]]
function GM:SendTopGreencoins(to)
	local PlayerSorted = {}

	for _, pl in pairs( player.GetAll() ) do
		pl.TotalGreencoins = pl.GreencoinsGained[TEAM_HUMAN] + pl.GreencoinsGained[TEAM_UNDEAD]
		table.insert(PlayerSorted, pl)
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.TotalGreencoins == b.TotalGreencoins then
			return a:UserID() > b:UserID()
		end
		return a.TotalGreencoins > b.TotalGreencoins
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopGreencoins", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring ( math.ceil( pl.TotalGreencoins ) ) )
			umsg.End()
		end
	end
end


--[[---------------------------------------------------------
	 Send top assisting players
---------------------------------------------------------]]
function GM:SendTopAssists(to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.Assists then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted, function(a, b)
		if a.Assists == b.Assists then
			return a:UserID() > b:UserID()
		end

		return a.Assists > b.Assists
	end)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopAssists", to)
				umsg.Short(x)
				umsg.String(pl:Name())
				umsg.String(tostring(math.ceil(pl.Assists))) 
			umsg.End()
		end
	end
end

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
	
	if not IsValid ( pl ) then 
	   return 
	end
	
	-- Update server and client votepoints
	UpdateClientVotePoints ( pl, args[1] )
end
concommand.Add("VoteAddMap",GetChosenMap)

local VotePointTable = {}

function GM:SendVotemaps(to)
	local VoteMaps = self:GetVoteMaps()
	
	if #VoteMaps < 3 then 
	   return -- Deluvas; what kind of error handling system is this
	end

	net.Start("ReceiveVoteMaps")
	for i = 1, 3 do
		local key = VoteMaps[i].Map

		if not VotePointTable[key] then
			VotePointTable[key] = {
				Votes = 0,
				Map = {
					FileName = key,
					FriendlyName = VoteMaps[i].MapName
				}
			}
		end
			
		-- Send the data
		net.WriteString(VotePointTable[key].Map.FileName)
		net.WriteString(VotePointTable[key].Map.FriendlyName)
	end
	net.Broadcast()
end

--Init Net messages
util.AddNetworkString("ReceiveVoteMaps")
util.AddNetworkString("ReceiveVotePoints")
util.AddNetworkString("ReceiveVoteMapWinner")

--[==[---------------------------------------------------------
  Update client and server vote points for maps
---------------------------------------------------------]==]
function UpdateClientVotePoints(pl, mapfilename)
	if pl.Voted or not VotePointTable[mapfilename] then 
	   return 
	end
		
	-- Increment voting points for map
	VotePointTable[mapfilename].Votes = VotePointTable[mapfilename].Votes + 1
	
	pl.Voted = true

	UpdateClientVoteMaps()
end

--[==[---------------------------------------------------------
	Proper Server to client votemap 
		   update for one player
---------------------------------------------------------]==]
function UpdateClientVoteMaps()
	-- Send change to all players
	net.Start("ReceiveVotePoints")
	for k,v in pairs(VotePointTable) do
		net.WriteString(k)
		net.WriteDouble(v.Votes)
	end
	--net.Send(pl)
	net.Broadcast()
end	
	
--[==[---------------------------------------------------------
		Main Endgame Function
---------------------------------------------------------]==]
function GM:OnEndRound(winner)
	if ENDROUND then
		return
	end
	ENDROUND = true
	ENDTIME = CurTime()
	
	--log.WorldAction("Round_End")
	
	--[[if winner == TEAM_UNDEAD then
		log.WorldAction("Undead_Win")
	elseif winner == TEAM_HUMAN then
		log.WorldAction("Survivor_Win")
	end]]

	--Enable all talk
	--TODO: Hide this from player chat
	RunConsoleCommand("sv_alltalk", "1")
	
	timer.Simple(VOTE_TIME, function()
		--Force vote state for idlers
		for k,pl in pairs(player.GetAll()) do
			if pl:Team() == TEAM_SPECTATOR or pl.Voted then
				continue
			end

			pl:SendLua("MySelf.HasVotedMap = true")
		end
		
		--Calculate the map with most points
		local MaximumPoints = -100
		
		--Find winner map
		for k, v in pairs(VotePointTable) do
			if v.Votes > MaximumPoints then
				MaximumPoints = v.Votes
				NextMap = k
			end
		end

		--Send final votings
		UpdateClientVoteMaps(pl)
	
		--TODO: Use net messages
		gmod.BroadcastLua("SetWinnerMap('".. NextMap .."')")
	end)
		
	-- Change level after intermission time runs out
	timer.Simple(INTERMISSION_TIME, function()
		game.ConsoleCommand("changelevel ".. NextMap .."\n");
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
			if pl.TookHit == false then
				pl:UnlockAchievement("dancingqueen")
			end
				
			-- For the last 2 levels, the second achievement is to survive.
			if team.NumPlayers(TEAM_HUMAN) + team.NumPlayers(TEAM_UNDEAD) > 10 then
				if not pl:IsBot() and pl:Alive() then
					pl:AddXP(4000)
					
				if game.GetMap() == "zs_uglyfort" then
					pl:UnlockAchievement("uglyfort")
				elseif game.GetMap() == "zs_fortress_mod" then
					pl:UnlockAchievement("fortress")				
				elseif game.GetMap() == "zs_termites_v2" then
					pl:UnlockAchievement("termites")				
				end
				
				end
			end
		end
	end

	-- Send the information payload to the client ( all of them :o )
	GAMEMODE:SendTopGreencoins()
	GAMEMODE:SendTopAssists()
	GAMEMODE:SendTopTimes()
	GAMEMODE:SendTopZombies()
	GAMEMODE:SendTopHumanDamages()	
	GAMEMODE:SendTopZombieDamages()
	GAMEMODE:SendVotemaps()
	GAMEMODE:SendTopHealing()
	GAMEMODE:SendTopZombiesKilled()
	
	--MapExploitWrite()
	--Send the information to the player that joined in the intermission
	hook.Add("PlayerReady", "LateJoin", function(pl)
		--Send all the info the that late join player
		GAMEMODE:SendTopGreencoins(pl)
		GAMEMODE:SendTopAssists(pl)
		GAMEMODE:SendTopTimes(pl)
		GAMEMODE:SendTopZombies(pl)
		GAMEMODE:SendTopHumanDamages(pl)
		GAMEMODE:SendTopZombieDamages(pl)
		GAMEMODE:SendVotemaps(pl)
		GAMEMODE:SendTopHealing(pl)
		GAMEMODE:SendTopZombiesKilled(pl)
		
		--Delay this so it doesn't give errors
		timer.Simple(0.2, function() 
			if not IsValid(pl) then
				return
			end
			
			local TimeLeft = INTERMISSION_TIME - ( CurTime() - ENDTIME )
			pl:SendLua("Intermission('"..GAMEMODE:GetMapNext().."', "..ROUNDWINNER..", "..TimeLeft.." )")
				
			--Update his votemaps
			UpdateClientVoteMaps(pl)
			if TimeLeft < INTERMISSION_TIME - VOTE_TIME then
				pl:SendLua("SetWinnerMap('".. NextMap .."')")
				pl:SendLua("MySelf.HasVotedMap = true")
			end
				
			timer.Simple(0.4, function()
				if not IsValid(pl) then
					return
				end
				
				pl:DrawViewModel(false)
				pl:Lock()
			end)
		end)
	end)
	
	--Send the actual panel in delay
	timer.Simple(0.2, function()
		gmod.BroadcastLua("Intermission('"..NextMap.."', "..winner..", "..INTERMISSION_TIME.." )")
	end)
		
	local playerCount = #player.GetAll()

	local DamageUndead = 0
	local DamageHuman = 0
	for _, pl in ipairs(player.GetAll()) do
		-- Don't draw the weapon viewmodel for artistic purposes.
		pl:DrawViewModel(false)
		
		--Lock the player and make him unable to spawn
		pl.NextSpawn = CurTime() + 500

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
			if not IsValid(pl) then
				return 
			end
			
			-- Most stats/class data
			pl:WriteDataSQL()

			-- Greencoins
			pl:SaveGreenCoins()
		end)
	end
end

Debug("[MODULE] Loaded Intermission")