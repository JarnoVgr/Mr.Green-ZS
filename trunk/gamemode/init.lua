-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Third Party timer and hook profiler
--include("modules/dbugprofiler/dbug_profiler.lua")

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
AddCSLuaFile("client/cl_players.lua")
AddCSLuaFile("client/cl_waves.lua")
AddCSLuaFile("client/cl_supplies.lua")
AddCSLuaFile("client/vgui/dpingmeter.lua")
AddCSLuaFile("client/vgui/scoreboard.lua")
AddCSLuaFile("client/vgui/poptions.lua")
AddCSLuaFile("client/vgui/phelp.lua")
AddCSLuaFile("client/vgui/pclasses.lua")
AddCSLuaFile("client/vgui/pshop.lua")
AddCSLuaFile("client/vgui/phclasses.lua")
AddCSLuaFile("client/vgui/pclassinfo.lua")
AddCSLuaFile("client/vgui/pmapmanager.lua")
AddCSLuaFile("client/vgui/p_intermission_generalscore.lua")
AddCSLuaFile("client/vgui/p_intermission_teamscore.lua")
AddCSLuaFile("client/vgui/p_intermission_nitwits.lua")
AddCSLuaFile("client/vgui/p_intermission_votemap.lua")
AddCSLuaFile("client/cl_splitmessage.lua")
AddCSLuaFile("client/cl_customdeathnotice.lua")
AddCSLuaFile("client/cl_intermission.lua")
AddCSLuaFile("client/cl_outline.lua")
AddCSLuaFile("client/cl_selectionmenu.lua")
AddCSLuaFile("client/cl_director.lua")
AddCSLuaFile("client/cl_admin.lua")
AddCSLuaFile("shared/sh_animations.lua")
AddCSLuaFile("shared/sh_zombo_anims.lua")
AddCSLuaFile("client/cl_hud.lua")
AddCSLuaFile("client/cl_cratemove.lua")
AddCSLuaFile("client/cl_etherial_blend.lua")
AddCSLuaFile("client/cl_achievements.lua")
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
AddCSLuaFile("shared/shopdata/zs_shop.lua")
AddCSLuaFile("shared/zombiedata/zs_zombie_classes.lua")
AddCSLuaFile("shared/sounds/sounds.lua")
AddCSLuaFile("shared/obj_entity_extend.lua")
AddCSLuaFile("shared/sh_maps.lua")
--AddCSLuaFile("shared/achievements/sh_achievements.lua")


--JSON support
AddCSLuaFile("modules/json/json.lua")

--Debug
include("modules/debug/sv_debug.lua")

--SQL 
include("modules/sql/sv_sql.lua")

--[=[---------------------------------------------------------
	Include the server and shared files
---------------------------------------------------------]=]
include("shared.lua")
include("shared/objectivemaps/zm_gasdump_b4.lua")
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
include("server/admin_commands.lua")
include("server/doplayerdeath/sv_main.lua")
include("server/doredeem/sv_main.lua")
include("server/voice.lua") -- Team voice management
include("server/sv_director.lua") -- Director (handles supply crates spawning etc.)
include("greencoins/sv_greencoins.lua") -- Green-Coins
include("server/sv_intermission.lua")
include("server/sv_maps.lua") -- Map specific
include("server/sv_admin.lua") -- Admin commands
-- include("shared/sh_animations.lua")
-- include("shared/sh_zombo_anims.lua")
-- include("shared/sh_human_anims.lua")
include("server/anti_map_exploit.lua")
include("server/sv_poisongasses.lua")
include("server/sv_waves.lua") 
include("server/sv_pickups.lua")

--[=[---------------------------------------------------------
	        Include stand alone modules
----------------------------------------------------------]=]
--Ambient
include("modules/ambient/sv_ambient.lua")

--AFK manager
include("modules/afk/sv_afk.lua") -- AFK manager

--Damage indicator
include("modules/damage_indicator/sv_dmg_indicator.lua")

--Spectate(?)
include("modules/spectate/sv_spectate.lua")

--Dynamic walk speed
include("modules/weightspeed/sv_weightspeed.lua")

--Buddy system
--include("modules/friends/sv_friends.lua")

--New HUD
include("modules/hud/sv_init.lua")

--Nav Graph
-- include("modules/nav_graph/sh_nav_graph.lua")

