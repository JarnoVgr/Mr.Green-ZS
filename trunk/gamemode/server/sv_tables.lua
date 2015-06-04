-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

GM.TeamMostChosenClass = {}
--for k,v in pairs ( HumanClasses ) do
	--GM.TeamMostChosenClass[v.Name] = 0
--end

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

WeaponClassToCategory = {}
WeaponClassToCategory["support"] = "Support"
WeaponClassToCategory["medic"] = "Medic"
WeaponClassToCategory["sharpshooter"] = "Sharpshooter"
WeaponClassToCategory["berserker"] = "Berserker"
WeaponClassToCategory["commando"] = "Commando"
WeaponClassToCategory["engineer"] = "Engineer"

-- Restricted weapons (mainly half life 2 ones)
WeaponsRestricted = { "weapon_stunstick", "weapon_crowbar", "weapon_pistol", "weapon_357", "weapon_ar2", "weapon_shotgun", "weapon_frag", "weapon_crossbow", "weapon_rpg" }

-- SuperAdmin only weapons 
SuperAdminOnlyWeapons = { "admin_tool_canister", "admin_tool_remover", "weapon_physgun", "weapon_physcannon", "admin_tool_sprayviewer", "admin_tool_igniter", "admin_maptool" }

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
VoiceSetTranslate["models/player/group03m/male_01.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_02.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_03.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_04.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_05.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_06.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_07.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_08.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/male_09.mdl"] = "male"
VoiceSetTranslate["models/player/group03m/female_01.mdl"] = "female"
VoiceSetTranslate["models/player/group03m/female_02.mdl"] = "female"
VoiceSetTranslate["models/player/group03m/female_03.mdl"] = "female"
VoiceSetTranslate["models/player/group03m/female_04.mdl"] = "female"
VoiceSetTranslate["models/player/group03m/female_05.mdl"] = "female"
VoiceSetTranslate["models/player/group03m/female_06.mdl"] = "female"

--[==[---------------------------------------------------------
	    Resources management
---------------------------------------------------------]==]
ResourceFiles = {}

--Particles
local files = {"butt_fart1.pcf", "cig_smoke.pcf", "cig_smoke_dx80.pcf"}
for _, filename in pairs(files) do
	table.insert(ResourceFiles, "particles/".. filename)
end

--Fonts
local files = {"akbar.ttf", "corpuscare.ttf", "Fears.ttf", "zsnew.ttf", "Futurot.ttf"}
for _, filename in pairs(files) do
	table.insert(ResourceFiles, "resource/fonts/".. filename)
end

--
for _, filename in pairs(file.Find("materials/zombiesurvival/*.*", "GAME") ) do
	table.insert(ResourceFiles, "materials/zombiesurvival/"..filename  )
end

for _, filename in pairs(file.Find("materials/vgui/images/blood_splat/*.*" , "GAME") ) do
	table.insert(ResourceFiles, "materials/vgui/images/blood_splat/"..filename  )
end

--Blood spray decals
for i=1,8 do
	local filename = "blood_spray".. i ..".vmt"
	table.insert(ResourceFiles, "materials/decals/".. filename)
end

--Sound files here
for _, filename in pairs(file.Find("sound/mrgreen/*.*", "GAME") ) do
	if string.find(filename, "mp3") or string.find(filename, "wav") then
		table.insert(ResourceFiles, "sound/mrgreen/"..filename  )
	end
end

for _, filename in pairs(file.Find("sound/player/zombies/hate/*.*", "GAME")) do  
	table.insert(ResourceFiles, "sound/player/zombies/hate/"..filename)
end

for _, filename in pairs(file.Find("sound/player/zombies/b/*.*", "GAME")) do  
	table.insert(ResourceFiles, "sound/player/zombies/b/"..filename)
end

for _, filename in pairs(file.Find("sound/player/zombies/seeker/*.*", "GAME")) do  
	table.insert(ResourceFiles, "sound/player/zombies/seeker/".. filename)
end

for _, filename in pairs(file.Find("sound/mrgreen/ambient/random/*.mp3", "GAME")) do
	--Randomized to improve download speed
	if math.random(1,3) == 3 then
		table.insert(ResourceFiles, "sound/mrgreen/ambient/random/".. filename)
	end
end

for _, filename in pairs(file.Find("sound/mrgreen/ambient/random/*.wav", "GAME")) do
	table.insert(ResourceFiles, "sound/mrgreen/ambient/random/".. filename)
