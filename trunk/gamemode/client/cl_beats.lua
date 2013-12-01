-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")

-- Replace beats with cuts of hl2_song2.mp3 here:
local Beats = {}
Beats[0] = {}
Beats[1] = {"zombiesurvival/hbeat1.wav"}
Beats[2] = {"zombiesurvival/hbeat1.wav"}
Beats[3] = {"zombiesurvival/hbeat2.wav"}
Beats[4] = {"zombiesurvival/hbeat3.wav"}
Beats[5] = {"zombiesurvival/hbeat4.wav"}
Beats[6] = {"zombiesurvival/hbeat5.wav"}
Beats[7] = {"zombiesurvival/hbeat6.wav"}
Beats[8] = {"zombiesurvival/hbeat7.wav"}
Beats[9] = {"zombiesurvival/hbeat8.wav"}
Beats[10] = {"zombiesurvival/hbeat9.wav"}

for i=1,10 do
	util.PrecacheSound(Beats[i][1])
end

local OldBeats = {}
OldBeats[0] = {}
OldBeats[1] = {"beat1.wav"}
OldBeats[2] = {"beat1.wav", "beat2.wav"}
OldBeats[3] = {"beat2.wav", "beat3.wav"}
OldBeats[4] = {"beat2.wav", "beat3.wav", "beat5.wav"}
OldBeats[5] = {"beat1.wav", "beat2.wav", "beat8.wav"}
OldBeats[6] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat7.wav", "beat8.wav"}
OldBeats[7] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav"}
OldBeats[8] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav", "beat7.wav"}
OldBeats[9] = {"beat3.wav", "beat5.wav", "beat8.wav", "beat9.wav", "beat7.wav"}
OldBeats[10] = {"ecky.wav"}

local NewZBeats = {}




local ZBeats = {}
ZBeats[0] = {}
ZBeats[1] = {"zombiesurvival/_zbeat1.wav"}
ZBeats[2] = {"zombiesurvival/_zbeat2.wav"}
ZBeats[3] = {"zombiesurvival/_zbeat3.wav"}
ZBeats[4] = {"zombiesurvival/_zbeat4.wav"}
ZBeats[5] = {"zombiesurvival/_zbeat5.wav"}
ZBeats[6] = {"zombiesurvival/_zbeat6.wav"}
ZBeats[7] = {"zombiesurvival/_zbeat6_5.wav"}
ZBeats[8] = {"zombiesurvival/_zbeat7.wav"}
ZBeats[9] = {"zombiesurvival/_zbeat7_5.wav"}
ZBeats[10] = {"zombiesurvival/_zbeat8.wav"}

for i=1,10 do
	util.PrecacheSound(ZBeats[i][1])
end

local ZBeatLength = {}
ZBeatLength[0] = 1
ZBeatLength[1] = 2.4
ZBeatLength[2] = 3.3
ZBeatLength[3] = 4.5
ZBeatLength[4] = 9.9
ZBeatLength[5] = 9.95
ZBeatLength[6] = 7.4
ZBeatLength[7] = 5.1
ZBeatLength[8] = 10.3
ZBeatLength[9] = 10.3
ZBeatLength[10] = 10.2

util.PrecacheSound("beat1.wav")
util.PrecacheSound("beat2.wav")
util.PrecacheSound("beat3.wav")
util.PrecacheSound("beat4.wav")
util.PrecacheSound("beat5.wav")
util.PrecacheSound("beat6.wav")
util.PrecacheSound("beat7.wav")
util.PrecacheSound("beat8.wav")
util.PrecacheSound("beat9.wav")
util.PrecacheSound("zbeat1.wav")
util.PrecacheSound("zbeat2.wav")
util.PrecacheSound("zbeat3.wav")
util.PrecacheSound("zbeat4.wav")
util.PrecacheSound("zbeat5.wav")
util.PrecacheSound("zbeat6.wav")
util.PrecacheSound("zbeat7.wav")
util.PrecacheSound("zbeat8.wav")
util.PrecacheSound("ecky.wav")

