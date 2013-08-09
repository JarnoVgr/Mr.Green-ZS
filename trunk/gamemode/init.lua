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
local ents = ents
local gmod = gmod

--Very important script
include("modules/debug/sh_debug.lua")

--[=[---------------------------------------------------------
          Add them to download list (Client)
---------------------------------------------------------]=]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("client/cl_chat.lua")
AddCSLuaFile("client/cl_utils.lua")
AddCSLuaFile("shared/sh_utils.lua")
AddCSLuaFile("client/cl_chatbox.lua")
AddCSLuaFile("client/cl_spawnmenu.lua")
AddCSLuaFile("client/cl_scoreboard.lua")
AddCSLuaFile("client/cl_spawnmenu.lua")
AddCSLuaFile("client/cl_hudpickup.lua")
AddCSLuaFile("client/cl_targetid.lua")
AddCSLuaFile("client/cl_scoreboard.lua" )
AddCSLuaFile("client/cl_postprocess.lua")
AddCSLuaFile("client/cl_deathnotice.lua")
AddCSLuaFile("client/cl_beats.lua")
AddCSLuaFile("client/cl_dermaskin.lua")
AddCSLuaFile("client/cl_voice.lua")
AddCSLuaFile("client/cl_waves.lua")
AddCSLuaFile("client/vgui/scoreboard.lua")
AddCSLuaFile("client/vgui/poptions.lua")
AddCSLuaFile("client/vgui/phelp.lua")
AddCSLuaFile("client/vgui/pclasses.lua")
AddCSLuaFile("client/vgui/pshop.lua")
AddCSLuaFile("client/vgui/pweapons.lua")
AddCSLuaFile("client/vgui/phclasses.lua")
AddCSLuaFile("client/vgui/pclassinfo.lua")
AddCSLuaFile("client/vgui/pskillshop.lua")
AddCSLuaFile("client/vgui/pmapmanager.lua")
AddCSLuaFile("client/cl_splitmessage.lua")
AddCSLuaFile("client/cl_customdeathnotice.lua")
AddCSLuaFile("client/cl_endgame.lua")
AddCSLuaFile("client/cl_outline.lua")
AddCSLuaFile("client/cl_selectionmenu.lua")
AddCSLuaFile("client/cl_director.lua")
AddCSLuaFile("client/cl_admin.lua")
AddCSLuaFile("shared/sh_animations.lua")
AddCSLuaFile("shared/sh_zombo_anims.lua")
AddCSLuaFile("shared/sh_human_anims.lua")
AddCSLuaFile("client/cl_hud.lua")

AddCSLuaFile("modules/legs/cl_legs.lua")
AddCSLuaFile("modules/news/cl_news.lua")

--[=[---------------------------------------------------------
          Add them to download list (Shared)
---------------------------------------------------------]=]
AddCSLuaFile("shared.lua")
AddCSLuaFile("shared/sh_dps_sys.lua")
AddCSLuaFile("shared/obj_player_extend.lua")
AddCSLuaFile("shared/obj_weapon_extend.lua")
AddCSLuaFile("shared/zs_options_shared.lua")
AddCSLuaFile("shared/obj_entity_extend.lua")
AddCSLuaFile("shared/sh_maps.lua")

AddCSLuaFile("modules/json/json.lua")

include("modules/sql/sv_sql.lua")


include("modules/debug/sv_debug.lua")

include("modules/log/hl_log.lua")
--require("log")

--[=[---------------------------------------------------------
	Include the server and shared files
---------------------------------------------------------]=]
include("shared.lua")
include("shared/sh_utils.lua")
include("server/zs_options_server.lua") -- Options
include("server/sv_tables.lua")
include("server/sv_playerspawn.lua")
include("server/sv_utils.lua")
include("server/entitytakedamage/sv_main.lua")
include("server/achievements/sv_achievements.lua") -- Achievements
include("server/upgrades/sv_upgrades.lua")
include("server/sv_obj_player_extend.lua")
include("server/commands.lua")
include("server/doplayerdeath/sv_main.lua")
include("server/doredeem/sv_main.lua")
include("server/voice.lua") -- Team voice management
include("server/sv_director.lua") -- Director (handles supply crates spawning etc.)
include("greencoins/sv_greencoins.lua") -- Green-Coins
include("server/sv_endround.lua") -- Intermission
include("server/sv_maps.lua") -- Map specific
include("server/sv_admin.lua") -- Admin commands
-- include("shared/sh_animations.lua")
-- include("shared/sh_zombo_anims.lua")
-- include("shared/sh_human_anims.lua")
include("server/anti_map_exploit.lua" )
include("server/sv_poisongasses.lua" )
include("server/sv_waves.lua" )
include("server/sv_pickups.lua" )

--[=[---------------------------------------------------------
	        Include stand alone modules
----------------------------------------------------------]=]
include("modules/afk/sv_afk.lua") -- AFK manager
include("modules/damage_indicator/sv_dmg_indicator.lua")
include("modules/news/sv_news.lua") -- News flash
include("modules/spectate/sv_spectate.lua")
include("modules/weightspeed/sv_weightspeed.lua") -- change walk speed depending on weapon weight
-- include("modules/friends/sv_friends.lua") -- w.i.p. friends system
include("modules/hud_beta/sv_hud_beta.lua") -- New hud
-- include("modules/nav_graph/sh_nav_graph.lua")
include("server/stats/sv_server_stats.lua") -- Statistics
include("modules/skillpoints/sv_skillpoints.lua")
include("modules/skillpoints/sh_skillpoints.lua")

include("modules/boneanimlib_v2/sh_boneanimlib.lua")
include("modules/boneanimlib_v2/boneanimlib.lua")

include( "extended/irc/sv_irc.lua" )

for map,opt in pairs(TranslateMapTable) do
	if TranslateMapTable[map].Objective then
		Debug("[MAPCODER] Added Objectives file "..tostring(map) .."")
		AddCSLuaFile("shared/objectivemaps/"..map..".lua")
	end
end
Debug("[MAPCODER] Included Objectives file")

hook.Remove("PlayerTick","TickWidgets")

--[=[---------------------------------------------------------
  Include the data for supply crate points and more
---------------------------------------------------------]=]
--[[if file.Exists("gamemodes/zombiesurvival/gamemode/server/maps/"..game.GetMap()..".lua","lsv") then
	include("server/maps/".. game.GetMap()..".lua")
	Debug("[MAPCODER] Loaded map config file for current map")
else
	Debug("[MAPCODER] WARNING: Config file for this map has not been found")
end]]

Thres = 0
difficulty = 1 --default 1
HEAD_NPC_SCALE = math.Clamp(3 - difficulty, 1.5, 4)

--[=[---------------------------------------------------------
         Custom broadcast lua function
---------------------------------------------------------]=]
gmod.BroadcastLua = gmod.BroadcastLua or function( lua )
	for _, pl in pairs( player.GetAll() ) do
		pl:SendLua( lua )
	end
end

--[=[---------------------------------------------------------
      Give weapons to the player here
---------------------------------------------------------]=]
function GM:PlayerLoadout ( pl )
end

--[=[----------------------------------------------------------------------
		Called when a player receives a SWEP
-----------------------------------------------------------------------]=]
function GM:OnWeaponEquip ( pl, mWeapon )
	if not IsEntityValid ( pl ) then return end

	-- Hacky way to update weapon slot count
	local EntClass = mWeapon:GetClass()
	local PrintName = mWeapon.PrintName or "weapon"
	if pl:IsPlayer() then
		if pl:Team() == TEAM_HUMAN then
			local category = WeaponTypeToCategory[ mWeapon:GetType() ]
			pl.CurrentWeapons[ category ] = pl.CurrentWeapons[ category ] + 1
			WeaponPickupNotify ( pl, PrintName )				
		end
	end
end