end
	
--Pills taunts
for _, filename in pairs(file.Find("sound/mrgreen/pills/*.*", "GAME")) do  
	table.insert(ResourceFiles, "sound/mrgreen/pills/".. filename)
end
--greenshat.mdl	
--Sound files here
for _, filename in pairs(file.Find("sound/mrgreen/new/*.*", "GAME")) do
	table.insert(ResourceFiles, "sound/mrgreen/new/".. filename)
end

--
for _, filename in pairs(file.Find("sound/mrgreen/supplycrates/*.*", "GAME")) do
	table.insert(ResourceFiles, "sound/mrgreen/supplycrates/".. filename)
end

--HUD warning and info notice icons
local files, dir = file.Find("materials/hud3/*.*", "GAME")
for _, filename in pairs(files) do
	table.insert(ResourceFiles, "materials/hud3/".. filename)
end

--Present textures --This is probably a hat
local files = {"bday_gift01.vtf", "bday_gift01.vmt", "bday_gift01_blue.vmt", "bday_gift01_blue.vtf"}
for _, filename in pairs(files) do
	table.insert(ResourceFiles, "materials/models/effects/".. filename)
end

--UI sounds
table.insert(ResourceFiles, "sound/mrgreen/ui/menu_accept.wav")
table.insert(ResourceFiles, "sound/mrgreen/ui/menu_click01.wav")
table.insert(ResourceFiles, "sound/mrgreen/ui/menu_focus.wav")
table.insert(ResourceFiles, "sound/mrgreen/ui/menu_countdown.wav")
--table.insert(ResourceFiles, "sound/mrgreen/supplycrates/thunder3.mp3")


--Game start music (random to improve download speed)
table.insert(ResourceFiles, "sound/mrgreen/music/gamestart".. math.random(2,4) ..".mp3")
--table.insert(ResourceFiles, "sound/mrgreen/music/gamestart4.mp3")
--table.insert(ResourceFiles, "sound/mrgreen/music/gamestart2.mp3")

if CHRISTMAS then
	table.insert(ResourceFiles, "sound/mrgreen/music/gamestart_xmas.mp3")
end

--Last human music
table.insert(ResourceFiles, "sound/mrgreen/music/lasthuman.mp3")

--Intermission
table.insert(ResourceFiles, "sound/mrgreen/music/intermission.mp3")
table.insert(ResourceFiles, "sound/mrgreen/music/intermission_undead.mp3")

--SlowMo effect sound
table.insert(ResourceFiles, "sound/mrgreen/new/slowmo_down.mp3")
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/mrgreen/new/slowmo_up.mp3")
end

--Unlife music (2 variants)
table.insert(ResourceFiles, "sound/mrgreen/music/deadlife.mp3")
table.insert(ResourceFiles, "sound/mrgreen/music/deadlife_insane.mp3")
--table.insert(ResourceFiles, "sound/mrgreen/music/bosstheme.mp3")

--Boss music (random to improve download speed)
local randDownloadId = math.random(3,4)
table.insert(ResourceFiles, "sound/mrgreen/music/bosstheme".. randDownloadId ..".mp3")

if CHRISTMAS then
	--Christmas lights
	table.insert(ResourceFiles, "materials/effects/tiledfile/firelayeredslowtiled512.vtf")
	table.insert(ResourceFiles, "materials/models/lightwarps/weapon_lightwarp.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_colored_lights.vmt")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_colored_lights_blu.vmt")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_colored_lights_white.vmt")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_colored_lights.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_colored_lights_blu.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_coloredlights_anim.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_coloredlights_anim000.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_coloredlights_anim001.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_coloredlights_anim002.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_coloredlights_blue_anim.vtf")
	table.insert(ResourceFiles, "materials/models/player/items/heavy/xms_coloredlights_white_anim.vtf")
	table.insert(ResourceFiles, "models/player/items/scout/xms_bat.mdl")
	table.insert(ResourceFiles, "models/player/items/scout/xms_scattergun.mdl")
	table.insert(ResourceFiles, "models/player/items/scout/xms_wrench.mdl")
	table.insert(ResourceFiles, "models/player/items/medic/xms_medigun.mdl")
	table.insert(ResourceFiles, "models/player/items/sniper/xms_sniperrifle.mdl")

	--Christmas snow
	table.insert(ResourceFiles, "materials/particle/cloud.vtf")
	table.insert(ResourceFiles, "materials/particle/cloud.vmt")
	table.insert(ResourceFiles, "materials/particle/snow.vmt")
	table.insert(ResourceFiles, "materials/particle/snow.vtf")