local BeatLength = {}
BeatLength[0] = 1.0
BeatLength[1] = 1.7
BeatLength[2] = 1.7
BeatLength[3] = 1.7
BeatLength[4] = 1.7
BeatLength[5] = 1.7
BeatLength[6] = 1.7
BeatLength[7] = 1.65
BeatLength[8] = 1.7
BeatLength[9] = 1.7
BeatLength[10] = 21.8

local BeatText = {}
BeatText[0] = "Perfectly Safe"
BeatText[1] = "Safe-ish"
BeatText[2] = "Unsafe"
BeatText[3] = "Impending Danger"
BeatText[4] = "Dangerous"
BeatText[5] = "Very Dangerous"
BeatText[6] = "Blood Bath"
BeatText[7] = "Horror Show"
BeatText[8] = "Zombie Survival"
BeatText[9] = "Zombie Cluster-Fuck"
BeatText[10] = "OH SHI-"

local BeatColors = {}
BeatColors[0]  = Color(  0,   0, 240, 255)
BeatColors[1]  = Color( 10,  10, 225, 255)
BeatColors[2]  = Color( 50,  85, 190, 255)
BeatColors[3]  = Color(145, 145,  40, 255)
BeatColors[4]  = Color(150, 190,  10, 255)
BeatColors[5]  = Color(210, 210,   5, 255)
BeatColors[6]  = Color(190, 160,   0, 255)
BeatColors[7]  = Color(220,  90,   0, 255)
BeatColors[8]  = Color(220,  40,   0, 255)
BeatColors[9]  = Color(230,  15,   0, 255)
BeatColors[10] = Color(245,   0,   0, 255)

local ZombieHordeText = {}
ZombieHordeText[0] = "Nobody Around"
ZombieHordeText[1] = "So Ronery"
ZombieHordeText[2] = "Undead Duo"
ZombieHordeText[3] = "Undead Trio"
ZombieHordeText[4] = "Zombie Assault"
ZombieHordeText[5] = "Flesh Pile"
ZombieHordeText[6] = "Zombie Party"
ZombieHordeText[7] = "Lawn Mower"
ZombieHordeText[8] = "Steam Roller"
ZombieHordeText[9] = "Zombie Horde"
ZombieHordeText[10] = "DEAD MEAT"

local ZombieHordeColors = {}
ZombieHordeColors[0]  = Color(  0,   0, 240, 210)
ZombieHordeColors[1]  = Color(  0,  10, 225, 210)
ZombieHordeColors[2]  = Color(  0,  30, 220, 210)
ZombieHordeColors[3]  = Color(  0,  65, 180, 210)
ZombieHordeColors[4]  = Color(  0,  95, 155, 210)
ZombieHordeColors[5]  = Color(  0, 108, 108, 210)
ZombieHordeColors[6]  = Color(  0, 130,  85, 210)
ZombieHordeColors[7]  = Color(  0, 170,  65, 210)
ZombieHordeColors[8]  = Color(  0, 210,  40, 210)
ZombieHordeColors[9]  = Color(  5, 240,   0, 210)
ZombieHordeColors[10] = Color( 25, 240,  20, 210)

local WATER_DROWNTIME = 30
local CRAMP_METER_TIME = 0

function GM:ResetWaterAndCramps()
	WATER_DROWNTIME = 30
	CRAMP_METER_TIME = 0
end

local NextAmmoDropOff = AMMO_REGENERATE_RATE

function GM:InitPostEntity()
	NextAmmoDropOff = math.ceil(CurTime() / AMMO_REGENERATE_RATE) * AMMO_REGENERATE_RATE
end

local NextHordeCalculate = 0
local DisplayHorde = 0
local ActualHorde = 0
local NextThump = 0

function GM:SetLastHumanText()
	if LASTHUMAN then
		BeatText[10] = "LAST HUMAN!"
		ZombieHordeText[10] = "LAST HUMAN!"
		NextHordeCalculate = 999999
		NearZombies = 10
		DisplayHorde = 10
		ActualHorde = 10
	end
end