--[=[---------------------------------------------------------
      Called when a weapon is deployed
---------------------------------------------------------]=]
function GM:WeaponDeployed ( mOwner, mWeapon, bIron )
	if not ValidEntity ( mOwner ) or not mWeapon:IsWeapon() then return end
	
	-- We don't want bots
	if mOwner:IsBot() then return end

	-- Weapon walking speed, health, and player human class
	local fSpeed, fHealth, iClass, fHealthSpeed = mWeapon.WalkSpeed or 200, mOwner:Health(), mOwner:GetHumanClass()
	
	if mOwner:GetPerk("_sboost") then
		fSpeed = fSpeed*1.08
	end

	-- Does player got adrenaline shop item or is player medic
	-- if mOwner:HasBought("adrenaline") or iClass == 1 then
	-- 	fHealthSpeed = 1
	-- else
		fHealthSpeed = mOwner:GetPerk("_adrenaline") and 1 or math.Clamp ( ( fHealth / 50 ), 0.7, 1 )
	-- end
	
	if bIron then
		fSpeed = math.Round ( ( fSpeed * 0.6 ) * fHealthSpeed )
	else
		if mOwner:IsHolding() then
			local status = mOwner.status_human_holding
			-- for _, status in pairs(ents.FindByClass("status_human_holding")) do
				if status and IsValid(status) and status:GetOwner() == mOwner and status.GetObject and status:GetObject():IsValid() and status:GetObject():GetPhysicsObject():IsValid() then
					fSpeed = math.max(CARRY_SPEEDLOSS_MINSPEED, fSpeed - status:GetObject():GetPhysicsObject():GetMass() * CARRY_SPEEDLOSS_PERKG)
					-- break
				end
			-- end
		else
			fSpeed = math.Round ( fSpeed * fHealthSpeed )
		end
	end
	
	-- Change speed
	self:SetPlayerSpeed( mOwner, fSpeed )
end

--[=[---------------------------------------------------------
	      Called at map load
---------------------------------------------------------]=]
function GM:Initialize()
	-- Creates the data/zombiesurvival folder if it doesn't exist
	if (not file.IsDir("zombiesurvival","DATA")) then
		file.CreateDir("zombiesurvival")
	end 
	
	-- Add resource files to download
	for k,v in pairs(ResourceFiles) do
		if not file.Exists( v, "GAME") then
			Debug ( "[RESOURCE-FILES] Couldn't add/find file "..tostring ( v ).." to add to resource files!" )
		else
			resource.AddFile(v)
		end
	end

	
	GAMEMODE:SetMapList()
	
	GAMEMODE:SetCrates()
	
	GAMEMODE:SetExploitBoxes()
	
	GAMEMODE:AddRandomSales()
	
	GAMEMODE:EnableSuperBoss()
	
	self:SetRetroMode(self:IsRetroMode())
	
	self:SetNightMode(self:IsNightMode())
	
	-- game.GetWorld():SetDTFloat(0,RETRO_AMMO_REGENERATION)
		
	-- Set few cvars
	game.ConsoleCommand("fire_dmgscale 1\nmp_flashlight 1\nmp_allowspectators 0\n")
	
	-- Map is loaded!
	Debug ( "[MAP] Loaded map: "..tostring ( game.GetMap() ) )
end

function GM:SetNightMode(mode)
	self.NightMode = mode
	SetGlobalBool("nightmode", self.NightMode)
	
	if mode then
		env_skypaint = ents.Create("env_skypaint")
		env_skypaint:Spawn()
		env_skypaint:Activate()
	
		env_skypaint:SetTopColor(Vector(0,0,0))
		env_skypaint:SetBottomColor(Vector(0,0,0))
		env_skypaint:SetDuskIntensity(0)
		env_skypaint:SetSunColor(Vector(0,0,0))
		env_skypaint:SetStarScale(1.1)
	
	
		game.ConsoleCommand("sv_skyname painted\n")
		
		timer.Simple(1,function() engine.LightStyle(0,"c") end)
	end
end

function GM:IsNightMode()
	return self.NightMode
end

-- Player presses F1
function OnPressF1(pl)
	-- Display help menu
	if not ENDROUND then
		pl:SendLua("MakepHelp()")
	end
end

-- Player presses F2
function OnPressF2(pl)
	--[[if not ENDROUND and pl:Team() == TEAM_HUMAN then
	pl:SendLua("MakeWeps()")
	end]]
	
	local red = REDEEM_KILLS
	if pl:HasBought("quickredemp") then
		red = REDEEM_FAST_KILLS
	end
	if not LASTHUMAN then
		if REDEEM and AUTOREDEEM and pl:Team() == TEAM_UNDEAD and pl:Frags() >= red then
			if not pl:IsBossZombie() then
				pl:Redeem()
			else
				pl:ChatPrint("Zombie boss can't redeem.")
			end
		else
			if pl:Team() == TEAM_UNDEAD then
				pl:ChatPrint("You need a score of ".. red .." to redeem!")
			end
		end
	else
		pl:ChatPrint("You can't redeem anymore.")
	end
end

-- Player presses F3
local function OnPressedF3( pl )
	if not ENDROUND then
		if pl:Team() == TEAM_UNDEAD then
			-- If undead show classes menu
			if not (pl:IsBossZombie() and pl:Alive()) then
				pl:SendLua("DoClassesMenu()")
			end
		elseif pl:Team() == TEAM_HUMAN then
			-- If survivor drop weapon
			DropWeapon(pl)
		end
	end
end
hook.Add ( "ShowSpare1", "PressedF3", OnPressedF3 )

-- Player presses F4
function GM:ShowSpare2( pl )
	-- Options menu
	pl:SendLua("MakepOptions()")
end

function GM:InitPostEntity()
	--Keep calls in order
	gamemode.Call("SetupSpawnPoints")
	gamemode.Call("SpawnPoisonGasses")
	gamemode.Call("SetupProps")
	
	--Loop 1 through props to convert into entity where needed
	for _, ent in pairs(ents.FindByClass("prop_physics")) do
		self:ModelToEntity(ent)
	end
	
	--Loop 2 through props to convert into entity where needed
	for _, ent in pairs(ents.FindByClass("prop_physics_multiplayer")) do
		self:ModelToEntity(ent)
	end
	
	--Set objective stage
	if OBJECTIVE then
		self:SetObjStage(1)
	end
	
	--Check if in retro mode
	if self:IsRetroMode() then
		--Sync ammo regeneration time
		game.GetWorld():SetDTFloat(0,RETRO_AMMO_REGENERATION+WAVEONE_LENGTH)
	else
		--Spawn crate
		self:CalculateSupplyDrops()
	end
	
	--Create zombie flashlight
	self:CreateZombieFlashLight()
	
	--Log
	log.WorldAction("Round_Start")
end

function GM:CreateZombieFlashLight()
	local ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetLocalPos(Vector(16000, 16000, 16000))
		ent:SetKeyValue("enableshadows", 0)
		ent:SetKeyValue("farz", 1024)
		ent:SetKeyValue("nearz", 8)
		ent:SetKeyValue("lightfov", 60)
		ent:SetKeyValue("lightcolor", "235 60 60 255")
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")

		game.GetWorld():SetDTEntity(0,ent)
	end
end