end

--Soft-notice HUD
table.insert(ResourceFiles, "sound/hud/notice_soft.wav")

--Zombine
table.insert(ResourceFiles, "models/weapons/v_zombine.mdl")
table.insert(ResourceFiles, "models/zombie/zombie_soldier.mdl")
table.insert(ResourceFiles, "models/zombie/zombie_soldier_animations.mdl")
table.insert(ResourceFiles, "models/zombie/zombie_soldier_animations.ani")
local files = {"combinesoldiersheet.vmt", "combinesoldiersheet_zombie.vmt","combinesoldiersheet_zombie.vtf", "combinesoldiersheet_zombie_normal.vtf", "combinesoldiersheet_zombie_phong.vtf"}
for _, filename in pairs(files) do
	table.insert(ResourceFiles, "materials/models/zombie_classic/".. filename)
end
for _, filename in pairs(file.Find("sound/npc/zombine/*.wav", "GAME")) do
	table.insert(ResourceFiles, "sound/npc/zombine/"..filename)
end

--Infected sounds
for _, filename in pairs(file.Find( "sound/npc/zombiegreen/*.wav" , "GAME")) do
	table.insert(ResourceFiles, "sound/npc/zombiegreen/".. filename)
end

--Beats
for _, filename in pairs(file.Find( "sound/zombiesurvival/*.wav", "GAME")) do
	table.insert(ResourceFiles, "sound/zombiesurvival/".. filename)
end

--Killicons
table.insert(ResourceFiles, "materials/killicon/zs_zombie.vtf")
table.insert(ResourceFiles, "materials/killicon/zs_zombie.vmt")
table.insert(ResourceFiles, "materials/killicon/propkill.vtf")
table.insert(ResourceFiles, "materials/killicon/propkill.vmt")
table.insert(ResourceFiles, "materials/killicon/redeem.vtf")
table.insert(ResourceFiles, "materials/killicon/redeem.vmt")
table.insert(ResourceFiles, "materials/killicon/fists.vtf")
table.insert(ResourceFiles, "materials/killicon/fists.vmt")
table.insert(ResourceFiles, "materials/killicon/fire.vtf")
table.insert(ResourceFiles, "materials/killicon/fire.vmt")
table.insert(ResourceFiles, "materials/killicon/laser.vtf")
table.insert(ResourceFiles, "materials/killicon/laser.vmt")
table.insert(ResourceFiles, "materials/killicon/turret.vtf")
table.insert(ResourceFiles, "materials/killicon/turret.vmt")
--table.insert(ResourceFiles, "materials/killicon/zs_shovel.vtf")
--table.insert(ResourceFiles, "materials/killicon/zs_shovel.vmt")

--More materials
table.insert(ResourceFiles, "materials/hud3/hud_warning1.vtf")
table.insert(ResourceFiles, "materials/hud3/hud_warning1.vmt")
table.insert(ResourceFiles, "materials/hud3/hud_warning2.vtf")
table.insert(ResourceFiles, "materials/hud3/hud_warning2.vmt")
table.insert(ResourceFiles, "materials/hud3/hud_info.vtf")
table.insert(ResourceFiles, "materials/hud3/hud_info.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/hud/danger_sign.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/hud/danger_sign.vmt")

--Class menu icons
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/zombie.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/zombie.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/fastzombie.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/fastzombie.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/poisonzombie.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/poisonzombie.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/chemzombie.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/chemzombie.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/wraith.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/wraith.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/headcrab.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/headcrab.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/poisonheadcrab.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/poisonheadcrab.vtf")
--table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/torso.vmt")
--table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/torso.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/zombine.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/zombine.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/howler.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/howler.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/ghast.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/ghast.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/freshdead.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/classmenu/freshdead.vtf")

--Human classes


table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_medic.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_medic.vmt")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_marksman.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_marksman.vmt")

table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_constructor.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_constructor.vmt")

table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_demolitions.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_demolitions.vmt")

table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_assault.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_assault.vmt")

table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_berserker.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/humanclass/avatar_berserker.vmt")


