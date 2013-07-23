-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include ("sv_director_supply.lua")
include ("sv_director_vote.lua")
include ("sv_director_titles.lua")
-- include ("sv_director_rewards.lua")

GAMEACTIVE = false

--[==[---------------------------------------------------------
   Event Director - Unlife/ Last human/ Endround
---------------------------------------------------------]==]
function ManageEvents()
	--End game if the time has passed
	if ServerTime() > ROUNDTIME and not ENDROUND then
		if OBJECTIVE then
			GAMEMODE:OnEndRound(TEAM_UNDEAD)
		else
			GAMEMODE:OnEndRound(TEAM_HUMAN)
		end
	end
	
	--Start LastHuman mode if undead > 2 and human = 1
	if team.NumPlayers(TEAM_HUMAN) == 1 and team.NumPlayers(TEAM_UNDEAD) > 2 and not LASTHUMAN and not ENDROUND then
		GAMEMODE:LastHuman()
	end
	
	--End round if undead are more than 1 and no humans
	if team.NumPlayers(TEAM_HUMAN) == 0 and team.NumPlayers(TEAM_UNDEAD) > 1 and not ENDROUND then
		GAMEMODE:OnEndRound(TEAM_UNDEAD)
	end
	
	--Enable unlife if infliction is more than 80%
	if GetInfliction() >= 0.8 and not ENDROUND then
		GAMEMODE:SetUnlife(true)
	end
	
	--Enable HalfLife halfway
	if GetInfliction() >= 0.5 and not ENDROUND then
		GAMEMODE:SetHalflife(true)
	end

	--Pick random zombie(s) if there aren't any
	if team.NumPlayers(TEAM_UNDEAD) == 0 and team.NumPlayers(TEAM_HUMAN) > 3 and not ENDROUND and GAMEACTIVE then
		GAMEMODE:SetRandomsToFirstZombie()
		Debug("[DIRECTOR] There were no zombies. Fixed it")
	end
	
	--Check warming up time
	if CurTime() > WARMUPTIME and not GAMEACTIVE and not ENDROUND then
		GAMEACTIVE = true
		GAMEMODE:SetRandomsToFirstZombie()

		--Give SkillPoints to survivors timer
		timer.Create("GiveSkillPointsSurvivors", math.Round(ROUNDTIME/6), 0, GiveSkillPointsSurvivors)

		--
		for k,v in pairs(team.GetPlayers(TEAM_HUMAN)) do
			if IsEntityValid(v) then
				v:SendLua("surface.PlaySound(\"ambient/creatures/town_zombie_call1.wav\") GAMEMODE:Add3DMessage(140,\"The Undead have arrived!\",nil,\"ArialBoldTwelve\") GAMEMODE:Add3DMessage(140,\"They are hungry for your fresh flesh!\",nil,\"ArialBoldTen\")")
			end
		end
	end
end
--hook.Add("Think", "EventDirector", ManageEvents)
timer.Create("ManageEvents", 0.2, 0, ManageEvents)

--Timer creator is at ManageEvents
function GiveSkillPointsSurvivors()
	--Give skillpoints to all players for still being alive
	for _, h in pairs(team.GetPlayers(TEAM_HUMAN)) do
		if h and h:IsValid() and h:Alive() then
			--Give SP
			skillpoints.AddSkillPoints(h,175*GetInfliction())

			--Give XP
			h:AddXP(200*GetInfliction())
		end
	end
end

--[==[---------------------------------------------------
      Update server and clients with unlife
----------------------------------------------------]==]
function GM:SetUnlife(bool)
	if UNLIFE == bool then
		return
	end

	UNLIFE = not UNLIFE

	if bool then
		if GAMEMODE:IsBossRequired() then
			bossPlayer = GAMEMODE:GetPlayerForBossZombie()
			if bossPlayer then
				bossPlayer:SpawnAsZombieBoss()
			end
			
			for _, pl in pairs(player.GetAll()) do
				if pl:Team() == TEAM_HUMAN and pl:Alive() then
					if ARENA_MODE then
						local hp = 100
						if pl:GetPerk("_kevlar") then
							hp = 110
						end
						
						if pl:GetPerk("_kevlar2") then
							hp = 120
						end
						
						pl:SetHealth(hp)
					end
				end
			end
		end
	end
	
	gmod.BroadcastLua( "GAMEMODE:SetUnlife("..tostring( bool )..")" )
end


function GM:SetHalflife(bool)
	if HALFLIFE == bool then return end

	HALFLIFE = not HALFLIFE

	gmod.BroadcastLua( "GAMEMODE:SetHalflife("..tostring( bool )..")" )
end

--[==[------------------------------------------------------------
	       Zombie unlock classes Director 
-------------------------------------------------------------]==]
function UnlockZombieClassesThink()
	if ENDROUND then return end
	
	--  Infliction and threshold table
	local Infliction = GetInfliction()
	local ThresTable = { [1] = { Min = 0, Max = 0.3 }, [2] = { Min = 0.3, Max = 0.4 } ,[3] = { Min = 0.4, Max = 0.5 }, [4] = { Min = 0.5, Max = 0.75 }, [5] = { Min = 0.75, Max = 1 } }
	
	--  Check the current infliction
	for k,v in pairs (ThresTable) do
		if Infliction <= ThresTable[k].Max and Infliction > ThresTable[k].Min then
			Thres = k - 1
		end	
	end
	
	--  Lock/unlock the class
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

-- Drop points table
DropPointsX = {}
DropPointsY = {}
DropPointsZ = {}

--[==[-------------------------------------------
	   Main Director Function 
--------------------------------------------]==]
local Check = false
local function CheckGame()
	if ENDROUND then return end

	-- We have no weapon spawn points
	if table.Count( DropPointsX ) == 0 then if not Check then Debug ( "[DIRECTOR] WARNING: NO WEAPON DROP POINTS FOUND FOR THIS MAP!" ) Check = true end return end
	
	-- No players, normal difficulty
	if team.NumPlayers( TEAM_HUMAN ) == 0 and team.NumPlayers( TEAM_UNDEAD ) == 0 then return end
	
	-- Stats about the game
	local Infliction, Difficulty = GetInfliction(), 0, 0
	
	-- For the moment
	Difficulty = GAMEMODE:CalculateDifficulty()
	difficulty = Difficulty
end
-- timer.Create( "DirectorCheck", GAMECHECKTIMER, 0, CheckGame )


function GM:AllowPlayerPickup( pl, ent)
	return false
end


function SetTurretName(pl, command, args)
	if not args[1] then return end
	if not ValidTurretNick(pl,tostring(args[1])) then 
		return 
	end
	if ValidEntity(pl.Turret) then
		-- pl.Turret:SetNWString("TurretName",tostring(args[1]))
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
-- hook.Add("Think","CheckObjSpawnpoints",CheckObjSpawnpoints)


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
																										-- hacky way how to check if one of few stages were bypassed
																										if GAMEMODE:GetObjStage() ~= math.Clamp(i-1,1,#Objectives) then
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
																										if GAMEMODE:GetObjStage() ~= math.Clamp(i-1,1,#Objectives) then
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
	--[=[for _,v in pairs (ents.FindByClass("logic_*")) do
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
	end]=]
	
end
--concommand.Add( "findtriggers", FindTriggers ) 


Debug ( "[MODULE] Loaded the Main Director." )