--[=[--------------------------------------------------------------------
      Removes restricted entities or protects excluded ones 
---------------------------------------------------------------------]=]
local function DeleteEntitiesRestricted()
	-- Entities to delete on map (wildcards are supported)
	local EntitiesToRemove = { "prop_ragdoll", "npc_zombie","npc_headcrab", "npc_zombie_torso", "npc_maker", "npc_template_maker", "npc_maker_template", --[=["func_door", "func_door_rotating",]=] "weapon_*", "item_ammo_*", "item_box_buckshot" }
	
	-- Trash bin table, stores entities that will be removed
	local TrashBin, CurrentMapTable = {}, MapProperties[game.GetMap()]-- TranslateMapTable[ game.GetMap() ]
	
	-- Run through restricted ents table and add them to trash bin 
	for k,v in pairs ( EntitiesToRemove ) do
		if string.find ( v, "npc_" ) then
			if not USE_NPCS then
				table.Add ( TrashBin, ents.FindByClass ( tostring ( v ) ) )
			end
		elseif string.find ( v, "func_" ) then
			if DESTROY_DOORS and not OBJECTIVE then
				table.Add ( TrashBin, ents.FindByClass ( tostring ( v ) ) )
			end
		else
			table.Add ( TrashBin, ents.FindByClass ( tostring ( v ) ) )
		end
	end
	
	-- Map specific filter for ents
	if CurrentMapTable then
		-- local MapRemoveEnts,MapRemoveEntsByModel, MapException, MapRemoveGlass,MapRemoveEntsByModelPattern = CurrentMapTable.RemoveEntities,CurrentMapTable.RemoveEntitiesByModel, CurrentMapTable.ExceptEntitiesRemoval, CurrentMapTable.RemoveGlass, CurrentMapTable.RemoveEntitiesByModelPattern
		local MapRemoveEnts,MapRemoveEntsByModel, MapException, MapRemoveGlass,MapRemoveEntsByModelPattern = CurrentMapTable[1],CurrentMapTable[3], CurrentMapTable[2], CurrentMapTable[4], CurrentMapTable.RemoveEntitiesByModelPattern
		-- Add entities to trash bin table 
		if MapRemoveEnts and #MapRemoveEnts > 0 then
			for i = 1, #MapRemoveEnts do
				if not string.find ( MapRemoveEnts[i], "/" ) then table.Add ( TrashBin, ents.FindByClass ( tostring ( MapRemoveEnts[i] ) ) ) end
				if string.find ( MapRemoveEnts[i], "/" ) then
					local FormatEnt = string.gsub ( tostring ( MapRemoveEnts[i] ), "/", "" )
					if ValidEntity ( Entity ( FormatEnt ) ) then 
						table.insert ( TrashBin, Entity ( FormatEnt ) ) 
					end 
				end
			end
		end
		--Remove entities by model
		timer.Simple(1,function()
		if MapRemoveEntsByModel and #MapRemoveEntsByModel > 0 then
			for k,v in pairs ( ents.GetAll() ) do
				for n,mdl in pairs(MapRemoveEntsByModel) do
					if v:GetModel() == mdl then
						if ValidEntity ( v ) then
							SafeRemoveEntity ( v )	
						Debug ( "[INIT] Safely removing entity "..tostring ( v ).." from map "..tostring ( game.GetMap() ) )
						end		
					end
				end
			end
		end	
		end)
		--Remove complicated models
		timer.Simple(1,function()
		if MapRemoveEntsByModelPattern and #MapRemoveEntsByModelPattern > 0 then
			for k,v in pairs ( ents.GetAll() ) do
				for n,pat in pairs(MapRemoveEntsByModelPattern) do
					if v:GetModel() and string.find(v:GetModel(),pat) then
						if ValidEntity ( v ) then
							SafeRemoveEntity ( v )	
						Debug ( "[INIT] Safely removing entity "..tostring ( v ).." from map "..tostring ( game.GetMap() ) )
						end		
					end
				end
			end
		end	
		end)
		
		
		--Temp force
		MapRemoveGlass = true
		
		--Remove glass
		timer.Simple(1,function()
			if MapRemoveGlass then
				for k,v in pairs ( ents.GetAll() ) do
					if v:GetClass() == "func_breakable" then
						if ValidEntity(v) then
							local phys = v:GetPhysicsObject()
							if ValidEntity(phys) and phys:GetMaterial() == "glass" then
								SafeRemoveEntity(v)	
								Debug("[INIT] Safely removing entity "..tostring(v).." from map "..tostring(game.GetMap()))
							end
						end		
					end
				end
			end	
		end)
		
		-- Except entities from the trash bin table
		if MapException and #MapException > 0 then
			for k,v in pairs ( TrashBin ) do
				for i = 1, #MapException do
					if string.find ( tostring ( v ), MapException[i] ) then
						TrashBin[k] = nil
					end
				end
			end
		end			
	end
	
	if OBJECTIVE then
		GAMEMODE:HandleObjEnts()
		TrashBin = {}
		if #Objectives.RemoveEntities > 0 then
			for k,v in pairs (Objectives.RemoveEntities) do
				table.Add ( TrashBin, ents.FindByClass ( tostring ( v ) ) )	
			end
		end
	end
	
	-- Delete them all
	for k,v in pairs ( TrashBin ) do
		if ValidEntity ( v ) then
			Debug ( "[INIT] Safely removing entity "..tostring ( v ).." from map "..tostring ( game.GetMap() ) )
			SafeRemoveEntity ( v )
		end
	end
end
hook.Add ( "InitPostEntity", "DeleteRestricteEnts", DeleteEntitiesRestricted )

--[=[----------------------------------------------------------
              Enables support for mappers to
    add "zs_weapondrop" as spawn for weapons
------------------------------------------------------------]=]
local function EnableWeaponDrop ()
	local WeaponDropEntites = ents.FindByClass("zs_weapondrop")
	for k,v in pairs ( WeaponDropEntites ) do
		if #WeaponDropEntites >= 1 and v then
			table.insert(DropPointsX,v:GetPos().x) -- PosX
			table.insert(DropPointsY,v:GetPos().y) -- PosY
			table.insert(DropPointsZ,v:GetPos().z) -- PosZ
		end
	end
end
hook.Add ("InitPostEntity","EnableMappingSupport",EnableWeaponDrop)

--[=[----------------------------------------------------------
       Initializes toxic fumes (around zombie spawn)
------------------------------------------------------------]=]
local function InitializeToxicFumes()
	
	-- Check to see if there are zs_disable_toxic_damage ents
	for k,v in pairs ( ents.FindByClass ( "zs_disable_toxic_damage" ) ) do
		if ValidEntity ( v ) then 
			TOXIC_SPAWN = false
		end
	end
end
-- hook.Add ( "InitPostEntity","InitializeToxicFumes",InitializeToxicFumes )

--[=[--------------------------------------------------------
             Translates the given entity to
        another one, based on the original model
---------------------------------------------------------]=]
function GM:ModelToEntity ( ent )
	if not ValidEntity ( ent ) then return end
	-- Initliaze our translation table
	local ModelToEntity = {
		["models/props_c17/tools_wrench01a.mdl"] = "weapon_zs_tools_hammer",
		["models/props/cs_office/computer_keyboard.mdl"] = "weapon_zs_melee_keyboard",
		["models/props_c17/metalpot002a.mdl"] = "weapon_zs_melee_fryingpan",
		["models/weapons/w_fryingpan.mdl"] = "weapon_zs_melee_fryingpan",
		["models/weapons/w_pot.mdl"] = "weapon_zs_melee_pot",
		["models/props/cs_militia/axe.mdl"] = "weapon_zs_melee_axe",
		["models/props_junk/shovel01a.mdl"] = "weapon_zs_melee_shovel",
		["models/weapons/w_knife_t.mdl"] = "weapon_zs_melee_combatknife",
		["models/weapons/w_knife_ct.mdl"] = "weapon_zs_melee_combatknife",
		["models/weapons/w_knife_t.mdl"] = "weapon_zs_melee_combatknife",
		["models/props_c17/metalpot001a.mdl"] = "weapon_zs_melee_pot",
		["models/props_interiors/pot02a.mdl"] = "weapon_zs_melee_fryingpan",
	}
	
	-- See if the model exists in the table and if it, replace it with an entity
	local mEnt = ModelToEntity[ string.lower(ent:GetModel()) ]
	if mEnt == nil then return end
	
	local blockedweapon = self.HumanWeapons[mEnt] and self.HumanWeapons[mEnt].NoRetro == true 
	
	if self:IsRetroMode() and blockedweapon then return end

	timer.Simple(1, function()
		if ValidEntity ( ent ) then
			local newEnt = ents.Create( mEnt )
			newEnt:SetPos( ent:GetPos() )
			ent:Remove()
			newEnt:Spawn()
		end
	end)
	