--Undead crosshair
table.insert(ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_core.vtf")  
table.insert(ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_core.vmt")  
table.insert(ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_outer.vtf")  
table.insert(ResourceFiles, "materials/zombiesurvival/crosshair/undead_crosshair_outer.vmt")

--Hazard icon
table.insert(ResourceFiles, "materials/effects/hazard_icon.vtf")
table.insert(ResourceFiles, "materials/effects/hazard_icon.vmt")


--Sniper Scope
table.insert(ResourceFiles, "materials/zombiesurvival/scope/sniper_scope.vtf")
table.insert(ResourceFiles, "materials/zombiesurvival/scope/sniper_scope.vmt")

--Chainsaw worldmodel
table.insert(ResourceFiles,"models/weapons/w_chainsaw.mdl")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/body.vmt")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/body.vtf")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/body_n.vtf")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw.vtf")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw.vmt")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw_chain.vtf")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw_chain.vmt")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/chainsaw_exp.vtf")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/parts.vtf")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/parts.vmt")
table.insert(ResourceFiles,"materials/models/weapons/w_chainsaw/parts_n.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/body.vmt")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/body.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/body_n.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw.vmt")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw_chain.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw_chain.vmt")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/chainsaw_exp.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/parts.vtf")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/parts.vmt")
table.insert(ResourceFiles,"materials/models/weapons/v_chainsaw/parts_n.vtf")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_die_01.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_idle.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_start_01.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_start_02.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_gore_01.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_gore_02.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_gore_03.wav")
table.insert(ResourceFiles, "sound/weapons/melee/chainsaw_gore_04.wav")

--Golf club
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/weapons/melee/golf club/golf_hit-01.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/golf club/golf_hit-02.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/golf club/golf_hit-03.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/golf club/golf_hit-04.wav")
end

--Crowbar
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-1.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-2.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-3.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/crowbar/crowbar_hit-4.wav")
end

--Shovel
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-01.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-02.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-03.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/shovel/shovel_hit-04.wav")
end

--Sledgehammer
table.insert(ResourceFiles, "models/weapons/w_sledgehammer.mdl")
table.insert(ResourceFiles, "materials/models/weapons/sledge.vtf")
table.insert(ResourceFiles, "materials/models/weapons/sledge.vmt")

--Axe
table.insert(ResourceFiles, "models/weapons/w_axe.mdl")
table.insert(ResourceFiles, "materials/models/weapons/axe.vtf")
table.insert(ResourceFiles, "materials/models/weapons/axe.vmt")

--Hammer
table.insert(ResourceFiles, "models/weapons/w_hammer.mdl")
table.insert(ResourceFiles, "materials/models/weapons/hammer2.vtf")
table.insert(ResourceFiles, "materials/models/weapons/hammer2.vmt")
table.insert(ResourceFiles, "materials/models/weapons/hammer.vtf")
table.insert(ResourceFiles, "materials/models/weapons/hammer.vmt")

--Shovel
table.insert(ResourceFiles, "models/weapons/w_shovel.mdl")
table.insert(ResourceFiles, "materials/models/weapons/shovel.vtf")
table.insert(ResourceFiles, "materials/models/weapons/shovel.vmt")

--Plank
table.insert(ResourceFiles, "models/weapons/w_plank.mdl")

--Frying Pan
table.insert(ResourceFiles, "models/weapons/w_fryingpan.mdl")
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-01.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-02.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-03.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/frying_pan/pan_hit-04.wav")
end

--Pot
table.insert(ResourceFiles, "models/weapons/w_pot.mdl")
table.insert(ResourceFiles, "materials/models/weapons/pot.vtf")
table.insert(ResourceFiles, "materials/models/weapons/pot.vmt")

--Keyboard
table.insert(ResourceFiles, "models/weapons/w_keyboard.mdl")
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-01.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-02.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-03.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/keyboard/keyboard_hit-04.wav")
	table.insert(ResourceFiles, "materials/models/weapons/computer.vtf")
	table.insert(ResourceFiles, "materials/models/weapons/computer.vmt")
end

--Katana
table.insert(ResourceFiles, "models/weapons/w_katana.mdl")
for _, filename in pairs(file.Find("materials/models/weapons/v_katana/*.*" , "GAME") ) do
	table.insert(ResourceFiles, "materials/models/weapons/v_katana/"..string.lower(filename )  )
end
if math.random(1, 3) == 1 then
	table.insert(ResourceFiles, "sound/weapons/katana/draw.wav")
	table.insert(ResourceFiles, "sound/weapons/katana/katana_01.wav")
	table.insert(ResourceFiles, "sound/weapons/katana/katana_02.wav")
	table.insert(ResourceFiles, "sound/weapons/katana/katana_03.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/melee_skull_break_01.wav")
	table.insert(ResourceFiles, "sound/weapons/melee/melee_skull_break_02.wav")
