-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

MySelf = MySelf or NULL
hook.Add("Think", "GetLocal", function()
	if not ClientReady then
		ClientReady = true
		gamemode.Call("OnClientReady")
	end
	
	MySelf = LocalPlayer()
	if IsValid(MySelf) then
		hook.Remove("Think", "GetLocal")
		
		--Placeholder when there's none
		if not GAMEMODE.HookGetLocal then
			GAMEMODE.HookGetLocal = function(g)
			end
		end
		gamemode.Call("HookGetLocal", MySelf)
		RunConsoleCommand("PostPlayerInitialSpawn")
		gamemode.Call("OnSelfReady")
	end
end)

-- gm13 workaround
--TODO: Move to own utils lib
function surface.CreateFontLegacy(arg1,arg2,arg3,arg4,arg5,arg6)
	local name = arg6-- [6]-- or "None"
	local fontdata = {
		font = arg1,-- [1],-- or "Arial",
		size = arg2,-- [2],-- or 5,
		weight = arg3,-- [3],-- or 500,
		antialias = arg4,-- [4],-- or false, 
		additive = arg5,-- [5],-- or true,
	}
	surface.CreateFont(name,fontdata)
end

w, h = ScrW(), ScrH()

--Third Party timer and hook profiler
--include("modules/dbugprofiler/dbug_profiler.lua")

--Very important script
include("modules/debug/sh_debug.lua")

include("shared.lua")
include("client/cl_utils.lua")
include("shared/sh_utils.lua")
include("client/cl_chat.lua")
include("client/cl_scoreboard.lua")
include("client/cl_targetid.lua")
include("client/cl_selectionmenu.lua")
include("client/cl_hudpickup.lua")
include("client/cl_spawnmenu.lua")
include("client/cl_intermission.lua")
include("client/cl_postprocess.lua")
include("client/cl_players.lua")
include("client/cl_deathnotice.lua")
include("client/cl_supplies.lua")
include("client/cl_beats.lua")
include("client/cl_splitmessage.lua")
include("client/cl_director.lua")
include("client/vgui/poptions.lua")
include("client/vgui/phelp.lua")
include("client/vgui/pclasses.lua")
include("client/vgui/pshop.lua")
include("client/vgui/pclassinfo.lua")
include("client/vgui/pmapmanager.lua")
include("client/vgui/dpingmeter.lua")
include("client/cl_dermaskin.lua")
include("client/vgui/phclasses.lua")
include("greencoins/cl_greencoins.lua")
include("client/cl_admin.lua")
include("client/cl_customdeathnotice.lua")
include("client/cl_hud.lua")
include("client/cl_voice.lua")
include("client/cl_waves.lua")
--include("client/cl_cratemove.lua")
include("client/cl_etherial_blend.lua")
include("client/cl_achievements.lua")



--[=[-----------------------------------------------------------
		Include stand alone modules
------------------------------------------------------------]=]
--Ambient
include("modules/ambient/cl_ambient.lua")

--AFK manager
include("modules/afk/cl_afk.lua")

--Damage indicator
include("modules/damage_indicator/cl_dmg_indicator.lua")

--Dynamic walk speed
include("modules/weightspeed/sh_weightspeed.lua")

--New HUD
include("modules/hud/cl_init.lua")

--SkillPoints
include("modules/skillpoints/cl_skillpoints.lua")
include("modules/skillpoints/sh_skillpoints.lua")

--SkillShop
include("modules/skillshop/cl_init.lua")

--Player legs
include("modules/legs/cl_legs.lua")

--Chat news and game hints
include("modules/news/cl_news.lua")

--Bone Animation Library
include("modules/boneanimlib_v2/cl_boneanimlib.lua")

--SQL-stats related
include("server/stats/sh_utils.lua")

--FPS buff
include("modules/fpsbuff/sh_buffthefps.lua")
include("modules/fpsbuff/sh_nixthelag.lua")

--Compass
include("modules/compass/cl_compass.lua")

--Christmas
if CHRISTMAS then
	--Snow
	include("modules/christmas/snow.lua")
end

--
CreateClientConVar("_zs_redeemclass", 1, true, false)

color_white = Color(255, 255, 255, 220)
color_black = Color(50, 50, 50, 255)
color_black_alpha180 = Color(0, 0, 0, 180)
color_black_alpha90 = Color(0, 0, 0, 90)
color_white_alpha200 = Color(255, 255, 255, 200)
color_white_alpha180 = Color(255, 255, 255, 180)
color_white_alpha90 = Color(255, 255, 255, 90)
COLOR_INFLICTION = Color(235, 185, 0, 165)
COLOR_DARKBLUE = Color(5, 75, 150, 255)
COLOR_DARKGREEN = Color(0, 150, 0, 255)
COLOR_DARKRED = Color(185, 0, 0, 255)
COLOR_DARKRED_HUD = Color(185, 0, 0, 180)
COLOR_DARKCYAN = Color(0, 155, 155, 255)
COLOR_DARKCYAN_HUD = Color(0, 155, 155, 180)
COLOR_GRAY = Color(190, 190, 190, 255)
COLOR_GRAY_HUD = Color(190, 190, 190, 180)
COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255, 255)
COLOR_BLACK = Color(0, 0, 0, 255)

COLOR_MRGREEN = Color(0,165,132,165)
COLOR_MRGREEN2 = Color(80,120,110,165)

COLOR_HUD_OK = Color(0, 150, 0, 255)
COLOR_HUD_SCRATCHED = Color(35, 130, 0, 255)
COLOR_HUD_HURT = Color(160, 160, 0, 255)
COLOR_HUD_CRITICAL = Color(220, 0, 0, 255)

COLOR_HUD_OK2 = Color(40, 100, 40, 255)
COLOR_HUD_SCRATCHED2 = Color(25, 100, 10, 255)
COLOR_HUD_HURT2 = Color(120, 120, 40, 255)
COLOR_HUD_CRITICAL2 = Color(170, 40, 40, 255)

COLOR_AMMO = Color(200,170,150)

ENDTIME = 0
difficulty = 0

TOTALGIBS = 0

ActualNearZombies = 0

