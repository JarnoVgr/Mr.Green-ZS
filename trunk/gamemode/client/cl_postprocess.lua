-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local render = render


CreateClientConVar("_disable_pp", 0, true, false)
CreateClientConVar("_zs_enableblur",1,true,false) 
-- CreateClientConVar("_zs_enablefilmgrain", 1, true, false)
-- CreateClientConVar("_zs_enablecolormod", 1, true, false)
CreateClientConVar("_zs_filmgrainopacity", 4, true, false)
-- CreateClientConVar( "_zs_ironsight",0, true, false ) 

local FILM_GRAIN = util.tobool( GetConVarNumber("_zs_enablefilmgrain") )
local FILM_GRAIN_OPACITY = GetConVarNumber( "_zs_filmgrainopacity" )
local COLOR_MOD = true
local DAMAGE_BLUR = true
IRON_CROSSHAIR = false

ColorModify = {}
ColorModify["$pp_colour_addr"] = 0
ColorModify["$pp_colour_addg" ] = 0
ColorModify["$pp_colour_addb" ] = 0
ColorModify["$pp_colour_brightness" ] = 0
ColorModify["$pp_colour_contrast" ] = 1
ColorModify["$pp_colour_colour" ] = 1
ColorModify["$pp_colour_mulr" ] = 0
ColorModify["$pp_colour_mulg" ] = 0
ColorModify["$pp_colour_mulb" ] = 0

ColorMod = {}
ColorMod["$pp_colour_addr"] = 0
ColorMod["$pp_colour_addg" ] = 0
ColorMod["$pp_colour_addb" ] = 0
ColorMod["$pp_colour_brightness" ] = 0
ColorMod["$pp_colour_contrast" ] = 1
ColorMod["$pp_colour_colour" ] = 1
ColorMod["$pp_colour_mulr" ] = 0
ColorMod["$pp_colour_mulg" ] = 0
ColorMod["$pp_colour_mulb" ] = 0

local ZombieCM = {}
ZombieCM[ "$pp_colour_addb" ] 	= 0
ZombieCM[ "$pp_colour_contrast" ] = 1.2
ZombieCM[ "$pp_colour_colour" ] = 1
ZombieCM["$pp_colour_mulg" ] = 0
ZombieCM["$pp_colour_mulb" ] = 0
ZombieCM[ "$pp_colour_brightness" ] = -0.1
ZombieCM[ "$pp_colour_addr" ]	= 0.25
ZombieCM[ "$pp_colour_mulr" ] 	= 0.15
ZombieCM[ "$pp_colour_addg" ]	= 0.20

local tColorModZombie = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1.25,
	["$pp_colour_colour"] = 0.5,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

ZombieCM = tColorModZombie

local tColorModHuman = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}


local ZombieHowlerCM = {}
ZombieHowlerCM[ "$pp_colour_addb" ] 	= 0
ZombieHowlerCM[ "$pp_colour_contrast" ] = 1.2
ZombieHowlerCM[ "$pp_colour_colour" ] = 1
ZombieHowlerCM["$pp_colour_mulg" ] = 0
ZombieHowlerCM["$pp_colour_mulb" ] = 0
ZombieHowlerCM[ "$pp_colour_brightness" ] = -0.20
ZombieHowlerCM[ "$pp_colour_addr" ]	= 0.31
ZombieHowlerCM[ "$pp_colour_mulr" ] 	= 0.15
ZombieHowlerCM[ "$pp_colour_addg" ]	= 0.20

local ZombieRageCM = {}
ZombieRageCM[ "$pp_colour_addb" ] 	= 0
ZombieRageCM[ "$pp_colour_contrast" ] = 1.5
ZombieRageCM[ "$pp_colour_colour" ] = 1
ZombieRageCM["$pp_colour_mulg" ] = 0
ZombieRageCM["$pp_colour_mulb" ] = 0
ZombieRageCM[ "$pp_colour_brightness" ] = -0.18
ZombieRageCM[ "$pp_colour_addr" ] = 0.27
ZombieRageCM[ "$pp_colour_mulr" ] = 0.16
ZombieRageCM[ "$pp_colour_addg" ] = 0.15