end

-- Toxic damage
ToxicPoints = {}
ToxicTime = 0
ToxicWarningTime = 0
function ToxicDamager() 
	if ToxicTime > CurTime() then return end
	
	-- Damage humans that enter toxic fumes, but don't kill them
	for _,pl in pairs ( team.GetPlayers( TEAM_HUMAN ) ) do
		if pl:IsInToxicFumes ( ToxicPoints ) then
			local MaxHealth = pl:GetMaximumHealth()
			if pl:Health() > MaxHealth * 0.15 then
				pl:TakeDamage ( MaxHealth * 0.05, nil, nil )
				pl:Message ("Stay out of the infected areas as they might get you killed!", 2, "white")
			end
		end
	end
	
	-- Heal the undead within the toxic fumes
	for _,pl in pairs ( team.GetPlayers( TEAM_UNDEAD ) ) do
		if pl:IsInToxicFumes ( ToxicPoints ) then
			local MaxHealth = pl:GetMaximumHealth()
			if pl:Health() < MaxHealth then
				pl:SetHealth ( math.Clamp ( pl:Health() + ( MaxHealth * 0.25 ), 0, MaxHealth ) )
			end
		end
	end
	
	ToxicTime = CurTime() + 1
end

NextAmmoDropOff = AMMO_REGENERATE_RATE
NextHeal = 0
NextQuickHeal = 0

function GM:OnNPCKilled ( ent, attacker, inflictor )
	if NPCS_COUNT_AS_KILLS and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		attacker:AddFrags(1)
	end
end

--[=[--------------------------------------
             Last Human Event
---------------------------------------]=]
function GM:LastHuman()
	if LASTHUMAN then
		return
	end

	-- Global var change
	LASTHUMAN = true
	RunConsoleCommand("sv_alltalk", "1")
	
	-- Broadcast status to clients
	gmod.BroadcastLua("GAMEMODE:LastHuman()")
	
	-- Get the last human
	local LastHuman = team.GetPlayers( TEAM_HUMAN )[1]
	if not ValidEntity ( LastHuman ) then
		return
	end
	
	-- Remember the time
	LastHuman.LastHumanTime = CurTime()
	
	-- Log
	log.WorldAction("Last_Human")
	
	-- The rest goes to the "LastManStand" upgrade
	--[[if not LastHuman:HasBought( "lastmanstand" ) then
		return
	end
	
	-- Reward and class to name translation table
	local RewardTable = { [1] = "weapon_zs_m249", [2] = "weapon_zs_m249", [3] = "weapon_zs_g3sg1", [4] = "weapon_zs_pulserifle", [5] = "weapon_zs_m249" }
	local ClassToName = { ["weapon_zs_shotgun"] = "Shotgun",["weapon_zs_crossbow"] = "Imba Crossbow", ["weapon_zs_annabelle"] = "Annabelle Shotgun", ["weapon_zs_melee_katana"] = "Katana", ["weapon_zs_pulserifle"] = "Pulse Rifle", ["weapon_zs_m3super90"] = "M3 Shotgun" }  
	
	-- Message printed to last human
	local Class = LastHuman:GetHumanClass()
	local Message = "Upgrade [Last Man Stand] gave you a(n) "..GAMEMODE.HumanWeapons[ RewardTable[ Class ] ].Name.."!"
	
	local Automatic, Melee = LastHuman:GetAutomatic(), LastHuman:GetMelee()
	local WeaponToStrip = Automatic
	local Reward = RewardTable [ Class ]
	if Automatic then
	if GetWeaponType ( Reward ) == "Automatic" and not ((GAMEMODE.HumanWeapons[ Reward ].DPS > GAMEMODE.HumanWeapons[ Automatic:GetClass() ].DPS) or Reward ~= Automatic:GetClass() ) then return end
	end
	if Melee then
	if GetWeaponType ( Reward ) == "Melee" and not ((GAMEMODE.HumanWeapons[ Reward ].DPS > GAMEMODE.HumanWeapons[ Melee:GetClass() ].DPS) or Reward ~= Melee:GetClass()) then return end
	end
	-- Strip the old weapon - melee for berserkers, automatic for rest
	--if Class == 3 then WeaponToStrip = Melee end
	if ValidEntity ( WeaponToStrip ) and WeaponToStrip:IsWeapon() then
		LastHuman:StripWeapon ( tostring ( WeaponToStrip:GetClass() ) )
	end
	
	-- Notify
	LastHuman:ChatPrint ( Message )
	
	-- Give the new weapon and select it
	LastHuman:Give ( RewardTable [ Class ] )
	LastHuman:SelectWeapon ( RewardTable [ Class ] )]]
end

--[=[--------------------------------------------------------------------
       Restrict or allow players to turn on their flashlights
---------------------------------------------------------------------]=]
local function RestrictFlashlight ( pl, Switch )
	if Switch == false then return true end --  Always let them allow to turn it off.
	
	-- Allow flashlight if the weapon is not melee
	local Weapon = pl:GetActiveWeapon()
	--if ValidEntity ( Weapon ) then if Weapon:GetType() == "melee" and pl:GetHumanClass() ~= 3 then return false end	end

	return pl:Alive() and pl:Team() == TEAM_HUMAN
end
-- hook.Add ( "PlayerSwitchFlashlight", "RestrictFlashLight", RestrictFlashlight )

function GM:PlayerSwitchFlashlight(pl, Switch)
	pl.m_ZombieVision = pl.m_ZombieVision or false
	if pl:Team() == TEAM_UNDEAD then
		if pl:Alive() then
			pl.m_ZombieVision = not pl.m_ZombieVision
			pl:SendLua("gamemode.Call(\"ToggleZombieVision\", "..tostring(pl.m_ZombieVision)..")")
		end

		return false
	end

	return true
end



function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	
	local sv_alltalk = GetConVar( "sv_alltalk" )
	
	local alltalk = sv_alltalk:GetInt()
	if (alltalk > 0) then return true, alltalk == 2 end

	return pListener:Team() == pTalker:Team(), false
	
end

--[=[--------------------------------------------------------
       Restrict or allow player to pick up weapons
---------------------------------------------------------]=]
function GM:PlayerCanPickupWeapon(ply, entity)
	local EntClass = entity:GetClass()
	
	--Filter Half-Life weapons (expect physgun and physcannon - they are handled by admin filter)
	for k,v in pairs(WeaponsRestricted) do
		if EntClass == v then
			return false
		end
	end
	
	--Allow Super Admin to pickup any admin weapon!
	for k,v in pairs(SuperAdminOnlyWeapons) do
		if v == EntClass then
			if ply:IsAdmin() and v == "admin_tool_sprayviewer" then 
				return true
			end
			
			return ply:IsSuperAdmin()
		end
	end
	
	--Restrict zombie only weapons to undead team members
	if ply:Team() == TEAM_UNDEAD then
		return EntClass == ZombieClasses[ply.Class].SWEP
	end
	
	-- If we already got the weapon, don't do anything
	if ply:HasWeapon(EntClass) then
		return false
	end
	
	-- Notify the player if he is carying more than 1 weapon of each type --  Dont notify anymore
	
	local limit = 1
	
	if self:IsRetroMode() then
		limit = 11
	end
	
	local Category = WeaponTypeToCategory[ entity:GetType() ]
	if Category then
		if ply.CurrentWeapons[Category] and ply.CurrentWeapons[Category] >= limit and Category ~= "Admin" then
			return false
		end
	end
			
	ply.HighestAmmoType = string.lower( entity:GetPrimaryAmmoTypeString() or ply.HighestAmmoType )
	
	--  logging
	--log.PlayerAcquireWeapon( ply, entity:GetClass() )
	
	
	return true
