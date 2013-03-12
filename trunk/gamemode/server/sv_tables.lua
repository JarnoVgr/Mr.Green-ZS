-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

GM.TeamMostChosenClass = {}
for k,v in pairs ( HumanClasses ) do
	GM.TeamMostChosenClass[v.Name] = 0
end

for k,v in pairs ( ZombieClasses ) do
	GM.TeamMostChosenClass[v.Name] = 0
end

-- Used to translate general category to restricted category for weapon selection menu.
WeaponTypeToCategory = {}
WeaponTypeToCategory["rifle"] = "Automatic"
WeaponTypeToCategory["smg"] = "Automatic"
WeaponTypeToCategory["shotgun"] = "Automatic"
WeaponTypeToCategory["pistol"] = "Pistol"
WeaponTypeToCategory["melee"] = "Melee"
WeaponTypeToCategory["tool1"] = "Tool1"
WeaponTypeToCategory["tool2"] = "Tool2"
WeaponTypeToCategory["misc"] = "Misc"
WeaponTypeToCategory["explosive"] = "Explosive"
WeaponTypeToCategory["admin"] = "Admin"
WeaponTypeToCategory["christmas"] = "Admin"

-- Restricted weapons (mainly half life 2 ones)
WeaponsRestricted = { "weapon_stunstick", "weapon_crowbar", "weapon_pistol", "weapon_357", "weapon_ar2", "weapon_shotgun", "weapon_frag", "weapon_crossbow", "weapon_rpg" }

-- SuperAdmin only weapons 
SuperAdminOnlyWeapons = { "admin_tool_canister", "admin_tool_remover", "weapon_physgun", "weapon_physcannon", "admin_tool_sprayviewer", "admin_tool_igniter" }

GM.AmmoTranslations = {}
GM.AmmoTranslations["weapon_physcannon"] = "pistol"
GM.AmmoTranslations["weapon_ar2"] = "ar2"
GM.AmmoTranslations["weapon_shotgun"] = "buckshot"
GM.AmmoTranslations["weapon_smg1"] = "smg1"
GM.AmmoTranslations["weapon_pistol"] = "pistol"
GM.AmmoTranslations["weapon_357"] = "357"
GM.AmmoTranslations["weapon_slam"] = "pistol"
GM.AmmoTranslations["weapon_crowbar"] = "pistol"
GM.AmmoTranslations["weapon_stunstick"] = "pistol"

VoiceSetTranslate = {}
VoiceSetTranslate["models/player/alyx.mdl"] = "female"
VoiceSetTranslate["models/player/barney.mdl"] = "male"
VoiceSetTranslate["models/player/breen.mdl"] = "male"
VoiceSetTranslate["models/player/combine_soldier.mdl"] = "combine"
VoiceSetTranslate["models/player/combine_soldier_prisonguard.mdl"] = "combine"
VoiceSetTranslate["models/player/combine_super_soldier.mdl"] = "combine"
VoiceSetTranslate["models/player/eli.mdl"] = "male"
VoiceSetTranslate["models/player/gman_high.mdl"] = "male"
VoiceSetTranslate["models/player/kleiner.mdl"] = "male"
VoiceSetTranslate["models/player/monk.mdl"] = "male"
VoiceSetTranslate["models/player/mossman.mdl"] = "female"
VoiceSetTranslate["models/player/magnusson.mdl"] = "male"
VoiceSetTranslate["models/player/police.mdl"] = "combine"
VoiceSetTranslate["models/player/artic.mdl"] = "male"
VoiceSetTranslate["models/player/leet.mdl"] = "male"
VoiceSetTranslate["models/player/guerilla.mdl"] = "male"
VoiceSetTranslate["models/player/phoenix.mdl"] = "male"
VoiceSetTranslate["models/player/gasmask.mdl"] = "combine"
VoiceSetTranslate["models/player/riot.mdl"] = "male"
VoiceSetTranslate["models/player/swat.mdl"] = "male"
VoiceSetTranslate["models/player/urban.mdl"] = "male"
VoiceSetTranslate["models/player/group01/female_01.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_02.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_03.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_04.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_06.mdl"] = "female"
VoiceSetTranslate["models/player/group01/female_07.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_01.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_02.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_03.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_04.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_06.mdl"] = "female"
VoiceSetTranslate["models/player/group03/female_07.mdl"] = "female"
VoiceSetTranslate["models/player/group01/male_01.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_02.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_03.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_04.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_05.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_06.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_07.mdl"] = "male"
VoiceSetTranslate["models/player/group01/male_08.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_01.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_02.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_03.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_04.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_05.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_06.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_07.mdl"] = "male"
VoiceSetTranslate["models/player/group03/male_08.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_01.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_02.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_03.mdl"] = "male"
VoiceSetTranslate["models/player/hostage/hostage_04.mdl"] = "male"