local HumanCM = { }
HumanCM[ "$pp_colour_addr" ] 		= 0
HumanCM[ "$pp_colour_addg" ] 		= 0
HumanCM[ "$pp_colour_addb" ] 		= 0
HumanCM[ "$pp_colour_brightness" ] 	= -0.09---0.02
HumanCM[ "$pp_colour_contrast" ] 	= 1.1
HumanCM[ "$pp_colour_colour" ] 		= 0.7--0.68
HumanCM[ "$pp_colour_mulr" ] 		= 0
HumanCM[ "$pp_colour_mulg" ] 		= 1
HumanCM[ "$pp_colour_mulb" ] 		= 1

HumanCM = tColorModHuman

local DHumanCM = { }
DHumanCM[ "$pp_colour_addr" ] 		= 0
DHumanCM[ "$pp_colour_addg" ] 		= 0
DHumanCM[ "$pp_colour_addb" ] 		= 0
DHumanCM[ "$pp_colour_brightness" ] 	= -0.02
DHumanCM[ "$pp_colour_contrast" ] 	= 0.8
DHumanCM[ "$pp_colour_colour" ] 		= 0.68
DHumanCM[ "$pp_colour_mulr" ] 		= 0
DHumanCM[ "$pp_colour_mulg" ] 		= 1
DHumanCM[ "$pp_colour_mulb" ] 		= 1


local DeadCM = {}
DeadCM["$pp_colour_contrast"] = 1.25
DeadCM["$pp_colour_colour"] = 0
DeadCM["$pp_colour_addr"] = 0
DeadCM["$pp_colour_addg"] = 0
DeadCM["$pp_colour_addb"] = 0
DeadCM["$pp_colour_brightness"] = -0.08
DeadCM["$pp_colour_mulr"] = 0
DeadCM["$pp_colour_mulg"] = 0
DeadCM["$pp_colour_mulb"] = 0

--[==[---------------------------------------------------------
      Receives toxic zombie points from the server 
---------------------------------------------------------]==]
ToxicPoints = {}
local function ReceiveToxicPositions ( um )
	if not ValidEntity ( MySelf ) then return end
	
	-- Table length
	local tbStart = um:ReadShort()
	local tbEnd = um:ReadShort()
	
	-- Grab the data
	for i = tbStart, tbEnd do
		local vPos = um:ReadVector() 
		table.insert ( ToxicPoints, vPos )
	end
	
	-- Initialize toxic fumes effect
	timer.Simple ( 1.5, function() if not bInitFumes then RefreshToxicFumes() bInitFumes = true Debug ( "[FUMES] Initialized toxic fumes effects." ) end end )
	
	Debug ( "[CLIENT] Succesfully received toxic fumes positions from server." )
end
usermessage.Hook ( "ReceiveToxicPositions", ReceiveToxicPositions )