-- Loading...
local RandomText = table.Random({ 
	"Fetching your braaainns!", 
	"Messing with your data!", 
	"Braaaainnns...", 
	"Stealing your brains...", 
	"A brain a day keeps the doctor away!",
	"Messing with Lua...", 
	"Headcrabs ate your profile...", 
	"I'll load your profile right now!",
	"Don't worry, we know what we're doing!",
	"Breeding headcrab eggs...",
	"Searching for Zombie antidote...",
	"Removing blood from the map...",
	"Piling up meat...",
	"Mixing fake blood...",
	"Putting supplies into crates...",
	"Starting zombie apocalypse...",
	"Sewing zombie parts together...",
	"Inserting a coin...",
	"Waking up the Behemoth...",  
	"Spawning poison gas...",  
	"Shuffling crate spawns..."
})

local matGlow = Material("Sprites/light_glow02_add_noz")
local colHealth = Color(255, 255, 0, 255)

local CachedHumans, NextHumansCache = {}, 0
local function HeartbeatGlow()
	if MySelf:Team() ~= TEAM_UNDEAD then
		return
	end

	--Recache
	if RealTime() > NextHumansCache then
		CachedHumans = team.GetPlayers(TEAM_HUMAN)
		NextHumansCache = RealTime() + 10
	end

	local eyepos = EyePos()
	for i=1, #CachedHumans do
		local pl = CachedHumans[i]
		if not IsValid(pl) or pl:Team() ~= TEAM_HUMAN or not pl:Alive() or pl:GetPos():Distance(eyepos) > 1024 or (pl:GetSuit() == "stalkersuit" and pl:GetVelocity():Length() < 10) then
			continue
		end			
		
		local healthfrac = math.max(pl:Health(), 0) / 100
		colHealth.r = math.Approach(255, 0, math.abs(255 - 0) * healthfrac)
		colHealth.g = math.Approach(0, 255, math.abs(0 - 255) * healthfrac)
					
		local attach = pl:GetAttachment(pl:LookupAttachment("chest"))
		local pos = attach and attach.Pos or pl:LocalToWorld(pl:OBBCenter())

		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 13, 13, colHealth)
		local size = math.sin(RealTime()*3 + pl:EntIndex()) * 50 - 21
		if size > 0 then
			render.DrawSprite(pos, size * 1.5, size, colHealth)
			render.DrawSprite(pos, size, size * 1.5, colHealth)
		end
	end	
end
 
