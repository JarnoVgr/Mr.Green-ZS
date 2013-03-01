-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg

//Web-Stats file
include( "sv_endround_stats.lua" )

local function CheckPlayerDeathNitwits ( pl, attacker, dmginfo )
	local headshot = false
	local attach = pl:GetAttachment(1)
	
	// Headshots nitwit
	if pl:IsPlayer() and attacker:IsPlayer() then
		if attach then
			headshot = dmginfo:IsBulletDamage() and dmginfo:GetDamagePosition():Distance( pl:GetAttachment(1).Pos ) < 15
			pl.Headshots = pl.Headshots + 1
		end
	end
	
	
end
hook.Add("DoPlayerDeath","CheckNitwits",CheckPlayerDeathNitwits)

/*---------------------------------------------------------
	 Send top surivival times to client
---------------------------------------------------------*/
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

/*---------------------------------------------------------
	 Send top brains eaten to client
---------------------------------------------------------*/
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

/*---------------------------------------------------------
	 Send top damage done by humans
---------------------------------------------------------*/
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

/*---------------------------------------------------------
	 Send top greencoins ( both teams)
---------------------------------------------------------*/
function GM:SendTopGreencoins (to)
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

/*---------------------------------------------------------
	 Send top zombies killed
---------------------------------------------------------*/
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

