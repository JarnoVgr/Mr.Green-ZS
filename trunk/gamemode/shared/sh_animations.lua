-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Custom gestures
CUSTOM_PRIMARY, CUSTOM_SECONDARY = 100,200

-- Mananges playback rate and such
function GM:UpdateAnimation( pl, velocity, maxseqgroundspeed )	

	-- Update zombie animations, too
	if pl:IsZombie() then self:UpdateZombieAnimation( pl, velocity, maxseqgroundspeed ) return end
	
	return self.BaseClass.UpdateAnimation(self, pl, velocity, maxseqgroundspeed)
--[==[
	local len = velocity:Length()
	local movement = 1.0
	
	if ( len > 0.2 ) then
			movement =  ( len / maxseqgroundspeed )
	end
	
	rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( pl:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( not pl:IsOnGround() and len >= 1000 ) then 
		rate = 0.1;
	end
	
	pl:SetPlaybackRate( rate )
	
		
	if ( CLIENT ) and pl:IsHuman() then
		GAMEMODE:GrabEarAnimation( pl )
	end
	]==]
end

-- Manages activities to play I think
function GM:CalcMainActivity( ply, velocity )	
	
	-- ply.CalcIdeal = ACT_MP_STAND_IDLE
	-- ply.CalcSeqOverride = -1
	
	if ply:IsZombie() then 
		if self.CalcMainActivityZombies[ ply:GetZombieClass() ] then 
			return self.CalcMainActivityZombies[ ply:GetZombieClass() ]( ply, velocity ) 
		end 
	end
	
	return self.BaseClass.CalcMainActivity(self, ply, velocity)
	-- Human animations
	--[==[if ply:IsHuman() then
	
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1

		self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround );
		
		if ( self:HandlePlayerNoClipping( ply, velocity ) or
			self:HandlePlayerDriving( ply ) or
			self:HandlePlayerVaulting( ply, velocity ) or
			self:HandlePlayerJumping( ply, velocity ) or
			self:HandlePlayerDucking( ply, velocity ) or
			self:HandlePlayerSwimming( ply, velocity ) ) then
			
		else

			local len2d = velocity:Length2D()
			if ( len2d > 150 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.5 ) then ply.CalcIdeal = ACT_MP_WALK end

		end
		
		-- a bit of a hack because we're missing ACTs for a couple holdtypes
		local weapon = ply:GetActiveWeapon()
		local ht = "pistol"

		if ( IsValid( weapon ) ) then ht = weapon.GetHoldType and weapon:GetHoldType() end
		
		if ( ply.CalcIdeal == ACT_MP_CROUCH_IDLE and	( ht == "knife" or ht == "melee2" ) ) then
			ply.CalcSeqOverride = ply:LookupSequence("cidle_" .. ht)
		end

		ply.m_bWasOnGround = ply:IsOnGround()
		ply.m_bWasNoclipping = (ply:GetMoveType() == MOVETYPE_NOCLIP)
	
		
		return ply.CalcIdeal, ply.CalcSeqOverride
	end]==]
	
	-- Undead animations
	-- if ply:IsZombie() then if self.CalcMainActivityZombies[ ply:GetZombieClass() ] then return self.CalcMainActivityZombies[ ply:GetZombieClass() ]( ply, velocity ) end end
end

local IdleActivity = ACT_HL2MP_IDLE
local IdleActivityTranslate = {}
	IdleActivityTranslate [ ACT_MP_STAND_IDLE ] 				= IdleActivity
	IdleActivityTranslate [ ACT_MP_WALK ] 						= IdleActivity+1
	IdleActivityTranslate [ ACT_MP_RUN ] 						= IdleActivity+2
	IdleActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= IdleActivity+3
	IdleActivityTranslate [ ACT_MP_CROUCHWALK ] 				= IdleActivity+4
	IdleActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= IdleActivity+5
	IdleActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= IdleActivity+5
	IdleActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= IdleActivity+6
	IdleActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= IdleActivity+6
	IdleActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_SLAM
	IdleActivityTranslate [ ACT_MP_SWIM_IDLE ] 					= ACT_MP_SWIM_IDLE
	IdleActivityTranslate [ ACT_MP_SWIM ] 						= ACT_MP_SWIM
	IdleActivityTranslate [ ACT_LAND ] 							= ACT_LAND
	
--  it is preferred you return ACT_MP_* in CalcMainActivity, and if you have a specific need to not tranlsate through the weapon do it here
--[==[function GM:TranslateActivity( ply, act )

	local act = act
	local newact = ply:TranslateWeaponActivity( act )
	
	-- select idle anims if the weapon didn't decide
	if ( act == newact ) then
		return IdleActivityTranslate[ act ]
	end
	
	return newact

end]==]

-- Animation events
function GM:DoAnimationEvent( ply, event, data )
	
	if ply:IsZombie() then 
		if self.DoAnimationEventZombies[ ply:GetZombieClass() ] then 
			return self.DoAnimationEventZombies[ ply:GetZombieClass() ]( ply, event, data ) 
		end 
	end
	
	self.BaseClass:DoAnimationEvent(ply, event, data)
	
	-- Debug ( event .." -- ".. data )
	
	-- Humans only
	--[==[if ply:IsHuman() then
		if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
	
		if ply:Crouching() then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true )
		end
		
		return ACT_VM_PRIMARYATTACK
	
		elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then
		
			-- there is no gesture, so just fire off the VM event
			return ACT_VM_SECONDARYATTACK
			
		elseif event == PLAYERANIMEVENT_RELOAD then
		
			if ply:Crouching() then
				ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true )
			else
				ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true )
			end
			
			return ACT_INVALID
			
		elseif event == PLAYERANIMEVENT_JUMP then
		
			ply.m_bJumping = true
			ply.m_bFirstJumpFrame = true
			ply.m_flJumpStartTime = CurTime()
			
			ply:AnimRestartMainSequence()
			
			return ACT_INVALID
			
		elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
		
			ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
			
			return ACT_INVALID
		end
	end
	]==]
	--  Animation event handle for zombies
	-- if ply:IsZombie() then if self.DoAnimationEventZombies[ ply:GetZombieClass() ] then return self.DoAnimationEventZombies[ ply:GetZombieClass() ]( ply, event, data ) end end
end