end

--Alyx Gun
local files = {"fire01.wav", "fire02.wav"}
for _, filename in pairs(files) do
	table.insert(ResourceFiles, "sound/weapons/alyxgun/"..string.lower(filename))
end

--Infected
table.insert(ResourceFiles, "models/weapons/v_zombiearms.mdl")
for _, filename in pairs(file.Find("materials/models/weapons/v_zombiearms/*.*", "GAME") ) do
	table.insert(ResourceFiles, "materials/models/weapons/v_zombiearms/"..string.lower(filename )  )
end
for _, filename in pairs(file.Find("sound/mrgreen/undead/infected/*.mp3" , "GAME")) do
	table.insert(ResourceFiles, "sound/mrgreen/undead/infected/".. filename)
end
for _, filename in pairs(file.Find("sound/mrgreen/undead/infected/*.wav" , "GAME")) do
	table.insert(ResourceFiles, "sound/mrgreen/undead/infected/".. filename)
end

--Fast Zombie
table.insert(ResourceFiles, "models/weapons/v_fza.mdl")
for _, filename in pairs(file.Find("materials/models/weapons/v_fza/*.*" , "GAME") ) do
	table.insert(ResourceFiles, "materials/models/weapons/v_fza/"..string.lower(filename )  )
end
for _, filename in pairs(file.Find( "sound/mrgreen/undead/fastzombie/*.wav" , "GAME")) do
	table.insert(ResourceFiles, "sound/mrgreen/undead/fastzombie/".. filename)
end

--Poison Zombie viewmodel
table.insert(ResourceFiles, "models/weapons/v_pza.mdl")
for _, filename in pairs(file.Find("materials/models/weapons/v_pza/*.*", "GAME") ) do
	table.insert(ResourceFiles, "materials/models/weapons/v_pza/"..string.lower(filename )  )
end

if math.random(1, 3) == 1 then
	--Homburg hat
	table.insert(ResourceFiles, "models/katharsmodels/hats/homburg/homburg.mdl")
	table.insert(ResourceFiles, "materials/katharsmodels/hats/homburg/homburg_all.vmt")
	table.insert(ResourceFiles, "materials/katharsmodels/hats/homburg/homburg_all.vtf")

	--Tophat
	table.insert(ResourceFiles, "models/tophat/tophat.mdl")
	table.insert(ResourceFiles, "materials/models/tophat/tophat.vmt")
	table.insert(ResourceFiles, "materials/models/tophat/tophat.vtf")

	--Pirate Hat
	table.insert(ResourceFiles, "models/piratehat/piratehat.mdl")
	table.insert(ResourceFiles, "materials/models/piratehat/piratehat.vmt")
	table.insert(ResourceFiles, "materials/models/piratehat/piratehat.vtf")

	--Green Admin hat
	--table.insert(ResourceFiles, "models/greenshat/greenshat.mdl")
	--table.insert(ResourceFiles, "materials/models/greenshat/greenshat.vmt")
	--table.insert(ResourceFiles, "materials/models/greenshat/greenshat.vtf")
end

--Green Admin hat
	table.insert(ResourceFiles, "models/greenshat/greenshat.mdl")
	table.insert(ResourceFiles, "materials/models/greenshat/greenshat.vmt")
	table.insert(ResourceFiles, "materials/models/greenshat/greenshat.vtf")

if math.random(1, 3) == 1 then
	--Santa Hat
	table.insert(ResourceFiles, "models/cloud/kn_santahat.mdl")
	table.insert(ResourceFiles, "materials/models/cloud/santahat/kn_santahat.vmt")
	table.insert(ResourceFiles, "materials/models/cloud/santahat/kn_santahat.vtf")

	--Bunny Ears hat
	table.insert(ResourceFiles, "models/bunnyears/bunnyears.mdl")
	table.insert(ResourceFiles, "materials/models/bunnyears/bunnyears.vmt")
	table.insert(ResourceFiles, "materials/models/bunnyears/bunnyears.vtf")

	--Egg hat
	table.insert(ResourceFiles, "models/props_phx/misc/egg.mdl")
	table.insert(ResourceFiles, "materials/phoenix_storms/egg.vtf")
	table.insert(ResourceFiles, "materials/phoenix_storms/egg.vmt")
	table.insert(ResourceFiles, "materials/phoenix_storms/egg_bump.vtf")

	--Pumpkin Hat
	table.insert(ResourceFiles, "models/props_outland/pumpkin01.mdl")
	table.insert(ResourceFiles, "materials/models/props_outland/pumpkin01.vmt")
	table.insert(ResourceFiles, "materials/models/props_outland/pumpkin01.vtf")
	table.insert(ResourceFiles, "materials/models/props_outland/pumpkin01_normal.vtf")
