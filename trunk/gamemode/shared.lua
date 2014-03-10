-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information


--[[oldIsValid = IsValid

function IsValid( object )

	if ( not object ) then return false end
	if type(object) == "number" or type(object) == "string" or type(object) == "boolean" then 
		return false
	end
	return oldIsValid(object)

end]]

function IsValidSpecial( object )

	if ( not object ) then return false end
	if type(object) == "number" or type(object) == "string" or type(object) == "boolean" then 
		return false
	end
	return IsValid(object)

end




ValidEntity = IsValid
WorldSound = sound.Play
GetWorldEntity = game.GetWorld
SinglePlayer = game.SinglePlayer
MaxPlayers = game.MaxPlayers

--[=[---------------------------------------------------------
	     Include the shared files
---------------------------------------------------------]=]
include("shared/obj_player_extend.lua")
include("shared/obj_weapon_extend.lua")
include("shared/obj_entity_extend.lua")
include("shared/zs_options_shared.lua")
include("shared/sh_maps.lua")
include("shared/sh_animations.lua")
include("shared/sh_zombo_anims.lua")
include("extended/sh_engine.lua")

--Screentaker
include("modules/screentaker/screentaker.lua")

--Clavus' Ravebreak
include("modules/ravebreak/sh_ravebreak.lua")
	
--MapCoder
for map,opt in pairs(TranslateMapTable) do
	if TranslateMapTable[map].Objective then
		print("[MAPCODER] Included shared/objectivemaps/".. tostring(map) ..".lua")
		include("shared/objectivemaps/".. map ..".lua")
	end
	if TranslateMapTable[map].MapCoder then
		print("[MAPCODER] Included shared/maps/".. tostring(map) ..".lua")
		include("shared/maps/".. map ..".lua")
		if SERVER then
			AddCSLuaFile("shared/maps/".. map ..".lua")
		end
	end
end

--This stuff isn't for you to change. You should only edit the stuff in zs_options.lua
--GM.Name = "Zombie Survival "..GM.Version.." "..GM.SubVersion
GM.Name = "Zombie Survival Green Apocalypse"
GM.Author = "Limetric"
GM.Email = "info@limetric.com"
GM.Website = "www.limetric.com"

INFLICTION = 0

-- Spawn prediction
PREDICT_SPAWN, PREDICT_SPAWN_END = 50, 10

-- Death prediction
PREDICT_DEATH, PREDICT_DEATH_END = 55, 12

-- Damage predicting
PREDICT_DAMAGE, PREDICT_DAMAGE_END = 15,33

TEAM_ZOMBIE = 3
TEAM_UNDEAD = TEAM_ZOMBIE
TEAM_SURVIVORS = 4
TEAM_HUMAN = TEAM_SURVIVORS
TEAM_SPECTATOR = 0

-- Setup teams
team.SetUp( TEAM_ZOMBIE, "The Undead", Color(0, 255, 0) )
team.SetUp( TEAM_SURVIVORS, "Survivors", Color(0, 160, 255) )
team.SetUp( TEAM_SPECTATOR, "Connecting", Color(128, 155, 21, 255) )

-- Initialize team tags for log
if SERVER then
	log.InitializeTeamBased( {TEAM_ZOMBIE, "Undead", TEAM_SURVIVORS, "Survivor"} )
end

HumanGibs = {"models/gibs/HGIBS.mdl",
"models/gibs/HGIBS_spine.mdl",
"models/gibs/HGIBS_rib.mdl",
"models/gibs/HGIBS_scapula.mdl",
"models/gibs/antlion_gib_medium_2.mdl",
"models/gibs/Antlion_gib_Large_1.mdl",
"models/gibs/Strider_Gib4.mdl"
}


HumanTorsos = {
"models/Gibs/Fast_Zombie_Torso.mdl",
"models/Zombie/Classic_torso.mdl",
"models/Humans/Charple03.mdl"
}

HumanLegs = {
"models/Zombie/Classic_legs.mdl",
"models/Gibs/Fast_Zombie_Legs.mdl"
}

for i=2, 4 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end

for i=1,3 do
	util.PrecacheSound("physics/metal/metal_box_impact_bullet"..i..".wav")
end
for i=1,2 do
	util.PrecacheSound("npc/zombine/zombine_charge"..i..".wav")
end
for i=1,5 do
	util.PrecacheSound("weapons/fx/rics/ric"..i..".wav")
end

