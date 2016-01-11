-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function IsValidSpecial( object )
	if not object then
		return false
	end
	
	if type(object) == "number" or type(object) == "string" or type(object) == "boolean" then 
		return false
	end
	
	return IsValid(object)
end

local _CreateConVar = CreateConVar
function CreateConVar(name, value, flags, helptext)
	if ConVarExists(name) then
		print("[CVAR] ".. name .." exists. Not recreated.")
		return GetConVar(name)
	else
		return _CreateConVar(name, value, flags, helptext)
	end
end

--GameModes
include("shared/sh_gamemode.lua")

--[=[---------------------------------------------------------
	     Include the shared files
---------------------------------------------------------]=]
include("shared/obj_player_extend.lua")
include("shared/obj_weapon_extend.lua")
include("shared/obj_entity_extend.lua")
include("shared/zs_options_shared.lua")
include("shared/shopdata/zs_shop.lua")
include("shared/zombiedata/zs_zombie_classes.lua")
include("shared/sounds/sounds.lua")
include("shared/sh_maps.lua")
include("shared/sh_animations.lua")
include("shared/sh_zombo_anims.lua")
include("extended/sh_engine.lua")

--MapCoder inclusions
if SERVER then
	for k, file in pairs(file.Find("zombiesurvival/gamemode/shared/maps/*.lua", "lsv")) do
		local path = "shared/maps/".. tostring(file)
		include(path)
		AddCSLuaFile(path)

		Debug("[MAPCODER] Included '".. path .."'")
	end
else
	local mapcoderMaps = {"zs_fortress_mod","zs_prc_wurzel_v2","zs_storm_fixed","zs_the_pub_beta1","zs_yp_jungle"}
	for _,v in pairs(mapcoderMaps) do
  		if v == game.GetMap() then
  			local includeFile = "shared/maps/".. v ..".lua"
			include(includeFile)

			Debug("[MAPCODER] Included '".. includeFile .."'")

  			break
  		end
  	end

end

--Some particles
game.AddParticles("particles/butt_fart1.pcf")
PrecacheParticleSystem("BUTT_FART2")
PrecacheParticleSystem("BUTT_FART3")

--Screentaker
include("modules/screentaker/screentaker.lua")

--Clavus' Ravebreak
include("modules/ravebreak/sh_ravebreak.lua")

--
GM.Name = "Zombie Survival"
GM.Author = "Limetric"
GM.Email = "info@limetric.com"
GM.Website = "http://limetric.com"

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
team.SetUp(TEAM_ZOMBIE, "The Undead", Color(198, 43, 43))
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(43, 129, 198))
team.SetUp(TEAM_SPECTATOR, "Spectators", Color(128, 155, 21, 255))

-- Initialize team tags for log
--[[if SERVER then
	log.InitializeTeamBased( {TEAM_ZOMBIE, "Undead", TEAM_SURVIVORS, "Survivor"} )
end]]

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
	[0] = { Sound ( "npc/zombie/foot1.wav" ), Sound ( "npc/zombie/foot2.wav" ), Sound ( "npc/zombie/foot3.wav" ) }, 
	[1] = { Sound ( "npc/zombie/foot1.wav" ), Sound ( "npc/zombie/foot2.wav" ), Sound ( "npc/zombie/foot3.wav" ) }, 
	[2] = { Sound ( "player/footsteps/ladder1.wav" ), Sound ( "player/footsteps/ladder2.wav" ), Sound ( "player/footsteps/ladder3.wav" ), Sound ( "player/footsteps/ladder4.wav" ) },
	[3] = { Sound ( "npc/zombine/gear1.wav" ), Sound ( "npc/zombine/gear2.wav" ), Sound ( "npc/zombine/gear3.wav" ),Sound ( "npc/zombie/foot1.wav" ), Sound ( "npc/zombie/foot2.wav" ) },-- zombine
	[4] = { Sound ( "npc/zombie_poison/pz_right_foot1.wav" ), Sound ( "npc/zombie_poison/pz_left_foot1.wav" ) },-- poison zombie
	[5] = { Sound ( "npc/fast_zombie/foot1.wav" ), Sound ( "npc/fast_zombie/foot2.wav" ), Sound ( "npc/fast_zombie/foot3.wav" ), Sound ( "npc/fast_zombie/foot4.wav" ) },-- fast zombie
	[6] = { Sound ( "npc/headcrab_poison/ph_step1.wav" ), Sound ( "npc/headcrab_poison/ph_step2.wav" ), Sound ( "npc/headcrab_poison/ph_step3.wav" ), Sound ( "npc/headcrab_poison/ph_step4.wav" ) },-- poison headcrab
	-- [11] = { Sound("physics/metal/metal_barrel_impact_hard5.wav"),Sound("physics/metal/metal_barrel_impact_hard6.wav")}
	[11] = { Sound("npc/strider/strider_step1.wav"),Sound("npc/strider/strider_step2.wav"),Sound("npc/strider/strider_step3.wav"),Sound("npc/strider/strider_step4.wav"),Sound("npc/strider/strider_step5.wav"),Sound("npc/strider/strider_step6.wav")}
}