end

--CSS orange model for Poison Headcrab spit
table.insert(ResourceFiles, "models/props/cs_italy/orange.mdl")

--Present hat
table.insert(ResourceFiles, "models/effects/bday_gib01.mdl")

--Howler
table.insert(ResourceFiles, "models/mrgreen/howler.mdl")
table.insert(ResourceFiles, "materials/models/mrgreen/howler/eyes.vmt")
table.insert(ResourceFiles, "materials/models/mrgreen/howler/eye.vtf")
table.insert(ResourceFiles, "materials/models/mrgreen/howler/eyes_bright.vmt")
table.insert(ResourceFiles, "materials/models/mrgreen/howler/zj_diffuse.vtf")
table.insert(ResourceFiles, "materials/models/mrgreen/howler/zj_normal.vtf")
table.insert(ResourceFiles, "materials/models/mrgreen/howler/zombie_jailbait.vmt")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_death_01.wav")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_scream_01.wav")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_scream_02.wav")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_mad_01.wav")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_mad_02.wav")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_mad_03.wav")
table.insert(ResourceFiles, "sound/player/zombies/howler/howler_mad_04.wav")

--Gordon Freeman playermodel
table.insert(ResourceFiles, "models/player/gordon_classic.mdl")
for _, filename in pairs(file.Find("materials/katharsmodels/gordon_freeman/*.*", "GAME")) do
	table.insert(ResourceFiles, "materials/katharsmodels/gordon_freeman/".. filename)
end

--Obama materials and models
--[[for _, filename in pairs(file.Find( "materials/models/mrgreen/obama/*.*", "GAME")) do
	table.insert(ResourceFiles, "materials/models/mrgreen/obama/"..filename)
end
table.insert(ResourceFiles, "models/mrgreen/obama.mdl")
player_manager.AddValidModel("obama", "models/mrgreen/obama.mdl")]]

--Creepr (naked man)
--[[for _, filename in pairs(file.Find( "materials/models/mrgreen/creepr/*.*", "GAME")) do
	table.insert(ResourceFiles, "materials/models/mrgreen/creepr/"..filename)
end
table.insert(ResourceFiles, "models/mrgreen/creepr.mdl")
player_manager.AddValidModel("creepr", "models/mrgreen/creepr.mdl")]]

--Wraith/Ethereal
table.insert(ResourceFiles, "models/wraith.mdl")
table.insert(ResourceFiles, "models/wraith__animations.mdl")
table.insert(ResourceFiles, "models/weapons/v_wraith.mdl")
for _, filename in pairs( file.Find( "sound/npc/stalker/*.wav" , "GAME") ) do
	table.insert(ResourceFiles, "sound/npc/stalker/"..filename  )
end

--Santa Claus Boss
if CHRISTMAS then
	table.insert(ResourceFiles, "models/Jaanus/santa.mdl")
	for _, filename in pairs(file.Find("materials/Jaanus/monk/*.*", "GAME")) do
		table.insert(ResourceFiles, "materials/Jaanus/monk/".. filename)
	end
end

--HUD materials
for _, filename in pairs(file.Find("materials/mrgreen/hud/*.*", "GAME")) do
	table.insert(ResourceFiles, "materials/mrgreen/hud/".. filename)
end

--Intermission materials
for _, filename in pairs(file.Find("materials/mrgreen/intermission/*.*", "GAME")) do
	table.insert(ResourceFiles, "materials/mrgreen/intermission/".. filename)
end

--HUD arrow
table.insert(ResourceFiles, "materials/models/props_mrgreen/arrow/debugwhite.vmt")
table.insert(ResourceFiles, "models/props_mrgreen/arrow.mdl")

--Precache all models from resources
for k,v in pairs(ResourceFiles) do
	if string.find(v, ".mdl") then
		util.PrecacheModel(v)
	end
end

Debug("[MODULE] Loaded General Tables and Resource Files")