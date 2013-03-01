-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include ("sv_director_supply.lua")
include ("sv_director_vote.lua")
include ("sv_director_titles.lua")
//include ("sv_director_rewards.lua")

/*---------------------------------------------------------
   Event Director - Unlife/ Last human/ Endround
---------------------------------------------------------*/
function ManageEvents()

	//Case 1: End the game if the time has passed
	if ROUNDTIME < CurTime() and not ENDROUND then
		if not ENDROUND then
			if OBJECTIVE then
				gamemode.Call( "OnEndRound", TEAM_UNDEAD )
			else
				gamemode.Call( "OnEndRound", TEAM_HUMAN )
			end
		end
	end
	
	//Case 2: Start lasthuman mode if undead > 2 and human = 1
	if team.NumPlayers( TEAM_HUMAN ) == 1 and team.NumPlayers( TEAM_UNDEAD ) > 2 then
		GAMEMODE:LastHuman()
	end
	
	//Case 3: End round if undead more than 1 and no humans
	if team.NumPlayers( TEAM_HUMAN ) == 0 and team.NumPlayers( TEAM_UNDEAD ) > 1 then
		if not ENDROUND then
			gamemode.Call( "OnEndRound", TEAM_UNDEAD )
		end
	end
	
	//Case 4: Enable unlife if infliction more than 60%
	if GetInfliction() >= 0.6 then
		GAMEMODE:SetUnlife ( true )
	end
	
	//Less people, enable Deadlife
	if GetInfliction() >= 0.75 then
		DEADLIFE = true
	end
end
--hook.Add ( "Think", "EventDirector", ManageEvents )

/*---------------------------------------------------
      Update server and clients with unlife
----------------------------------------------------*/
function GM:SetUnlife ( bool )
	if UNLIFE == bool then return end
	
	UNLIFE = not UNLIFE
	gmod.BroadcastLua( "GAMEMODE:SetUnlife("..tostring( bool )..")" )
end

/*---------------------------------------------------------
   Selects a zombie to lead the undead army
	        (ticks every 5 seconds)
---------------------------------------------------------*/
local iNoticeTime = 0
local bCheckFZombies
function CheckFirstZombie ()
	if CurTime() < FIRST_ZOMBIE_SPAWN_DELAY then return end
	if ENDROUND or team.NumPlayers ( TEAM_UNDEAD ) >= 5 then return end
	--poor 2 zombies at the round start :o
	if (team.NumPlayers( TEAM_UNDEAD ) < 2 and team.NumPlayers( TEAM_HUMAN ) >= 5) then
		bCheckFZombies = true
	elseif (team.NumPlayers( TEAM_UNDEAD ) < 3 and team.NumPlayers( TEAM_HUMAN ) >= 13) then
		bCheckFZombies = true
	elseif (team.NumPlayers( TEAM_UNDEAD ) < 5 and team.NumPlayers( TEAM_HUMAN ) >= 25) then
		bCheckFZombies = true
	elseif (team.NumPlayers( TEAM_UNDEAD ) < 6 and team.NumPlayers( TEAM_HUMAN ) >= 30) then
		bCheckFZombies = true
	elseif (team.NumPlayers( TEAM_UNDEAD ) < 7 and team.NumPlayers( TEAM_HUMAN ) >= 35) then
		bCheckFZombies = true
	else
		bCheckFZombies = false
	end
	
	if bCheckFZombies then --balance, balance, balance
		local tbHumans = team.GetPlayers( TEAM_HUMAN )
		
		//Randomize the random
		local Zombie = table.Random ( tbHumans )
		for i = 1, #tbHumans do
			if math.random ( 1,2 ) == 1 then 
				Zombie = table.Random ( tbHumans )
				if math.random ( 1,4 ) == 1 then break end 
			end
		end		
		
		if not Zombie.FreshRedeem then
			Zombie:SetFirstZombie()
		end
		
		//Notice
		if iNoticeTime <= CurTime() then
			for k,v in pairs ( player.GetAll() ) do
				if IsEntityValid ( v ) then
					v:Message( "The undead have arrived and they're hungry for your fresh flesh! Braaiinnns!", 1, "255,255,255,255" )
					v:ChatPrint( "The undead have arrived and they're hungry for your fresh flesh! Braaiinnns!" )
				end
			end
			
			iNoticeTime = CurTime() + 10
		end
	end