end

function GM:SendAdminStats(to)
	umsg.Start("SendAdminStats",to)
		umsg.Bool(to:IsAdmin())
	umsg.End()
end

function ChangeClass(pl,cmd,args)
	if args[1] == nil then return end
	
	if pl:Team() == TEAM_SPECTATOR then
		local Team = TEAM_HUMAN
		
		if LASTHUMAN then
			Team = TEAM_UNDEAD
		end
				
		pl:SetTeam(Team)
		-- pl:SetHumanClass ( math.ceil(args[1]) )
		
		--  logging
		--log.PlayerJoinTeam( pl, Team )
		-- log.PlayerRoleChange( pl, pl:GetClassTag() )
		
		pl:Spawn()
	end
end
concommand.Add( "ChangeClass", ChangeClass )

--[=[---------------------------------------------------------
	  Crappy bypass for the FCVAR
	       CAN SERVER EXECUTE
---------------------------------------------------------]=]
function server_RunCommand ( ply, command, args )
	if not ply:IsValid() then return end
	if command == nil then ErrorNoHalt("Server_RunCommand failed because there was no command to run!") return end
	local firstarg
	
	if args ~= nil then 
		firstarg = true
	else
		firstarg = false
	end

	umsg.Start ("client_GetCommand", ply)
		umsg.String (command)
		umsg.Bool (firstarg)
		if args ~= nil then
			umsg.String ( tostring(args) )
		end
	umsg.End()	
end

function SendDiffic(difficulty)
	umsg.Start( "SetDiff", pl )
		umsg.Float( difficulty )
	umsg.End()
end

-- Spawn hats for players
function GM:SpawnHat(pl, hattype)
	if not ValidEntity ( pl ) then
		return
	end
	if not pl:IsPlayer() then
		return
	end

	-- Player is a bot - testing purposes
	-- if pl:IsBot() then hattype = "rpresent" end
	-- 	self:SpawnSuit( pl, "techsuit" )
	--return end--
	
	-- if suits[hattype] then self:SpawnSuit(pl,hattype) return end
	
	if pl:IsBot() then
		hattype = "cigar$homburg"
	end
	
	--We clearly require a hat type
	if not hattype then
		return
	end
	
	local player_hats = string.Explode("$",hattype)
	-- Check to see if the hat is in the hats table
	local IsHatValid = true
	for k,v in pairs(player_hats) do
		if not hats[v] and not v == "" then
			IsHatValid = false
		end
	end
	
	-- print("hat "..tostring(IsHatValid))
	-- print(hattype)
	--[==[for k,v in pairs ( hats ) do
		if hattype == k then
			IsHatValid = true
			break
		end
	end]==]
	
	-- There isn't a hat with that name in the table
	if not IsHatValid then return end

	if not ValidEntity( pl.Hat ) and pl:Alive() then
		pl.Hat = ents.Create("sent_hat_new")
		pl.Hat:SetOwner(pl)
		pl.Hat:SetParent(pl)
		pl.Hat:SetPos( pl:GetPos() )
		
		-- Select random hat for bot
		if pl:IsBot() then
			pl.Hat:SetHatType("cigar$homburg")-- "cigar"
			--print("Setting hat to rpresent")
			--[==[local randhat = math.random( 1,13 )
			local cnt = 1
			for k, v in pairs( hats ) do
				if cnt == randhat then
					pl.Hat:SetHatType(k)
					break
				end
				cnt = cnt+1
			end	]==]	
		else
			pl.Hat:SetHatType( hattype )
		end
		
		pl.Hat:Spawn()
	end
end

--Disable acts and other funky shit
hook.Add( "PlayerShouldTaunt", "Disable_Acts", function(pl)
    return false
end)

function GM:SpawnSuit( pl, hattype )
	if not ValidEntity ( pl ) then return end
	if not pl:IsPlayer() then return end

	-- Player is a bot - testing purposes
	-- if pl:IsBot() then hattype = "stalkersuit" end
	
	local IsHatValid = false
	for k,v in pairs ( suits ) do
		if hattype == k then
			IsHatValid = true
			break
		end
	end
	
	if not IsHatValid then return end
	
	local suitdata = suits[hattype]
	
	local itemID = util.GetItemID(hattype )
	
	--[==[if suits[hattype] and (not ValidEntity(pl.Suit) or pl.Suit:GetHatType() ~= hattype) and pl:Team() == TEAM_HUMAN 
	and pl:GetItemsDataTable()[itemID] and (not shopData[itemID].AdminOnly or pl:IsAdmin()) then]==]
	
		if not ValidEntity( pl.Suit ) and pl:Alive() then
			pl.Suit = ents.Create("suit_new")
			pl.Suit:SetOwner(pl)
			pl.Suit:SetParent(pl)
			pl.Suit:SetPos(pl:GetPos())
			pl.Suit:SetHatType( hattype )
			pl.Suit:Spawn()
			pl.Suit.IsSuit = true
			
			-- pl.Suit:CreateSuit( suitdata, hattype )
		end
	-- end
end

function GM:DropSuit(pl)
	if ValidEntity(pl.Suit) and pl.Suit.IsSuit then
		pl.Suit:Remove()
		pl.Suit = nil
	end
end

function GM:DropHat(pl)
	if ValidEntity(pl.Hat) and not pl.Hat.IsSuit then
		pl.Hat:Remove()
		pl.Hat = nil
	end
end

HatCounter = 0
--[==[
function GM:DropHat(pl)
	if ValidEntity(pl.Hat) and not pl.Hat.IsSuit and pl.Hat:GetModel() then
		local boneindex = pl:LookupBone("ValveBiped.Bip01_Head1")
		if boneindex and HatCounter < 10 then -- hatcounter is protection against hat drop spamming
			local pos, ang = pl:GetBonePosition(boneindex)
			if pos and pos ~= pl:GetPos() then
				local exhat = ents.Create("prop_physics_multiplayer")
				exhat:SetModel(pl.Hat:GetModel())
				exhat:SetPos(pos)
				local hatAng = hats[pl.Hat:GetHatType()].Ang
				ang:RotateAroundAxis(ang:Forward(), hatAng.p)
				ang:RotateAroundAxis(ang:Up(), hatAng.y)
				ang:RotateAroundAxis(ang:Right(), hatAng.r)
				exhat:SetAngles(ang)
				exhat:Spawn()
				
				HatCounter = HatCounter + 1
				
				local phys = exhat:GetPhysicsObject()
				if ValidEntity(phys) then
					phys:SetMass(1)
					phys:ApplyForceCenter( pl:GetVelocity()+Vector(0,0,math.random(200,300)) )
					phys:ApplyForceOffset( Vector(0,0,-math.random(20,50)), exhat:GetPos()+Vector(0,0,10) )
				end
				
				exhat:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				
				exhat:SetHealth ( 9999 )
				
				if not ValidEntity(phys) then
					exhat:Remove()
				end
				
				timer.Simple(10,function( ent ) 
					if ValidEntity(ent) then
						ent:Remove() 
					end
					HatCounter = HatCounter - 1
				end,exhat)
			end
		end
		pl.Hat:Remove()
		pl.Hat = nil
	end
	
end
]==]

function GM:PlayerNoClip ( pl, on )	
	if pl:IsAdmin() and ALLOW_ADMIN_NOCLIP and pl:Team() ~= TEAM_SPECTATOR and not pl:IsFreeSpectating() then
		if pl:GetMoveType() ~= MOVETYPE_NOCLIP then
			for k, v in pairs( player.GetAll() ) do
				v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," turned ",Color(255,0,0),"ON",Color(235,235,255)," noclip."} )
			end
		else
			for k, v in pairs( player.GetAll() ) do
				v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," turned ",Color(255,0,0),"OFF",Color(235,235,255)," noclip."} )
			end
		end
		
		return true
	end
	
	return false
	--return pl:IsAdmin() and ALLOW_ADMIN_NOCLIP and pl:Team() ~= TEAM_SPECTATOR
