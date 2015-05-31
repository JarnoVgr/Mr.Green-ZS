-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local DAMAGE_BLUR = true
local IRON_CROSSHAIR = false

ColorModify = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0.
}

local ColorMod = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0.
}

local ZombieCM = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_addr"] = 0.2,
	["$pp_colour_addg"] = 0.1,
	["$pp_colour_addb"] = 0.0,
	["$pp_colour_mulr"] = 0.2,
	["$pp_colour_mulg"] = 0.1,
	["$pp_colour_mulb"] = 0.0
}

--[[local ZombieCM = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.3,
	["$pp_colour_addr"] = 0.1,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_mulr"] = 1,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 1.
]]--}

local ZombieHowlerCM = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_addr"] = 0.2,
	["$pp_colour_addg"] = 0.10,
	["$pp_colour_addb"] = 0.0,
	["$pp_colour_mulr"] = 1.3,
	["$pp_colour_mulg"] = 0.1,
	["$pp_colour_mulb"] = 0.1
}

local ZombieRageCM = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_addr"] = 0.15,
	["$pp_colour_addg"] = 0.10,
	["$pp_colour_addb"] = 0.0,
	["$pp_colour_mulr"] = 1.5,
	["$pp_colour_mulg"] = 0.5,
	["$pp_colour_mulb"] = 0.5
}

--Alive Human
--[[
--Oldest
local HumanCM = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}]]
--[[
--Pre-Changes
local HumanCM = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.03, --0.08
	["$pp_colour_contrast"] = 0.8,
	["$pp_colour_colour"] = 0.68,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 1
}]]

local HumanCM = {
	["$pp_colour_addr"] = 20,
	["$pp_colour_addg"] = 2,
	["$pp_colour_addb"] = 20,
	["$pp_colour_brightness"] = 0.005,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0.8,
	["$pp_colour_mulr"] = 1.2,
	["$pp_colour_mulg"] = 1.0,
	["$pp_colour_mulb"] = 1.2
}

--When spectating Zombies
local DeadSpectatorCM = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_addr"] = 0.2,
	["$pp_colour_addg"] = 0.10,
	["$pp_colour_addb"] = 0.0,
	["$pp_colour_mulr"] = 1.05,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

--Spectators
local SpectatorCM = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 1,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 1
}

--When connecting
local ConnectingCM = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.08,
	["$pp_colour_contrast"] = 1.25,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

--[==[--------------------------------------------------
        Used to calculate color mod values
---------------------------------------------------]==]
local DrawColorModify = DrawColorModify
local surface = surface
local EyePos = EyePos
local EyeAngles = EyeAngles
local zombies = 0
function CalculateColorMod()
	if not IsValid(MySelf) or not util.tobool(GetConVarNumber("zs_drawcolourmod")) then
		return
	end
	
	-- Undead side post proccesing
	if MySelf:Team() == TEAM_UNDEAD and not ENDROUND then
		local max = math.min(team.NumPlayers(TEAM_UNDEAD),HORDE_MAX_ZOMBIES)
		zombies = math.Approach(zombies, math.Clamp(MySelf:GetNearUndead(HORDE_MAX_DISTANCE),0,10), FrameTime() * 5)
		ZombieCM["$pp_colour_colour"] = math.min(1, 0.25 + 1.75 * (zombies/max))

		for k,v in pairs ( ZombieCM ) do
			local ApproachTo = ZombieCM[k]
			if MySelf:HasHowlerProtection() then
				ApproachTo = ZombieHowlerCM[k]
			end
			
			-- Check for zombie rage
			if MySelf:IsZombieInRage() or MySelf.IsWraithTeleporting then
				ApproachTo = ZombieRageCM[k]
			end
			
			-- Approach colors
			local ApproachMul = 0.01
			if MySelf:IsWraith() then ApproachMul = 0.0025 end
			ColorMod[k] = math.Approach ( ColorMod[k], ApproachTo, ApproachTo * ApproachMul )
		end
	-- Human side post proccesing
	elseif MySelf:Team() == TEAM_HUMAN and not ENDROUND then
		--Draw bloom
		--DrawBloom( .65, 1, 9, 9, 1, .65, 1, 1, 1 )
		
		--Special settings for Nightmode
		for k,v in pairs(HumanCM) do
			if k ~= "$pp_colour_addr" and k ~= "$pp_colour_addg" and k ~= "$pp_colour_addb" and k ~= "$pp_colour_colour" then
				ColorMod[k] = v
			end
		end

		--Health events
		local Red, Green, Blue, Color = ColorMod["$pp_colour_addr"], ColorMod["$pp_colour_addg"], ColorMod["$pp_colour_addb"], ColorMod["$pp_colour_colour"]
		local iRedAmount, iGreenAmount, iBlueAmount, iColor = 0, 0, 0, 0.68
		local Health = MySelf:Health()
		
		--Smooth rate
		local Rate, ColorRate = FrameTime() * 0.1, FrameTime() * 0.18	
		
		--Make the screen red when below 35 hp
		if not MySelf:GetPerk("_adrenaline") then
			if Health <= 35 then 
				iRedAmount = 0.16
			end
			
			-- Make the screen go yellowish inbetween [36, 50]
			if Health > 35 and Health <= 50 or ( MySelf:IsTakingDOT() and Health > 35 ) then 
				iRedAmount, iGreenAmount = 0.05, 0.05		
			end
		end
		
		--Exploit color change
		if MySelf:GetDTInt(3) > 0 then
			iRedAmount, iGreenAmount = 0.25, 0.1
		end
		
		--More color when humans around, less when you are alone!
		if Health > 50 then
			local HumansNearMe = GetHumanFocus(MySelf, 380)
			iColor = math.Clamp(HumansNearMe / 3, 0.4, 0.75) 
		end
			
		-- Dramatically change colors if you redeem
		if Red == 0.25 and Green == 0.20 then
			Rate = 10
		end
		
		-- Smooth color values
		ColorMod["$pp_colour_addr"] = math.Approach( Red, iRedAmount, Rate)
		ColorMod["$pp_colour_addg"] = math.Approach( Green, iGreenAmount, Rate)
		ColorMod["$pp_colour_addb"] = math.Approach( Blue, iBlueAmount, Rate)
		ColorMod["$pp_colour_colour"] = math.Approach( Color, iColor, ColorRate)
	-- Dead post proccesing
	elseif MySelf:Team() == TEAM_SPECTATOR or ENDROUND then
		if not MySelf.ReadySQL or IsLoadoutOpen() or ENDROUND then
			for k,v in pairs(ConnectingCM) do
				ColorMod[k] = v
			end
		else
			for k,v in pairs(SpectatorCM) do
				ColorMod[k] = v
			end
		end

	end
	
	-- Actually change colors
	
	DrawColorModify(ColorMod)