end
--timer.Create ( "CheckFirstZombie", 5, 0, CheckFirstZombie )

/*------------------------------------------------------------
	       Zombie unlock classes Director 
-------------------------------------------------------------*/
function UnlockZombieClassesThink()
	if ENDROUND then return end
	
	// Infliction and threshold table
	local Infliction = GetInfliction()
	local ThresTable = { [1] = { Min = 0, Max = 0.3 }, [2] = { Min = 0.3, Max = 0.4 } ,[3] = { Min = 0.4, Max = 0.5 }, [4] = { Min = 0.5, Max = 0.75 }, [5] = { Min = 0.75, Max = 1 } }
	
	// Check the current infliction
	for k,v in pairs (ThresTable) do
		if Infliction <= ThresTable[k].Max and Infliction > ThresTable[k].Min then
			Thres = k - 1
		end	
	end
	
	// Lock/unlock the class
	for i=1, #ZombieClasses do
		if ZombieClasses[i] then
			if ( ( ZombieClasses[i].Threshold <= Thres ) or ( ZombieClasses[i].TimeLimit and ZombieClasses[i].TimeLimit < CurTime() ) ) and not ZombieClasses[i].Unlocked then
				ZombieClasses[i].Unlocked = true
			end
		end
	end
end
--timer.Create ( "UnlockZombies", 1, 0, UnlockZombieClassesThink )

local GAMECHECKTIMER = 5 

//Drop points table
DropPointsX = {}
DropPointsY = {}
DropPointsZ = {}

/*-------------------------------------------
	   Main Director Function 
--------------------------------------------*/
local Check = false
local function CheckGame()
	if ENDROUND then return end

	//We have no weapon spawn points
	if table.Count( DropPointsX ) == 0 then if not Check then Debug ( "[DIRECTOR] WARNING: NO WEAPON DROP POINTS FOUND FOR THIS MAP!" ) Check = true end return end
	
	//No players, normal difficulty
	if team.NumPlayers( TEAM_HUMAN ) == 0 and team.NumPlayers( TEAM_UNDEAD ) == 0 then return end
	
	//Stats about the game
	local Infliction, Difficulty = GetInfliction(), 0, 0
	
	//For the moment
	Difficulty = GAMEMODE:CalculateDifficulty()
	difficulty = Difficulty
end
//timer.Create( "DirectorCheck", GAMECHECKTIMER, 0, CheckGame )


function GM:AllowPlayerPickup( pl, ent)
	return false
end


function SetTurretName(pl, command, args)
	if not args[1] then return end
	if not ValidTurretNick(pl,tostring(args[1])) then 
		return 
	end
	if ValidEntity(pl.Turret) then
		//pl.Turret:SetNWString("TurretName",tostring(args[1]))
		pl.Turret:SetDTString(0,tostring(args[1]))
	end
end
concommand.Add("turret_nickname",SetTurretName)

function GM:UpdateObjStageOnClients(pl)
	
	umsg.Start("UpdateObjStage",pl)
		umsg.Short(self:GetObjStage())
	umsg.End()
	
end

function CheckObjSpawnpoints()

	if not OBJECTIVE then return end
	if #Objectives < 0 then return end
	
	if not Objectives[GAMEMODE:GetObjStage()].VerifiedSpawns then
		
		GAMEMODE.UndeadSpawnPoints = {}
		print("Cleared spawns")
		Objectives[GAMEMODE:GetObjStage()].ZombieSpawns()
		print("Loaded new")
		
		for k,v in pairs ( SpawnPoints ) do
			GAMEMODE.UndeadSpawnPoints[k] = { [1] = v[1], [2] = v[2] }
		end
		print("Done")
		Objectives[GAMEMODE:GetObjStage()].VerifiedSpawns = true
	
	end