/*---------------------------------------------------------
	 Send top assisting players
---------------------------------------------------------*/
function GM:SendTopAssists (to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.Assists then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.Assists == b.Assists then
			return a:UserID() > b:UserID()
		end
		return a.Assists > b.Assists
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopAssists", to)
				umsg.Short(x)
				umsg.String( pl:Name() )
				umsg.String( tostring ( math.ceil(pl.Assists) ) ) 
			umsg.End()
		end
	end
end

/*---------------------------------------------------------
	 Send top damage done by zombie
---------------------------------------------------------*/
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

/*---------------------------------------------------------
          Send top healing done (medic only)
---------------------------------------------------------*/
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

/*---------------------------------------------------------
	Send Most chosen class (both teams)
---------------------------------------------------------*/
function GM:SendMostChosenClass ( to )
	local MostChosenHumanClass,MostChosenUndeadClass = "",""

	-- Calculate most chosen human class
	local MaximumPoint = -100
	for k,v in pairs (self.TeamMostChosenClass) do
		for i = 1, #HumanClasses do
			if k == HumanClasses[i].Name then
				local CurrentPoint = v
				if CurrentPoint > MaximumPoint then
					MaximumPoint = CurrentPoint
					MostChosenHumanClass = k
					
					--Correct my spelling mistakes :<
					if k == "Berseker" then
						MostChosenHumanClass = "Marksman"
					end
				end
			end
		end
	end
	
	-- Chose most chosen undead class
	MaximumPoint = -100
	for k,v in pairs (self.TeamMostChosenClass) do
		for i = 1, #ZombieClasses do
			if k == ZombieClasses[i].Name then
				local CurrentPoint = v
				if CurrentPoint > MaximumPoint then
					MaximumPoint = CurrentPoint
					MostChosenUndeadClass = k
				end
			end
		end
	end
	
	--Send info to all players (Use only one string and split it on client)
	umsg.Start("RecMostChosenClass", to)
		umsg.String ( MostChosenHumanClass.."|"..MostChosenUndeadClass )
	umsg.End()
end

/*---------------------------------------------------------
  Send total greencoins gained for each team
---------------------------------------------------------*/
function GM:SendGreencoinsGained ( to )
	local HumanGC, UndeadGC = 0,0
	
	-- Calculate total gc gained for each team.
	for k,v in pairs (player.GetAll()) do
		HumanGC = HumanGC + v.GreencoinsGained[TEAM_HUMAN]
		UndeadGC = UndeadGC + v.GreencoinsGained[TEAM_UNDEAD]
	end
	
	--Send info to all players
	umsg.Start("RecTeamGreencoinsGained", to)
		umsg.Short ( HumanGC )
		umsg.Short ( UndeadGC )
	umsg.End()
end

function GM:SendVotemaps ( to )
	local VoteMaps = self:GetVoteMaps()
	
	if (#VoteMaps < 3) then return end
	
	umsg.Start("RecVotemaps", to)
		-- Only 3 maps!
		for i = 1,3 do 
			umsg.String ( VoteMaps[i][1] )
			umsg.String ( VoteMaps[i][2] )
		end
	umsg.End()
end

local function SortNitwit ( Nitwits, a, b, pl )
	if Nitwits[a] then
		if Nitwits[a][b] < pl[b] then
			Nitwits[a] = pl
		end
	elseif pl[b] > 0 then
		Nitwits[a] = pl
	end
end

function GM:SendTopNitwits (to)
	local Nitwits = {}
	Nitwits.HeadshotChamp = nil
	Nitwits.HelpfulChamp = nil
	Nitwits.BrutalChamp = nil
	Nitwits.FirstRedeemChamp = nil
	Nitwits.GreencoinChamp = nil
	Nitwits.HungryZombieChamp = nil
	Nitwits.ScaryChamp = nil
	Nitwits.HornyChamp = nil
	Nitwits.UnhappyChamp = nil
	Nitwits.MeleeChamp = nil
	Nitwits.PropChamp = nil
	Nitwits.Lasthuman = nil
	
	for k, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD or pl:Team() == TEAM_HUMAN then
			SortNitwit ( Nitwits, "HeadshotChamp", "Headshots", pl)
			SortNitwit ( Nitwits, "ScaryChamp", "ScreensFucked", pl)
			SortNitwit ( Nitwits, "HornyChamp", "Hornyness", pl)
			SortNitwit ( Nitwits, "MeleeChamp", "MeleeKills", pl)
			SortNitwit ( Nitwits, "PropChamp", "PropKills", pl)
			SortNitwit ( Nitwits, "HungryZombieChamp", "BrainsEaten", pl)
			
			for k,v in pairs (player.GetAll()) do
				if v.FirstRedeem then
					Nitwits.FirstRedeemChamp = v
				end
			end
			
			if Nitwits.GreencoinChamp then
				if Nitwits.GreencoinChamp.GreencoinsGained[TEAM_HUMAN] + pl.GreencoinsGained[TEAM_UNDEAD] < pl.GreencoinsGained[TEAM_HUMAN] + pl.GreencoinsGained[TEAM_UNDEAD] then
					Nitwits.GreencoinChamp = pl
				end
			elseif pl.GreencoinsGained[TEAM_HUMAN] + pl.GreencoinsGained[TEAM_UNDEAD] > 0 then
				Nitwits.GreencoinChamp = pl
			end
			
			if Nitwits.BrutalChamp then
				if Nitwits.BrutalChamp.DamageDealt[TEAM_HUMAN] + pl.DamageDealt[TEAM_UNDEAD] < pl.DamageDealt[TEAM_HUMAN] + pl.DamageDealt[TEAM_UNDEAD] then
					Nitwits.BrutalChamp = pl
				end
			elseif pl.DamageDealt[TEAM_HUMAN] + pl.DamageDealt[TEAM_UNDEAD] > 0 then
				Nitwits.BrutalChamp = pl
			end
			
			if Nitwits.HelpfulChamp then
				if Nitwits.HelpfulChamp.HealingDone + Nitwits.HelpfulChamp.Assists < pl.HealingDone + pl.Assists then
					Nitwits.HelpfulChamp = pl
				end
			elseif pl.HealingDone + pl.Assists > 0 then
				Nitwits.HelpfulChamp = pl
			end
			
			if Nitwits.UnhappyChamp then
				if Nitwits.UnhappyChamp:Deaths() < pl:Deaths() then
					Nitwits.UnhappyChamp = pl
				end
			elseif pl:Deaths() > 0 then
				Nitwits.UnhappyChamp = pl
			end
			
			if Nitwits.Lasthuman then
				if pl.LastHumanTime and pl.LastHumanTime > Nitwits.Lasthuman.LastHumanTime then
					Nitwits.Lasthuman = pl
				end
			elseif pl.LastHumanTime then
				Nitwits.Lasthuman = pl
			end
		end
	end
	
	//See what player has more than 1 nitwit achieved
	local currentpl, iIndex = 0, {}
	for k,pl in pairs (Nitwits) do
		if pl then
			local Name = pl:Name()
			if not iIndex[ Name ] then
				iIndex[ Name ] = {
					Index = 0,
					HasTakenGC = false,
				}
			end
			
			local currentpl = pl
			for i, j in pairs (Nitwits) do
				if j then
					if currentpl == j then
						iIndex[ Name ].Index = iIndex[ Name ].Index + 1
						
						// Give the player with more than 2 achievments 5 greencoins
						if iIndex[ Name ].Index > 1 and not iIndex[ Name ].HasTakenGC then
							j:GiveGreenCoins ( 5 )
							iIndex[ Name ].HasTakenGC = true
						end
					end
				end
			end
		end
	end	
	
	umsg.Start("RcTopNitwits",to)
		if Nitwits.ScaryChamp then
			umsg.String (Nitwits.ScaryChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.HornyChamp then 
			umsg.String (Nitwits.HornyChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.UnhappyChamp then
			umsg.String (Nitwits.UnhappyChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.BrutalChamp then
			umsg.String (Nitwits.BrutalChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.PropChamp then
			umsg.String (Nitwits.PropChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.Lasthuman then
			umsg.String (Nitwits.Lasthuman:Name())
		else
			umsg.String ("")
		end
		if Nitwits.HeadshotChamp then
			umsg.String (Nitwits.HeadshotChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.HelpfulChamp then
			umsg.String (Nitwits.HelpfulChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.MeleeChamp then
			umsg.String (Nitwits.MeleeChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.FirstRedeemChamp then
			umsg.String (Nitwits.FirstRedeemChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.GreencoinChamp then
			umsg.String (Nitwits.GreencoinChamp:Name())
		else
			umsg.String ("")
		end
		if Nitwits.HungryZombieChamp then
			umsg.String (Nitwits.HungryZombieChamp:Name())
		else
			umsg.String ("")
		end
	umsg.End()
end

/*--------------------------------------------------------
     Receive the chosen map from the client
--------------------------------------------------------*/
local VotePointTable = {}
for i = 1,3 do
	VotePointTable[i] = 0
end

function GetChosenMap( pl, cmd, args )
	if args[1] == nil then return end
	if not ValidEntity ( pl ) then return end
	
	-- Update server and client votepoints
	UpdateClientVotePoints ( pl, tonumber (args[1]) )
end
concommand.Add ("VoteAddMap",GetChosenMap)

/*---------------------------------------------------------
  Update client and server vote points for maps
---------------------------------------------------------*/
function UpdateClientVotePoints ( pl, slot )
	if pl.Voted then return end

	//Voted
	VotePointTable[slot] = VotePointTable[slot] + 1 
	pl.Voted = true
	
	--- Send the change to all players
	umsg.Start ("RecVoteChange", to)
		for i = 1,3 do
			umsg.Short ( VotePointTable[i] )
		end
	umsg.End()
	
	--Send the automatic vote result
	umsg.Start ("RecAutomaticVoteResult", pl)
		umsg.Short ( slot )
	umsg.End()
end

/*---------------------------------------------------------
	Proper Server to client votemap 
	       update for one player
---------------------------------------------------------*/
function UpdateClientVoteMaps ( pl )
	if not ValidEntity ( pl ) then return end
	
	--- Send the change to pl
	umsg.Start ("RecVoteChange", pl)
		for i = 1,6 do
			umsg.Short ( VotePointTable[i] )
		end
	umsg.End()
end	
	
/*---------------------------------------------------------
	    Main Endgame Function
---------------------------------------------------------*/
function GM:OnEndRound ( winner )
	if ENDROUND then return end
	ENDROUND = true
	ENDTIME = CurTime()
	WinnerMap = ""
	
	// logging
	log.WorldAction("Round_End")
	
	if (winner == TEAM_UNDEAD) then
		log.WorldAction("Undead_Win")
	elseif (winner == TEAM_HUMAN) then
		log.WorldAction("Survivor_Win")
	end
	
	hook.Remove("SetupPlayerVisibility", "AddCratesToPVS")
	
	//Enable all talk
	RunConsoleCommand ( "sv_alltalk", "1" )
	
	//Stop NPCs attacking humans
	for k,npc in pairs ( ents.GetAll() ) do 
		if npc:IsNPC() or npc:GetClass() == "npc_maker" then
			npc:Remove()
		end
	end
	
	-- Get nextmap in case voting fails
	local NextMap = GAMEMODE:GetMapNext()
	
	timer.Simple(VOTE_TIME, function()
		for k,pl in pairs (player.GetAll()) do
			if pl:Team() != TEAM_SPECTATOR then
				if not pl.Voted then
					UpdateClientVotePoints ( pl, math.random (1,3) )
					pl:SendLua ("MySelf.VoteAlready = true")
				end
			end
		end
		
		--- Calculate the map with most points
		local MaximumPoint = -100
		WinnerMap = ""
		
		for k,v in ipairs (VotePointTable) do
			local CurrentPoint = v
			if CurrentPoint > MaximumPoint then
				MaximumPoint = CurrentPoint
				WinnerMap = VoteMaps[k][1]
				WinnerMapName = VoteMaps[k][2]
				NextMap = WinnerMap
			end
		end
		
		--Send the map name to client
		if NextMap == nil then NextMap = "zs_noir" WinnerMap = "zs_noir" end
		gmod.BroadcastLua( "SetWinnerMap( '"..WinnerMap.."','"..WinnerMapName.."' )" )
	end)
		
	-- Change level after intermission time runs out
	timer.Simple(INTERMISSION_TIME, function()
		//RunConsoleCommand( "changelevel", NextMap )
		game.ConsoleCommand("changelevel "..NextMap.."\n");
	end)
	
	//timer.Simple(INTERMISSION_TIME+40, function()
	//	RunConsoleCommand( "changelevel", "zs_please" )
	//end)
	
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
				
			-- For the last 2 levels, the second achievment is to survive.
			if team.NumPlayers (TEAM_HUMAN) + team.NumPlayers(TEAM_UNDEAD) > 11 then
			--[[	if not pl:IsBot() then
					if pl:Alive() and pl:GetTableScore(string.lower(HumanClasses[pl:GetHumanClass()].Name),"achlevel4_2") < 150 and pl:GetTableScore(string.lower(HumanClasses[pl:GetHumanClass()].Name),"level") == 4 then
						pl:AddTableScore(string.lower(HumanClasses[pl:GetHumanClass()].Name),"achlevel4_2",1)
					elseif pl:Alive() and pl:GetTableScore(string.lower(HumanClasses[pl:GetHumanClass()].Name),"achlevel4_2") < 300 and pl:GetTableScore(string.lower(HumanClasses[pl:GetHumanClass()].Name),"level") == 5 then
						pl:AddTableScore(string.lower(HumanClasses[pl:GetHumanClass()].Name),"achlevel4_2",1)
					end
					pl:CheckLevelUp()
				end]]
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
	GAMEMODE:SendTopNitwits()
	GAMEMODE:SendVotemaps()
	GAMEMODE:SendTopGreencoins()
	GAMEMODE:SendTopHealing ()
	GAMEMODE:SendTopAssists ()
	GAMEMODE:SendTopZombiesKilled ()
	GAMEMODE:SendGreencoinsGained ()
	GAMEMODE:SendMostChosenClass ()
	
	--MapExploitWrite()
	--Send the information to the player that joined in the intermission
	hook.Add("PlayerReady", "LateJoin", function ( pl )
		--Send all the info the that late join player
		GAMEMODE:SendTopTimes(pl)
		GAMEMODE:SendTopZombies(pl)
		GAMEMODE:SendTopHumanDamages(pl)
		GAMEMODE:SendTopZombieDamages(pl)
		GAMEMODE:SendTopNitwits(pl)
		GAMEMODE:SendVotemaps(pl)
		GAMEMODE:SendTopGreencoins(pl)
		GAMEMODE:SendTopHealing (pl)
		GAMEMODE:SendTopAssists (pl)
		GAMEMODE:SendTopZombiesKilled (pl)
		GAMEMODE:SendGreencoinsGained (pl)
		GAMEMODE:SendMostChosenClass (pl)
		
		--Delay this so it doesn't give errors
		timer.Simple(0.2, function() 
			if ValidEntity ( pl ) then
				local TimeLeft = INTERMISSION_TIME - ( CurTime() - ENDTIME )
				pl:SendLua( "Intermission('"..GAMEMODE:GetMapNext().."', "..ROUNDWINNER..", "..TimeLeft.." )" )
				
				--Update his votemaps
				UpdateClientVoteMaps ( pl )
				if TimeLeft < INTERMISSION_TIME - VOTE_TIME then
					pl:SendLua ( "SetWinnerMap( '"..WinnerMap.."' )" )
					pl:SendLua ( "MySelf.VoteAlready = true" )
				end
				
				timer.Simple (0.4, function()
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
		pl:DrawViewModel ( false )
		
		--Lock the player and make him unable to spawn
		pl.NextSpawnTime = 100
		pl:Lock()
	
		if pl.DamageDealt then
			if pl.DamageDealt[TEAM_HUMAN] then
				DamageUndead = DamageUndead + pl.DamageDealt[TEAM_HUMAN]
			end
			if pl.DamageDealt[TEAM_UNDEAD] then
				DamageHuman = DamageHuman + pl.DamageDealt[TEAM_UNDEAD]
			end
		end
		
		//Saving data/stats over time
		timer.Simple( _ * ( ( INTERMISSION_TIME - 3 ) / playerCount ), function()
			if not IsValid( pl ) then
				return 
			end
			
			//Most stats/class data
			local time1 = os.time()
				pl:WriteDataSQL()
			local time2 = os.time()
			Debug( "[SQL] Saved sql data for "..tostring( pl ).." in "..tostring( time2 - time1 ) )
		
			//Greencoins
			local time1 = os.time()
				pl:SaveGreenCoins()
			local time2 = os.time()
			Debug( "[SQL] Saved GC data for "..tostring( pl ).." in "..tostring( time2 - time1 ) )
		end )
	end
end

Debug ( "[MODULE] Loaded End-Round file." )