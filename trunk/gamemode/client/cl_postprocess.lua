-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local DAMAGE_BLUR = true
local IRON_CROSSHAIR = false





local colorModM = {
	activeColorCorrection = {
		[ "$pp_colour_addr" ] 				= 0,
		[ "$pp_colour_addg" ] 				= 0,
		[ "$pp_colour_addb" ] 				= 0,
		[ "$pp_colour_brightness" ] 		= 0,
		[ "$pp_colour_contrast" ] 			= 0,
		[ "$pp_colour_colour" ] 			= 0,
		[ "$pp_colour_mulr" ] 				= 0,
		[ "$pp_colour_mulg" ] 				= 0,
		[ "$pp_colour_mulb" ] 				= 0,		
	},

	//Team one base values and stuff.
	[TEAM_SPECTATOR] = {
		baseValues = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 1,
			[ "$pp_colour_colour" ] 			= 1.96,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
			motionBlurAmount					= 0
		},
		colorModMStages	= {
			[ 1 ] = {
				[ "$pp_colour_addr" ] 				= 0,
				[ "$pp_colour_addg" ] 				= 0,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= 0,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0,
				[ "$pp_colour_mulg" ] 				= 0,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			[ 2 ] = {
				[ "$pp_colour_addr" ] 				= 0,
				[ "$pp_colour_addg" ] 				= 0,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= 0,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0,
				[ "$pp_colour_mulg" ] 				= 0,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			[ 3 ] = {
				[ "$pp_colour_addr" ] 				= 0,
				[ "$pp_colour_addg" ] 				= 0,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= 0,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0,
				[ "$pp_colour_mulg" ] 				= 0,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
		},
		ColorRate = {
			[ "$pp_colour_addr" ] 				= 0.18,
			[ "$pp_colour_addg" ] 				= 0.12,
			[ "$pp_colour_addb" ] 				= 0.05,
			[ "$pp_colour_brightness" ] 		= 0.8,
			[ "$pp_colour_contrast" ] 			= 0.24,
			[ "$pp_colour_colour" ] 			= 0.48,
			[ "$pp_colour_mulr" ] 				= 0.24,
			[ "$pp_colour_mulg" ] 				= 0.16,
			[ "$pp_colour_mulb" ] 				= 0.12,	
		},
		addedEffects = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 0,
			[ "$pp_colour_colour" ] 			= 0,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
		},
		motionBlurAmount 						= 0,
		addedEffectRecoverRate 					= 0.4
	},
	[2] = {
		baseValues = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 1,
			[ "$pp_colour_colour" ] 			= 1.96,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
			motionBlurAmount					= 0
		},
		colorModMStages	= {
			[ 1 ] = {
				[ "$pp_colour_addr" ] 				= 0,
				[ "$pp_colour_addg" ] 				= 0,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= 0,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0,
				[ "$pp_colour_mulg" ] 				= 0,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			[ 2 ] = {
				[ "$pp_colour_addr" ] 				= 0,
				[ "$pp_colour_addg" ] 				= 0,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= 0,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0,
				[ "$pp_colour_mulg" ] 				= 0,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			[ 3 ] = {
				[ "$pp_colour_addr" ] 				= 0,
				[ "$pp_colour_addg" ] 				= 0,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= 0,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0,
				[ "$pp_colour_mulg" ] 				= 0,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			
		},
		ColorRate = {
			[ "$pp_colour_addr" ] 				= 0.18,
			[ "$pp_colour_addg" ] 				= 0.12,
			[ "$pp_colour_addb" ] 				= 0.05,
			[ "$pp_colour_brightness" ] 		= 0.8,
			[ "$pp_colour_contrast" ] 			= 0.24,
			[ "$pp_colour_colour" ] 			= 0.48,
			[ "$pp_colour_mulr" ] 				= 0.24,
			[ "$pp_colour_mulg" ] 				= 0.16,
			[ "$pp_colour_mulb" ] 				= 0.12,	
		},
		addedEffects = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 0,
			[ "$pp_colour_colour" ] 			= 0,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
		},
		motionBlurAmount 						= 0,
		addedEffectRecoverRate 					= 0.4
	},
	//Zombie Team
	[3] = {
		baseValues = {
				[ "$pp_colour_addr" ] 				= 0.24,
				[ "$pp_colour_addg" ] 				= 0.08,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.1,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.32,
				[ "$pp_colour_mulg" ] 				= 0.16,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
		colorModMStages	= {
			[ 1 ] = {
				[ "$pp_colour_addr" ] 				= 0.16,
				[ "$pp_colour_addg" ] 				= 0.06,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.1,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.22,
				[ "$pp_colour_mulg" ] 				= 0.12,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			[ 2 ] = {
				[ "$pp_colour_addr" ] 				= 0.16,
				[ "$pp_colour_addg" ] 				= 0.06,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.1,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.22,
				[ "$pp_colour_mulg" ] 				= 0.12,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			[ 3 ] = {
				[ "$pp_colour_addr" ] 				= 0.16,
				[ "$pp_colour_addg" ] 				= 0.06,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.1,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.22,
				[ "$pp_colour_mulg" ] 				= 0.12,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0
			},
			
		},
		ColorRate = {
			[ "$pp_colour_addr" ] 				= 0.16,
			[ "$pp_colour_addg" ] 				= 0.24,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0.30,
			[ "$pp_colour_contrast" ] 			= 0.5,
			[ "$pp_colour_colour" ] 			= 3,
			[ "$pp_colour_mulr" ] 				= 0.4,
			[ "$pp_colour_mulg" ] 				= 0.4,
			[ "$pp_colour_mulb" ] 				= 0.4,	
		},
		addedEffects = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 0,
			[ "$pp_colour_colour" ] 			= 0,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
		},
		motionBlurAmount 						= 0,
		addedEffectRecoverRate 					= 0.4
	},
	//Human team
	[4] = {
		baseValues = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 1,
			[ "$pp_colour_colour" ] 			= 1.96,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
			motionBlurAmount					= 0
		},
		colorModMStages	= {
			[ 1 ] = {
				[ "$pp_colour_addr" ] 				= 0.06,
				[ "$pp_colour_addg" ] 				= 0.02,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.05,
				[ "$pp_colour_contrast" ] 			= 1,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.08,
				[ "$pp_colour_mulg" ] 				= 0.04,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0.01
			},
			[ 2 ] = {
				[ "$pp_colour_addr" ] 				= 0.12,
				[ "$pp_colour_addg" ] 				= 0.04,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.07,
				[ "$pp_colour_contrast" ] 			= 1.2,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.16,
				[ "$pp_colour_mulg" ] 				= 0.08,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0.02
			},
			[ 3 ] = {
				[ "$pp_colour_addr" ] 				= 0.16,
				[ "$pp_colour_addg" ] 				= 0.06,
				[ "$pp_colour_addb" ] 				= 0,
				[ "$pp_colour_brightness" ] 		= -0.1,
				[ "$pp_colour_contrast" ] 			= 1.3,
				[ "$pp_colour_colour" ] 			= 1.96,
				[ "$pp_colour_mulr" ] 				= 0.22,
				[ "$pp_colour_mulg" ] 				= 0.12,
				[ "$pp_colour_mulb" ] 				= 0,
				motionBlurAmount					= 0.1
			},
			
		},
		ColorRate = {
			[ "$pp_colour_addr" ] 				= 0.18,
			[ "$pp_colour_addg" ] 				= 0.12,
			[ "$pp_colour_addb" ] 				= 0.05,
			[ "$pp_colour_brightness" ] 		= 0.8,
			[ "$pp_colour_contrast" ] 			= 0.5,
			[ "$pp_colour_colour" ] 			= 0.45,
			[ "$pp_colour_mulr" ] 				= 0.24,
			[ "$pp_colour_mulg" ] 				= 0.16,
			[ "$pp_colour_mulb" ] 				= 0.12,	
		},
		addedEffects = {
			[ "$pp_colour_addr" ] 				= 0,
			[ "$pp_colour_addg" ] 				= 0,
			[ "$pp_colour_addb" ] 				= 0,
			[ "$pp_colour_brightness" ] 		= 0,
			[ "$pp_colour_contrast" ] 			= 0,
			[ "$pp_colour_colour" ] 			= 0,
			[ "$pp_colour_mulr" ] 				= 0,
			[ "$pp_colour_mulg" ] 				= 0,
			[ "$pp_colour_mulb" ] 				= 0,
		},
		motionBlurAmount 						= 0,
		addedEffectRecoverRate 					= 0.4
	},
}

local function AnimatedColor(iStart, iEnd, iRate)
	if ( iStart == iEnd ) then
		return iEnd
	end
	return math.Approach(iStart, iEnd, FrameTime() * iRate )
end

local function SetcolorModMTable(activeTable, newTable, colorRateTable )
		activeTable[ "$pp_colour_addr" ] 			= AnimatedColor(activeTable[ "$pp_colour_addr" ], newTable["$pp_colour_addr"], colorRateTable["$pp_colour_addr"])
		activeTable[ "$pp_colour_addg" ] 			= AnimatedColor(activeTable[ "$pp_colour_addg" ], newTable["$pp_colour_addg"], colorRateTable["$pp_colour_addg"] )
		activeTable[ "$pp_colour_mulr" ] 			= AnimatedColor(activeTable[ "$pp_colour_mulr" ], newTable["$pp_colour_mulr"], colorRateTable["$pp_colour_mulr"])
		activeTable[ "$pp_colour_mulg" ] 			= AnimatedColor(activeTable[ "$pp_colour_mulg" ], newTable["$pp_colour_mulg"], colorRateTable["$pp_colour_mulg"] )
		activeTable[ "$pp_colour_addb" ] 			= AnimatedColor(activeTable[ "$pp_colour_addb" ], newTable["$pp_colour_addb"], colorRateTable["$pp_colour_mulg"] )
		activeTable[ "$pp_colour_mulb" ] 			= AnimatedColor(activeTable[ "$pp_colour_mulb" ], newTable["$pp_colour_mulb"], colorRateTable["$pp_colour_mulg"] )
		activeTable[ "$pp_colour_contrast" ] 		= AnimatedColor(activeTable[ "$pp_colour_contrast" ], newTable["$pp_colour_contrast"], colorRateTable["$pp_colour_contrast"] )
		activeTable[ "$pp_colour_brightness" ] 		= AnimatedColor(activeTable[ "$pp_colour_brightness" ], newTable["$pp_colour_brightness"], colorRateTable["$pp_colour_brightness"] )
		activeTable[ "$pp_colour_colour" ] 			= AnimatedColor(activeTable[ "$pp_colour_colour" ], newTable["$pp_colour_colour"], colorRateTable["$pp_colour_colour"])
end

local function RendercolorModM(pl)
	local pHealth			= pl:Health() 		|| 100
	local pMaxHealth		= pl:GetMaxHealth() || 100
	local pTeam				= pl:Team()
	local hPersentage		= (pHealth/pMaxHealth)
	local defaultTable 		= defaultTable		||	colorModM[pTeam].baseValues
	local ColorRate			= ColorRate 		||	colorModM[pTeam].ColorRate
	local activeColorTable 	= activeColorTable	||	colorModM.activeColorCorrection
	local colorStages		= colorStages		||	colorModM[pTeam].colorModMStages


	if ( hPersentage > 0.5 ) then
		SetcolorModMTable(activeColorTable, defaultTable, ColorRate)
		colorModM[pTeam].motionBlurAmount = AnimatedColor(colorModM[pTeam].motionBlurAmount, defaultTable.motionBlurAmount, 0.2 )
	elseif(hPersentage <= 0.5 && hPersentage > 0.4) then
		SetcolorModMTable(activeColorTable, colorStages[1], ColorRate)
		colorModM[pTeam].motionBlurAmount = AnimatedColor(colorModM[pTeam].motionBlurAmount, colorStages[1].motionBlurAmount, 0.2 )
	elseif(hPersentage <= 0.4 && hPersentage > 0.25) then
		SetcolorModMTable(activeColorTable, colorStages[2], ColorRate)
		colorModM[pTeam].motionBlurAmount = AnimatedColor(colorModM[pTeam].motionBlurAmount, colorStages[2].motionBlurAmount, 0.2 )
	elseif(hPersentage <= 0.25) then
		SetcolorModMTable(activeColorTable, colorStages[3], ColorRate)
		colorModM[pTeam].motionBlurAmount = AnimatedColor(colorModM[pTeam].motionBlurAmount, colorStages[3].motionBlurAmount, 0.2 )
	end
	
	DrawColorModify( activeColorTable )
end



hook.Add( "RenderScreenspaceEffects", "ScreenEffects", function()
	if ( !IsValid( MySelf ) || !util.tobool(GetConVarNumber("zs_drawcolourmod") ) ) then
		return 
	end
	print('asasasas')
	RendercolorModM( MySelf )
	DrawBloom( 0.6, 0.7, 4, 4, 1, 1.4, 1, 1.2, 1 )
end )

local maxBlur, addedBlur =  0.1, 0
function GM:GetMotionBlurValues( x, y, z, r )
	if ( !IsValid( MySelf ) ) then
		return 
	end
	local pTeam 		= MySelf:Team() 
	local blurAmount	= colorModM[pTeam].motionBlurAmount
	
	if ( MySelf:IsTakingDOT() ) then
		blurAmount = math.Min( blurAmount + 0.1, maxBlur )
	end
	 --Explot blur
	if MySelf:GetDTInt( 3 ) > 0 then
		blurAmount = math.Min( blurAmount + 0.1, maxBlur )
	end
	
		--Wraith blur effect/ethereal
	if MySelf:Alive() and MySelf:IsZombie() and MySelf:IsWraith() then
		blurAmount = math.Min( blurAmount + 0.04, maxBlur )
	end
	
	--Ironsight blur
	local Weapon = MySelf:GetActiveWeapon()
	if IsValid ( Weapon ) then
		if Weapon.GetIronsights and Weapon:GetIronsights() then
			blurAmount = math.Min( blurAmount + 0.03, maxBlur )
		end
	end
	return  x, y, blurAmount, r 
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
	HumCM["$pp_colour_addg"] = math.Approach(colorModMify["$pp_colour_addg"], 0, FrameTime() * 0.5)
	HumCM["$pp_colour_brightness"] = math.Approach(colorModMify["$pp_colour_brightness"], 0, FrameTime() * 0.5)

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