end
//hook.Add("Think","CheckObjSpawnpoints",CheckObjSpawnpoints)


function GM:HandleObjEnts()
	
	--Apply filter for obj entities, so zombies wont be able to harm them
	print("Messing with objects")
	if #Objectives.Entities > 0 then
		for _, ent in pairs(Objectives.Entities) do
			for _,objent in pairs ( ents.GetAll() ) do
				if objent:GetKeyValues().targetname and string.find(objent:GetKeyValues().targetname,ent) then
					objent.IsObjEntity = true
				end
			end
		end
	end
	
	--Apply output hooks to triggers, so we an track objectives (Thanks to Clavus :D)
	if #Objectives > 0 then
	print("Messing with objectives")
		for i=1, #Objectives do
			print("Doing stage "..i)
			if Objectives[i].Trigger and Objectives[i].TriggerOutputHook then
				print("Confirmed stage "..i)
				for _,objent in pairs ( ents.GetAll() ) do
					if objent:GetKeyValues().origin == Objectives[i].Trigger then
						print("Doing entity "..tostring(objent))
						objent:HookOutput(Objectives[i].TriggerOutputHook, "Objective"..tostring(v), function(self,activator,data) 
																										if Objectives[i].TriggerOutputFunction then 
																											Objectives[i].TriggerOutputFunction() 
																										end 
																										//hacky way how to check if one of few stages were bypassed
																										if GAMEMODE:GetObjStage() != math.Clamp(i-1,1,#Objectives) then
																											GAMEMODE:SetObjStage(i)
																										else
																											GAMEMODE:NextObjStage() 
																										end
																										
																									  end)
					end
				end
			elseif Objectives[i].TriggerOutputHook and Objectives[i].TriggerTargetName then
				print("Confirmed stage "..i)
				for _,objent in pairs ( ents.GetAll() ) do
					if objent:GetKeyValues().targetname == Objectives[i].TriggerTargetName then
						print("Doing entity "..tostring(objent))
						objent:HookOutput(Objectives[i].TriggerOutputHook, "Objective"..tostring(v), function(self,activator,data) 
																										if Objectives[i].TriggerOutputFunction then 
																											Objectives[i].TriggerOutputFunction() 
																										end 
																										if GAMEMODE:GetObjStage() != math.Clamp(i-1,1,#Objectives) then
																											GAMEMODE:SetObjStage(i)
																										else
																											GAMEMODE:NextObjStage() 
																										end
																										
																									  end)
					end
				end
				
			end
		end
	end

end

function FindTriggers(p, cmd, arg)
	for _,v in pairs (ents.FindByClass("trigger_*")) do
			print("------------")
			print("Entity "..tostring(v))
			PrintTable(v:GetKeyValues())
	end
	--[[for _,v in pairs (ents.FindByClass("logic_*")) do
			print("------------")
			print("Entity "..tostring(v))
			PrintTable(v:GetKeyValues())
	end
	for _,v in pairs (ents.FindByClass("math_*")) do
			print("------------")
			print("Entity "..tostring(v))
			PrintTable(v:GetKeyValues())
	end
	for _,v in pairs (ents.FindByClass("game_*")) do
			print("------------")
			print("Entity "..tostring(v))
			PrintTable(v:GetKeyValues())
	end
	
	for _,v in pairs (ents.GetAll()) do
		for k,key in pairs(v:GetKeyValues()) do
			if string.find(key,"truc") then
				print("------------")
				print("Entity "..tostring(v))
				PrintTable(v:GetKeyValues())
				break
			end
		end
	end]]
	
end
--concommand.Add( "findtriggers", FindTriggers ) 


Debug ( "[MODULE] Loaded the Main Director." )
