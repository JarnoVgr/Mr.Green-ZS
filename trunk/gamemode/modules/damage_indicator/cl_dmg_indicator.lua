-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Local variables
local iDuration = 3

-- Arrow texture
local matArrow = surface.GetTextureID ( "zombiesurvival/classmenu/arrow" )

net.Receive( "DamageIndicator", function( len )

-- local function GetDamageIndicator ( um )
	if not IsValid ( MySelf ) then return end
	
	-- Damage source
	-- local iIndex = um:ReadShort()
	
	-- Get entity
	local mEnt = net.ReadEntity()
	if not IsValid ( mEnt ) then return end
	
	-- Hook our draw function
	local HookName = "DrawDamageIndicator"..math.random ( 1, 100 )
	
	-- Time start
	local Start = CurTime()
	
	-- Alpha
	local fAlpha = 190
	hook.Add ( "HUDPaint", HookName, function()
		if not IsValid ( mEnt ) then return end
	
		local vPos = ( mEnt:LocalToWorld ( mEnt:OBBCenter() ) ):ToScreen()
		
		-- Don't draw if dead
		if not MySelf:Alive() then hook.Remove ( "HUDPaint", HookName ) return end
		
		-- Arrow position on screen (radial)
		local xArrow, yArrow = 0, 0
		
		-- Angle pointer (substract 180 because the image is upside down)
		local aAng = math.NormalizeAngle( math.Angle2D ( { ["x"] = w * 0.5, ["y"] = h * 0.5 }, { ["x"] = vPos.x, ["y"] = vPos.y } ) ) - 180
		
		-- Calculate radial position
		local iRadius = math.Clamp ( h * 0.38, 30, h * 0.45 )
		xArrow, yArrow = ( ScrW() / 2 ) + ( math.sin( math.rad( aAng ) ) * iRadius ), ( ScrH() / 2 ) + ( math.cos( math.rad( aAng ) ) * iRadius )
		
		-- Fade time
		if CurTime() > ( Start + iDuration ) - 1.8 then fAlpha = math.Approach ( fAlpha, 0, 3 ) end
		
		-- Remove hook when alpha is 0
		if fAlpha <= 0 then hook.Remove ( "HUDPaint", HookName ) end			
		
		-- Draw arrow
		surface.SetDrawColor ( 255,0,0,fAlpha )
		surface.SetTexture ( matArrow )
		surface.DrawTexturedRectRotated( xArrow, yArrow, ScaleW(73), ScaleW(73), aAng )
	end )
end)
-- usermessage.Hook ( "DamageIndicator", GetDamageIndicator )

-- Adds bloodsplats to screen
function SoMuchBlood( point, kill, distance )
	if not IsValid(MySelf) then
		return
	end

	local tbHax, vDir = {}
	vDir = MySelf:GetPos() - point
	if ( vDir:Length() <= distance ) then
		table.insert( tbHax, { pl = MySelf, severity = math.Clamp( math.Round( 1 - distance/ vDir:Length() ) * 5,1,5 ) } )
	end
	
	for k, v in pairs( tbHax ) do
		AddBloodSplat( v.severity )
		
		-- Severity kill -- w/e
		if kill and v.severity > 1 then
			AddBloodSplat( v.severity - 1 )
		end
	end
end

-- Here we call the blood on screen thing
local function OnPlayerDeath ( pl, attacker )
	if not IsValid(pl) or not IsValid(attacker) then
		return
	end

	-- Add bloodsplats to the screen
	SoMuchBlood( pl:GetPos(), true, 100 )
end
hook.Add ( "DoPlayerDeath", "OnBloodSplat", OnPlayerDeath )

Debug ( "[MODULE] Loaded Client Side Damage Indicator." )