util.PrecacheSound("ambient/energy/whiteflash.wav")

for k, v in pairs(HumanGibs) do
	util.PrecacheModel(v)
end

for k, v in pairs( hats ) do
	for _,tbl in pairs(v) do
		if tbl.model then
			util.PrecacheModel(tbl.model)
		end
	end
end

for k, v in pairs( suits ) do
	for _,tbl in pairs(v) do
		if tbl.model then
			util.PrecacheModel(tbl.model)
		end
	end
end

-- Define footstep sounds
local tbFootSteps = { 
	[1] = { Sound ( "npc/zombie/foot1.wav" ), Sound ( "npc/zombie/foot2.wav" ), Sound ( "npc/zombie/foot3.wav" ) }, 
	[2] = { Sound ( "player/footsteps/ladder1.wav" ), Sound ( "player/footsteps/ladder2.wav" ), Sound ( "player/footsteps/ladder3.wav" ), Sound ( "player/footsteps/ladder4.wav" ) },
	[3] = { Sound ( "npc/zombine/gear1.wav" ), Sound ( "npc/zombine/gear2.wav" ), Sound ( "npc/zombine/gear3.wav" ),Sound ( "npc/zombie/foot1.wav" ), Sound ( "npc/zombie/foot2.wav" ) },-- zombine
	[4] = { Sound ( "npc/zombie_poison/pz_right_foot1.wav" ), Sound ( "npc/zombie_poison/pz_left_foot1.wav" ) },-- poison zombie
	[5] = { Sound ( "npc/fast_zombie/foot1.wav" ), Sound ( "npc/fast_zombie/foot2.wav" ), Sound ( "npc/fast_zombie/foot3.wav" ), Sound ( "npc/fast_zombie/foot4.wav" ) },-- fast zombie
	[6] = { Sound ( "npc/headcrab_poison/ph_step1.wav" ), Sound ( "npc/headcrab_poison/ph_step2.wav" ), Sound ( "npc/headcrab_poison/ph_step3.wav" ), Sound ( "npc/headcrab_poison/ph_step4.wav" ) },-- poison headcrab
	-- [11] = { Sound("physics/metal/metal_barrel_impact_hard5.wav"),Sound("physics/metal/metal_barrel_impact_hard6.wav")}
	[11] = { Sound("npc/strider/strider_step1.wav"),Sound("npc/strider/strider_step2.wav"),Sound("npc/strider/strider_step3.wav"),Sound("npc/strider/strider_step4.wav"),Sound("npc/strider/strider_step5.wav"),Sound("npc/strider/strider_step6.wav")}
}

--[[local tbFootSteps = { 
	[1] = { "Zombie.FootstepLeft","Zombie.FootstepRight" }, 
	[2] = { "Ladder.StepLeft","Ladder.StepRight" },
	[3] = { "NPC_CombineS.RunFootstepLeft", "NPC_CombineS.RunFootstepRight" },-- zombine
	[4] = { "NPC_PoisonZombie.FootstepLeft", "NPC_PoisonZombie.FootstepRight"},-- poison zombie
	[5] = { "NPC_FastZombie.FootstepLeft", "NPC_FastZombie.FootstepRight" },-- fast zombie
	[6] = { "NPC_BlackHeadcrab.Footstep", "NPC_BlackHeadcrab.Footstep" },-- poison headcrab
	[11] = { "NPC_Strider.Footstep","NPC_Strider.Footstep"}
}]]

for i=1, 6 do
	for _,snd in pairs(tbFootSteps[i]) do
		util.PrecacheSound( snd )
	end
end

-- Save what step type the player is running
local function StepSoundTime( pl, iType, bWalking )
	pl.Footstep = iType
end
hook.Add ( "PlayerStepSoundTime", "FootSteps", StepSoundTime )
	
if SERVER then
	function GM:PlayerFootstep(pl, vPos, iFoot, strSoundName, fVolume, pFilter)
	end