--[==[--------------------------------------------------
        Used to calculate color mod values
---------------------------------------------------]==]
local DrawColorModify = DrawColorModify
local surface = surface
local EyePos = EyePos
local EyeAngles = EyeAngles
local zombies = 0
function CalculateColorMod()
	if not ValidEntity ( MySelf ) then return end
	
	
	
	-- Undead side post proccesing
	if MySelf:Team() == TEAM_UNDEAD then
		local max = math.min(team.NumPlayers(TEAM_UNDEAD),HORDE_MAX_ZOMBIES)
		zombies = math.Approach(zombies, MySelf:GetHordeCount(), FrameTime() * 5)
		ZombieCM["$pp_colour_colour"] = math.min(1, 0.25 + 1.75 * (zombies/max))
		for k,v in pairs ( ZombieCM ) do
			local ApproachTo = ZombieCM[k]
			if MySelf:HasHowlerProtection() then ApproachTo = ZombieHowlerCM[k] end
			
			-- Check for zombie rage
			if MySelf:IsZombieInRage() or MySelf.IsWraithTeleporting then ApproachTo = ZombieRageCM[k] end
			
			-- Approach colors
			local ApproachMul = 0.01
			if MySelf:IsWraith() then ApproachMul = 0.0025 end
			ColorMod[k] = math.Approach ( ColorMod[k], ApproachTo, ApproachTo * ApproachMul )
		end
	end
	
	--HCOLORMOD = util.tobool( GetConVarNumber("_zs_hcolormod") )
	--COLORMOD = util.tobool( GetConVarNumber("_zs_enablecolormod") )
	HCOLORMOD = true
	COLORMOD = true
	
	-- Human side post proccesing
	if MySelf:Team() == TEAM_HUMAN then
		if COLORMOD then
			if HCOLORMOD then
				DrawBloom( .65, 1, 9, 9, 1, .65, 1, 1, 1 )
			end
		end
		
		if COLORMOD then
			if HCOLORMOD and not GAMEMODE:IsNightMode() then
				for k,v in pairs(HumanCM) do
					if k ~= "$pp_colour_addr" and k ~= "$pp_colour_addg" and k ~= "$pp_colour_addb" and k ~= "$pp_colour_colour" then
						ColorMod[k] = v
					end
				end
			else
				for k,v in pairs(DHumanCM) do
					if k ~= "$pp_colour_addr" and k ~= "$pp_colour_addg" and k ~= "$pp_colour_addb" and k ~= "$pp_colour_colour" then
						ColorMod[k] = v
					end
				end
			end
		end
		
		-- Health events
		local Red, Green, Blue, Color = ColorMod["$pp_colour_addr"], ColorMod["$pp_colour_addg"], ColorMod["$pp_colour_addb"], ColorMod["$pp_colour_colour"]
		local iRedAmount, iGreenAmount, iBlueAmount, iColor = 0, 0, 0, 0.68
		local Health = MySelf:Health()
		
		-- Smooth rate
		local Rate, ColorRate = FrameTime() * 0.1, FrameTime() * 0.18	
		
		-- Make the screen red when below 35 hp
		if not MySelf:GetPerk("_adrenaline") then
			if Health <= 35 then 
				iRedAmount = 0.16
			end
			
			-- Make the screen go yellowish inbetween [36, 50]
			if Health > 35 and Health <= 50 or ( MySelf:IsTakingDOT() and Health > 35 ) then 
				iRedAmount, iGreenAmount = 0.05, 0.05		
			end
		end
		-- Color the screen green-yellow if the player is in toxic fumes
		if MySelf:Health() > 30 and MySelf:IsInToxicFumes( ToxicPoints ) then
			iRedAmount, iGreenAmount, Rate = 0.2, 0.2, FrameTime() * 0.18
		end
		
		-- Exploit color change
		if MySelf:GetDTInt( 3 ) > 0 then
			iRedAmount, iGreenAmount = 0.25, 0.1
		end
		
		-- More color when humans around, less when you are alone!
		if Health > 50 then
			local HumansNearMe = GetHumanFocus ( MySelf, 380 )
			iColor = math.Clamp ( HumansNearMe / 3, 0.4, 0.75 ) 
		end
			
		-- Dramatically change colors if you redeem
		if Red == 0.25 and Green == 0.20 then Rate = 10 end
		
		-- Smooth color values
		ColorMod["$pp_colour_addr"] = math.Approach ( Red, iRedAmount, Rate ) 
		ColorMod["$pp_colour_addg"] = math.Approach ( Green, iGreenAmount, Rate )
		ColorMod["$pp_colour_addb"] = math.Approach ( Blue, iBlueAmount, Rate )
		ColorMod["$pp_colour_colour"] = math.Approach ( Color, iColor, ColorRate )  		
	end
	
	-- Dead post proccesing
	if not ENDROUND and ( MySelf:Team() == TEAM_SPECTATOR ) then
		for k,v in pairs ( DeadCM ) do
			ColorMod[k] = v
		end
	end
	
	-- Actually change colors
	
	DrawColorModify( ColorMod )
end

--[==[---------------------------------------------------------
     Render screen effects/ post proccesing here
---------------------------------------------------------]==]
function GM:_RenderScreenspaceEffects()
	if not ValidEntity ( MySelf ) then return end
	if render.GetDXLevel() < 80 then return end
	
	--  Blur the screen on endround
	if ENDROUND then
		DrawBlur ( 5, 1.2 )
	end
		
	-- Blur for zombie classes menu background
	if IsClassesMenuOpen() then
		DrawBlur ( 5, 3 )
	end
		
	-- Sharpen Effect Think
	CalculateSharpenEffect()
	
	-- Dynamic Filmgrain
	CalculateFilmGrainEffect()
	
	-- Dynamic color mod
	CalculateColorMod()
	
	-- Sobel post-process
	ManageSobelEffect()
end

--[==[----------------------------------------------------
	Used to manage sobel effect
-----------------------------------------------------]==]
local fSobel = 0
function ManageSobelEffect()

	local fCurrentSobel = 0

	-- Approach sobel value
	fSobel = math.Approach ( fSobel, fCurrentSobel, 0.004 )
	
	-- Apply 
	if fSobel > 0 then
		DrawSobel( fSobel )
	end
end