end

function GM:OnPhysgunFreeze( weapon, phys, ent, pl )
	return true
end

function GM:OnPhysgunReload( weapon, pl )
end

function GM:PlayerSay( player, text, teamonly )
	return player:Team() ~= TEAM_SPECTATOR
end

function TrueVisible(posa, posb)
	-- local filt = ents.FindByClass("projectile_*")
	-- filt = table.Add(filt, ents.FindByClass("npc_*"))
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
end

function FromBehind( attacker, pl )
	local ang1 = (pl:GetPos()-attacker:GetPos()):Angle()
	local ang2 = pl:GetAngles()
	ang1.p = 0
	ang2.p = 0
	local dot = ang1:Forward():DotProduct(ang2:Forward())
	if dot > 0.5 then
		return true
	end
	return false
end

-- Point is location, kill is whether it's a kill, distance is distance affected
function SoMuchBlood(point, kill, distance)
	local hax = {}
	local dirvec
	for k, v in pairs(team.GetPlayers(TEAM_HUMAN)) do
		dirvec = v:GetPos()-point
		if (dirvec:Length() <= distance) then
			table.insert(hax, { pl = v, severity = math.Clamp(math.Round(1-distance/dirvec:Length())*5,1,5 )} )
		end
	end
	
	for k, v in pairs(hax) do
		net.Start("BloodSplatter")
			net.WriteDouble(v.severity)
			net.WriteBit(kill and 1 or 0)
		net.Send(v.pl)
	end
end

function GM:PlayerDeathSound()
	return true
end

--Can a player suicide (by using the kill command)
function GM:CanPlayerSuicide(pl)
	--Suicide disabled at end round
	if ENDROUND then
		return false
	end

	--Humans can't suicide in first waves
	if pl:Team() == TEAM_HUMAN and CurTime() < WARMUPTIME then 
		return false
	end
	
	--Spectators can't suicide
	if pl:Team() == TEAM_SPECTATOR then
		return false
	end
	
	--Boss zombies can't suicide
	if pl:Team() == TEAM_UNDEAD and pl:IsBossZombie() then
		return false
	end
	
	return true
end

function ChemBomb( pl,suicide )
	if not pl:IsValid() then return end
	
	local damage,radius
	if suicide then 
		damage = 20
		radius = 100
	else
		damage = 40
		radius = 150
	end
	
	util.BlastDamage ( pl, pl, pl:GetPos() + Vector(0,0,16), radius, damage )

	if REDEEM and AUTOREDEEM and util.tobool(pl:GetInfoNum("_zs_autoredeem",1)) and not LASTHUMAN then-- pl.AutoRedeem
		if REDEEM_KILLS <= pl:Frags() then
			pl:Redeem()
		end
	end
end

--Obsolete ban function
function BanIdiot(pl)
end

--Spawnprotection
function SpawnProtection(pl)
	if pl:IsValid() and pl:IsPlayer() then
		if pl:Team() == TEAM_UNDEAD then
			if TranslateMapTable[ game.GetMap() ] and TranslateMapTable[ game.GetMap() ].ZombieSpawnProtection then
			local tim = TranslateMapTable[ game.GetMap() ].ZombieSpawnProtection
				if pl:GetZombieClass() == 1 and not pl.Suicided then
					-- print("Def. Speed is "..pl:GetMaxSpeed().." Settin' to "..math.Round(ZombieClasses[pl:GetZombieClass()].Speed * 1.3))
					GAMEMODE:SetPlayerSpeed(pl, math.Round(ZombieClasses[pl:GetZombieClass()].Speed * 1.3))
					pl.SpawnProtected1 = true
					timer.Create(pl:UserID().."SpawnProtection", tim, 1, DeSpawnProtection, pl)
					umsg.Start("EnableZombieBoost", pl)
					umsg.End()
				end
			end
		end
	end
end

function DeSpawnProtection(pl)
	if pl:IsValid() and pl:IsPlayer() then
		if pl:Team() == TEAM_UNDEAD then
			if pl:Alive() then
				if pl:GetMaxSpeed() == math.Round(ZombieClasses[pl:GetZombieClass()].Speed * 1.3) then
					-- print("Speed is "..pl:GetMaxSpeed().." Settin' to "..math.Round(ZombieClasses[pl:GetZombieClass()].Speed))
					GAMEMODE:SetPlayerSpeed(pl, ZombieClasses[pl:GetZombieClass()].Speed)
					pl.SpawnProtected1 = false
				end
			end
		elseif pl:Team() == TEAM_HUMAN then
			pl.SpawnProtected1 = false
		end
	end
end

function GM:WeaponEquip(weapon)
end

local PickUpMessageTimer = 0
function WeaponPickupNotify ( owner, PrintName )
	if not ValidEntity ( owner ) then return end

	if PickUpMessageTimer <= CurTime() then
		owner:Notice ("You have picked up a(n) "..PrintName.." . Use it wisely!",3, Color (210,210,210,255))
		PickUpMessageTimer = CurTime() + 3
	end
end

function ThrowGib(owner, wep)
	if not owner:IsValid() then return end
	if not owner:IsPlayer() then return end
	if not wep.Weapon then return end
	if owner:Alive() and owner:Team() == TEAM_UNDEAD and owner.Class == 3 then
		wep.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		GAMEMODE:SetPlayerSpeed(owner, ZombieClasses[3].Speed)
		
		local eyeangles = owner:EyeAngles()
		local vel = eyeangles:Forward():GetNormal()
		local ent = ents.Create("playergib")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos()+vel)
			ent:SetAngles(eyeangles)
			ent:SetOwner(owner)
			ent:SetModel(HumanGibs[math.random(5, 7)])
			ent:SetMaterial("models/flesh")
			ent:Spawn()
			if not ent:IsInWorld() then
				ent:Remove()
				return
			end
			
			vel = vel * 4500
			ent:GetPhysicsObject():SetMass(10)
			ent:GetPhysicsObject():ApplyForceCenter(vel)
			ent:EmitSound("npc/headcrab_poison/ph_jump"..math.random(1,3)..".wav")
		end
	end
end

concommand.Add("zs_class", function(sender, command, arguments)
	if arguments[1] == nil then return end
	if sender:Team() ~= TEAM_UNDEAD or sender.Revive then return end
	arguments = table.concat(arguments, " ")

	for i=0, #ZombieClasses do
		if string.lower(ZombieClasses[i].Name) == string.lower(arguments) then
			if ZombieClasses[i].Hidden then
				sender:PrintMessage(HUD_PRINTTALK, "AND STOP SHOUTING! I'M NOT DEAF!")
			elseif not ZombieClasses[i].Unlocked and GetInfliction() < ZombieClasses[i].Infliction then
				sender:PrintMessage(HUD_PRINTTALK, "That class is not unlocked yet. It will be unlocked at wave "..ZombieClasses[i].Wave.."")
			elseif sender.Class == i and not sender.DeathClass then
				sender:PrintMessage(HUD_PRINTTALK, "You are already a "..ZombieClasses[i].Name.."!")
			else
				sender:PrintMessage(HUD_PRINTTALK, "You will spawn as a "..ZombieClasses[i].Name..".")
				sender.DeathClass = i
			end
		    return
		end
	end
end)

concommand.Add("water_death", function(sender, command, arguments)
	if sender:Alive() then
		sender:Kill()
		sender:EmitSound("player/pl_drown"..math.random(1, 3)..".wav")
	end
end)

concommand.Add("cramped_death", function(sender, command, arguments)
	if sender:Alive() then
		sender:Kill()
		sender:EmitSound("physics/flesh/flesh_bloody_break.wav")
		PrintMessageAll(HUD_PRINTTALK,""..sender:Name().."'s spine turned into dust.")
	end
end)