elseif CLIENT then
	function GM:PlayerFootstep( pl, pos, iFoot, sound, volume, rf ) 
	    if not pl:IsZombie() then
			return
		end
		
		-- Override for zombies
		if CLIENT then
			if not pl.iFootTime then
				pl.iFootTime = 0
			end

			if pl.iFootTime and pl.iFootTime > CurTime() then
				return true
			end
			
			local sSound
			local ftime
			
			-- Walk on something zombie footstep
			if pl:IsCommonZombie() or pl:GetZombieClass() == 0 or pl:GetZombieClass() == 14 then
				sSound = tbFootSteps[1][iFoot+1]
				ftime = 0.1
			elseif pl:IsZombine() then
				sSound = tbFootSteps[3][iFoot+1]
				ftime = 0.365
			elseif pl:IsPoisonZombie() then
				sSound = tbFootSteps[4][iFoot+1]
				ftime = 0.31-- 0.27
			elseif pl:IsFastZombie() then
				sSound = tbFootSteps[5][iFoot+1]
				ftime = 0.1
			elseif pl:IsPoisonCrab() then
				sSound = tbFootSteps[6][iFoot+1]
				ftime = 0.001
			elseif pl:GetZombieClass() == 10 then
				sSound = tbFootSteps[4][iFoot+1]
				ftime = 0.27
			elseif pl:GetZombieClass() == 11 then
				sSound = tbFootSteps[11][iFoot+1]
				ftime = math.Rand(0.4,0.6)
			else
				ftime = 0.1
			end
		
			
			if pl:Crouching() then
				ftime = ftime*2
			end
			
			-- Climbing
			if pl.Footstep and pl.Footstep == STEPSOUNDTIME_ON_LADDER then
				sSound = tbFootSteps[2][iFoot+1]
			end
			
			-- Play sound
			if sSound then
				pl:EmitSound( sSound ) pl.iFootTime = CurTime() + ftime
			end
		end

	    return true
	end	
end
	
-- Play footstep sounds for some zombies


util.PrecacheModel("models/props_debris/wood_board05a.mdl")

local util = util
local pairs = pairs
local file = file