for i=1, 6 do
	for _,snd in pairs(tbFootSteps[i]) do
		util.PrecacheSound( snd )
	end
end

-- Save what step type the player is running
local function StepSoundTime( pl, iType, bWalking )
	pl.Footstep = iType
end
hook.Add( "PlayerStepSoundTime", "FootSteps", StepSoundTime)
	
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
			if pl:IsCommonZombie2() or pl:GetZombieClass() == 14 then
				sSound = tbFootSteps[0][iFoot+1]
				ftime = 0.1
			elseif pl:IsCommonZombie() then
				sSound = tbFootSteps[1][iFoot+1]
				ftime = 0.365
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
LASTHUMAN = false
BOSSACTIVE = false
UNLIFE = false

-- Mobile supplies
MOBILE_SUPPLIES = false

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
local forbiddenwords = { "moderator", "host", "server", "fuck", "( ?° ?? ?°) " }
function ValidTitle( pl, str )
	-- 24 character limit
	if not str or string.len(str) > 24 then
		return false
	end
	
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
		if not string.find ( validchars, v ) then
			return false
		end
	end
	
	if not (CLIENT and pl:IsAdmin()) or (SERVER and pl:IsAdmin()) then
		for k, word in pairs(forbiddenwords) do
			if string.find( string.lower( str ),word ) then
				return false
			end
		end
	end
	
	return true
end

local forbiddenwords2 = { "fuck", "nigger", "nawb", "admin", "shit", "server", "( ?° ?? ?°) ", "Duby", "gay" } --The standard things, including myself after DanRod..

function ValidTurretNick(pl,str)
	if not str then
		return false
	end
	
	if string.len(str) > 15 then 
		pl:ChatPrint("Maximum nickname length is 15 characters!")
		return false 
	end
	
	for k, word in pairs(forbiddenwords2) do
		if string.find( string.lower( str ),word ) then
			return false
		end
	end
	
	return true
end

--Amazing but SetNoCollideWithTeammates is shitty as fuck
function GM:ShouldCollide(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) then
		if (ent1:IsPlayer() and ent2:IsPlayer() and ent1:Team() == ent2:Team()) or ent1.NoCollideAll or ent2.NoCollideAll then	
			return false
		elseif ent1.ShouldCollide then
			local result = ent1:ShouldCollide(ent2)
			if result == false then
				return false
			end
		elseif ent2.ShouldCollide then
			local result = ent2:ShouldCollide(ent1)
			if result == false then
				return false
			end
		end
	end

	return true
end
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

--Refresh cache
local Humans, AllPlayers = {}, {}
timer.Create("RefreshSharedData", 3, 0, function()
	AllPlayers = player.GetAll()
	Humans = team.GetPlayers(TEAM_HUMAN)
end)