util.PrecacheSound("ambient/voices/citizen_punches2.wav")
concommand.Add("Shove", function(sender, command, arguments)
	if not ALLOW_SHOVE then return end
	if not (sender:Alive() and sender:Team() == TEAM_HUMAN and CurTime() >= sender.NextShove) then return end
	local ent = Entity(tonumber(arguments[1]))
	if not (ent and ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_HUMAN) then return end
	local shootpos = sender:GetShootPos()
	if shootpos:Distance(ent:GetPos() + Vector(0,0,36)) <= 50 then
		local vVel = sender:GetAimVector()
		vVel.z = 0
		local _start = ent:GetPos() + vVel * 32
		local tr = util.TraceLine({start = _start, endpos = _start - Vector(0,0,32)})
		if tr.Hit then
			sender.NextShove = CurTime() + 1.5
			ent:EmitSound("ambient/voices/citizen_punches2.wav", 80, math.random(76, 85))
			ent:SetVelocity(vVel:GetNormal() * 340 + Vector(0,0,32))
		end
	end
end)

util.PrecacheSound("player/pl_pain5.wav")
util.PrecacheSound("player/pl_pain6.wav")
util.PrecacheSound("player/pl_pain7.wav")
function DoPoisoned ( ent, owner, timername )
	if not (ent:IsValid() and ent:Alive()) then
		timer.Destroy(timername)
		return
	end
	
	local damage --  damage taken
	local viewpunchangle = Angle (0,0,0) --  view punch for each poison tick
	
	if ent:HasBought("naturalimmunity") then
		damage = math.random (1,2)
		viewpunchangle = Angle(math.random(-5, 5), math.random(-5, 5), math.random(-10, 10))
	else
		damage = math.random (3,4)
		viewpunchangle = Angle(math.random(-10, 10), math.random(-10, 10), math.random(-20, 20))
	end
	
	ent:ViewPunch(viewpunchangle)

	if ent:Health() > damage then
		ent:SetHealth(ent:Health() - damage)
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
	else
		ent:TakeDamage(damage, owner)
	end
	
	ent:Notice("You have lost "..damage.." health because of a poison spit!",3, Color (240,5,5,255))
end

-- Update server stats
function GM:UpdateServerStats()

	local index = 0
	local myid = ""
	local temp = {}
	local toDisplay = {}
	
	for key, pl in pairs(player.GetAll()) do
		if not pl:IsBot() and pl:GetScore("undeadkilled") ~= nil then
		
		toDisplay = {}
		myid = pl:SteamID()

		
		local function AddDisplay( title, ind )
			table.insert(toDisplay,"RANK: "..pl:Name().." is now number "..ind.." on "..title)
		end
		
		-- Top zombies killed in one round 
		index = 1
		switchindex = 0
		for k, v in ipairs(self.DataTable[1].players) do
			if pl:SteamID() == v.steamid then
				switchindex = k
			end
			if pl.ZombiesKilled < v.value then
				index = index+1
			end
		end
		
		if index < 6 then
			if switchindex == 0 then
				table.insert( self.DataTable[1].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = pl.ZombiesKilled })
				self.DataTable[1].players[6] = nil
				AddDisplay(string.lower(self.DataTable[1].title),index)
			elseif switchindex >= index then
				if index ~= switchindex then
					table.remove(self.DataTable[1].players,switchindex)
					table.insert(self.DataTable[1].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = pl.ZombiesKilled })
					AddDisplay(string.lower(self.DataTable[1].title),index)
				else
					self.DataTable[1].players[index].value = pl.ZombiesKilled
				end
			end
		end

		-- Top zombies killed overall
		index = 1
		switchindex = 0
		zombskilled = pl:GetScore("undeadkilled")
		for k, v in ipairs(self.DataTable[2].players) do
			if pl:SteamID() == v.steamid then
				switchindex = k
			end
			if zombskilled < v.value then
				index = index+1
			end
		end
		
		if index < 6 then
			if switchindex == 0 then
				table.insert( self.DataTable[2].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = zombskilled })
				self.DataTable[2].players[6] = nil
				AddDisplay(string.lower(self.DataTable[2].title),index)
			elseif switchindex >= index then
				if index ~= switchindex then
					table.remove(self.DataTable[2].players,switchindex)
					table.insert(self.DataTable[2].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = zombskilled })
					AddDisplay(string.lower(self.DataTable[2].title),index)
				else
					self.DataTable[2].players[index].value = zombskilled
				end
			end
		end


		-- Top brains eaten in one round 
		index = 1
		switchindex = 0
		for k, v in ipairs(self.DataTable[3].players) do
			if pl:SteamID() == v.steamid then
				switchindex = k
			end
			if pl.BrainsEaten < v.value then
				index = index+1
			end
		end
		
		if index < 6 then
			if switchindex == 0 then
				table.insert( self.DataTable[3].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = pl.BrainsEaten })
				self.DataTable[3].players[6] = nil
				AddDisplay(string.lower(self.DataTable[3].title),index)
			elseif switchindex >= index then
				if index ~= switchindex then
					table.remove(self.DataTable[3].players,switchindex)
					table.insert(self.DataTable[3].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = pl.BrainsEaten })
					AddDisplay(string.lower(self.DataTable[3].title),index)
				else
					self.DataTable[3].players[index].value = pl.BrainsEaten
				end
			end
		end

		-- Top brains eaten overall
		index = 1
		switchindex = 0
		humskilled = pl:GetScore("humanskilled")
		for k, v in ipairs(self.DataTable[4].players) do
			if pl:SteamID() == v.steamid then
				switchindex = k
			end
			if humskilled < v.value then
				index = index+1
			end
		end
		
		if index < 6 then
			if switchindex == 0 then
				table.insert( self.DataTable[4].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = humskilled })
				self.DataTable[4].players[6] = nil
				AddDisplay(string.lower(self.DataTable[4].title),index)
			elseif switchindex >= index then
				if index ~= switchindex then
					table.remove(self.DataTable[4].players,switchindex)
					table.insert(self.DataTable[4].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = humskilled })
					AddDisplay(string.lower(self.DataTable[4].title),index)
				else
					self.DataTable[4].players[index].value = humskilled
				end
			end
		end		
		
		
		-- Longest last human
		if pl.LastHumanTime then
			index = 1
			switchindex = 0
			local length = CurTime()-pl.LastHumanTime
			for k, v in ipairs(self.DataTable[5].players) do
				if pl:SteamID() == v.steamid then
					switchindex = k
				end
				if length < v.value then
					index = index+1
				end
			end
			
			if index < 6 then
				if switchindex == 0 then
					table.insert( self.DataTable[5].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = length})
					self.DataTable[5].players[6] = nil
					AddDisplay(string.lower(self.DataTable[5].title),index)
				elseif switchindex >= index then
					if index ~= switchindex then
						table.remove(self.DataTable[5].players,switchindex)
						table.insert(self.DataTable[5].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = length })
						AddDisplay(string.lower(self.DataTable[5].title),index)
					else
						self.DataTable[5].players[index].value = length
					end
				end
			end
		end

		-- Longest playtime
		index = 1
		switchindex = 0
		timeplayed = pl.DataTable["timeplayed"]
		for k, v in ipairs(self.DataTable[6].players) do
			if pl:SteamID() == v.steamid then
				switchindex = k
			end
			if timeplayed < v.value then
				index = index+1
			end
		end
		
		if index < 6 then
			if switchindex == 0 then
				table.insert( self.DataTable[6].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = timeplayed })
				self.DataTable[6].players[6] = nil
				AddDisplay(string.lower(self.DataTable[6].title),index)
			elseif switchindex >= index then
				if index ~= switchindex then
					table.remove(self.DataTable[6].players,switchindex)
					table.insert(self.DataTable[6].players, index, { name = pl:Name(), steamid = pl:SteamID(), value = timeplayed })
					AddDisplay(string.lower(self.DataTable[6].title),index)
				else
					self.DataTable[6].players[index].value = timeplayed
				end
			end
		end
		
		for k, v in pairs(toDisplay) do
			PrintMessageAll(HUD_PRINTTALK,v)
		end
		
		end -- not pl.IsBot
	end