--Server Stats
include("server/stats/sv_server_stats.lua")

--SkillPoints
include("modules/skillpoints/sv_skillpoints.lua")
include("modules/skillpoints/sh_skillpoints.lua")

--SkillShop
include("modules/skillshop/sv_init.lua")

--Bone Anim Library
include("modules/boneanimlib_v2/sh_boneanimlib.lua")
include("modules/boneanimlib_v2/boneanimlib.lua")

--IRC
if IRC_RELAY_ENABLED then
	print("[IRC] Module enabled")
	include("extended/irc/sv_irc.lua")
	include("modules/ircrelay/sv_ircrelay.lua")
else
	print("[IRC] Module disabled")
end

--Kill Rewards
--include("modules/kill_rewards/sv_kill_rewards.lua")

--Unstuck
include("modules/unstuck/sh_unstuck.lua")

--FPS buff
include("modules/fpsbuff/sh_buffthefps.lua")
include("modules/fpsbuff/sh_nixthelag.lua")

--Compass
include("modules/compass/sv_compass.lua")

--Dynamic MaxPlayers
include("modules/dynamic_maxplayers/sv_init.lua")

--Christmas
if CHRISTMAS then
	--Snow
	AddCSLuaFile("modules/christmas/snow.lua")
end

if HALLOWEEN then
	AddCSLuaFile("modules/halloween/blood.lua")
end

--Disable sv_alltalk and sv_visiblemaxplayers chat notification
if file.Exists("bin/gmsv_cvar3_*.dll", "LUA") then
	require("cvar3")
	local cvAllTalk = GetConVar("sv_alltalk")
	--[[if cvAllTalk:GetFlags() ~= FCVAR_NOTIFY then
		cvAllTalk:SetFlags(FCVAR_NOTIFY)
	end]]
	if cvAllTalk:GetFlags() ~= 0 then
		cvAllTalk:SetFlags(0)
	end
	
	local cvVisibleMaxPlayers = GetConVar("sv_visiblemaxplayers")
	--[[if cvVisibleMaxPlayers:GetFlags() ~= FCVAR_NOTIFY then
		cvVisibleMaxPlayers:SetFlags(FCVAR_NOTIFY)
	end]]
	if cvVisibleMaxPlayers:GetFlags() ~= 0 then
		cvVisibleMaxPlayers:SetFlags(0)
	end
end

Thres = 0
difficulty = 1 --default 1
HEAD_NPC_SCALE = math.Clamp(3 - difficulty, 1.5, 4)

--[=[---------------------------------------------------------
         Custom broadcast lua function
---------------------------------------------------------]=]
gmod.BroadcastLua = gmod.BroadcastLua or function( lua )
	local players = player.GetAll()
	for i=1,#players do
		local pl = players[i]
		if not IsValid(pl) then
			continue
		end
		
		pl:SendLua(lua)
	end
end

--[=[---------------------------------------------------------
      Give weapons to the player here
---------------------------------------------------------]=]
function GM:PlayerLoadout(pl)
end

--[=[----------------------------------------------------------------------
		Called when a player receives a SWEP
-----------------------------------------------------------------------]=]
function GM:OnWeaponEquip(pl, mWeapon)
	if not IsValid(pl) or not pl:IsPlayer() or pl:Team() ~= TEAM_HUMAN then
		return
	end

	-- Hacky way to update weapon slot count
	local EntClass = mWeapon:GetClass()
	local PrintName = mWeapon.PrintName or "weapon"

	local category = WeaponTypeToCategory[mWeapon:GetType()]
	if not category or not pl.CurrentWeapons[category] then
		return
	end
	
	pl.CurrentWeapons[category] = pl.CurrentWeapons[category] + 1
end