for _,mdl in pairs (file.Find("models/player/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/"..mdl )
end

for _,mdl in pairs (file.Find("models/player/group01/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/group01/"..mdl )
end

for _,mdl in pairs (file.Find("models/player/group03/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/group03/"..mdl )
end

for _,mdl in pairs (file.Find("models/player/hostage/*.mdl","GAME")) do
	util.PrecacheModel( "models/player/hostage/"..mdl )
end

--[==[for k, v in pairs(suits) do
	for j, prop in pairs(v) do
		util.PrecacheModel( prop.model )
	end
end]==]

for k=1, #ZombieClasses do
	util.PrecacheModel( ZombieClasses[k].Model )
end

for k=1, #ZombieClasses do
	if ZombieClasses[k].PainSounds then
		for _,snd in pairs(ZombieClasses[k].PainSounds) do
			util.PrecacheSound( snd )
		end
	end
	if ZombieClasses[k].DeathSounds then
		for _,snd in pairs(ZombieClasses[k].DeathSounds) do
			util.PrecacheSound( snd )
		end
	end
	if ZombieClasses[k].IdleSounds then
		for _,snd in pairs(ZombieClasses[k].IdleSounds) do
			util.PrecacheSound( snd )
		end
	end
	if ZombieClasses[k].AttackSounds then
		for _,snd in pairs(ZombieClasses[k].AttackSounds) do
			util.PrecacheSound( snd )
		end
	end
	if ZombieClasses[k].AlertSounds then
		for _,snd in pairs(ZombieClasses[k].AlertSounds) do
			util.PrecacheSound( snd )
		end
	end
	
end

for k=1, #HumanClasses do
	for _, v in pairs(HumanClasses[k].Models) do
	--	util.PrecacheModel( v )
	end
end

-- Identifier for hat adjustment
TModels = {
	"models/player/arctic.mdl",
	"models/player/leet.mdl",
	"models/player/guerilla.mdl",
	"models/player/phoenix.mdl"
}
CTModels = {
	"models/player/gasmask.mdl",
	"models/player/riot.mdl",
	"models/player/swat.mdl",
	"models/player/urban.mdl"
}
CombineModels = {
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/police.mdl"
}

-- Initial variables
ENDROUND = false
HALFLIFE = false
UNLIFE = false
LASTHUMAN = false
BOSSACTIVE = false

VecRand = VectorRand

-- Hull types
HULL_PLAYER = { Vector ( -16, -16, 0 ), Vector ( 16, 16, 72 ), Vector ( 16, 16, 36 ) }
BIG_HULL = { Vector ( -32, -32, 0 ), Vector ( 32, 32, 72 ) }

function GM:GetGameDescription()
	return self.Name
end

function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )
	return false
end

function GM:PhysgunPickup( ply, ent )
	return true
end

function GM:GravGunPunt( ply, ent )
	return true	
end

-- Check if player title is valid
local validchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789><! "
local tbPatern = { "%", "&", "(", ")", "+", "]", "[", "?" }
local forbiddenwords = { "admin", "moderator", "host", "server", "fuck" }
function ValidTitle( pl, str )
	-- 24 character limit
	if not str then return false end
	if (string.len(str) > 24) then return false end
	
	-- Explode the string
	local tbText = string.Explode ( "", str )
	
	for k,v in pairs ( tbText ) do
		-- Workaround for pattersns
		for i,j in ipairs ( tbPatern ) do
			if v == j then 
				return false
			end
		end
		
		-- Normal mechanism
		if not string.find ( validchars, v ) then return false end
	end
	
	if not ( ( CLIENT and pl:IsAdmin() ) or ( SERVER and pl:IsAdmin() ) ) then
		for k, word in pairs(forbiddenwords) do
			if string.find( string.lower( str ),word ) then return false end
		end
	end
	
	return true
end

local forbiddenwords2 = { "fuck", "nigger", "nawb", "admin", "shit" }

function ValidTurretNick(pl,str)

	if not str then return false end
	if (string.len(str) > 15) then 
	pl:ChatPrint("Maximum nickname length is 15 characters!")
	return false 
	end
	
	
	for k, word in pairs(forbiddenwords2) do
		if string.find( string.lower( str ),word ) then return false end
	end
	
	return true
	
end

function CalculateHordeStatus()
	if ( NextHordeCalculate or 0 ) > CurTime() then return end

	NextHordeCalculate = CurTime() + 0.13

	if #team.GetPlayers( TEAM_UNDEAD ) == 0 then return end

	for k, Zombies in pairs( team.GetPlayers( TEAM_UNDEAD ) ) do
	--print("Found: "..k)
		Zombies.InHorde = Zombies.InHorde or 0
		if IsValid( Zombies ) and Zombies:Alive() then
		print("Alive: "..Zombies:Nick())
			for i, Zombie in pairs( ents.FindInSphere( Zombies:GetPos(), 230 ) ) do
				print("Nearby: "..tostring(Zombie))
				if Zombie:IsPlayer() and Zombie:Alive() then
					print("Nearby alive: "..Zombie:Nick())
					local iDistance = Zombies:GetPos():Distance( Zombie:GetPos() )
					if iDistance <= 230 and Zombies ~= Zombie then
						--print("Checked: "..Zombie:Nick())
						if Zombie:IsZombie() then
							Zombie.InHorde = CurTime() + 0.5
							--print("Set shared: "..Zombie:Nick())
							--print("Set "..Zombie:Nick())
						end
					end
				end
			end
		end
	end
end
--hook.Add( "Think", "CalculateHordeStatus", CalculateHordeStatus )

function CalculateHordeStatus1()
	if ( NextHordeCalculate or 0 ) > CurTime() then return end
	if LASTHUMAN then return end

	NextHordeCalculate = CurTime() + 0.13

	if #team.GetPlayers( TEAM_UNDEAD ) == 0 then return end

	for k, pl in pairs( team.GetPlayers( TEAM_UNDEAD ) ) do
		
		if IsValid( pl ) and pl:Alive() then
		pl.InHorde = pl.InHorde or 0
			for i, Zombie in pairs( ents.FindInSphere( pl:GetPos(), 230 ) ) do
				if IsValid( Zombie ) and Zombie:IsPlayer() and Zombie:Alive() and Zombie ~= pl then
					pl.InHorde = CurTime() + 0.5 Zombie.InHorde = CurTime() + 0.5
				end
			end		
		end
	end
end
-- hook.Add( "Think", "CalculateHordeStatus", CalculateHordeStatus1 )


-- Amazing but SetNoCollideWithTeammates is shitty as fuck
-- SO I have to use this thing (with player pushing from IW) :<
function GM:_ShouldCollide( ent1, ent2 )
	if ent1:IsPlayer() and ent2:IsPlayer() and ent1:Team() == ent2:Team() or ent1.NoCollideAll or ent2.NoCollideAll then
	   	-- Soft collision for humans
	   	--[[if ( ent1:GetPos():Distance( ent2:GetPos() ) <= 30 ) and ent1:Team() == TEAM_HUMAN then
            local dir = ( ent1:GetPos() - ent2:GetPos() ):GetNormal()
            
            -- Now PUSH
            if ( ent1:GetVelocity():Length() > 0 ) then
                ent1:SetVelocity( dir * 33 )  
            end
        end]]
	
		return false
	end
	return true
end

hook.Add("Initialize","InitShouldCollide",function()
	GAMEMODE.ShouldCollide = GAMEMODE._ShouldCollide
end)

--------------------------------------------
--Include some objective stuff
--------------------------------------------


function GM:SetObjStage(num)
	SetGlobalInt("objstage", num)
	self.ObjectiveStage = num
	if SERVER then
		for _,pl in pairs(player.GetAll()) do
			self:UpdateObjStageOnClients(pl)
		end
	end
end

function GM:GetObjStage()
	return GetGlobalInt("objstage")
end

function GM:NextObjStage()
	if self:GetObjStage() >= #Objectives then return end
	self:SetObjStage(self:GetObjStage() + 1)
end

function GM:ZombieSpawnDistanceSort(other)
	return self._ZombieSpawnDistance < other._ZombieSpawnDistance
end

function GM:SortZombieSpawnDistances(allplayers)
	local zspawns = ents.FindByClass("zombiegasses") --team.GetSpawnPoint(TEAM_UNDEAD)
	for _, pl in pairs(allplayers) do
		if pl:Team() == TEAM_UNDEAD then
			pl._ZombieSpawnDistance = -1
		else
			local plpos = pl:GetPos()
			local closest = 9999999
			for _, ent in pairs(zspawns) do
				local dist = ent:GetPos():Distance(plpos)
				if dist < closest then
					closest = dist
				end
			end
			pl._ZombieSpawnDistance = closest
		end
	end

	table.sort(allplayers, self.ZombieSpawnDistanceSort)
end

function WorldVisible(posa, posb)
	return not util.TraceLine({start = posa, endpos = posb, mask = MASK_SOLID_BRUSHONLY}).Hit
end

local playerheight = Vector(0, 0, 72)
local playermins = Vector(-17, -17, 0)
local playermaxs = Vector(17, 17, 4)

function GM:DynamicSpawnIsValid(zombie, humans, allplayers)
	-- Optional caching for these.
	if not humans then humans = team.GetPlayers(TEAM_HUMAN) end
	if not allplayers then allplayers = player.GetAll() end

	local pos = zombie:GetPos() + Vector(0, 0, 1)
	if zombie:Alive() and zombie:GetMoveType() == MOVETYPE_WALK and zombie:WaterLevel() < 2 and not util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID, filter = allplayers}).Hit then
		local valid = true

		for ___, human in pairs(humans) do
			local eyepos = human:EyePos()
			local nearest = zombie:NearestPoint(eyepos)
			local dist = eyepos:Distance(nearest)
			if dist <= 400 or dist <= 824 and WorldVisible(eyepos, nearest) then -- Zombies can't be in radius of any humans. Zombies can't be clearly visible by any humans.
				valid = false
				break
			end
		end

		return valid
	end

	return false