--[==[---------------------------------------------------------
     Used to motion blur the edge of the screen
---------------------------------------------------------]==]
local fBlurForward = 0
local function ManageSourceMotionBlur ( x, y, fwd, spin )
	if not ValidEntity ( MySelf ) then return end
	
	local fBlurForwardAmount = 0
	
	-- Blur when health is low as human
	if MySelf:Team() == TEAM_HUMAN then
		if MySelf:Health() <= 50 or MySelf:IsTakingDOT() then
			if MySelf:Health() >= 35 then fBlurForwardAmount = 0.03 else fBlurForwardAmount = 0.1 end
		end
		
		-- Explot blur
		if MySelf:GetDTInt( 3 ) > 0 then
			fBlurForwardAmount = 0.6
		end
		IRONBLUR = util.tobool( GetConVarNumber("_zs_enableironsightblur") )
		if IRONBLUR then
			-- ironsight blur
			local Weapon = MySelf:GetActiveWeapon()
			if ValidEntity ( Weapon ) then
				if Weapon.GetIronsights and Weapon:GetIronsights() then
					fBlurForwardAmount = 0.03
				end
			end
		end
	end
	
	-- Wraith blur effect/ethereal
	if MySelf:Alive() then
		if MySelf:IsZombie() and MySelf:IsWraith() then
			fBlurForwardAmount = 0.04
		end
	end
	
	-- Smooth the blur apparition
	fBlurForward = math.Approach ( fBlurForward, fBlurForwardAmount, 0.001 )
	
	return x * 4, y * 4, fBlurForward, spin
end
hook.Add( "GetMotionBlurValues", "GetBlurValues", ManageSourceMotionBlur )

--[==[---------------------------------------------------------
	Calculate how much sharpen to apply
---------------------------------------------------------]==]
local fSharpenContrast, fSharpenOffset = 0, 0.22
function CalculateSharpenEffect ()
	if not ValidEntity ( MySelf ) then return end
	
	local fSharpenContrastAmount = 0
	
	-- Get how many zombies are there near me
	if MySelf:Team() == TEAM_HUMAN then
		local ZombiesNearMe = GetZombieFocus ( MySelf, 300 )
		fSharpenContrastAmount = math.Clamp ( ZombiesNearMe, 0, 9 )
		
		-- Make it more obvious
		if ZombiesNearMe < 3 and ZombiesNearMe > 0 then
			fSharpenContrastAmount = 3.5
		end
	end
	
	-- Smooth the contrast apparition
	fSharpenContrast = math.Approach ( fSharpenContrast, fSharpenContrastAmount, 0.05 )
		
	-- Finally, set the sharpen
	if fSharpenContrast ~= 0 then
		DrawSharpen ( fSharpenContrast, fSharpenOffset )
	end
end

--[==[---------------------------------------------------------
    Blur function taken from utils
---------------------------------------------------------]==]
local matBlurScreen = Material( "pp/blurscreen" )

function DrawBlur ( starttime, amount )
    if starttime == 0 and amount == 0 then return end
 
    local Fraction = 1
     
    if ( starttime ) then
        Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
    end
    
    if ( amount ) then  
        Fraction = amount
    end
     
    x,y = 0,0
     
    DisableClipping( true )
           
    surface.SetMaterial( matBlurScreen )   
    surface.SetDrawColor( 255, 255, 255, 255 )
                   
    for i=0.33, 1, 0.33 do
        matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
        if ( render ) then render.UpdateScreenEffectTexture() end 
        surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
    end
           
    surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
    surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
           
    DisableClipping( false )
end

--[==[---------------------------------------------------------
	Calculates how much film grain to apply
---------------------------------------------------------]==]
local fFilmGrain, matFilmGrain = 0, surface.GetTextureID( "zombiesurvival/filmgrain/filmgrain.vtf" )
function CalculateFilmGrainEffect()
	if not ValidEntity ( MySelf ) or ENDROUND then return end
	if not util.tobool( GetConVarNumber("_zs_enablefilmgrain") ) then return end
	
	local fFilmGrainAmount, iLimit, iOffset = 0, 2.3, 3
	if WIDESCREEN then iLimit, iOffset = 2.3, 0.6  end
	
	-- Get how many zombies are there near me
	if MySelf:Team() == TEAM_HUMAN then
		local ZombiesNearMe = GetZombieFocus ( MySelf, 300 )
		fFilmGrainAmount = math.Clamp ( ZombiesNearMe + iOffset, 0, iLimit )
	end
	
	-- Get how many humans are near me (zombie side grain)
	if MySelf:Team() == TEAM_UNDEAD then
		local HumansNearMe = GetHumanFocus ( MySelf, 180 )
		fFilmGrainAmount = math.Clamp ( HumansNearMe + iOffset, 0, iLimit )
	end
	
	-- Smooth the contrast apparition
	fFilmGrain = math.Approach ( fFilmGrain, fFilmGrainAmount, 0.08 )
		
	-- Apply film grain material
	surface.SetTexture ( matFilmGrain )
	surface.SetDrawColor( 225, 225, 225, fFilmGrain * 1.5 )
			
	-- Tile it on the screen
	for x = 0, w, 1024 do
		for y = 0, h, 512 do
			surface.DrawTexturedRect( x, y, 1024, 512 )
		end
	end