hook.Add("HUDPaint", "DrawWaiting", function()
	if ENDROUND or game.SinglePlayer() then
		return
	end
	
	draw.SimpleText("Please wait... ".. RandomText, "ArialBoldFifteen", ScrW() * 0.5, ScrH() * 0.5, Color(255, 255, 255, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("MrGreenGaming.com", "HUDFontTiny", ScrW() * 0.5, ScrH() * 0.55, Color(59, 119, 59, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if not IsValid(MySelf) then
		return
	end

	if (RealTime() - MySelf.ReadyTime) > 20 then
		MySelf.ReconnectTime = MySelf.ReconnectTime or RealTime() + 6
		draw.SimpleText("There are some troubles. Reconnecting in "..math.Clamp(math.Round(MySelf.ReconnectTime - RealTime()), 0, 10), "ArialFifteen", ScrW() * 0.5, ScrH() * 0.6, Color( 230,50,38,235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
		--Run the 'ready' command (bugged from GMod update)
		if (RealTime() - MySelf.ReadyTime) > 25 then
			RunConsoleCommand("PostPlayerInitialSpawn")
		end
				
		--Reconnect after 20 seconds
		if math.Round(MySelf.ReconnectTime - RealTime()) <= 0 then
			RunConsoleCommand("retry")
		end
	end
end)

-- Called when client loaded
function GM:OnClientReady()
	gui.EnableScreenClicker(true)
end

-- Called when myself is ready
function GM:OnSelfReady()
	MySelf.Ready, MySelf.ReadyTime = true, RealTime()
end

--Called when myself got SQL gata
function GM:OnPlayerReadySQL()
	MySelf.ReadySQLTime = CurTime()

	if MySelf:Team() == 0 then
		hook.Add("Think", "CheckUpdateData", function()
			if not IsValid(MySelf) then
				Debug("[SQL] MySelf is invalid at CheckUpdateData")
				return
			end

			if MySelf.ReadySQLTime + 2 < CurTime() then
				if MySelf.GotClassData and MySelf.GotShopData and MySelf.GotAchievementsData then
					MySelf.ReadySQL = true
					if not ENDROUND then 
						gui.EnableScreenClicker(false) 
					end
						
					--Remove wait message and this hook
					hook.Remove("HUDPaint", "DrawWaiting")
					hook.Remove("Think", "CheckUpdateData")
					
					--Class menu
					DrawSelectClass()
				end
			end
		end)
	else
		MySelf.ReadySQL = true
		hook.Remove( "HUDPaint", "DrawWaiting" )
		
		if not ENDROUND then 
			gui.EnableScreenClicker(false) 
		end
	end
end

net.Receive( "OnReadySQL", function( len )
	timer.Simple( 0.1, function()
		gamemode.Call( "OnPlayerReadySQL" )
	end)
end)

--[=[----------------------------------------------------------------------
		Called when local player receives a SWEP
-----------------------------------------------------------------------]=]
function GM:OnWeaponEquip ( pl, mWeapon )
end



if not killicon.GetFont then -- Need this for the rewards message.
	local kiaf = killicon.AddFont
	local storedfonts = {}
	local HL2Weapons = { "weapon_zs_melee_crowbar","weapon_zs_shotgun","weapon_zs_crossbow","weapon_zs_smg", "weapon_zs_pulserifle", "weapon_zs_magnum", "weapon_zs_barricadekit", "christmas_snowball",  "weapon_zs_grenade", "weapon_zs_pulsesmg", "weapon_zs_annabelle","admin_raverifle","weapon_zs_boomstick","weapon_zs_grenadelauncher","weapon_zs_minishotty","weapon_zs_classic"}
	local ZSWeapons = { "weapon_zs_melee_axe","weapon_zs_melee_fryingpan","weapon_zs_melee_keyboard","weapon_zs_melee_pot", "weapon_zs_melee_plank", "weapon_zs_tools_hammer", "weapon_zs_melee_katana" }
	
	function killicon.AddFont(sClass, sFont, sLetter, cColor)
		-- Check to see if the weapon is hl2 or css
		local IsHl2Weapon = false
		for k,v in pairs (HL2Weapons) do
			if v == sClass then
				IsHl2Weapon = true
			end
		end
		if string.find(sClass,"pickup") then
			IsHl2Weapon = true
		end
		--Good way to sort out my new killicons :D
		local IsZSWeapon = false
		
		for k,v in pairs(ZSWeapons) do
			if v == sClass then
				IsZSWeapon = true
			end
		end
		
		if GetWeaponType(sClass) == "melee" and not IsZSWeapon then
			IsHl2Weapon = true
		end
		if sClass == "weapon_zs_melee_combatknife" then
			IsZSWeapon = false
			IsHl2Weapon = false
		end
		
		
		-- Add the font to the list
		storedfonts[sClass] = { font = sFont, letter = sLetter, IsHl2 = IsHl2Weapon, IsZS = IsZSWeapon }
		kiaf(sClass, sFont, sLetter, cColor)
	end

	function killicon.GetFont ( sClass )
		return storedfonts[sClass]
	end
end

if not killicon.GetImage then
	local kia = killicon.Add
	local storedicons = {}
	
	function killicon.Add(sClass, sMat, cColor)
		storedicons[sClass] = { mat = sMat, color = cColor }
		kia(sClass, sMat, cColor)
	end

	function killicon.GetImage ( sClass )
		return storedicons[sClass]
	end
end

local Top = {}
local TopZ = {}
local TopZD = {}
local TopHD = {}

local matHumanHeadID = ""
local matZomboHeadID = ""

bloodSplats = {}
for k = 1, 8 do
	bloodSplats[k] = surface.GetTextureID("vgui/images/blood_splat/blood_splat0"..k)
end

-- Custom ConCommand Function
function client_GetCommand(um)
	if not MySelf:IsValid() then
		return
	end
	
	local command = um:ReadString()
	local stringcommand = tostring (command) -- Just in case
	local argonepresent = um:ReadBool()
	local firstarg
	
	if argonepresent then
		firstarg = tostring(um:ReadString())
	end
	
	if argonepresent == true then
		RunConsoleCommand(stringcommand, firstarg) -- pl;ConCommand ("command 1") while RunConsoleCommand is like ("command","1") !!!!
	else
		RunConsoleCommand(stringcommand)
	end
end
usermessage.Hook("client_GetCommand",client_GetCommand)

function GM:Initialize()
	self.ShowScoreboard = false

	--Initialize fonts
	surface.CreateFontLegacy("csd", 42, 500, true, true, "Signs")
	
	surface.CreateFontLegacy("csd", ScreenScale(30), 500, true, true, "CSKillIcons") --Killicons 1 (cl_deathnotice)
	surface.CreateFontLegacy("csd", ScreenScale(60), 500, true, true, "CSSelectIcons") --Killicons 2 (cl_deathnotice)

	surface.CreateFontLegacy("akbar", ScreenScale(20), 250, true, true, "HUDFontTiny") --MrGreenGaming.com intro
	surface.CreateFontLegacy("akbar", 28, 400, true, true, "HUDFontSmallAA")
	
	--Used in some SWEPs
	surface.CreateFontLegacy("HL2MP", ScreenScale( 30 ), 500, true, true, "HL2KillIcons")
	surface.CreateFontLegacy("HL2MP", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons")

	
	surface.CreateFontLegacy("Arial", ScreenScale(5), 700, true, false, "ArialBoldFour")
	surface.CreateFontLegacy("Arial", ScreenScale(7), 700, true, false, "ArialBoldFive")
	surface.CreateFontLegacy("Arial", ScreenScale(9), 700, true, false, "ArialBoldSeven")
	surface.CreateFontLegacy("Arial", ScreenScale(10), 700, true, false, "ArialBoldTen")
	surface.CreateFontLegacy("Arial", ScreenScale(12), 700, true, false, "ArialBoldTwelve")
	surface.CreateFontLegacy("Arial", ScreenScale(12), 500, true, false, "ArialTwelve")
	surface.CreateFontLegacy("Arial", ScreenScale(14), 500, true, false, "ArialFourteen")
	surface.CreateFontLegacy("Arial", ScreenScale(16), 500, true, false, "ArialFifteen")
	surface.CreateFontLegacy("Arial", ScreenScale(15), 700, true, false, "ArialBoldFifteen")
	surface.CreateFontLegacy("Arial", ScreenScale(20), 700, true, false, "ArialBoldTwenty")

	--Used in Loadout screen
	surface.CreateFontLegacy("Arial", ScreenScale(6), 700, true, false, "WeaponNames")
	surface.CreateFontLegacy("Arial", ScreenScale(5), 700, true, false, "WeaponNamesTiny")

	--SkillPoints fonts
	surface.CreateFontLegacy("CorpusCare", ScreenScale(6), 700, true, false, "CorpusCareFive")
	surface.CreateFontLegacy("CorpusCare", ScreenScale(7), 700, true, false, "CorpusCareSeven")
	surface.CreateFontLegacy("CorpusCare", ScreenScale(10), 700, true, false, "CorpusCareTen")
	surface.CreateFontLegacy("CorpusCare", ScreenScale(13), 700, true, false, "CorpusCareThirteen")
	surface.CreateFontLegacy("CorpusCare", ScreenScale(16), 500, true, false, "CorpusCareFifteen")
	
	surface.CreateFontLegacy("ZS New", ScreenScale(19), 500, true, false, "ZSKillicons")

	--Sync server setting
	timer.Simple(4, function()
		RunConsoleCommand("zs_setautoredeem", tostring(GetConVarNumber("_zs_autoredeem")))
	end)
end

function HTTPChangelog(contents, size)
	contents = string.Explode("@", contents)
	for _, text in pairs(contents) do
		text = string.gsub(text, "@", "")
	end
	table.Add(HELP_TEXT[2].text,contents)
end

function HTTPAdmins1(contents, size)
	contents = string.Explode("@", contents)
	for _, text in pairs(contents) do
		text = string.gsub(text, "@", "")
	end
	PrintTable(contents)
	table.Add(HELP_TXT[5].txt,contents)
end

function HTTPAdmins(contents, size)
	contents = string.Explode("@", contents)
	
	for _, text in pairs(contents) do
		text = string.gsub(text, "@", "")
	end
	
	contents[1] = nil
	
	for _, t in pairs(contents) do
		if string.find(t,"%^") then
			local new = string.sub(t,3)
			contents[_] = new
		end
	end
	

	local c = ""
	
	for _,line in pairs(contents) do
		c = c..[[		
				]]..line..[[]]
	end
	
	HELP_TXT[5].txt = c-- HELP_TXT[5].txt..[[]]..c..[[]]
	
	-- table.Add(HELP_TXT[3].text,contents)
end

local function LoopLastHuman()
	if not ENDROUND and util.tobool(GetConVar( "_zs_enablemusic" )) then
		surface.PlaySound(LASTHUMANSOUND)
		timer.Simple(LASTHUMANSOUNDLENGTH, LoopLastHuman)
	end
end

local function DelayedLastHumanAlert()
	if not ENDROUND then
		if MySelf:Team() == TEAM_UNDEAD or not MySelf:Alive() then
			GAMEMODE:Add3DMessage(140, "Kill the Last Human", nil, "ArialBoldFifteen")
		else
			GAMEMODE:Add3DMessage(140, "You are the LAST HUMAN", nil, "ArialBoldFifteen")
			GAMEMODE:Add3DMessage(140, "Run for your life", nil, "ArialBoldTen")
		end
	end
end

function GM:LastHuman()
	if LASTHUMAN or ENDROUND then
		return
	end

	LASTHUMAN = true
	
	--Stop all sounds
	RunConsoleCommand("stopsound")
	
	timer.Simple(0.5, function()
		--Loop music
		LoopLastHuman()
		
		--Alert players
		DelayedLastHumanAlert()
	end)
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.Alive then
		return pl:Team() ~= attacker:Team() or pl == attacker
	end
	return true
end

local function HUDShouldDraw( name )
	local result = name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudSecondaryAmmo" and name ~= "CHudAmmo" and name ~= "CHudDamageIndicator" and name ~= "CHudWeapon" and name ~= "CHudHintDisplay"
	if not result then
		return result
	end
end

local function ReceiveHeadcrabScale(um)
	local pl = um:ReadEntity()
	if pl:IsValid() then
		if pl == MySelf then
			HCView = true
			hook.Add("Think", "HCView", function()
				if MySelf:Health() <= 0 then
					HCView = false
					hook.Remove("Think", "HCView")
				end
			end)
		end
	end
end
usermessage.Hook("RcHCScale", ReceiveHeadcrabScale)

net.Receive("SendTitles", function(len)
	local tbl = net.ReadTable() or {}
	
	for _, stuff in pairs(tbl) do
		local pl = Entity(stuff[1])
		if pl and IsValid(pl) then
			pl.Title = stuff[2] or ""
		end
	end
end)

local function ReceiveTitles(um)
	local pl, title
	local amount = um:ReadShort()
	for k = 1, amount do
		pl = um:ReadEntity()
		pl.Title = um:ReadString()
	end
end
usermessage.Hook( "SendTitles", ReceiveTitles )

PlayerIsAdmin = false
local function ReceiveAdmin(um)
	PlayerIsAdmin = um:ReadBool()
end
usermessage.Hook("SendAdminStats", ReceiveAdmin)

-- Receive map list
MapList = {}
local function ReceiveMapList(um)
	local index = um:ReadShort()
	local map = um:ReadString()
	map = string.gsub(map,".bsp","")
	MapList[index] = map
end
usermessage.Hook("RcMapList", ReceiveMapList)

net.Receive("SetAchievementsData", function(len)
	local pl = net.ReadEntity()
	if not IsValid(pl) then
		return
	end
	
	local tbl = net.ReadTable() or {}
	
	pl.DataTable = pl.DataTable or {}
	pl.DataTable["Achievements"] = {}
	
	for k, v in ipairs( achievementDesc ) do
		pl.DataTable["Achievements"][k] = tbl[k] or false
	end

	pl.GotAchievementsData = true
	pl.StatsReceived = true
	
	print("[DB] Successfully received achievements data")
end)

net.Receive("SetStatsData", function(len)
	local pl = net.ReadEntity()
	if not IsValid(pl) then
		return
	end
	
	-- Init datatable if it's not
	pl.DataTable = pl.DataTable or {}
	
	-- Receive goodies
	local Key = net.ReadString()
	local Value = net.ReadString()
	pl.DataTable[tostring(Key)] = string.Sanitize(Value)
end)

net.Receive("SendClassData", function(len)
	if not IsValid(MySelf) then
		return
	end
	
	local tbl = net.ReadTable() or {}
	
	MySelf.DataTable = MySelf.DataTable or {}
	MySelf.DataTable["ClassData"] = MySelf.DataTable["ClassData"] or { }
	
	MySelf.DataTable["ClassData"] = table.Copy(tbl)
	
	MySelf.GotClassData = true
	print("[DB] Successfully received class data")
end)

net.Receive("SetShopData", function(len)
	local pl = net.ReadEntity()
	if not IsValid(pl) then
		return
	end
	
	local tbl = net.ReadTable() or {}
	
	pl.DataTable = pl.DataTable or {}
	pl.DataTable["ShopItems"] = {}
	
	for k, v in pairs(shopData) do
		pl.DataTable["ShopItems"][k] = tbl[k] or false
	end

	pl.GotShopData = true
	print("[DB] Successfully received shop data..")
end)

local function SetServerData(um)
	local index = um:ReadShort()
	
	for i, j in pairs(GAMEMODE.DataTable[index].players) do
		j.name = um:ReadString()
		j.value = um:ReadLong()
	end
	for i, j in pairs(GAMEMODE.DataTable[index+1].players) do
		j.name = um:ReadString()
		j.value = um:ReadLong()
	end
end
usermessage.Hook("SetServerData1", SetServerData)
usermessage.Hook("SetServerData2", SetServerData)
usermessage.Hook("SetServerData3", SetServerData)

net.Receive( "SendUpgradeNumbers", function( len )
	MySelf.TotalUpgrades = net.ReadDouble()
end)

local function SendUpgradeNumbers(um)
	MySelf.TotalUpgrades = um:ReadShort()
end
usermessage.Hook("SendUpgradeNumbers", SendUpgradeNumbers)

function SendZombieClass(um)
	local playersclass, pl

	-- Receive the interval
	local tbStart, tbEnd = um:ReadShort(), um:ReadShort()
	
	-- Set classes throughout the interval given
	for i = tbStart, tbEnd do
		pl = um:ReadEntity()
		playersclass = um:ReadShort()
		pl.Class = playersclass
	end
end
usermessage.Hook("SendZombieClass", SendZombieClass)

local function SendMaximumHealth(um)
	MySelf.MaximumHealth = um:ReadShort()
end
usermessage.Hook("SendMaximumHealth", SendMaximumHealth)

function draw.DrawTextShadow( text, font, x, y, color, shadowcolor, xalign )
	local tw, th = 0, 0
	surface.SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		x = x - tw * 0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		tw, th = surface.GetTextSize(text)
		x = x - tw
	end

	surface.SetTextColor(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a or 255)
	surface.SetTextPos(x+1, y+1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x+1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y+1)
	surface.DrawText(text)

	if color then
		surface.SetTextColor(color.r, color.g, color.b, color.a or 255)
	end

	surface.SetTextPos(x, y)
	surface.DrawText(text)

	return tw, th
end

function draw.SimpleTextShadow( text, font, x, y, color, shadowcolor, xalign, yalign )
	font 	= font 		or "Default"
	x 		= x 		or 0
	y 		= y 		or 0
	xalign 	= xalign 	or TEXT_ALIGN_LEFT
	yalign 	= yalign 	or TEXT_ALIGN_TOP
	local tw, th = 0, 0
	surface.SetFont(font)
	
	if xalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		x = x - tw*0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		tw, th = surface.GetTextSize(text)
		x = x - tw
	end
	
	if yalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		y = y - th*0.5
	end

	surface.SetTextColor(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a or 255)
	surface.SetTextPos(x+1, y+1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x+1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y+1)
	surface.DrawText(text)

	if color then
		surface.SetTextColor(color.r, color.g, color.b, color.a or 255)
	else
		surface.SetTextColor(255, 255, 255, 255)
	end

	surface.SetTextPos(x, y)
	surface.DrawText(text)

	return tw, th
end

local WATER_DROWNTIME_CONST = 20
local WATER_DROWNTIME = 20
-- Draw HUD
local function HUDPaint()
	if not MySelf:IsValid() or not MySelf.ReadySQL then
		return
	end
	local MyTeam = MySelf:Team()
	
	h = ScrH()
	w = ScrW()

	
	if MyTeam ~= TEAM_SPECTATOR then
		if MySelf:Alive() and not IsClassesMenuOpen() then
			GAMEMODE:DrawDeathNotice(0.83, 0.07)
			GAMEMODE:HUDDrawTargetID(MySelf, MyTeam)
		end
	end
	
	if MySelf:IsHuman() and MySelf:Alive() then
		--Drowning code for humans
		if 2 < MySelf:WaterLevel() then
			WATER_DROWNTIME = math.max(WATER_DROWNTIME - FrameTime(), 0)
			if WATER_DROWNTIME <= 0 then
				RunConsoleCommand("water_death")
				WATER_DROWNTIME = WATER_DROWNTIME_CONST
			elseif 10 < WATER_DROWNTIME then
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0.45, FrameTime() * 0.2)
				ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 0, FrameTime() * 0.25)
			end
			
			local ww,wh = ScaleW(212),ScaleH(30)
			local wx,wy = w/2-ww/2, h-wh*2
			
			surface.SetDrawColor( 0, 0, 0, 150)
			surface.DrawRect(wx,wy,ww,wh)
			surface.DrawRect(wx+5 , wy+5,  ww-10, wh-10 )
			
			surface.SetDrawColor(98,17,17,255)
			surface.DrawRect(wx+5 , wy+5,((WATER_DROWNTIME/WATER_DROWNTIME_CONST)*ww)-10, wh-10 )
			
			draw.SimpleTextOutlined("Oxygen: "..math.Round(WATER_DROWNTIME).." sec left", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
			
		elseif WATER_DROWNTIME > 0 and WATER_DROWNTIME ~= WATER_DROWNTIME_CONST then
		
			WATER_DROWNTIME = math.min(WATER_DROWNTIME + FrameTime() * 3, WATER_DROWNTIME_CONST)
			if WATER_DROWNTIME <= WATER_DROWNTIME_CONST then
				ColorModify["$pp_colour_addb"] = 0
				ColorModify["$pp_colour_colour"] = 1
			else
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0, FrameTime() * 0.3)
				ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 1, FrameTime())
			end
			
			local ww,wh = ScaleW(212),ScaleH(30)
			local wx,wy = w/2-ww/2, h-wh*2
			
			surface.SetDrawColor( 0, 0, 0, 150)
			surface.DrawRect(wx,wy,ww,wh)
			surface.DrawRect(wx+5 , wy+5,  ww-10, wh-10 )
			
			surface.SetDrawColor(98,17,17,255)
			surface.DrawRect(wx+5 , wy+5,((WATER_DROWNTIME/WATER_DROWNTIME_CONST)*ww)-10, wh-10 )
			
			draw.SimpleTextOutlined("Recharging breath: "..math.Round(math.abs (WATER_DROWNTIME - WATER_DROWNTIME_CONST)).." sec left", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		end
	end
end

BloodDraws = {}
function AddBloodSplat( severity )
	local toDraw = bloodSplats[math.random(1,8)]
	local dur = severity
	local alp = 35+severity*20
	
	if #BloodDraws < 3 then
		table.insert(BloodDraws, { fadestart = CurTime()+3+math.Rand(1,5), image = toDraw, duration = dur, alpha = alp })
	end
end

-- Blood shit
net.Receive("BloodSplatter", function(len)
	local severity = net.ReadDouble()-- um:ReadShort()
	AddBloodSplat(severity)
	if ((net.ReadBit() or 0) == 1 and severity > 1) then
		AddBloodSplat(severity-1)
	end
end)

function BloodDraw()
	if not IsEntityValid( MySelf ) then
		return
	end
	
	for k, v in pairs(BloodDraws) do
		
		surface.SetTexture( v.image )
		surface.SetDrawColor( Color(120,0,0,v.alpha) )
		surface.DrawTexturedRect( 0,0,w,h )
		
		if (v.fadestart < CurTime()) then
			v.alpha = math.Approach(v.alpha, 0, FrameTime()*v.duration*100)
			if v.alpha <= 0 then
				table.remove(BloodDraws,k)
			end
		end
	end
end
hook.Add("HUDPaint","DrawBloodSplats",BloodDraw)

-----------------

util.PrecacheSound("npc/stalker/breathing3.wav")
util.PrecacheSound("npc/zombie/zombie_pain6.wav")

GM.ZombieThirdPerson = false
function GM:PlayerBindPress(pl, bind, pressed)
	if pl:Team() ~= TEAM_UNDEAD and not pl:IsZombine() and string.find(bind, "speed") then
		return true
	elseif pl:Team() == TEAM_SPECTATOR and (string.find (bind, "messagemode") or string.find (bind,"messagemode2") or string.find(bind,"+voicerecord")) then 
		return true
	end
	
	--Third person view toggle
	if bind == "+menu_context" then
		self.ZombieThirdPerson = not self.ZombieThirdPerson
	end
end

--[=[----------------------------------------------------------------
   Restrict  keys like jump / crouch for some classes
------------------------------------------------------------------]=]
function RestrictControls ( pl , bind, pressed ) 
	if not pl == MySelf then
		return
	end

	if pl:Team() == TEAM_UNDEAD then
		--Ducking
		if string.find(bind, "duck") then
			local Class = pl:GetZombieClass()
		
			if ZombieClasses[Class].CanCrouch == false then
				return true
			end
		end
	end
	
	--Walk for humans
	if pl:Team() == TEAM_HUMAN then
		if string.find(bind, "walk") then
			return true
		end		
	end
end
hook.Add("PlayerBindPress", "RestrictControl", RestrictControls)

function SpectatorSay ( say )
	if MySelf:Team() == TEAM_SPECTATOR then
		return true
	end
end
hook.Add("StartChat", "Spectator", SpectatorSay)

DEBUG_VIEW = false

local SkullCam = NULL
usermessage.Hook("SkullCam", function(um)
	local ent = um:ReadEntity()
	if ent and ent:IsValid() then
		SkullCam = ent
	end
end)
GM.FOVLerp = 1

hook.Add("Think", "CheckFOV", function()
	if not MySelf or not MySelf.Team then
		return
	end
	
	if MySelf:Team() == TEAM_HUMAN then
		local wep = MySelf:GetActiveWeapon()
		
		if wep:IsValid() and wep.GetIronsights and wep:GetIronsights() then
			GAMEMODE.FOVLerp = math.Approach(GAMEMODE.FOVLerp, wep.IronsightsMultiplier or 0.6, FrameTime() * 4)
		else
			GAMEMODE.FOVLerp = math.Approach(GAMEMODE.FOVLerp, 1, FrameTime() * 5)
		end
	else
		if not MySelf:Alive() then
			GAMEMODE:ToggleZombieVision(false)
		end
	end
end)


function GM:PreDrawViewModel(vm, pl, weapon)
	if not weapon then
		return
	end

	--Call same function in SWEP
	if isfunction(weapon.PreDrawViewModel)	then
		weapon:PreDrawViewModel(vm, pl, weapon)
	end

	--Use unified hands
	if weapon.UseHands then
		local hands = pl:GetHands()
		if IsValid(hands) then
			hands:DrawModel()
		end
	end
end

function GM:PostDrawViewModel(vm, pl, weapon)	
	--Call same function in SWEP
	if isfunction(weapon.PostDrawViewModel)	then
		weapon:PostDrawViewModel(vm, pl, weapon)
	end
end

local fovlerp = GetConVarNumber("fov_desired")
local maxfov = fovlerp
local minfov = fovlerp * 0.6
local staggerdir = VectorRand():GetNormal()

function GM:_ShouldDrawLocalPlayer(pl)
	if not IsValid(pl) then
		return
	end

	local weapon = pl:GetActiveWeapon()
	return pl.Team and pl:Team() == TEAM_UNDEAD and ((self.ZombieThirdPerson or (IsValid(weapon) and weapon.GetClimbing and weapon:GetClimbing())) or (pl.Revive and pl.Revive:IsValid()))--  and pl.Revive:IsRising()
end

local function CalculateView(pl, vPos, aAng, fFov)
	if not IsValid(MySelf) then
		return
	end

	-- Grab data
	local Velocity, EyeAngle = pl:GetVelocity(), pl:EyeAngles()
	
	--Revive camera
	if pl.Revive and pl.Revive.GetRagdollEyes then
		local rpos, rang = pl.Revive:GetRagdollEyes(pl)
		if rpos then
			return { origin = rpos, angles = rang }
		end
	end
	
	--Skull camera for dead humans
	if MySelf:GetRagdollEntity() and not (MySelf:GetObserverMode() == OBS_MODE_ROAMING or MySelf:GetObserverMode() == OBS_MODE_FREEZECAM or MySelf:GetObserverMode() == OBS_MODE_CHASE ) then
		local rpos, rang = GAMEMODE:GetRagdollEyes(MySelf)
		if rpos then
			return { origin = rpos, angles = rang }
		end
	end
	
	--
	if pl:ShouldDrawLocalPlayer() and pl:Alive() then
		local wep = pl:GetActiveWeapon()
		if IsValid(wep) and wep.GetClimbing and wep:GetClimbing() and not GAMEMODE.ZombieThirdPerson then
			local bone = pl:LookupBone("ValveBiped.HC_BodyCube")
			if bone then
				local pos,ang = pl:GetBonePosition(bone)
				if pos and ang then
					ang:RotateAroundAxis(ang:Up(),-90)
					return {
						origin = pos+pl:SyncAngles():Forward()*4+pl:SyncAngles():Up()*-3,
						angles = Angle(math.Clamp(aAng.p,-45,45), aAng.y, ang.r/6)
					}
				end
			end
		else
			return {origin = pl:GetThirdPersonCameraPos(vPos, aAng), angles = aAng}
		end
	end

	fFov = fFov or GetConVar("fov_desired"):GetInt() or 75

	-- Weapon calc. view management ( human only )
	if MySelf:Team() == TEAM_HUMAN then
		local Weapon, WeaponAngle, WeaponPos = pl:GetActiveWeapon()
		if Weapon:IsValid() then
			local ViewModelFunc, CalcViewFunc = Weapon.GetViewModelPosition, Weapon.CalcView
			
			-- Use the weapon calc. view functions instead
			if ViewModelFunc then WeaponPos, WeaponAngle = ViewModelFunc ( Weapon, vPos, aAng ) end
			if CalcViewFunc then vPos, aAng, fFov = CalcViewFunc ( Weapon, pl, vPos, aAng, fFov ) end
		end
		
		--Bouncy view ( strafe )
		if ( MySelf:Alive() and MySelf:Health() > 30 ) and Velocity:Length() < 330 then
			aAng.roll = aAng.roll + EyeAngle:Right():DotProduct( Velocity ) * 0.007
		end	
		
		return { origin = vPos, angles = aAng, fov = fFov, vm_origin = WeaponPos, vm_angles = WeaponAngle }
	end

	return { origin = vPos, angles = aAng, fov = fFov }
end

function render.GetLightRGB(pos)
	local vec = render.GetLightColor(pos)
	return vec.r, vec.g, vec.b
end

local matPullBeam = Material("cable/rope")
local colPullBeam = Color(255, 255, 255, 255)
hook.Add("PostDrawOpaqueRenderables","DrawCarryRope",function()
	local holding = MySelf.status_human_holding
	if not holding or not IsValid(holding) or not holding:GetIsHeavy() then
		return
	end
	
	local object = holding:GetObject()
	if IsValid(object) then
		local pullpos = holding:GetPullPos()
		local hingepos = holding:GetHingePos()
		local r, g, b = render.GetLightRGB(hingepos)
		colPullBeam.r = r * 255
		colPullBeam.g = g * 255
		colPullBeam.b = b * 255
		render.SetMaterial(matPullBeam)
		render.DrawBeam(hingepos, pullpos, 0.5, 0, pullpos:Distance(hingepos) / 128, colPullBeam)
	end
end)

local vecfake = Vector(0, 0, 32000)
hook.Add("Think", "DrawZombieFlashLight", function()
	local light = Entity(0):GetDTEntity(0)
	
	if light and IsValid(light) then
		local todraw = MySelf and IsValid(MySelf) and MySelf.IsZombie and MySelf:IsZombie() and MySelf:OldAlive() and GAMEMODE.m_ZombieVision
		
		if todraw then
			if light:IsEffectActive( EF_NODRAW ) then
				light:SetNoDraw(false)
			end
			light:SetOwner(MySelf)
			light:SetPos(EyePos())
			light:SetAngles(MySelf:EyeAngles())
		else
			if not light:IsEffectActive( EF_NODRAW ) then
				light:SetNoDraw(true)
			end
			light:SetPos(vecfake)
		end
	end
end)

function GM:ToggleZombieVision(toggle)
	if toggle == nil then
		toggle = not self.m_ZombieVision
	end

	if toggle then
		if not self.m_ZombieVision then
			self.m_ZombieVision = true
			MySelf:EmitSound(Sound("npc/stalker/breathing3.wav"), 0, 230)
			-- MySelf:SetDSP(5)
		end
	elseif self.m_ZombieVision then
		self.m_ZombieVision = nil
		MySelf:EmitSound(Sound("npc/zombie/zombie_pain6.wav"), 0, 110)
		-- MySelf:SetDSP(0)
	end
end

function GM:GetTeamColor(ent)
	if ent and ent:IsValid() and ent:IsPlayer() then
		local teamnum = ent:Team() or TEAM_UNASSIGNED
		return team.GetColor(teamnum) or color_white
	end
	return color_white
end

function GM:GetTeamNumColor(num)
	return team.GetColor(num) or color_white
end

local function PredictChatNickName(str)
	local LastWord
	for word in string.gmatch(str, "%a+") do
	     LastWord = word
	end
	if LastWord == nil then return str end
	playerlist = player.GetAll()
	for k, v in pairs(playerlist) do
		local nickname = v:Nick()
		if string.len(LastWord) < string.len(nickname) and string.find(string.lower(nickname), string.lower(LastWord)) == 1 then
			str = string.sub(str, 1, (string.len(LastWord) * -1)-1)
			str = str .. nickname
			return str
		end
	end
	return str
end
hook.Add("OnChatTab", "PredictChatNickName", PredictChatNickName)

function GM:GetSWEPMenu()
	return {}
end

function GM:GetSENTMenu()
	return {}
end

local function BlockPP(ppeffect)
	return false
end
hook.Add("PostProcessPermitted", "BlockPP", BlockPP)

function GM:PostRenderVGUI()
end

function GM:RenderScene()
end

-- 2 second tick
local tbWarnings = { Sound ( "npc/zombie_poison/pz_alert1.wav" ), Sound ( "npc/zombie_poison/pz_call1.wav" ), Sound ( "npc/fast_zombie/fz_alert_far1.wav" ), Sound ( "ambient/creatures/town_zombie_call1.wav" ) }

function GM:Rewarded(wep)
	if not MySelf:IsValid() then
		return
	end
	
	surface.PlaySound(Sound("mrgreen/new/weppickup"..math.random(1,3)..".wav"))

	if wep and wep.PrintName then
		MySelf:Message("Picked up a ".. wep.PrintName, nil, 1, 2.5)
	else
		MySelf:Message("Arsenal upgraded", 2.5)
	end
end

-- Receive spray locations
Sprays = {}
function ReceiveSprays(um)
	local amount = um:ReadShort()
	Sprays = {}
	for k = 1, amount do
		local index = um:ReadShort()
		local nm = um:ReadString()
		local vec = um:ReadVector()
		Sprays[index] = { name = nm, pos = vec }
	end
end
usermessage.Hook("SendSprays",ReceiveSprays)

local function PlaySoundClient(um)
	local sound = um:ReadString()
	if LocalPlayer() and LocalPlayer():IsValid() then
		LocalPlayer():EmitSound(sound,130,100)
	end
end
usermessage.Hook("PlaySoundClient", PlaySoundClient) 

local function PlayClientsideSound(um)
	local sound = um:ReadString()
	surface.PlaySound(sound)
end
usermessage.Hook("PlayClientsideSound", PlayClientsideSound) 

function MeleeWeaponDrawHUD()
	local cW, cH = ScrW() * 0.5, ScrH() * 0.5
	local wLength, hLength =  ScaleW(16),ScaleW(6)
	
	surface.SetDrawColor( Color ( 188,183,153,30 ) )
	surface.DrawLine(cW - wLength, cH - 2, cW + wLength, cH - 2)
	
	surface.SetDrawColor( Color ( 188,183,153,160 ) )
	surface.DrawLine(cW - wLength, cH - 1, cW + wLength, cH - 1)
	
	surface.SetDrawColor( Color ( 188,183,153,160 ) )
	surface.DrawLine(cW - wLength, cH - 0, cW + wLength, cH - 0)
	
	surface.SetDrawColor( Color ( 188,183,153,30 ) )
	surface.DrawLine(cW - wLength, cH + 1, cW + wLength, cH + 1)

	
	surface.SetDrawColor( Color ( 188,183,153,50 ) )
	surface.DrawLine(cW - 1, cH - hLength, cW - 1, cH + hLength)
	
	surface.SetDrawColor( Color ( 188,183,153,130 ) )
	surface.DrawLine(cW - 0, cH - hLength, cW - 0, cH + hLength)
	
	surface.SetDrawColor( Color ( 188,183,153,50 ) )
	surface.DrawLine(cW + 1, cH - hLength, cW + 1, cH + hLength)
end

-- Textures we need to draw the crosshair 
local matCore, matOuter = surface.GetTextureID ( "zombiesurvival/crosshair/undead_crosshair_core" ), surface.GetTextureID ( "zombiesurvival/crosshair/undead_crosshair_outer" )

function GM:DrawZombieCrosshair ( m_Owner, iDistance )
	if not IsEntityValid ( MySelf ) then return end
	if ENDROUND or IsClassesMenuOpen() then return end
	
	-- SQL ready
	if not MySelf.ReadySQL then return end
	if util.tobool(GetConVarNumber("_zs_hidecrosshair")) then return end
		
	-- Vars
	local bDrawOutline, colOuter = false, Color ( 255,255,255,240 )
		
	-- Headcrab have different view position
	local vStart = m_Owner:GetShootPos()
	if m_Owner:IsHeadcrab() or m_Owner:IsPoisonCrab() then vStart = m_Owner:GetPos() + Vector ( 0,0,32 ) end
	
	-- Trace the line	
	local trLine = util.TraceLine ( { start = vStart, endpos = vStart + ( m_Owner:GetAimVector() * 10000 ), filter = m_Owner } )
		
	-- Draw outer crosshair if hits entity
	local m_Ent = trLine.Entity
	if IsEntityValid ( m_Ent ) then 
		if m_Ent:IsPlayer() and m_Ent:IsHuman() then
			local fDistance = m_Owner:GetPos():Distance ( m_Ent:GetPos() )
			bDrawOutline = true
			if fDistance <= iDistance then colOuter = Color ( 10, 240, 10, 160 ) else colOuter = Color ( 240, 10, 10, 160 ) end
		end
	end
		
	-- Draw the inner crosshair
	surface.SetDrawColor ( 190,190,190,170 )
	surface.SetTexture ( matCore )
	surface.DrawTexturedRectRotated ( w * 0.5, h * 0.5, ScaleW(64), ScaleW(64), 0 )
		
	-- Draw outer crosshair
	if bDrawOutline then
		surface.SetDrawColor ( colOuter )
		surface.SetTexture ( matOuter )
		surface.DrawTexturedRectRotated ( w * 0.5, h * 0.5, ScaleW(64), ScaleW(64), 0 )
	end
end

GM.MapExploits = {}
-- receive map exploit locations
function RecMapExploits(um)
	local tab = {}
	
	tab = {}
	tab.origin = um:ReadVector()
		
	tab.bsize = um:ReadShort()
	tab.type = um:ReadString()
	table.insert(MapExploits, tab)
end
usermessage.Hook("mapexploits",RecMapExploits)

function OnWeaponDropped(um)
	if SERVER or not IsValid(MySelf) then
		return
	end
	
	--Disable the ironsight
	--MySelf:SetFOV(GetConVar("fov_desired"):GetInt())
	
	--Call OnDrop function
	local ActiveWeapon = MySelf:GetActiveWeapon()
	if IsValid(ActiveWeapon) and isfunction(ActiveWeapon.OnDrop) then
		ActiveWeapon:OnDrop()
	end
end
usermessage.Hook("OnWeaponDropped", OnWeaponDropped)


--------------------------------------------------------


function GM:HookGetLocal()
	MYSELFVALID = true

	--[[self.Think = function()
	end]]

	hook.Add("HUDShouldDraw", "DrawHUD", HUDShouldDraw)
	hook.Add("CalcView", "CalculateView", CalculateView)

	--
	self.ShouldDrawLocalPlayer = self._ShouldDrawLocalPlayer

	hook.Add("PostDrawOpaqueRenderables", "HeartbeatGlow", HeartbeatGlow)

	--Required empty function
	self.HUDPaint = function()
	end
	hook.Add("HUDPaint", "HUDPaint", HUDPaint)

	--TODO: Check if this empty function is required
	self.HUDPaintBackground = function()
	end

	--Small function. No hook needed
	self.HUDWeaponPickedUp = self._HUDWeaponPickedUp
end