--[==[---------------------------------------------------------
	    Resources management
---------------------------------------------------------]==]
ResourceFiles = {}

for _, filename in pairs(file.Find("resource/fonts/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "resource/fonts/"..filename  )
end

for _, filename in pairs(file.Find("materials/zombiesurvival/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/zombiesurvival/"..filename  )
end

for _, filename in pairs(file.Find("materials/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/"..filename  )
end
	
for _, filename in pairs(file.Find("materials/vgui/images/blood_splat/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/vgui/images/blood_splat/"..filename  )
end

for _, filename in pairs(file.Find("materials/decals/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/decals/"..filename  )
end

-- Sound files here
for _, filename in pairs(file.Find("sound/mrgreen/*.*", "GAME" ) ) do
	if string.find ( filename, "mp3" ) or string.find ( filename, "wav" ) then
		table.insert ( ResourceFiles, "sound/mrgreen/"..filename  )
	end
end

for _, filename in pairs(file.Find("sound/player/zombies/hate/*.*", "GAME" ) ) do  
	table.insert ( ResourceFiles, "sound/player/zombies/hate/"..filename  )
end

for _, filename in pairs(file.Find("sound/player/zombies/b/*.*", "GAME" ) ) do  
	table.insert ( ResourceFiles, "sound/player/zombies/b/"..filename  )
end

for _, filename in pairs(file.Find("sound/player/zombies/seeker/*.*", "GAME" ) ) do  
	table.insert ( ResourceFiles, "sound/player/zombies/seeker/"..filename  )
end
	
-- Sound files here
for _, filename in pairs(file.Find("sound/mrgreen/pills/*.*", "GAME" ) ) do  
	table.insert ( ResourceFiles, "sound/mrgreen/pills/"..filename  )
end
	
-- Sound files here
for _, filename in pairs(file.Find("sound/mrgreen/new/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "sound/mrgreen/new/"..filename  )
end

for _, filename in pairs(file.Find("materials/models/weapons/v_zombiearms/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/models/weapons/v_zombiearms/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/models/weapons/v_pza/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/models/weapons/v_pza/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/models/weapons/v_fza/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/models/weapons/v_fza/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/models/weapons/v_katana/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/models/weapons/v_katana/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/models/weapons/alyxgun/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/models/weapons/alyxgun/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/weapons/v_supershorty/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/weapons/v_supershorty/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/weapons/w_supershorty/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/weapons/w_supershorty/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/weapons/survivor01_hands/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/weapons/survivor01_hands/"..string.lower(filename )  )
end

for _, filename in pairs(file.Find("materials/models/Combine_turrets/Floor_turret/*.*" , "GAME") ) do
	table.insert ( ResourceFiles, "materials/models/Combine_turrets/Floor_turret/"..string.lower(filename )  )
end

local files, dir = file.Find("materials/hud3/*.*", "GAME" )
for _, filename in pairs(files) do
	table.insert ( ResourceFiles, "materials/hud3/"..filename  )
end

for _, filename in pairs(file.Find("materials/katharsmodels/gordon_freeman/*.*", "GAME" ) ) do
	table.insert ( ResourceFiles, "materials/katharsmodels/gordon_freeman/"..filename )
end

-- Present textures
for _, filename in pairs ( file.Find("materials/models/effects/*.*" , "GAME") ) do		
	table.insert ( ResourceFiles, "materials/models/effects/"..filename )
end

--[=[---------------------------------------------------------
	            Add sounds here
---------------------------------------------------------]=]

table.insert ( ResourceFiles, "sound/mrgreen/ui/menu_accept.wav"  )
table.insert ( ResourceFiles, "sound/mrgreen/ui/menu_click01.wav"  )
table.insert ( ResourceFiles, "sound/mrgreen/ui/menu_focus.wav"  )
table.insert ( ResourceFiles, "sound/mrgreen/ui/menu_countdown.wav"  )
table.insert ( ResourceFiles, "sound/weapons/melee/golf club/golf_hit-01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/golf club/golf_hit-02.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/golf club/golf_hit-03.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/golf club/golf_hit-04.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-1.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-2.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-3.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-4.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-02.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-03.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-04.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-02.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-03.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-04.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-02.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-03.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-04.wav" )
table.insert ( ResourceFiles, "sound/weapons/katana/draw.wav" )
table.insert ( ResourceFiles, "sound/weapons/katana/katana_01.wav" )
table.insert ( ResourceFiles, "sound/weapons/katana/katana_02.wav" )
table.insert ( ResourceFiles, "sound/weapons/katana/katana_03.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/melee_skull_break_01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/melee_skull_break_02.wav" )
table.insert ( ResourceFiles, "sound/weapons/alyxgun/fire01.wav" )
table.insert ( ResourceFiles, "sound/weapons/alyxgun/fire02.wav" )

table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_die_01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_idle.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_start_01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_start_02.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_gore_01.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_gore_02.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_gore_03.wav" )
table.insert ( ResourceFiles, "sound/weapons/melee/chainsaw_gore_04.wav" )



table.insert ( ResourceFiles, "sound/"..LASTHUMANSOUND )
table.insert ( ResourceFiles, "sound/"..UNLIFESOUND )

-- Deadlife sound
table.insert ( ResourceFiles, "sound/deadlife_mrgreen.mp3" )
table.insert ( ResourceFiles, "sound/deadlife_mrgreen_insane.mp3" )

-- Howler sound effects
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_death_01.wav" )
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_scream_01.wav" )
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_scream_02.wav" )
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_mad_01.wav" )
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_mad_02.wav" )
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_mad_03.wav" )
table.insert ( ResourceFiles, "sound/player/zombies/howler/howler_mad_04.wav" )

-- Add hud notice sounds
table.insert ( ResourceFiles, "sound/hud/notice_soft.wav" )

-- Zombine sounds
for _, filename in pairs( file.Find( "sound/npc/zombine/*.wav", "GAME" ) ) do
	table.insert ( ResourceFiles, "sound/npc/zombine/"..filename  )
end

-- Wraith sounds
for _, filename in pairs( file.Find( "sound/npc/stalker/*.wav" , "GAME") ) do
	table.insert ( ResourceFiles, "sound/npc/stalker/"..filename  )
end

for _, filename in pairs( file.Find( "sound/zombiesurvival/*.wav", "GAME" ) ) do
	table.insert ( ResourceFiles, "sound/zombiesurvival/"..filename  )
end

--[=[---------------------------------------------------------
	    Add Materials here
---------------------------------------------------------]=]
table.insert ( ResourceFiles, "materials/killicon/zs_zombie.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/zs_zombie.vmt"  )
table.insert ( ResourceFiles, "materials/killicon/propkill.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/propkill.vmt"  )
table.insert ( ResourceFiles, "materials/killicon/redeem.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/redeem.vmt"  )
table.insert ( ResourceFiles, "materials/killicon/fists.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/fists.vmt"  )
table.insert ( ResourceFiles, "materials/killicon/fire.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/fire.vmt"  )
table.insert ( ResourceFiles, "materials/killicon/laser.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/laser.vmt"  )
table.insert ( ResourceFiles, "materials/killicon/turret.vtf"  )
table.insert ( ResourceFiles, "materials/killicon/turret.vmt"  )
table.insert ( ResourceFiles, "materials/katharsmodels/hats/homburg/homburg_all.vmt" )
table.insert ( ResourceFiles, "materials/katharsmodels/hats/homburg/homburg_all.vtf" )
table.insert ( ResourceFiles, "materials/models/tophat/tophat.vmt" )
table.insert ( ResourceFiles, "materials/models/tophat/tophat.vtf" )
table.insert ( ResourceFiles, "materials/damageover3.vtf" )
table.insert ( ResourceFiles, "materials/damageover3.vmt" )
table.insert ( ResourceFiles, "materials/hud3/hud_warning1.vtf" ) --!!
table.insert ( ResourceFiles, "materials/hud3/hud_warning1.vmt" ) --!!
table.insert ( ResourceFiles, "materials/hud3/hud_warning2.vtf" ) --!!
table.insert ( ResourceFiles, "materials/hud3/hud_warning2.vmt" ) --!!
table.insert ( ResourceFiles, "materials/hud3/hud_info.vtf" ) --!!
table.insert ( ResourceFiles, "materials/hud3/hud_info.vmt" ) --!!
table.insert ( ResourceFiles, "materials/models/weapons/pot.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/pot.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/sledge.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/sledge.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/temptexture/handsmesh1.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/temptexture/handsmesh1.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/hammer2.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/hammer2.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/hammer.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/hammer.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/axe.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/axe.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/computer.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/computer.vmt" )
table.insert ( ResourceFiles, "materials/models/weapons/shovel.vtf" )
table.insert ( ResourceFiles, "materials/models/weapons/shovel.vmt" )
table.insert ( ResourceFiles, "materials/models/piratehat/piratehat.vmt" )
table.insert ( ResourceFiles, "materials/models/piratehat/piratehat.vtf" )
table.insert ( ResourceFiles, "materials/models/cloud/santahat/kn_santahat.vmt" )
table.insert ( ResourceFiles, "materials/models/cloud/santahat/kn_santahat.vtf" )
table.insert ( ResourceFiles, "materials/models/bunnyears/bunnyears.vmt" )
table.insert ( ResourceFiles, "materials/models/bunnyears/bunnyears.vtf" )
table.insert ( ResourceFiles, "materials/models/greenshat/greenshat.vmt" )
table.insert ( ResourceFiles, "materials/models/greenshat/greenshat.vtf" )
table.insert ( ResourceFiles, "materials/phoenix_storms/egg.vtf" )
table.insert ( ResourceFiles, "materials/phoenix_storms/egg.vmt" )
table.insert ( ResourceFiles, "materials/phoenix_storms/egg_bump.vtf" )
table.insert ( ResourceFiles, "materials/models/props_outland/pumpkin01.vmt" )
table.insert ( ResourceFiles, "materials/models/props_outland/pumpkin01.vtf" )
table.insert ( ResourceFiles, "materials/models/props_outland/pumpkin01_normal.vtf" )
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/arrow.vtf" )
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/zombie.vtf" )
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/arrow.vmt" )
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/zombie.vmt" )
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/fastzombie.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/poisonzombie.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/chemzombie.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/wraith.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/headcrab.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/poisonheadcrab.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/torso.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/zombine.vtf")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/fastzombie.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/poisonzombie.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/chemzombie.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/wraith.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/headcrab.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/poisonheadcrab.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/torso.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/zombine.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/filmgrain/filmgrain.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/filmgrain/filmgrain.vtf")
-- Howler materials
table.insert ( ResourceFiles, "materials/models/mrgreen/howler/eyes.vmt" )
table.insert ( ResourceFiles, "materials/models/mrgreen/howler/eye.vtf" )
table.insert ( ResourceFiles, "materials/models/mrgreen/howler/eyes_bright.vmt" )
table.insert ( ResourceFiles, "materials/models/mrgreen/howler/zj_diffuse.vtf" )
table.insert ( ResourceFiles, "materials/models/mrgreen/howler/zj_normal.vtf" )
table.insert ( ResourceFiles, "materials/models/mrgreen/howler/zombie_jailbait.vmt" )
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/howler.vmt")
table.insert ( ResourceFiles, "materials/zombiesurvival/classmenu/howler.vtf")

-- Zombine materials
table.insert ( ResourceFiles, "materials/models/zombie_classic/combinesoldiersheet_zombie.vtf" ) 
table.insert ( ResourceFiles, "materials/models/zombie_classic/combinesoldiersheet_zombie.vmt" ) 
table.insert ( ResourceFiles, "materials/models/zombie_classic/combinesoldiersheet.vmt" ) 

-- Zombie crosshair
table.insert ( ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_core.vtf" )  
table.insert ( ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_core.vmt" )  
table.insert ( ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_outer.vtf" )  
table.insert ( ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_outer.vmt" )  

-- Hazard icon
table.insert( ResourceFiles, "materials/effects/hazard_icon.vtf" )
table.insert( ResourceFiles, "materials/effects/hazard_icon.vmt" )

table.insert( ResourceFiles,"models/weapons/w_chainsaw.mdl")
-- table.insert( ResourceFiles,"models/weapons/w_chainsaw.phy")
-- table.insert( ResourceFiles,"models/weapons/w_chainsaw.vvd")
-- table.insert( ResourceFiles,"models/weapons/w_chainsaw.dx80.vtx")
-- table.insert( ResourceFiles,"models/weapons/w_chainsaw.dx90.vtx")
-- table.insert( ResourceFiles,"models/weapons/w_chainsaw.sw.vtx")

table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/body.vmt")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/body.vtf")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/body_n.vtf")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw.vtf")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw.vmt")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw_chain.vtf")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw_chain.vmt")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw_exp.vtf")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/parts.vtf")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/parts.vmt")
table.insert( ResourceFiles,"materials/models/weapons/w_chainsaw/parts_n.vtf")

table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/body.vmt")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/body.vtf")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/body_n.vtf")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw.vtf")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw.vmt")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw_chain.vtf")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw_chain.vmt")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw_exp.vtf")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/parts.vtf")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/parts.vmt")
table.insert( ResourceFiles,"materials/models/weapons/v_chainsaw/parts_n.vtf")



--[==[---------------------------------------------------------
	     Add models here
---------------------------------------------------------]==]
table.insert ( ResourceFiles, "models/weapons/w_sledgehammer.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_sledgehammer/v_sledgehammer.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_axe.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_axe/v_axe.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_hammer.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_hammer/v_hammer.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_shovel.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_shovel/v_shovel.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_plank.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_plank/v_plank.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_fryingpan.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_fryingpan/v_fryingpan.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_pot.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_pot/v_pot.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_keyboard.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_keyboard/v_keyboard.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_zombiearms.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_fza.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_pza.mdl" )
table.insert ( ResourceFiles, "models/player/gordon_classic.mdl" )
table.insert ( ResourceFiles, "models/katharsmodels/hats/homburg/homburg.mdl" )
table.insert ( ResourceFiles, "models/tophat/tophat.mdl" )
table.insert ( ResourceFiles, "models/piratehat/piratehat.mdl" )
table.insert ( ResourceFiles, "models/greenshat/greenshat.mdl" )
table.insert ( ResourceFiles, "models/cloud/kn_santahat.mdl" )
table.insert ( ResourceFiles, "models/bunnyears/bunnyears.mdl" )
table.insert ( ResourceFiles, "models/props_phx/misc/egg.mdl" )
-- table.insert ( ResourceFiles, "models/weapons/v_healthkit.mdl" )
table.insert ( ResourceFiles, "models/props_outland/pumpkin01.mdl" )
table.insert ( ResourceFiles, "models/effects/bday_gib01.mdl" )
-- table.insert ( ResourceFiles, "models/props_mrgreen/arrow.mdl" )

-- Katana!
table.insert ( ResourceFiles, "models/weapons/v_katana.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_katana.mdl" )

-- AlyxGun
table.insert ( ResourceFiles, "models/weapons/v_alyxgun.mdl" )

table.insert ( ResourceFiles, "models/weapons/v_supershorty/v_supershorty.mdl" )
table.insert ( ResourceFiles, "models/weapons/w_supershorty.mdl" )

-- Pipe melee
-- table.insert ( ResourceFiles, "models/weapons/v_pipe.mdl" )

-- Howler
table.insert ( ResourceFiles, "models/mrgreen/howler.mdl" )

-- Zombine viewmodel and world model
table.insert ( ResourceFiles, "models/weapons/v_zombine.mdl" )
table.insert ( ResourceFiles, "models/zombie/zombie_soldier.mdl" )
table.insert ( ResourceFiles, "models/zombie/zombie_soldier_animations.mdl" )
table.insert ( ResourceFiles, "models/zombie/zombie_soldier_animations.ani" )

-- Stalker model fix!
table.insert ( ResourceFiles, "models/wraith.mdl" )
table.insert ( ResourceFiles, "models/wraith__animations.mdl" )
table.insert ( ResourceFiles, "models/weapons/v_wraith.mdl" )

-- Precache resource table models
for k,v in pairs ( ResourceFiles ) do
	if string.find ( v, ".mdl" ) then
		util.PrecacheModel ( v )
	end
end

Debug ( "[MODULE] Loaded Tables and Resource Files." )