--[==[--------------------------------------------------------
       Called on GM:SetUnlife ( bool ) -- Loops, too
---------------------------------------------------------]==]
function PlayUnlife()
	if LASTHUMAN or ENDROUND or not util.tobool(GetConVar( "_zs_enablemusic" )) then return end	
	-- Stop sounds
	RunConsoleCommand("stopsound")
	
	--Play sound right now
	local Duration = 277
	local song = "deadlife_mrgreen.mp3"
	
	if BOSSACTIVE or GAMEMODE:IsBossAlive() then
		Duration = 215
		song = "deadlife_mrgreen_insane.mp3"
	end
	
	timer.Simple(0.3, function()
		surface.PlaySound(song)
	end)
	
	-- Create timer
	timer.Create("LoopUnlife", Duration, 0, function() 
		if LASTHUMAN or ENDROUND then
			return
		end
		surface.PlaySound(song)  
	end)
end

util.PrecacheSound("deadlife_mrgreen.mp3")
util.PrecacheSound("deadlife_mrgreen_insane.mp3")

-- CreateClientConVar("_zs_customweaponpos", 1, true, false)
local ENABLE_WEPPOS = util.tobool(GetConVarNumber("_zs_customweaponpos"))
local function EnableCustomPos(sender, command, arguments)
	ENABLE_WEPPOS = util.tobool(arguments[1])

	if ENABLE_WEPPOS then
		RunConsoleCommand("_zs_customweaponpos", "1")
		MySelf:ChatPrint("Custom weapon positions enabled.")
	else
		RunConsoleCommand("_zs_customweaponpos", "0")
		MySelf:ChatPrint("Custom weapon positions disabled.")
	end
end
concommand.Add("zs_customweaponpos", EnableCustomPos)

-- CreateClientConVar("_zs_enablehptext", 1, true, false)
local ENABLE_HPTEXT = util.tobool(GetConVarNumber("_zs_enablehptext"))
local function EnableHPText(sender, command, arguments)
	ENABLE_HPTEXT = util.tobool(arguments[1])

	if ENABLE_HPTEXT then
		RunConsoleCommand("_zs_enablehptext", "1")
		MySelf:ChatPrint("Health bar text enabled.")
	else
		RunConsoleCommand("_zs_enablehptext", "0")
		MySelf:ChatPrint("Health bar text disabled.")
	end
end
concommand.Add("zs_enablehptext", EnableHPText)

-- CreateClientConVar("_zs_enablelighthud", 0, true, false)
local LIGHTHUD = util.tobool(GetConVarNumber("_zs_enablelighthud"))
local function LightHud(sender, command, arguments)
	LIGHTHUD = util.tobool(arguments[1])

	if LIGHTHUD then
		RunConsoleCommand("_zs_enablelighthud", "1")
		MySelf:ChatPrint("Light HUD enabled.")
	else
		RunConsoleCommand("_zs_enablelighthud", "0")
		MySelf:ChatPrint("Light HUD disabled.")
	end
end
concommand.Add("zs_enablelighthud", LightHud)

-- CreateClientConVar("_zs_enablemusic", 1, true, false)
ENABLE_MUSIC = util.tobool(GetConVarNumber("_zs_enablemusic"))
local function EnableMusic(sender, command, arguments)
	ENABLE_MUSIC = util.tobool(arguments[1])

	if ENABLE_MUSIC then
		RunConsoleCommand("_zs_enablemusic", "1")
		MySelf:ChatPrint("Music enabled.")
	else
		RunConsoleCommand("_zs_enablemusic", "0")
		MySelf:ChatPrint("Music disabled.")
	end
end
concommand.Add("zs_enablemusic", EnableMusic)

--Small turret's names from IW
local randnames = { "Joseph", "Finger", "Beer", "Blob", "Chicken" }
CreateClientConVar("_zs_turretnicknamefix", table.Random(randnames), true, true)
TurretNickname = GetConVarString("_zs_turretnicknamefix")
function SetTurretNick( pl,commandName,args )
	if not args[1] then return end
	if not ValidTurretNick(pl,tostring(args[1])) then return end
	TurretNickname = args[1]

	RunConsoleCommand("_zs_turretnicknamefix",tostring(args[1]))
	RunConsoleCommand("turret_nickname",tostring(args[1]))