--[=[---------------------------------------------------------
      Called when a weapon is deployed
---------------------------------------------------------]=]
function GM:WeaponDeployed(mOwner, mWeapon, bIron)
	if not IsValid ( mOwner ) or not mWeapon:IsWeapon() then
		return
	end
	
	-- We don't want bots
	if mOwner:IsBot() then return end

	-- Weapon walking speed, health, and player human class
	local fSpeed, fHealth, iClass, fHealthSpeed = mWeapon.WalkSpeed or SPEED, mOwner:Health(), mOwner:GetHumanClass()
	
	if mOwner:GetPerk("_sboost") then
		fSpeed = fSpeed + (fSpeed*0.05)
	end
	
	if mOwner:GetPerk("_sboost3") then
		fSpeed = fSpeed + (fSpeed*0.05)
	end	
	
	if mOwner:GetPerk("_sboost2") then
		fSpeed = fSpeed + fSpeed*0.05
	end
	
	if mOwner:GetPerk("_berserker") then
		local multiplier = 0.02 + (0.5*mOwner:GetRank())/100
		fSpeed = fSpeed +(fSpeed*multiplier)
		
	elseif mOwner:GetPerk("_commando") then
		fSpeed = fSpeed - 7	
		
		if mOwner:GetPerk("_kevlarcommando2") then
			fSpeed = fSpeed*0.95
		end
		
	elseif mOwner:GetPerk("_support2") then
		fSpeed = fSpeed - 8	
		
		if mOwner:GetPerk("_bulk") then
			fSpeed = SPEED - 14
		end
		
	elseif mOwner:GetPerk("_medic") then
		local multiplier = 0.03 + (1.5*mOwner:GetRank())/100
		fSpeed = fSpeed + (fSpeed*multiplier)	
	end	
	
	fHealthSpeed = math.Clamp ( ( fHealth / 40 ), 0.8, 1 )
	
	if bIron then
		fSpeed = math.Round ( ( fSpeed * 0.8 ) * fHealthSpeed )
	else
		if mOwner:IsHolding() then
			local status = mOwner.status_human_holding
			-- for _, status in pairs(ents.FindByClass("status_human_holding")) do
				if status and IsValid(status) and status:GetOwner() == mOwner and status.GetObject and status:GetObject():IsValid() and status:GetObject():GetPhysicsObject():IsValid() then
					fSpeed = math.Round ( fSpeed * fHealthSpeed )
					-- break
				end
			-- end
		else
			fSpeed = math.Round ( fSpeed * fHealthSpeed )
					
		end
	end	
	
	if mOwner:GetPerk("_berserk") and fHealth < 41 then
		fSpeed = mWeapon.WalkSpeed * 1.1
	end		
	
	
		
	-- Change speed
	self:SetPlayerSpeed(mOwner, fSpeed)
end

--[=[---------------------------------------------------------
	      Called at map load
---------------------------------------------------------]=]
function GM:Initialize()
	--Debug
	Debug("[MAP] Travelled to: ".. tostring(game.GetMap()))

	--Creates the data/zombiesurvival folder when it doesn't exist
	if not file.IsDir("zombiesurvival","DATA") then
		file.CreateDir("zombiesurvival")
	end 
	
	--Add resource files to download
	for k,v in pairs(ResourceFiles) do
		if not file.Exists(v, "GAME") then
			Debug("[RESOURCES] Unable to add file: "..tostring(v))
		else
			resource.AddFile(v)
		end
	end
	
	GAMEMODE:SetMapList()
	GAMEMODE:SetCrates()
	GAMEMODE:SetExploitBoxes()
				
	--Set few ConVars
	game.ConsoleCommand("fire_dmgscale 1\nmp_flashlight 1\nmp_allowspectators 0\n")
end

-- Player presses F1
function OnPressF1(pl)
	if ENDROUND then
		return
	end

	-- Display help menu	
	pl:SendLua("MakepHelp()")
end

-- Player presses F2
function OnPressF2(pl)	
	local requiredScore = REDEEM_KILLS
	if pl:HasBought("quickredemp") or pl:GetRank() < REDEEM_FAST_LEVEL then
		requiredScore = REDEEM_FAST_KILLS
	end
	if not LASTHUMAN and CurTime() < (ROUNDTIME + WARMUPTIME)*0.8 then

		if REDEEM and AUTOREDEEM and pl:Team() == TEAM_UNDEAD and pl:GetScore() >= requiredScore then
			if not pl:IsBossZombie() then
				pl:Redeem()
			else
				pl:ChatPrint("Undead Boss can't redeem.")
			end
		else
			if pl:Team() == TEAM_UNDEAD then
				pl:ChatPrint("You need a score of ".. requiredScore .." to redeem.")
			end
		end
	else
		pl:ChatPrint("You can't redeem anymore.")
	end
end

