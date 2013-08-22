-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Custom gestures
CUSTOM_PRIMARY, CUSTOM_SECONDARY = 100,200

-- Mananges playback rate and such
function GM:UpdateAnimation( pl, velocity, maxseqgroundspeed )	

	-- Update zombie animations, too
	if pl:IsZombie() then
		self:UpdateZombieAnimation( pl, velocity, maxseqgroundspeed )
		return
	end
	
	return self.BaseClass.UpdateAnimation(self, pl, velocity, maxseqgroundspeed)
end

-- Manages activities to play I think
function GM:CalcMainActivity( ply, velocity )		
	if ply:IsZombie() then 
		if self.CalcMainActivityZombies[ ply:GetZombieClass() ] then 
			return self.CalcMainActivityZombies[ ply:GetZombieClass() ]( ply, velocity ) 
		end
	end
	
	return self.BaseClass.CalcMainActivity(self, ply, velocity)
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

-- Animation events
function GM:DoAnimationEvent( ply, event, data )
	if ply:IsZombie() then 
		if self.DoAnimationEventZombies[ ply:GetZombieClass() ] then 
			return self.DoAnimationEventZombies[ ply:GetZombieClass() ]( ply, event, data ) 
		end 
	end
	
	self.BaseClass:DoAnimationEvent(ply, event, data)
end