end


local CachedEpicentreTimes = {}
local CachedEpicentres = {}
function GM:GetTeamEpicentre(teamid, nocache)
	if not nocache and CachedEpicentres[teamid] and CurTime() < CachedEpicentreTimes[teamid] then
		return CachedEpicentres[teamid]
	end

	local plys = team.GetPlayers(teamid)
	local vVec = Vector(0, 0, 0)
	for _, pl in pairs(plys) do
		if pl:Alive() then
			vVec = vVec + pl:GetPos()
		end
	end

	local epicentre = vVec / #plys
	if not nocache then
		CachedEpicentreTimes[teamid] = CurTime() + 0.5
		CachedEpicentres[teamid] = epicentre
	end

	return epicentre
end
GM.GetTeamEpicenter = GM.GetTeamEpicentre

local temppos
local function SortByDistance(a, b)
	return a:GetPos():Distance(temppos) < b:GetPos():Distance(temppos)
end

function GM:GetClosestSpawnPoint(teamid, pos)
	temppos = pos
	local spawnpoints
	if type(teamid) == "table" then
		spawnpoints = teamid
	else
		spawnpoints = team.GetSpawnPoint(teamid)
	end
	table.sort(spawnpoints, SortByDistance)
	return spawnpoints[1]
end

function GM:GetBestDynamicSpawn(pl)
	local spawns = self:GetDynamicSpawns(pl)
	if #spawns == 0 then
		return
	end

	return self:GetClosestSpawnPoint(spawns, self:GetTeamEpicentre(TEAM_HUMAN)) or table.Random(spawns)