end
concommand.Add("zs_turretnickname",SetTurretNick) 

-- CreateClientConVar("_zs_showhorde", 1, true, false)
SHOWHORDE = util.tobool( GetConVarNumber("_zs_showhorde") )
local function EnableHordeHUD(sender, command, arguments)
	SHOWHORDE = util.tobool( arguments[1] )

	if SHOWHORDE then
		RunConsoleCommand("_zs_showhorde", "1")
		MySelf:ChatPrint("Enabled HUD for horde status.")
	else
		RunConsoleCommand("_zs_showhorde", "0")
		MySelf:ChatPrint("Disabled HUD for horde status.")
	end
end
concommand.Add("zs_showhorde", EnableHordeHUD)

HCOLORMOD = true

CreateClientConVar("zs_wepfov", 57, true, true)

ENABLE_BLOOD = false

local NextBeat = 0
local LastBeatLevel = 0
local function PlayBeats(teamid, am)
	local ENABLE_BEATS = util.tobool(GetConVarNumber("_zs_enablebeats"))

	if RealTime() <= NextBeat or not ENABLE_BEATS then return end

	if ENDROUND or LASTHUMAN or UNLIFE then return end

	if am <= 0 then return end

	local beats = teamid == TEAM_HUMAN and Beats or ZBeats
	if not beats then return end

	LastBeatLevel = math.Approach(LastBeatLevel, math.ceil(am), 1)

	local snd = beats[LastBeatLevel][1]
	if snd then
		MySelf:EmitSound(snd, 0, 100, 0.8)
		NextBeat = RealTime() + SoundDuration(snd) - 0.025
	end
end


-- Good old beats :D
local function BeatsThink()
	MySelf = LocalPlayer()
	if not MySelf:IsValid() then
		return
	end

	
	local myteam = MySelf:Team()
	
	local am = myteam == TEAM_UNDEAD and MySelf:GetHordeCount(true) or math.Round(math.min(GetZombieFocus3(MySelf:GetPos(), 260, 0.001, 0) * 10, 10))
	
	PlayBeats(myteam, am)
end
hook.Add("Think", "BeatsThink", BeatsThink)


-- 2 functions from old zs for better calculating
function GetZombieFocus2(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, pl in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
		if pl ~= MySelf and pl:Team() == TEAM_UNDEAD and pl:Alive() then
			local dist = pl:GetPos():Distance(mypos)
			if dist < range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	return math.min(zombies, 1)
end

function GetZombieFocus3(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if pl:Team() == TEAM_UNDEAD and pl:Alive() then
			local dist = pl:GetPos():Distance(mypos)
			if dist <= range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	if UNLIFE then
		return math.max(0.75, math.min(zombies, 1))
	elseif HALFLIFE then
		return math.max(0.5, math.min(zombies, 1))
	else
		return math.min(zombies, 1)
	end
end

local regenSound = Sound("buttons/weapon_confirm.wav")

--[==[---------------------------------------------------------
      Generates those "soul" patterns on humans
---------------------------------------------------------]==]
local NextAura = 0
function ZombieAuraThink ()
	if not ValidEntity ( MySelf ) then return end
	if not MySelf:Alive() then return end
	if NextAura > CurTime() then return end
	
	local Position, MaxAuras, AuraTable = MySelf:GetPos(), 0, {}
	
	-- Run through the humans and check who is alive
	for _, pl in pairs( team.GetPlayers ( TEAM_HUMAN ) ) do
		if pl:Alive() and not (pl:GetSuit() == "stalkersuit" and pl:GetVelocity():Length() < 10) then
			local HumanPosition = pl:GetPos()
			if HumanPosition:Distance ( Position ) < 1024 and HumanPosition:ToScreen().visible then
				AuraTable[pl] = HumanPosition
				MaxAuras = MaxAuras + 1
				
				-- We have reached our aura limit ( 10 )
				if MaxAuras >= 10 then break end
			end
		end
	end
	
	-- End this if there are no player souls to render
	if MaxAuras <= 0 then return end
	
	-- Render the souls
	local Emitter = ParticleEmitter( EyePos() )
	for pl, HumanPosition in pairs( AuraTable ) do
		local vel = pl:GetVelocity() * 0.95
		local health = pl:Health()
		
		-- Get the position of the chest
		local attach = pl:GetAttachment( pl:LookupAttachment("chest") )
		if not attach then
			attach = { Pos = pl:GetPos() + Vector(0,0,48) }
		end
		
		-- Centered particle		
		local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand(0.4, 0.8) )
			particle:SetStartAlpha(255)
			particle:SetStartSize( math.Rand(14, 18) )
			particle:SetEndSize( 4 )
			particle:SetColor( 255 - health * 2, health * 2.1, 30 )
			particle:SetRoll( math.Rand(0, 359) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			
		-- Moving around particles
		for x = 1, math.random(1, 3) do
			local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos + VectorRand() * 3 )
				particle:SetVelocity( vel )
				particle:SetDieTime( math.Rand(0.4, 0.8) )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand(10, 14) )
				particle:SetEndSize(0)
				particle:SetColor( 255 - health * 2, health * 2.1, 30 )
				particle:SetRoll( math.Rand(0, 359) )
				particle:SetRollDelta( math.Rand(-2, 2) )
		end
		
		Emitter:Finish()
	end
	
	-- Apply cooldown to the effect
	NextAura = CurTime() + 0.4