end

local function DecayPoisonedEffect()
	HumCM["$pp_colour_addg"] = math.Approach(ColorModify["$pp_colour_addg"], 0, FrameTime() * 0.5)
	HumCM["$pp_colour_brightness"] = math.Approach(ColorModify["$pp_colour_brightness"], 0, FrameTime() * 0.5)

	if HumCM["$pp_colour_addg"] <= 0 then
		timer.Destroy("poison")
	end
end

local function PoisEff(um)
	HumCM["$pp_colour_addg"] = 0.25
	HumCM["$pp_colour_brightness"] = 0.25
	timer.Create("poison", 0, 0, DecayPoisonedEffect)
end
usermessage.Hook("PoisonEffect", PoisEff)

function EyePoisoned()
	MySelf.Blindness = CurTime() + math.random(14, 18)
	MySelf.BlindRotate = 0
	-- PoisEff()

	hook.Add("HUDPaint", "EyePoison", PaintBlindness)
end

-- Stalker Screen Fuck effect (copied from Infected Wars. Yes I'm lazy)

local FuckedTime = 0
local FuckedLength = 0
local FuckColTab = 
{
	[ "$pp_colour_addr" ] 		= 0,
	[ "$pp_colour_addg" ] 		= 0,
	[ "$pp_colour_addb" ] 		= 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] 	= 1,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0
}

local function DrawStalkerFuck()
	DrawColorModify( FuckColTab )
	DrawMotionBlur( 0.2, math.Clamp(FuckedTime-CurTime(),0,1), 0)
	FuckColTab[ "$pp_colour_colour" ] = math.Approach( FuckColTab[ "$pp_colour_colour" ], 1, FuckedLength*FrameTime())
	local sev = math.Clamp(FuckedTime-CurTime(),0,5)/35
	FuckColTab[ "$pp_colour_brightness" ] = math.Rand(-sev*2,sev*2)
	
	local MySelf = LocalPlayer()
	MySelf:SetEyeAngles((MySelf:GetAimVector()+Vector(math.Rand(-sev,sev),math.Rand(-sev,sev),math.Rand(-sev,sev))):Angle())
	
	if FuckedTime < CurTime() then
		FuckColTab[ "$pp_colour_brightness" ] = 0
		hook.Remove("RenderScreenspaceEffects", "DrawStalkerFuck")
	end
end
-- small snippet from iw
local EndColTab = 
{
	[ "$pp_colour_addr" ] 		= 0,
	[ "$pp_colour_addg" ] 		= 0,
	[ "$pp_colour_addb" ] 		= 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] 	= 1,
	[ "$pp_colour_colour" ] 	= 1,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0
}

function StalkerFuck(length)
	if not length then length = 3 end
	hook.Remove("RenderScreenspaceEffects", "DrawStalkerFuck")
	FuckColTab[ "$pp_colour_colour" ] = 0
	FuckedTime = CurTime()+length
	FuckedLength = length
	hook.Add("RenderScreenspaceEffects", "DrawStalkerFuck", DrawStalkerFuck)
end

-- Stalker Scream effect

local DrawTime = 0

local function DrawStalkerScream()
	DrawSharpen( (DrawTime-CurTime())/2 ,DrawTime-CurTime() )
	local MySelf = LocalPlayer()
	local sev = 0.01
	MySelf:SetEyeAngles((MySelf:GetAimVector()+Vector(math.Rand(-sev,sev),math.Rand(-sev,sev),math.Rand(-sev,sev))):Angle())	
	if DrawTime < CurTime() then
		hook.Remove("RenderScreenspaceEffects", "DrawStalkerScream")
	end