-- Player presses F3
local function OnPressedF3(pl)
	if ENDROUND then
		return
	end
	
	if pl:Team() == TEAM_UNDEAD then
		-- If undead show classes menu
		if not pl:IsBossZombie() then
			pl:SendLua("DoClassesMenu()")
		end
	elseif pl:Team() == TEAM_HUMAN and pl:Alive() then
	
	local vStart = pl:GetShootPos()
	local tr = util.TraceLine ( { start = vStart, endpos = vStart + ( pl:GetAimVector() * 90 ), filter = pl, mask = MASK_SHOT } )
	local entity = tr.Entity
	
		local price = GAMEMODE.HumanWeapons[pl:GetActiveWeapon():GetClass()].Price
	
		if IsValid(entity) and entity:GetClass() == "game_supplycrate" and price then	

			skillpoints.AddSkillPoints(pl,GAMEMODE.HumanWeapons[pl:GetActiveWeapon():GetClass()].Price*0.5)
			pl:GetActiveWeapon():Remove()				
			DropWeapon(pl)
			price = price * 0.5
			pl:Message("+"..price.."SP!", 1)			
			entity:EmitSound("Breakable.Metal")		
		else
			DropWeapon(pl)
		end
	end
end
hook.Add("ShowSpare1", "PressedF3", OnPressedF3)

-- Player presses F4
function GM:ShowSpare2(pl)
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
	
	
	
	--Spawn initial supply crates
	self:SpawnSupplyCrates()
	
	--Create zombie Flashlight
	self:CreateZombieFlashLight()
	
	--Log
	--log.WorldAction("Round_Start")
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
	--local EntitiesToRemove = { "prop_ragdoll", "npc_zombie","npc_headcrab", "npc_zombie_torso", "npc_maker", "npc_template_maker", "npc_maker_template", --[=["func_door", "func_door_rotating",]=] "weapon_*", "item_ammo_*", "item_box_buckshot" }
	local EntitiesToRemove = { "prop_ragdoll", "npc_zombie","npc_headcrab", "npc_zombie_torso", "npc_maker", "npc_template_maker", "npc_maker_template", --[=["func_door", "func_door_rotating",]=] }
	
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
		local MapRemoveEnts,MapRemoveEntsByModel, MapException, MapRemoveGlass,MapRemoveEntsByModelPattern = CurrentMapTable.RemoveEntities,CurrentMapTable.RemoveEntitiesByModel, CurrentMapTable.ExceptEntitiesRemoval, CurrentMapTable.RemoveGlass, CurrentMapTable.RemoveEntitiesByModelPattern
		--local MapRemoveEnts,MapRemoveEntsByModel, MapException, MapRemoveGlass,MapRemoveEntsByModelPattern = CurrentMapTable[1],CurrentMapTable[3], CurrentMapTable[2], CurrentMapTable[4], CurrentMapTable.RemoveEntitiesByModelPattern
		-- Add entities to trash bin table 
		if MapRemoveEnts and #MapRemoveEnts > 0 then
			for i = 1, #MapRemoveEnts do
				if not string.find ( MapRemoveEnts[i], "/" ) then table.Add ( TrashBin, ents.FindByClass ( tostring ( MapRemoveEnts[i] ) ) ) end
				if string.find ( MapRemoveEnts[i], "/" ) then
					local FormatEnt = string.gsub ( tostring ( MapRemoveEnts[i] ), "/", "" )
					if IsValid ( Entity ( FormatEnt ) ) then 
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
							if IsValid ( v ) then
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
							if IsValid ( v ) then
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
						if IsValid(v) then
							local phys = v:GetPhysicsObject()
							if IsValid(phys) and phys:GetMaterial() == "glass" then
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
		if IsValid ( v ) then
			Debug ( "[INIT] Safely removing entity "..tostring ( v ).." from map "..tostring ( game.GetMap() ) )
			SafeRemoveEntity ( v )
		end
	end
end
hook.Add ( "InitPostEntity", "DeleteRestricteEnts", DeleteEntitiesRestricted )