end

--  Almost same aura effect as above but for medic

local NextMAura = 0
function MedicAuraThink ()
	if not ValidEntity ( MySelf ) then return end
	if MySelf:GetHumanClass() ~= 1 then return end
	if not MySelf:Alive() then return end
	if NextMAura > CurTime() then return end
	
	local Position, MaxAuras, AuraTable = MySelf:GetPos(), 0, {}
	
	-- Run through the humans and check who is alive
	for _, pl in pairs( team.GetPlayers ( TEAM_HUMAN ) ) do
		if pl:Alive() and pl ~= MySelf then
			local HumanPosition = pl:GetPos()
			if HumanPosition:Distance ( Position ) < 500 and HumanPosition:ToScreen().visible then
				AuraTable[pl] = HumanPosition
				MaxAuras = MaxAuras + 1
				
				-- We have reached our aura limit ( 10 )
				if MaxAuras >= 7 then break end
			end
		end
	end
	
	-- End this if there are no player souls to render
	if MaxAuras <= 0 then return end
	
	-- Render the souls
	local Emitter = ParticleEmitter( EyePos() )
	for pl, HumanPosition in pairs( AuraTable ) do
		local vel = pl:GetVelocity() * 0.95
		local health = pl:Health()
		
		-- Get the position of the chest
		local attach = pl:GetAttachment( pl:LookupAttachment("chest") )
		if not attach then
			attach = { Pos = pl:GetPos() + Vector(0,0,48) }
		end
		
		-- Centered particle		
		local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand(0.4, 0.8) )
			particle:SetStartAlpha(255)
			particle:SetStartSize( math.Rand(14, 18) )
			particle:SetEndSize( 4 )
			particle:SetColor( 255 - health * 2, health * 2.1, 30 )
			particle:SetRoll( math.Rand(0, 359) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			
		-- Moving around particles
		for x = 1, math.random(1, 3) do
			local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos + VectorRand() * 3 )
				particle:SetVelocity( vel )
				particle:SetDieTime( math.Rand(0.4, 0.8) )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand(10, 14) )
				particle:SetEndSize(0)
				particle:SetColor( 255 - health * 2, health * 2.1, 30 )
				particle:SetRoll( math.Rand(0, 359) )
				particle:SetRollDelta( math.Rand(-2, 2) )
		end
		
		Emitter:Finish()
	end
	
	-- Apply cooldown to the effect
	NextMAura = CurTime() + math.Rand(0.2,0.7)
end