end

trackList = {}
trackEnded = true

function StartNameTrack( admin )
	if not trackEnded then
		admin:ChatPrint("There already is a name track in progress.")
		return
	end
	trackList = {}
	for k, pl in pairs(player.GetAll()) do
		table.insert(trackList,{player = pl, name = pl:Name()})
	end
	
	trackEnded = false
end

function EndNameTrack( admin )
	admin:ChatPrint("End of name tracking! Results:")
	local result = false
	for k, tab in pairs(trackList) do
		if tab.player:IsValid() then
			if tab.player:Name() ~= tab.name then
				result = true
				admin:ChatPrint("Player "..tab.player:Name().." changed name. User ID: "..tab.player:UserID().."; Steam ID: "..tab.player:SteamID())
			end
		end
	end
	
	if not result then
		admin:ChatPrint("None!")
	end
	
	trackEnded = true
end

-- Trace player sprays
Sprays = {}

function GM:PlayerSpray( ply )
	local col = ply:TraceLine(100)
	Sprays[ply:UserID()] = { name = ply:Name(), pos = col.HitPos }
	--SendSprayData()
	
	return false -- false allows spraying
end

function SendSprayData()
	umsg.Start("SendSprays",player.GetAdmin())
		umsg.Short(table.Count(Sprays))
		for key, value in pairs(Sprays) do
			umsg.Short(key)
			umsg.String(value.name)
			umsg.Vector(value.pos)
		end
	umsg.End()
end


-- People will hate me for this
-- Ywa: Nope. They still love you.
function RaveBreak()
	umsg.Start("RaveBreak")
	umsg.End()

	Raving = true
	
	-- 1 second buildup
	timer.Simple(1,function()
		hook.Add("Think","RaveThink",RaveThink)
	end)
	
	timer.Simple(24,function()
		hook.Remove("Think","RaveThink")
		umsg.Start("RaveEnd")
		umsg.End()
		Raving = false
	end)
end

function RaveThink()
	PrintMessageAll(HUD_PRINTCENTER,"RAVE BREAK!")
end

--[=[-------------------------------------------------------
      Saves prop_phys keyvalues to a table
-------------------------------------------------------]=]
local tbKeyValues = {}
function GetKeyValues ( ent, key, value )
	if ent:GetClass() == "prop_physics" then
		local name = ent:EntIndex()
		if not tbKeyValues[name] then
			tbKeyValues[name] = {}
		end
		
		tbKeyValues[name][key] = value
	end
end
-- hook.Add ("EntityKeyValue","GetKeyValues",GetKeyValues)

--[=[-----------------------------------------------------------------
   This replaces prop_physics with multiplayer ones
------------------------------------------------------------------]=]
local function DoPhysicsMultiplayer()
	local phys = {}
	local movetype, collision, model, vPos, aAng, Skin, Mass
	
	Debug("[INIT] Converting prop_physics to multiplayer!")
	local c = 0
	-- Set-up the phys table so it matches the keyvalues one
	for k,v in ipairs ( ents.FindByClass("prop_physics") ) do
		if not table.HasValue(IgnorePhysToMult,string.lower(v:GetModel())) then
			phys[v:EntIndex()] = v
			c = c + 1
		end
	end
	for k,v in ipairs ( ents.FindByClass("prop_physics_respawnable") ) do
		if not table.HasValue(IgnorePhysToMult,string.lower(v:GetModel())) then
			phys[v:EntIndex()] = v
			c = c + 1
		end
	end

	Debug("[INIT] Found "..tostring(c).." props to convert!")
	
	c = 0
	
	for k, v in pairs(phys) do
		-- Save the original values
		local index = v:EntIndex()
		movetype = v:GetMoveType()
		collision = v:GetCollisionGroup()
		model = v:GetModel()
		vPos,aAng = v:GetPos(), v:GetAngles()
		Skin = v:GetSkin()
		Mass = nil
		local obj= v:GetPhysicsObject()
		if obj:IsValid() then
			Mass = obj:GetMass()
		end

		-- Remove the entity
		if not v:IsValid() then return end
		--v:Remove()
		SafeRemoveEntity ( v )
		
		-- Respawn the entities at multiplayer physics with same properties
		local ent = ents.Create("prop_physics_multiplayer")-- 
		if not ent:IsValid() then return end
			
		-- Add the old values
		ent:SetMoveType( movetype )
		ent:SetCollisionGroup ( collision )
				
		-- Set the new keyvalues from the table init-ed in GM:EntityKeyValue
		-- for key, val in pairs ( tbKeyValues ) do
			-- if key == index then
			local val = v:GetKeyValues()
				for i,j in pairs ( val ) do
					if i ~= "classname" then
						ent:SetKeyValue ( i, j )
					end
				end
			-- end
		-- end
				
		-- Set some values to those that aren't in the keyvalue table
		ent:SetModel ( model )
		ent:SetPos ( vPos )
		ent:SetAngles ( aAng )	
		ent:SetSkin(Skin)
				
		-- Spawn the new entity
		ent:Spawn()
		
		local obj= ent:GetPhysicsObject()
		if obj:IsValid() then
			-- obj:Sleep()
			if Mass then
				obj:SetMass(Mass)
			end
		end
		
		c = c + 1
	end
	
	Debug("[INIT] Converted "..tostring(c).." props to prop_physics_multiplayer!")
end
-- hook.Add ( "InitPostEntity","MultiplayerReplace",DoPhysicsMultiplayer )

--[=[---------------------------------------------------------
       Removes defauly half life 2 supply crates
----------------------------------------------------------]=]
local function RemoveItemCrates()
	for k,v in pairs ( ents.FindByClass ( "item_item_crate" ) ) do
		if v:IsValid() then
			v:Remove()
		end
	end
end
hook.Add ( "InitPostEntity","RemoveCrates",RemoveItemCrates )

--[=[---------------------------------------------------------
          Removes health kits / power kits
----------------------------------------------------------]=]
local function RemovePowerups()
	timer.Simple( 0.7, function()
		local Filter = { "battery" }
		for k,v in pairs ( ents.GetAll() ) do
			if IsValid( v ) then
				for i,j in pairs( Filter ) do
					if string.find( tostring( v:GetClass() ), j ) then
						SafeRemoveEntity(v)
					end
				end
			end
		end
	end )
end
hook.Add( "InitPostEntity", "RemovePowerups", RemovePowerups )

--[=[---------------------------------------------------------
       Prevent door spam - Initialize cooldown
----------------------------------------------------------]=]
local function InitDoorSpam()
	for _, ent in pairs( ents.FindByClass("prop_door_rotating") ) do
		ent.AntiDoorSpam = 0
	end
end
hook.Add ( "InitPostEntity","InitDoorSpam",InitDoorSpam )

--[=[---------------------------------------------------------
       Prevent door spam - Available for both teams
----------------------------------------------------------]=]
local function PreventDoorSpam ( pl, ent )
	if not ValidEntity ( ent ) then return end
	
	-- Only for prop_door_rotating
	local Class = ent:GetClass()
	if Class ~= "prop_door_rotating" then return end
	
	-- Cooldown
	if ent.AntiDoorSpam <= CurTime() then ent.AntiDoorSpam = CurTime() + 0.85 return true end
	
	return false
end
hook.Add ( "PlayerUse", "PreventDoorSpam", PreventDoorSpam )

--[=[---------------------------------------------------------
      Called when the Lua System shuts down
---------------------------------------------------------]=]
function OnShutDown ()
	Debug ( "Lua system is shutting down." )
end
hook.Add ( "ShutDown", "OnShutDown", OnShutDown )

Debug("[MODULE] Loaded init.lua")
