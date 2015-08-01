-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ( "cl_dmg_indicator.lua" )

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg

util.AddNetworkString( "DamageIndicator" )
util.AddNetworkString( "BloodSplatter" )

-- Local vars
local iCooldown = 0.4

function GM:DoDamageIndicator ( mEnt, mInflictor, mAttacker, tbDmginfo )
	if not IsEntityValid ( mEnt ) or not IsEntityValid ( mAttacker ) then return end
	
	-- Only players
	if not mEnt:IsPlayer() then return end
	
	---
	-- FIXME: This bloodsplatter effect is called on every 1/4 damage any player gets
	-- Lowering the trigger chance seems like a fix, but it sure wouldn't be funny for the player
	-- 
	if math.random(1,12) == 1 then
		net.Start("BloodSplatter")
			net.WriteDouble(1)
		net.Send(mEnt)
	
		-- umsg.Start("BloodSplatter",mEnt)
			-- umsg.Short(math.random(1,5))
		-- umsg.End()
	end
	
	if not mAttacker:IsPlayer() then return end
	-- Cooldown
	if not mEnt.IndicatorTimer then mEnt.IndicatorTimer = 0 end
	if mEnt.IndicatorTimer > CurTime() then return end
	
	-- Next indicator
	mEnt.IndicatorTimer = CurTime() + iCooldown
	
	-- Shake the player a bit
	local iPunch = 17
	if mEnt:IsZombie() then iPunch = 2.5 end
	if mEnt.ViewPunch then mEnt:ViewPunch ( Angle ( math.random ( iPunch * -1, iPunch ), math.random ( iPunch * -1, iPunch ), math.random ( iPunch * -1, iPunch ) ) ) end
	
	-- Damage source
	-- local vSource = mAttacker:LocalToWorld ( mAttacker:OBBCenter() )
	
	-- Send damage indicators to client
	-- net.Start("DamageIndicator")
		-- net.WriteDouble(mAttacker:EntIndex())
	-- 	net.WriteEntity(mAttacker)
	-- net.Send(mEnt)
	
	
	--[==[umsg.Start( "DamageIndicator", mEnt )
		umsg.Short ( mAttacker:EntIndex() )
	umsg.End()]==]
	
end

Debug ( "[MODULE] Loaded Damage Indicators Script!" )