--[=[--------------------------------------------------------
             Translates the given entity to
        another one, based on the original model
---------------------------------------------------------]=]
function GM:ModelToEntity(ent)
	if not IsValid(ent) then
		return
	end
	
	--Initialize our translation table
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
		
			--Lets add some new weapons around the map to make it more interesting!
		--["models/props_junk/garbage_plasticbottle001a.mdl"] = "weapon_zs_glock3",
		["models/props_junk/garbage_glassbottle003a.mdl"] = "weapon_zs_melee_beer",
		["models/props_junk/GlassBottle01a.mdl"] = "weapon_zs_melee_beer",
		["models/props_canal/mattpipe.mdl"] = "weapon_zs_melee_pipe2",
		["models/props_c17/furniturechair001a.mdl"] = "weapon_zs_melee_chair"

		
	}
	
	--See if the model exists in the table and if it, replace it with an entity
	local mEnt = ModelToEntity[ string.lower(ent:GetModel()) ]
	if mEnt == nil then
		return
	end

	--Recreate entity
	timer.Simple(1, function()
		if IsValid(ent) then
			local newEnt = ents.Create(mEnt)
			newEnt:SetPos(ent:GetPos())
			newEnt:SetAngles(ent:GetAngles())
			ent:Remove()
			newEnt:Spawn()
		end
	end)
end


NextAmmoDropOff = AMMO_REGENERATE_RATE
NextHeal = 0
NextQuickHeal = 0


--[=[--------------------------------------
             Last Human Event
---------------------------------------]=]
function GM:LastHuman()
	--Check if already in Last Human mode
	if LASTHUMAN then
		return
	end

	--Global var change
	LASTHUMAN = true
	
	--Everyone can talk to each other
	RunConsoleCommand("sv_alltalk", "1")
	
	--Broadcast status to clients
	gmod.BroadcastLua("GAMEMODE:LastHuman()")
	
	--Get the last human
	local LastHuman = team.GetPlayers(TEAM_HUMAN)[1]
	if not IsValid(LastHuman) then
		return
	end
	
	--Remember the time
	LastHuman.LastHumanTime = CurTime()
	
	--Log
	--log.WorldAction("Last_Human")
end

--[=[--------------------------------------------------------------------
       Restrict or allow players to turn on their flashlights
---------------------------------------------------------------------]=]
local function RestrictFlashlight(pl, switch)
	--Always allow to turn off
	if switch == false then
		return true
	end
	
	-- Allow flashlight if the weapon is not melee
	local Weapon = pl:GetActiveWeapon()

	return pl:Alive() and pl:Team() == TEAM_HUMAN
end
-- hook.Add ( "PlayerSwitchFlashlight", "RestrictFlashLight", RestrictFlashlight )

function GM:PlayerSwitchFlashlight(pl, Switch)
	if pl:Team() == TEAM_UNDEAD then
		pl.m_ZombieVision = pl.m_ZombieVision or false
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
	if (alltalk > 0) then
		return true, alltalk == 2
	end

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
	
	--Restrict zombie only weapons to Undead team members
	if ply:Team() == TEAM_UNDEAD then
		return EntClass == ZombieClasses[ply.Class].SWEP
	end
	
	--If we already have the weapon, don't do anything
	if ply:HasWeapon(EntClass) then
		return false
	end
	
	-- Notify the player if he is carrying more than 1 weapon of each type --  Dont notify anymore		
	local Category = WeaponTypeToCategory[ entity:GetType() ]
	--if Category then
		if ply.CurrentWeapons[Category] and ply.CurrentWeapons[Category] >= 1 and Category ~= "Admin" then
			--return false
			return 
		--end
	end
	
	--			
	ply.HighestAmmoType = string.lower(entity:GetPrimaryAmmoTypeString() or ply.HighestAmmoType)
	
	--  logging
	--log.PlayerAcquireWeapon( ply, entity:GetClass() )
	
	return true
end

function GM:SendAdminStats(to)
	umsg.Start("SendAdminStats",to)
		umsg.Bool(to:IsAdmin())
	umsg.End()
end

local function ChangeClass(pl, cmd, args)
	if args[1] == nil then return end
	
	if pl:Team() == TEAM_SPECTATOR then
		local Team = TEAM_HUMAN
		
		if LASTHUMAN then
			Team = TEAM_UNDEAD
		end
				
		pl:SetTeam(Team)
		
		pl:Spawn()
	end
end
concommand.Add("ChangeClass", ChangeClass)

--[=[---------------------------------------------------------
	  Crappy bypass for the FCVAR
	       CAN SERVER EXECUTE
---------------------------------------------------------]=]
function server_RunCommand( ply, command, args)
	if not ply:IsValid() then
		return
	end
	
	if command == nil then
		ErrorNoHalt("Server_RunCommand failed because there was no command to run!")
		return
	end
	
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

