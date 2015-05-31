-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("sv_director_difficulty.lua")
include("sv_director_supply.lua")
include("sv_director_vote.lua")
include("sv_director_titles.lua")
include("sv_director_boss.lua")
include("sv_director_heal_undead.lua")
include("sv_director_heal_human.lua")

GAMEACTIVE = false
--[==[---------------------------------------------------------
   Event Director - Last human/ Endround
---------------------------------------------------------]==]
local function ManageEvents()
	--Stuff followed up by this is only needed when round hasn't ended
	if ENDROUND then
		return
	end
	
	--Check warmup time
	if not GAMEACTIVE then
		if CurTime() > WARMUPTIME then
			--Set active
			GAMEACTIVE = true
			
			--Assign random zombies
			--GAMEMODE:SetRandomsToFirstZombie()
			GAMEMODE:UpdateHumanTable()			
			GAMEMODE:SetRandomsToZombie() --Picks Humans closes to Z spawn or then random players..

			--Give SkillPoints to survivors timer
			timer.Create("GiveSkillPointsSurvivors", math.Round(ROUNDTIME/15), 0, GiveSkillPointsSurvivors)

			--
			local Survivors = team.GetPlayers(TEAM_HUMAN)
			for i=1, #Survivors do
				local pl = Survivors[i]
				if not IsValid(pl) then
					continue
				end

				pl:SendLua("surface.PlaySound(Sound(\"npc/fast_zombie/fz_alert_far1.wav\")) GAMEMODE:Add3DMessage(100,\"They come!\",nil,\"ArialBoldTwelve\")")
			end

			Debug("[DIRECTOR] Game is now active")
		end
		
		return
	end

	local numSurvivors = team.NumPlayers(TEAM_HUMAN)
	local numUndead = team.NumPlayers(TEAM_UNDEAD)
	
	--End game if the time has passed
	if CurTime() > ROUNDTIME then
		if OBJECTIVE then
			Debug("[DIRECTOR] End-time reached. Undead win.")
			GAMEMODE:OnEndRound(TEAM_UNDEAD)
		else
			Debug("[DIRECTOR] End-time reached. Survivors win.")
			GAMEMODE:OnEndRound(TEAM_HUMAN)
		end
	end
	
	if numSurvivors == 1 and numUndead > 2 and not LASTHUMAN then
		Debug("[DIRECTOR] Started Last Human")
		GAMEMODE:LastHuman()
	--End round if undead are more than 1 and no humans
	elseif numSurvivors == 0 and numUndead > 1 then
		Debug("[DIRECTOR] All survivors dead. Undead win.")
		GAMEMODE:OnEndRound(TEAM_UNDEAD)
	end

		GAMEMODE:CheckBoss()		


	--Pick random zombie(s) if there aren't any
	if numUndead == 0 and numSurvivors >= 5 then
		--GAMEMODE:SetRandomsToFirstZombie()
		GAMEMODE:SetRandomsToZombie()
		Debug("[DIRECTOR] There were no zombies. Setting randoms")
	end
	
	
	
end
timer.Create("ManageEvents", 0.5, 0, ManageEvents)


local function ManageMinorEvents()
	if ENDROUND or not GAMEACTIVE then
		return
	end

	GAMEMODE:CalculateInfliction()

	--
	GAMEMODE:CalculateInitialDifficulty()
end
timer.Create("ManageMinorEvents", 5, 0, ManageMinorEvents)

--Timer creator for this function is at ManageEvents
function GiveSkillPointsSurvivors()
	--Give skillpoints to all players for still being alive
	local Survivors = team.GetPlayers(TEAM_HUMAN)
	for i=1, #Survivors do
		local pl = Survivors[i]
		if not IsValid(pl) or not pl:Alive() then
			continue
		end

		--Give SP
		skillpoints.AddSkillPoints(pl, 10)

		--Give XP
		pl:AddXP(30)
	end
end

--TODO: Move this out of here
function GM:AllowPlayerPickup(pl, ent)
	return false
end

function SetTurretName(pl, command, args)
	if not args[1] then return end
	if not ValidTurretNick(pl,tostring(args[1])) then 
		return 
	end
	if IsValid(pl.Turret) then
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
	if not OBJECTIVE or #Objectives < 0 then
		return
	end
	
	if not Objectives[GAMEMODE:GetObjStage()].VerifiedSpawns then
		GAMEMODE.UndeadSpawnPoints = {}
		Debug("[DIRECTOR] Cleared spawns")
		Objectives[GAMEMODE:GetObjStage()].ZombieSpawns()
		Debug("[DIRECTOR] Loaded new")
		
		for k,v in pairs ( SpawnPoints ) do
			GAMEMODE.UndeadSpawnPoints[k] = { [1] = v[1], [2] = v[2] }
		end
		Debug("[DIRECTOR] Done")
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

function PrintEnts(p, cmd, arguments)
	--[[
	Examples:
		trigger_*
		logic_*
		math_*
		game_*
	]]
	print("------------")

	if not arguments[1] then
		for _,v in pairs (ents.GetAll()) do
			for k,key in pairs(v:GetKeyValues()) do
				print("Entity: "..tostring(v))
				PrintTable(v:GetKeyValues())
				print("------------")
			end
		end
	else
		for _,v in pairs (ents.FindByClass(arguments[1])) do
			print("Entity: "..tostring(v))
			PrintTable(v:GetKeyValues())
			print("------------")
		end
	end	
end
concommand.Add( "zs_printents", PrintEnts ) 


Debug("[MODULE] Loaded the Main Director")