function GM:DynamicSpawnIsValid(target)
	if not IsValid(target) then
		return false
	end

	local Class = target:GetClass()

	--Check if spawning on a Blood Spawner
	if Class == "game_spawner" then
	
		for i=1, #Humans do
			local human = Humans[i]
			if not IsValid(human) or not human:IsPlayer() or not human:Alive() then
				continue
			end
			
			local eyepos = human:EyePos()
			local nearest = target:NearestPoint(eyepos)

			local dist = human:EyePos():Distance(nearest)

			if dist <= 950 then
				return false
			end
		end
		
		return true
	--Check if spawning on player
	elseif target:IsPlayer() then
		local pos = target:GetPos() + Vector(0, 0, 1)

		local traceData = {
			start = pos,
			endpos = pos + playerheight,
			mins = playermins,
			maxs = playermaxs,
			mask = MASK_SOLID,
			filter = AllPlayers
		}

		if not target:Alive() or target:GetMoveType() ~= MOVETYPE_WALK or not target:OnGround() or target:WaterLevel() >= 2 or util.TraceHull(traceData).Hit then
			return false
		end

		for i=1, #Humans do
			local human = Humans[i]
			if not IsValid(human) or not human:IsPlayer() or not human:Alive() then
				continue
			end
			
			local eyepos = human:EyePos()
			local nearest = target:NearestPoint(eyepos)
			local dist = eyepos:Distance(nearest)
			--Zombies can't be in radius of any human and can't be clearly seen by any human
			if dist <= 600 or (dist <= 900 and WorldVisible(eyepos, nearest)) then
				return false
			end
		end

		return true
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
	for i=1, #plys do
		local pl = plys[i]
		if not IsValid(pl) or not pl:Alive() then
			continue
		end

		vVec = vVec + pl:GetPos()
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
	local zombies = team.GetPlayers(TEAM_UNDEAD)

	--Check for spawner ents to spawn on
	for k, v in pairs(ents.FindByClass("game_spawner")) do
		if v.Dormant then continue end
		table.insert(tab, v)
	end		
	
	for i=1, #zombies do
		local zombie = zombies[i]
		if not IsValid(zombie) then
			continue
		end
		
		local pos = zombie:GetPos() + Vector(0, 0, 1)
		if zombie ~= pl and self:DynamicSpawnIsValid(zombie) then
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
	local buddies = team.GetPlayers(TEAM_HUMAN)-- ents.FindInSphere( hm:GetPos(), 290 )

	for i=1, #humans do
		local hm = humans[i]

		if IsValid(hm) and hm:Alive() and pl ~= hm then
			local pos = hm:GetPos() + Vector(0, 0, 1)
			if not util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID, filter = player.GetAll()}).Hit then
				-- count humans
				hm._Humans = 0
				
				for i=1, #buddies do
					local bud = buddies[i]

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
	--TODO: Use GetBossZombie for this
	local Zombies = team.GetPlayers(TEAM_UNDEAD)
	for i=1, #Zombies do
		local z = Zombies[i]
		if IsValid(z) and z:Alive() and z:IsBossZombie() then
			return true
		end
	end
	
	return false
end

function GM:GetBossZombie()
	local Zombies = team.GetPlayers(TEAM_UNDEAD)
	for i=1, #Zombies do
		local z = Zombies[i]
		
		if IsValid(z) and z:Alive() and z:IsBossZombie() then
			return z
		end
	end
	return
end

function GM:IsBossRequired()
	--Check if there's already an active boss
	if GAMEMODE:GetBoss() then
		return false
	end
	
	--Require teams on both sides
	if team.NumPlayers(TEAM_UNDEAD) == 0 or team.NumPlayers(TEAM_HUMAN) == 0 then
		return false
	end
	
	--Require atleast X amount of players
	if (team.NumPlayers(TEAM_UNDEAD) + team.NumPlayers(TEAM_HUMAN)) < BOSS_TOTAL_PLAYERS_REQUIRED then
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
	
	--No boss picking if we have low player count.
	if team.NumPlayers(TEAM_UNDEAD) < 5 and team.NumPlayers(TEAM_HUMAN) < 5 then
		return nil
	end	
	
	--Init table
	local tab = {}
		
	--Check if players meet requirements
	for i=1, #zombies do
		local zmb = zombies[i]
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
	local num = 1
	
	--Return good zombie
	if tab[num] then
		return tab[num]
	end
	
	--Return random zombie
	return table.Random(zombies)
end


function GameSpeed()
	return (1/FrameTime()) / 66
end