end

function WraithScream( iTime )
	hook.Remove("RenderScreenspaceEffects", "DrawStalkerScream")
	DrawTime = CurTime() + ( iTime or 3 )
	hook.Add("RenderScreenspaceEffects", "DrawStalkerScream", DrawStalkerScream)
end


local RageTime = 0

local function DrawZombieRage()
	DrawSharpen( ( RageTime - CurTime() ) / 2.7, RageTime - CurTime() )
	local MySelf = LocalPlayer()
	local sev = 0.01
	MySelf:SetEyeAngles((MySelf:GetAimVector()+Vector(math.Rand(-sev,sev),math.Rand(-sev,sev),math.Rand(-sev,sev))):Angle())	
	if RageTime < CurTime() then
		hook.Remove("RenderScreenspaceEffects", "DrawZombieRage")
	end
end

function RageScream( iTime )
	hook.Remove("RenderScreenspaceEffects", "DrawZombieRage")
	RageTime = CurTime() + ( iTime or 3 )
	hook.Add("RenderScreenspaceEffects", "DrawZombieRage", DrawZombieRage)
end

local function DisablePP(sender, command, arguments)
	DISABLE_PP = util.tobool(arguments[1])

	if DISABLE_PP then
		--RunConsoleCommand("_disable_pp", "1")
		MySelf:ChatPrint("Post process cannot be disabled.")
	else
		RunConsoleCommand("_disable_pp", "0")
		MySelf:ChatPrint("Post process enabled.")
	end
end
concommand.Add("disable_pp", DisablePP)

local function ZS_EnableMotionBlur(sender, command, arguments)
	MOTION_BLUR = util.tobool(arguments[1])

	if MOTION_BLUR then
		RunConsoleCommand("_zs_enablemotionblur", "1")
		MySelf:ChatPrint("Motion Blur enabled.")
	else
		RunConsoleCommand("_zs_enablemotionblur", "0")
		MySelf:ChatPrint("Motion Blur disabled.")
	end
end
concommand.Add("zs_enablemotionblur", ZS_EnableMotionBlur)

local function ZS_EnableFilmGrain(sender, command, arguments)
	FILM_GRAIN = util.tobool(arguments[1])

	if FILM_GRAIN then
		RunConsoleCommand("_zs_enablefilmgrain", "1")
		MySelf:ChatPrint("Film Grain enabled.")
	else
		RunConsoleCommand("_zs_enablefilmgrain", "0")
		MySelf:ChatPrint("Film Grain disabled.")
	end
end
concommand.Add("zs_enablefilmgrain", ZS_EnableFilmGrain)

local function ZS_EnableColorMod(sender, command, arguments)
	COLOR_MOD = util.tobool(arguments[1])

	if COLOR_MOD then
		RunConsoleCommand("_zs_enablecolormod", "1")
		MySelf:ChatPrint("Color Mod enabled.")
	else
		RunConsoleCommand("_zs_enablecolormod", "0")
		MySelf:ChatPrint("Color Mod disabled.")
	end
end
concommand.Add("zs_enablecolormod", ZS_EnableColorMod)

local function ZS_FilmGrainOpacity(sender, command, arguments)
	FILM_GRAIN_OPACITY = arguments[1]

	RunConsoleCommand("_zs_filmgrainopacity", FILM_GRAIN_OPACITY)
end
concommand.Add("zs_filmgrainopacity", ZS_FilmGrainOpacity)

local function ZS_EnableBlur(sender, command, arguments)
	DAMAGE_BLUR = util.tobool(arguments[1])

	if DAMAGE_BLUR then
		RunConsoleCommand("_zs_enableblur", "1")
		MySelf:ChatPrint("Damage Blur Effect enabled.")
	else
		RunConsoleCommand("_zs_enableblur", "0")
		MySelf:ChatPrint("Damage Blur Effect disabled.")
	end
end
concommand.Add("zs_enableblur", ZS_EnableBlur)

local function ZS_Ironsight(sender, command, arguments)
	IRON_CROSSHAIR = util.tobool(arguments[1])

	if IRON_CROSSHAIR then
		RunConsoleCommand("_zs_ironsight", "1")
		MySelf:ChatPrint("Crosshair enabled while ironsight.")
	else
		RunConsoleCommand("_zs_ironsight", "0")
		MySelf:ChatPrint("Crosshair disabled while ironsight.")
	end
end
concommand.Add("zs_ironsight", ZS_Ironsight)