end

--[==[---------------------------------------------------------
     Render screen effects/ post proccesing here
---------------------------------------------------------]==]
function GM:_RenderScreenspaceEffects()
	if not IsValid(MySelf) or render.GetDXLevel() < 80 then
		return
	end

	--Blur the screen at Endround
	if ENDROUND then
		DrawBlur(5, 1.2)
	--Blur for zombie classes menu background
	elseif IsClassesMenuOpen() then
		--print("_RenderScreenspaceEffects-3")
		DrawBlur(5, 3)
	end
		
	-- Sharpen Effect Think
	CalculateSharpenEffect()

	-- Dynamic color mod
	CalculateColorMod()
	
	--Sobel post-process
	ManageSobelEffect()
end
hook.Add("RenderScreenspaceEffects", "PostProcess", function()
	GAMEMODE:_RenderScreenspaceEffects()
end)

--[==[----------------------------------------------------
	Used to manage sobel effect
-----------------------------------------------------]==]
local fSobel = 0
function ManageSobelEffect()
	local fCurrentSobel = 0

	-- Approach sobel value
	fSobel = math.Approach(fSobel, fCurrentSobel, 0.004)
	
	-- Apply 
	if fSobel > 0 then
		DrawSobel(fSobel)
	end
end

--[==[---------------------------------------------------------
     Used to motion blur the edge of the screen
---------------------------------------------------------]==]
local fBlurForward = 0
local function ManageSourceMotionBlur ( x, y, fwd, spin )
	if not IsValid ( MySelf ) then
		return
	end
	
	local fBlurForwardAmount = 0
	
	--Blur when health is low as human
	if MySelf:Team() == TEAM_HUMAN then
		if MySelf:Health() <= 50 or MySelf:IsTakingDOT() then
			if MySelf:Health() >= 35 then fBlurForwardAmount = 0.03 else fBlurForwardAmount = 0.1 end
		end
		
		--Explot blur
		if MySelf:GetDTInt( 3 ) > 0 then
			fBlurForwardAmount = 0.6
		end

		--Ironsight blur
		local Weapon = MySelf:GetActiveWeapon()
		if IsValid ( Weapon ) then
			if Weapon.GetIronsights and Weapon:GetIronsights() then
				fBlurForwardAmount = 0.03
			end
		end
	end
	
	--Wraith blur effect/ethereal
	if MySelf:Alive() and MySelf:IsZombie() and MySelf:IsWraith() then
		fBlurForwardAmount = 0.04
	end
	
	--Smooth the blur apparition
	fBlurForward = math.Approach ( fBlurForward, fBlurForwardAmount, 0.001 )
	
	return x * 4, y * 4, fBlurForward, spin
end
hook.Add( "GetMotionBlurValues", "GetBlurValues", ManageSourceMotionBlur )

--[==[---------------------------------------------------------
	Calculate how much sharpen to apply
---------------------------------------------------------]==]
local fSharpenContrast, fSharpenOffset = 0, 0.22
function CalculateSharpenEffect()
	if not IsValid(MySelf) or not util.tobool(GetConVarNumber("zs_drawsharpeneffect")) then
		return
	end
	
	local fSharpenContrastAmount = 0
	
	-- Get how many zombies are there near me
	if MySelf:Team() == TEAM_HUMAN then
		local ZombiesNearMe = MySelf:GetNearUndead(300)
		fSharpenContrastAmount = math.Clamp(ZombiesNearMe, 0, 7)
		
		-- Make it more obvious
		if ZombiesNearMe > 0 and ZombiesNearMe < 3 then
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
function DrawBlur(starttime, amount)
    if starttime == 0 and amount == 0 then
		return
	end
 
    local Fraction = 1
    
	if amount then  
        Fraction = amount
    elseif starttime then
        Fraction = math.Clamp((SysTime() - starttime) / 2, 0, 1)
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
           
    surface.SetDrawColor( 10, 10, 10, 105 * Fraction )
    surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
           
    DisableClipping( false )
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
local FuckColTab = {
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
	if not length then
		length = 3
	end
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

local function ZS_EnableBlur(sender, command, arguments)
	DAMAGE_BLUR = util.tobool(arguments[1])

	if DAMAGE_BLUR then
		MySelf:ChatPrint("Damage Blur Effect enabled.")
	else
		MySelf:ChatPrint("Damage Blur Effect disabled.")
	end
end
concommand.Add("zs_pp_enableblur", ZS_EnableBlur)

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