--Spawn hats for players
function GM:SpawnHat(pl, hattype)
	if not IsValid ( pl ) then
		return
	end
	if not pl:IsPlayer() then
		return
	end
	
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

	-- There isn't a hat with that name in the table
	if not IsHatValid then return end

	if not IsValid( pl.Hat ) and pl:Alive() then
		pl.Hat = ents.Create("sent_hat_new")
		pl.Hat:SetOwner(pl)
		pl.Hat:SetParent(pl)
		pl.Hat:SetPos( pl:GetPos() )
		
		-- Select random hat for bot
		if pl:IsBot() then
			pl.Hat:SetHatType("cigar$homburg")-- "cigar"
			--print("Setting hat to rpresent")
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
	if not IsValid ( pl ) or not pl:IsPlayer() then
		return
	end

	-- Player is a bot - testing purposes

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
	
	--[==[if suits[hattype] and (not IsValid(pl.Suit) or pl.Suit:GetHatType() ~= hattype) and pl:Team() == TEAM_HUMAN 
	and pl:GetItemsDataTable()[itemID] and (not shopData[itemID].AdminOnly or pl:IsAdmin()) then]==]
	
		if not IsValid( pl.Suit ) and pl:Alive() then
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
	if IsValid(pl.Suit) and pl.Suit.IsSuit then
		pl.Suit:Remove()
		pl.Suit = nil
	end
end

function GM:DropHat(pl)
	if IsValid(pl.Hat) and not pl.Hat.IsSuit then
		pl.Hat:Remove()
		pl.Hat = nil
	end
end

HatCounter = 0


function GM:PlayerNoClip(pl, on)	
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
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	return true
end

function GM:OnPhysgunReload(weapon, pl)
end

--Prevent spectators from using the chat
--[[function GM:PlayerSay(player, text, teamonly)
	return player:Team() ~= TEAM_SPECTATOR
end]]

function TrueVisible(posa, posb)
	-- local filt = ents.FindByClass("projectile_*")
	-- filt = table.Add(filt, ents.FindByClass("npc_*"))
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
end

function FromBehind(attacker, pl)
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
	local Humans = team.GetPlayers(TEAM_HUMAN)
	for i=1, #Humans do
		local pl = Humans[i]
		if not IsValid(pl) then
			continue
		end
	
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
	--[[if pl:Team() == TEAM_UNDEAD and pl:IsBossZombie() then
		return false
	end]]
	
	return true
end

--Spawnprotection
--OBSOLETE: Can this be removed?
--Duby: Made a work around for the human/zombie spawn protection in the player_spawn file.
function SpawnProtection(pl)
end
function DeSpawnProtection(pl)
end

function GM:WeaponEquip(weapon)
end

function ThrowGib(owner, wep)
	if not owner:IsValid() or not owner:IsPlayer() or not wep.Weapon then
		return
	end

	--if owner:Alive() and owner:Team() == TEAM_UNDEAD and owner.Class == 3 then
	if owner:Alive() and owner:Team() == TEAM_UNDEAD and owner.Class == 2 then
		wep.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	--	GAMEMODE:SetPlayerSpeed(owner, ZombieClasses[3].Speed)
		GAMEMODE:SetPlayerSpeed(owner, ZombieClasses[2].Speed)
		
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

util.PrecacheSound("player/pl_pain5.wav")
util.PrecacheSound("player/pl_pain6.wav")
util.PrecacheSound("player/pl_pain7.wav")
function DoPoisoned( ent, owner, timername)
	if not (ent:IsValid() and ent:Alive()) then
		timer.Destroy(timername)
		return
	end
	
	local damage --  damage taken
	local viewpunchangle = Angle (0,0,0) --  view punch for each poison tick

	damage = math.random (3,4)
	viewpunchangle = Angle(math.random(-10, 10), math.random(-10, 10), math.random(-20, 20))

	
	ent:ViewPunch(viewpunchangle)

	if ent:Health() > damage then
		ent:SetHealth(ent:Health() - damage)
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
	else
		ent:TakeDamage(damage, owner)
	end
	
	ent:Message("You have lost health because of a Poison Spit", 3)
end

--Update server stats
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

function StartNameTrack(admin)
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

function EndNameTrack(admin)
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
-- Duby: Removed it for a while as some admins are retarded and use it every game. 
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