end

function GM:GetDynamicSpawns(pl)
	local tab = {}

	local allplayers = player.GetAll()
	local humans = team.GetPlayers(TEAM_HUMAN)
	for _, zombie in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		local pos = zombie:GetPos() + Vector(0, 0, 1)
		if zombie ~= pl and self:DynamicSpawnIsValid(zombie, humans, allplayers) then
			table.insert(tab, zombie)
		end
	end

	return tab
end

function GM:GetRagdollEyes(pl)
	local Ragdoll = pl:GetRagdollEntity()
	if not Ragdoll then return end

	local att = Ragdoll:GetAttachment(Ragdoll:LookupAttachment("eyes"))
	if att then
		att.Pos = att.Pos + att.Ang:Forward() * -2
		att.Ang = att.Ang

		return att.Pos, att.Ang
	end
end

function GM:GetActualEyes(pl)

	local att = pl:GetAttachment(pl:LookupAttachment("eyes"))
	if att then
		att.Pos = att.Pos + att.Ang:Forward() * -2
		att.Ang = att.Ang

		return att.Pos, att.Ang
	end
end

local function SortByHumans(a, b)
	return a._Humans > b._Humans
end


function GM:GetNiceHumanSpawn(pl)
	
	local tab = {}
	
	local humans = team.GetPlayers(TEAM_HUMAN)
	for _, hm in pairs(humans) do
		if IsValid(hm) and hm:Alive() and pl ~= hm then
			local pos = hm:GetPos() + Vector(0, 0, 1)
			if not util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID, filter = player.GetAll()}).Hit then
				-- count humans
				hm._Humans = 0
				local buddies = team.GetPlayers(TEAM_HUMAN)-- ents.FindInSphere( hm:GetPos(), 290 )
				for k, bud in pairs(buddies) do
					if IsValid(bud) and bud:IsPlayer() and bud:Alive() and bud ~= hm and bud:IsHuman() and hm:GetPos():Distance(bud:GetPos()) <= 290 then
						hm._Humans = hm._Humans + 1
					end
				end
				table.insert(tab, hm)
			end
		end
	end
	
	table.sort(tab, SortByHumans)
	
	return tab[1] or nil

end

function GM:IsBossAlive()
	for _, z in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if ValidEntity(z) and z:Alive() and z:IsBossZombie() then
			return true
		end
	end
	return false
end

function GM:GetBossZombie()
	for _, z in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if ValidEntity(z) and z:Alive() and z:IsBossZombie() then
			return z
		end
	end
	return
end

function GM:IsBossRequired()
	if BOSSACTIVE then
		return false
	end
	-- if self:IsRetroMode() then return end
		
	--Require teams on both sides
	if team.NumPlayers(TEAM_UNDEAD) == 0 or team.NumPlayers(TEAM_HUMAN) == 0 then
		return false
	end
	
	--Require atleast X amount of players
	if #player.GetAll() < BOSS_TOTAL_PLAYERS_REQUIRED then
		return false
	end
	
	--Yay boss
	return true
end

function GM:GetPlayerForBossZombie()
	local zombies = team.GetPlayers(TEAM_UNDEAD)
	
	--Check if there are any zombies
	if team.NumPlayers(TEAM_UNDEAD) == 0 then
		return nil
	end
	
	--Init table
	local tab = {}
		
	--Check if players meet requirements
	for _, zmb in pairs(zombies) do
		if IsValid(zmb) then-- and zmb:Alive() 
			if zmb.DamageDealt and zmb.DamageDealt[TEAM_UNDEAD] and zmb.DamageDealt[TEAM_UNDEAD] > 0 and not zmb.bIsAFK then
				table.insert(tab, zmb)
			end
		end
	end
	
	--Sort descending based on damage dealt)
	table.sort(tab,
		function(a, b)
			if a.DamageDealt[TEAM_UNDEAD] == b.DamageDealt[TEAM_UNDEAD] then
				return a:UserID() > b:UserID()
			end
			return a.DamageDealt[TEAM_UNDEAD] > b.DamageDealt[TEAM_UNDEAD]
		end)
	
	--Take 3 best zombies
	local num = math.min(1,math.max(3,#tab))
	
	--Return good zombie
	if tab[num] then
		return tab[num]
	end
	
	--Return random zombie
	return table.Random(zombies)
end