--[=[---------------------------------------------------------
       Removes defauly half life 2 supply crates
----------------------------------------------------------]=]
local function RemoveItemCrates()
	for k,v in pairs(ents.FindByClass("item_item_crate")) do
		if IsValid(v) then
			v:Remove()
		end
	end
end
hook.Add("InitPostEntity", "RemoveCrates", RemoveItemCrates)

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
	for _, ent in pairs(ents.FindByClass("prop_door_rotating")) do
		ent.NextUse = 0
	end
end
hook.Add("InitPostEntity", "InitDoorSpam", InitDoorSpam)

--[=[---------------------------------------------------------
       Prevent door spam - Available for both teams
----------------------------------------------------------]=]
local function PreventDoorSpam(pl, ent)
	if not IsValid(ent) or ent:GetClass() ~= "prop_door_rotating" then
		return
	end

	--Cooldown
	if CurTime() <= ent.NextUse then
		return false
	end
	
	ent.NextUse = CurTime() + 0.85
	return true
end
hook.Add("PlayerUse", "PreventDoorSpam", PreventDoorSpam)

--[=[---------------------------------------------------------
      Called when the Lua System shuts down
---------------------------------------------------------]=]
function OnShutDown()
	Debug("Lua system is shutting down")
end
hook.Add("ShutDown", "OnShutDown", OnShutDown)

--[=[---------------------------------------------------------
      Slowdown when walking backwards.
---------------------------------------------------------]=]

function GM:KeyPress(pl, key)

	if pl:KeyPressed(IN_JUMP) then
		if (pl:Team() == TEAM_HUMAN and pl:GetJumpPower() > 0 and pl:GetVelocity():Length2D() > 230 and pl.LastJump + 0.8 > CurTime()) or (pl:Team() == TEAM_UNDEAD and pl:GetJumpPower() > 0 and pl:GetVelocity():Length2D() > 130 and pl.LastJump + 0.8 > CurTime()) then
			pl:SetJumpPower(20)
		else
			pl.LastJump = CurTime()			
			pl:SetJumpPower(190) 		
		end
	end

	if pl:Team() ~= TEAM_HUMAN then
		return
	end
	
	if pl:KeyPressed(IN_FORWARD) then
		pl.WalkingBackwards = false
		pl:CheckSpeedChange()		
	elseif pl:KeyPressed(IN_BACK) or pl:KeyDown(IN_BACK) then
		pl.WalkingBackwards = true
		pl:CheckSpeedChange()		
	else
		pl.WalkingBackwards = false
		pl:CheckSpeedChange()		
	end
	

end

--[=[----------------------------------------------------------------------
     Grave Digger suit health on death
---------------------------------------------------------------------------]=]
--TODO: Move to somewhere else
local SpecialWeapons = {
	["weapon_zs_melee_crowbar"] = true,
	["weapon_zs_melee_shovel"] = true,
	["weapon_zs_melee_axe"] = true,
	["weapon_zs_melee_fryingpan"] = true,
	["weapon_zs_melee_keyboard"] = true,
	["weapon_zs_melee_plank"] = true,
	["weapon_zs_melee_pot"] = true,
	["weapon_zs_melee_katana"] = true,
	["weapon_zs_melee_sledgehammer"] = true,	
	["weapon_zs_fists2"] = true,
	["weapon_zs_melee_pipe"] = true,
	["weapon_zs_melee_pipe2"] = true,
	["weapon_zs_melee_hook"] = true,
	["weapon_zs_melee_chainsaw"] = true	
}

hook.Add("PlayerDeath", "GraveDiggerHealth", function(victim, inflictor, attacker)
	if not inflictor then
		return
	end
	
	if not IsValid(attacker) or not attacker:IsPlayer() or attacker:Team() ~= TEAM_HUMAN then
		return
	end
		
	if attacker:Health() >= 100 then
		return
	end
		
	if attacker:GetPerk("_berserker") then
		local multiplier = attacker:GetRank()
		attacker:SetHealth(attacker:Health() + multiplier + 4)
		
		if attacker:GetPerk("_psychotic") then
			attacker:SetHealth(attacker:Health() + 4)
		end
		if attacker.DataTable["ShopItems"][80] then
			attacker:SetHealth(attacker:Health() + 3)
		end		
	end

end)