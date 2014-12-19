-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local timer = timer
local table = table

-- Animation function tables
GM.CalcMainActivityZombies, GM.DoAnimationEventZombies, GM.UpdateClassAnimation = {}, {}, {}

function GM:UpdateZombieAnimation( pl, vel, maxseqgroundspeed )
	local eye = pl:EyeAngles()
	
    --  correct player angles
	pl:SetLocalAngles( eye )

	-- Eye angles fix
	if CLIENT then pl:SetRenderAngles( eye ) end
	
	-- This is fucked
	pl:SetPoseParameter("move_yaw", math.NormalizeAngle(vel:Angle().yaw - eye.y))
	 --pl:SetPoseParameter( "move_yaw", -math.NormalizeAngle( math.NormalizeAngle( eye.y ) - math.Clamp( math.atan2( vel.y, vel.x ) * 180 / math.pi, -180, 180 ) ) )

	if self.UpdateClassAnimation[pl:GetZombieClass()] then
		self.UpdateClassAnimation[pl:GetZombieClass()](pl, vel, maxseqgroundspeed)
		return
	end
	
	-- Controls playback
	local len2d = vel:Length2D()
	local rate = 1.0
	
	if len2d > 0.5 then
		rate = ( ( len2d * 0.8 ) / maxseqgroundspeed )
	end
	
	rate = math.Clamp(rate, 0.8, 1.5)
	
	pl:SetPlaybackRate( rate )
	if pl._PlayBackRate then
		pl:SetPlaybackRate( pl._PlayBackRate )
	end

	
end

GM.CalcMainActivityZombies[0] = function ( pl, vel, key )

	pl._PlayBackRate = nil
	if IsValid(pl:GetActiveWeapon()) then 
		local iSeq, iIdeal = pl:LookupSequence ( "zombie_walk_02" ) --Duby: I spent ages finding this out...	
		return iIdeal, iSeq
	end
	
	--local iSeq, iIdeal = pl:LookupSequence("zombie_run")
		
	local wep = pl:GetActiveWeapon()
	if IsValid(wep) and wep.GetClimbing and wep:GetClimbing() then
		iSeq = 10
	end

	if pl:GetMoveType() == MOVETYPE_LADDER then
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = math.Clamp(pl:GetVelocity().z/200,-1,1)
	end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
	pl:LookupSequence("zombie_slump_rise_01")
	end
	
	
	return iIdeal, iSeq
	
end


GM.DoAnimationEventZombies[0] = function ( pl, event, data )
	if event == PLAYERANIMEVENT_CUSTOM_GESTURE then
		if ( data == CUSTOM_PRIMARY ) then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
			return ACT_INVALID
		end
	end
	
end

GM.UpdateClassAnimation[0] = function(pl, vel, maxseqgroundspeed)

	local revive = pl.Revive
	if revive and revive:IsValid() then
		pl:SetCycle(0.4 + (1 - math.Clamp((revive:GetReviveTime() - CurTime()) / 1.9, 0, 1)) * 0.6)
		--pl:SetPlaybackRate(0)
		pl:SetPlaybackRate(2)
	end 
	
	if pl:GetSequence() == 2 then
		local zvel = pl:GetVelocity().z
		if math.abs(zvel) < 8 then zvel = 0 end
		pl:SetPlaybackRate(math.Clamp(zvel / 60 * 0.25, -1, 1))
	end
	
	

end

GM.CalcMainActivityZombies[14] = GM.CalcMainActivityZombies[0]
GM.DoAnimationEventZombies[14] = GM.DoAnimationEventZombies[0]
GM.UpdateClassAnimation[14] = GM.UpdateClassAnimation[0]

-- Normal zombie - Activity handle
GM.CalcMainActivityZombies[1] = function ( pl, vel )

	local canwallpound = false
	if --[=[pl:GetAngles().pitch > 40 and]=] util.TraceLine({start = pl:GetShootPos(), endpos = pl:GetShootPos() + pl:GetAimVector() * 32, filter = pl}).Hit then canwallpound = true end

	-- Default zombie act
	--local iSeq, iIdeal = pl:LookupSequence ( "zombie_walk_05" )
	local iSeq, iIdeal = pl:LookupSequence ( "zombie_run" )
	pl._PlayBackRate = nil
	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	--if fVelocity > 30 then iIdeal = ACT_WALK else iIdeal = ACT_IDLE end
	
	-- Moaning
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsMoaning and pl:GetActiveWeapon():IsMoaning() then 
		if fVelocity > 2 then 
		 iSeq, iIdeal = pl:LookupSequence ( "zombie_run" )
		else 
			if canwallpound then 
				iSeq, iIdeal = pl:LookupSequence ( "zombie_run" )
			else 
				iSeq, iIdeal = pl:LookupSequence ( "zombie_walk_01" )
			end 
		end 
	end 
	
	if pl:GetMoveType() == MOVETYPE_LADDER then
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = math.Clamp(pl:GetVelocity().z/200,-1,1)
	end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			--iSeq = 25 --27
			iSeq = 27 --27
		else
			--iSeq = 22 --26
			iSeq = 26 --26
		end
	end
	
	return iIdeal, iSeq
end

--  Normal zombie - Called on events like primary attack
GM.DoAnimationEventZombies[1] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl.IsMoaning = false
			pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1, true  )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then
		
			-- Moaning
			if not pl.IsMoaning then
				pl.IsMoaning = true
			else
				pl.IsMoaning = false
			end
			 timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsMoaning = false end end, pl )
			
			return ACT_INVALID
		end
	end
end


-- Fast zombie - Activity handle
GM.CalcMainActivityZombies[3] = function ( pl, vel )

	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "idle" ) 
	pl._PlayBackRate = nil
	local fVelocity = vel:Length2D()
	if fVelocity > 2 then 
		--if fVelocity > 170 then
			if not pl:OnGround() and fVelocity > 230 then
				iSeq = pl:LookupSequence ( "LeapStrike" ) 
				pl._PlayBackRate = 1
			else
				--iIdeal = ACT_RUN
				iSeq = pl:LookupSequence ( "Run" ) 
			end
		--else
			--iIdeal = ACT_WALK
			--iSeq = pl:LookupSequence ( "walk_all" ) 
		--end
	else
		--iIdeal = ACT_IDLE
		iSeq = pl:LookupSequence ( "idle" ) 
	end
	-- Secondary attack - Moan
	if pl.iZombieSecAttack and CurTime() <= pl.iZombieSecAttack then 
		iIdeal = ACT_CLIMB_UP 
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = 1
	end
	
	
	
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsRoar and pl:GetActiveWeapon():IsRoar() then
		iSeq = pl:LookupSequence ( "idle_angry" ) 
	end
	
	if pl:GetMoveType() == MOVETYPE_LADDER then
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = math.Clamp(pl:GetVelocity().z/200,-1,1)
	end
	
	return iIdeal, iSeq
end

--  Fast zombie - Called on events like primary attack
GM.DoAnimationEventZombies[3] = function ( pl, event, data )
		if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1, true )
			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then
			 pl.IsRoar = true
			 timer.Simple ( 2, function( pl ) if IsEntityValid ( pl ) then pl.IsRoar = false end end, pl )
			return ACT_INVALID
		end
	end
end

-- Poison Zombie - Activity handle
GM.CalcMainActivityZombies[2] = function ( pl, vel )

	-- Default zombie act
	--local iSeq, iIdeal = -1
	local iSeq, iIdeal = pl:LookupSequence ( "zombie_walk_06" )
	pl._PlayBackRate = nil
	local fVelocity = vel:Length2D()
	if fVelocity > 30 then iIdeal = ACT_WALK else iIdeal = ACT_IDLE end
	
	if pl:GetMoveType() == MOVETYPE_LADDER then
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = math.Clamp(pl:GetVelocity().z/200,-1,1)
	end
	
	return iIdeal, iSeq
end

--  Poison Zombie - Called on events like primary attack
GM.DoAnimationEventZombies[2] = function ( pl, event, data )
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then
		pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true)
		return ACT_INVALID
	end
end

-- Ethereal - Activity handle
GM.CalcMainActivityZombies[5] = function ( pl, vel )
	
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsDisguised and pl:GetActiveWeapon():IsDisguised() then
		
		local iSeq, iIdeal = pl:LookupSequence ( "idle_all_cower" ) 
		
		local fVelocity = vel:Length2D()
		if fVelocity >= 0.5 then 
			iSeq = pl:LookupSequence ( "run_all_panicked_03" ) 
		end
		
		return iIdeal, iSeq
		
	end
	
	-- Default zombie act
	local iSeq, iIdeal = -1

	local fVelocity = vel:Length2D()
	if fVelocity > 30 then iIdeal = ACT_WALK else iIdeal = ACT_IDLE end
	
	return iIdeal, iSeq
end

--  Ethereal - Called on events like primary attack
GM.DoAnimationEventZombies[5] = function ( pl, event, data )
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsDisguised and pl:GetActiveWeapon():IsDisguised() then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		else
			pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true )
		end
		return ACT_INVALID
	end
end


-- Howler - Activity handle
GM.CalcMainActivityZombies[6] = function ( pl, vel )
	
	local fVelocity = vel:Length2D()
	pl._PlayBackRate = nil
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsScreaming and pl:GetActiveWeapon():IsScreaming() then 
		--local iSeq, iIdeal = pl:LookupSequence ( "zombie_run" )  
		iIdeal = ACT_IDLE_ON_FIRE 
		return iIdeal, iSeq
	end

	local iSeq, iIdeal = -1
	
	if fVelocity <= 0.5 then
		--iIdeal = ACT_HL2MP_IDLE_ZOMBIE
		iIdeal = ACT_HL2MP_WALK_ZOMBIE_02
	else
		iIdeal = ACT_HL2MP_WALK_ZOMBIE_02 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
	end

	if pl:GetMoveType() == MOVETYPE_LADDER then
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = math.Clamp(pl:GetVelocity().z/200,-1,1)
	end
	
	-- Default zombie act
	--[[
	local iSeq, iIdeal = -1

	local fVelocity = vel:Length2D()
	if fVelocity > 30 then iIdeal = ACT_WALK else iIdeal = ACT_IDLE end
	
	-- Screaming
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsScreaming and pl:GetActiveWeapon():IsScreaming() then 
		if fVelocity < 2 then 
			iIdeal = ACT_IDLE_ON_FIRE 
		end 
	end]]--
	
	return iIdeal, iSeq
end

-- Howler - Called on events like primary attack
GM.DoAnimationEventZombies[6] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			
			-- Screaming
			 pl.IsScreaming = true
			pl:AnimRestartMainSequence()
		   timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsScreaming = false end end, pl )

			return ACT_INVALID
		end
	end
end


-- Headcrab - Activity handle
GM.CalcMainActivityZombies[7] = function ( pl, vel )

	-- Default zombie act
	local iSeq, iIdeal = -1

	local fVelocity = vel:Length2D()
	if fVelocity > 30 then iIdeal = ACT_RUN else iIdeal = ACT_IDLE end
	
	-- Jumping 
	if not pl:OnGround() then iSeq = pl:LookupSequence ( "Drown" ) end
	
	-- TO DO- FIX ATTACK ANIMATION
	
	return iIdeal, iSeq
end

--  Headcrab - Called on events like primary attack
GM.DoAnimationEventZombies[7] = function ( pl, event, data )
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_RANGE_ATTACK1,true )
		return ACT_INVALID
	end
end


-- Poison-crab - Activity handle
GM.CalcMainActivityZombies[9] = function ( pl, vel )

	-- Default zombie act
	local iSeq, iIdeal = -1

	local fVelocity = vel:Length2D()
	if fVelocity > 30 then 
		if fVelocity > ZombieClasses[7].Speed then iIdeal = ACT_BLACKHEADCRAB_RUN_PANIC else iIdeal = ACT_RUN end
	else 	
		iIdeal = ACT_IDLE 
	end
	
	-- Spitting animation
	if (pl.IsSpitting and pl.IsSpitting >= CurTime()) then iSeq = pl:LookupSequence ( "Spitattack" ) end
	
	-- Drowning
	if not pl:OnGround() then iSeq = pl:LookupSequence ( "Drown" ) end
	
	return iIdeal, iSeq
end

-- Poison-crab - Called on events like primary attack
GM.DoAnimationEventZombies[9] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_SECONDARY ) then
			
			-- Thirdperson animation
			local iSeq, iDuration = pl:LookupSequence ( "Spitattack" )
			pl.IsSpitting = CurTime() + iDuration-- true
			
			-- Get sequence and restart it
			
			pl:AnimRestartMainSequence()
			--timer.Simple ( iDuration, function( pl ) if IsEntityValid ( pl ) then pl.IsSpitting = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		end
	end
end

-- Zombine - Activity handle
GM.CalcMainActivityZombies[8] = function ( pl, vel )

	local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
	if ( not wep ) then
        return    	         
    end
	
	-- wep = IsValid(wep) and wep
	
	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "Idle01" )
	if wep.IsHoldingGrenade and wep:IsHoldingGrenade() then iSeq = pl:LookupSequence ( "Idle_Grenade" ) end
	
	local fVelocity = vel:Length2D()
	
	-- Walking
	if fVelocity >= 1 then
		iSeq = pl:LookupSequence ( "walk_All" )
		-- Walking with grenade
		if wep.IsHoldingGrenade and wep:IsHoldingGrenade() then iSeq = pl:LookupSequence ( "walk_All_Grenade" ) end
	end
	
	-- Sprinting
	if ( fVelocity >= 150 ) then
		iSeq = pl:LookupSequence ( "Run_All" ) 
		
		-- Player running with grenade
		if wep.IsHoldingGrenade and wep:IsHoldingGrenade() then iSeq = pl:LookupSequence ( "Run_All_grenade" ) end
	end
	
	-- Getting grenade
	if wep.IsGettingNade and wep:IsGettingNade() then
		iSeq = pl:LookupSequence ( "pullGrenade" )
	end
	
	-- Attacking animation
	if (wep.IsAttackingAnim and wep:IsAttackingAnim() ) then iSeq = pl:LookupSequence ( wep.GetAttackSeq and wep:GetAttackSeq() or "attackD" ) --Moving
	

	end

	
	return iIdeal, iSeq
end

--  Zombine - Called on events like primary attack
local Attacks = { "attackD", "attackE", "attackF", "attackB" }
GM.DoAnimationEventZombies[8] = function ( pl, event, data )

	-- Weapon deploy
	if ( event == 34 ) then
		
		-- Set up the vars
		-- pl.HoldingGrenade, pl.IsAttacking, pl.IsGettingNade = false, 0, false
		
		return ACT_INVALID
	end
	
	-- Now custom gestures
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
	
		-- Attacking
		if ( data == CUSTOM_PRIMARY ) then
		
			-- Animation status
			pl.AttackSequence = table.Random ( Attacks )
			
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			--timer.Simple ( 1.2, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )
			
			return ACT_VM_PRIMARYATTACK
		end
		
		-- Getting grenade
		if ( data == CUSTOM_SECONDARY ) then
		
			-- Getting grenade
			-- pl.IsGettingNade = true
			pl:AnimRestartMainSequence()
			-- timer.Simple ( 1, function( pl ) if IsEntityValid ( pl ) then pl.IsGettingNade = false pl.HoldingGrenade = true end end, pl )
						
			return ACT_VM_SECONDARYATTACK
		end
	end
end

--[[
-- Crow
GM.CalcMainActivityZombies[9] = function ( pl, vel )

	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "Idle01" ) -- -1

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if pl:OnGround() then
		if fVelocity > 1 then 
			iSeq = pl:LookupSequence ( "Walk" )
			if fVelocity >= ZombieClasses[9].RunSpeed then 
				iSeq = pl:LookupSequence ( "Run" )
			end
			-- iIdeal = ACT_WALK 
		else 
			iSeq = pl:LookupSequence ( "Idle01" )
			-- iIdeal = ACT_IDLE 
		end
	else
		if fVelocity > 1 then
			iSeq = pl:LookupSequence ( "Fly01" )
			if pl:GetVelocity().z > 2 then
				iSeq = pl:LookupSequence ( "Soar" )
			end
		else
			iSeq = pl:LookupSequence ( "Fly01" )
		end
	end
	

	-- if pl.IsMoaning then if fVelocity > 2 then iIdeal = ACT_WALK_ON_FIRE else if canwallpound then iSeq = pl:LookupSequence ( "WallPound" ) else iIdeal = ACT_IDLE_ON_FIRE end end end
		
	return iIdeal, iSeq
end

]]--


-- Poison Zombie - Activity handle
GM.CalcMainActivityZombies[4] = function ( pl, vel )

	-- Default zombie act
	--local iSeq, iIdeal = -1
	local iSeq, iIdeal = pl:LookupSequence ( "zombie_walk_06" )

	local fVelocity = vel:Length2D()
	if fVelocity > 30 then iIdeal = ACT_WALK else iIdeal = ACT_IDLE end
	
	return iIdeal, iSeq
end

--  Poison Zombie - Called on events like primary attack
GM.DoAnimationEventZombies[4] = function ( pl, event, data )
	--if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
	--	pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true)
	--	return ACT_INVALID
	--elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then
	--	pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true)
		return ACT_INVALID
	--end
end

function MainActivityHate2(pl,vel)
	
	-- Default zombie act
	local iSeq, iIdeal = -1

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then iIdeal = ACT_WALK_ON_FIRE else iIdeal = ACT_IDLE_ON_FIRE end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) else pl._PlayBackRate = nil end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = 25 --27
		else
			iSeq = 22 --26
		end
	end
	
	return iIdeal, iSeq
	
	
end

local Attacks = { "Breakthrough" }
function AnimEventHate2(pl, event, data)
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			pl._PlayBackRate = 0.95
			
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() + 2.1
			--timer.Simple ( 2.1, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false pl._PlayBackRate = nil end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end


-- Hate
GM.CalcMainActivityZombies[10] = function ( pl, vel )	
	-- Default zombie act
	local iSeq, iIdeal = -1

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then iIdeal = ACT_WALK_ON_FIRE else iIdeal = ACT_IDLE_ON_FIRE end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = 25 --27
		else
			iSeq = 22 --26
		end
	end
	
	return iIdeal, iSeq
end

local Attacks = { "swatrightlow", "swatleftlow" }
GM.DoAnimationEventZombies[10] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			 --pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() + 1.3
			--timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end

GM.CalcMainActivityZombies[11] = function ( pl, vel )
	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "Idle_Grenade" )

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then 
		iSeq = pl:LookupSequence ( "walk_All_Grenade" )
		if fVelocity > 180 then
			iSeq = pl:LookupSequence ( "Run_All_grenade" )
		end
	else 
		iSeq = pl:LookupSequence ( "Idle_Grenade" ) 
	end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) else pl._PlayBackRate = nil end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = pl:LookupSequence ( "slumprise_b" ) 
		else
			iSeq = pl:LookupSequence ( "slump_b" ) 
		end
	end
	
	return iIdeal, iSeq
end

local Attacks = { "swatleftlow", "swatleftlow", "attackE" }
GM.DoAnimationEventZombies[11] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			pl._PlayBackRate = 0.95
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() + 1.3
			--timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end


-- Seeker
GM.CalcMainActivityZombies[12] = function ( pl, vel )

	local iSeq, iIdeal = pl:LookupSequence ( "Idle01" )

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then iSeq = pl:LookupSequence ( "Run" ) else iSeq = pl:LookupSequence ( "Idle01" ) end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) else pl._PlayBackRate = nil end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = 25 --27
		else
			iSeq = 22 --26
		end
	end
	
	return iIdeal, iSeq
end


local Attacks = { "melee_01" }
GM.DoAnimationEventZombies[12] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			pl._PlayBackRate = 0.95
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() +1.3
			--timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end

GM.CalcMainActivityZombies[13] = function ( pl, vel )

	-- Default zombie act
	--local iSeq, iIdeal = -1
	local iSeq, iIdeal = pl:LookupSequence ( "idle" ) 
	pl._PlayBackRate = nil
	local fVelocity = vel:Length2D()
	if fVelocity > 2 then 
		--if fVelocity > 170 then
			if not pl:OnGround() and fVelocity > 230 then
				iSeq = pl:LookupSequence ( "LeapStrike" ) 
				pl._PlayBackRate = 1
			else
				--iIdeal = ACT_RUN
				iSeq = pl:LookupSequence ( "Run" ) 
			end
		--else
			--iIdeal = ACT_WALK
			--iSeq = pl:LookupSequence ( "walk_all" ) 
		--end
	else
		--iIdeal = ACT_IDLE
		iSeq = pl:LookupSequence ( "idle" ) 
	end
	-- Secondary attack - Moan
	if pl.iZombieSecAttack and CurTime() <= pl.iZombieSecAttack then 
		--iIdeal = ACT_CLIMB_UP 
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = 1
	end
	
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsRoar and pl:GetActiveWeapon():IsRoar() then
		--iIdeal = ACT_IDLE_ON_FIRE 
		iSeq = pl:LookupSequence ( "idle_angry" ) 
	end
	
	if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().SlashAnimation and pl:GetActiveWeapon().SlashAnimation >= CurTime() then 
		iSeq = pl:LookupSequence ( "BR2_Attack" ) 
	end
	
	if pl:GetMoveType() == MOVETYPE_LADDER then
		iSeq = pl:LookupSequence ( "climbloop" ) 
		pl._PlayBackRate = math.Clamp(pl:GetVelocity().z/200,-1,1)
	end
	
	return iIdeal, iSeq
end


GM.DoAnimationEventZombies[13] = function ( pl, event, data )
		if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1,true )
			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then
			pl:AnimRestartMainSequence()
			return ACT_INVALID
		end
	end
end










GM.CalcMainActivityZombies[16] = function ( pl, vel )
	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "Idle_Grenade" )

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then 
		iSeq = pl:LookupSequence ( "walk_All_Grenade" )
		if fVelocity > 180 then
			iSeq = pl:LookupSequence ( "Run_All_grenade" )
		end
	else 
		iSeq = pl:LookupSequence ( "Idle_Grenade" ) 
	end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) else pl._PlayBackRate = nil end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = pl:LookupSequence ( "slumprise_b" ) 
		else
			iSeq = pl:LookupSequence ( "slump_b" ) 
		end
	end
	
	return iIdeal, iSeq
end

local Attacks = { "swatleftlow", "swatleftlow", "attackE" }
GM.DoAnimationEventZombies[16] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			pl._PlayBackRate = 0.95
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() + 1.3
			--timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end


GM.CalcMainActivityZombies[17] = function ( pl, vel )
	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "Idle_Grenade" )

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then 
		iSeq = pl:LookupSequence ( "walk_All_Grenade" )
		if fVelocity > 180 then
			iSeq = pl:LookupSequence ( "Run_All_grenade" )
		end
	else 
		iSeq = pl:LookupSequence ( "Idle_Grenade" ) 
	end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) else pl._PlayBackRate = nil end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = pl:LookupSequence ( "slumprise_b" ) 
		else
			iSeq = pl:LookupSequence ( "slump_b" ) 
		end
	end
	
	return iIdeal, iSeq
end

local Attacks = { "swatleftlow", "swatleftlow", "attackE" }
GM.DoAnimationEventZombies[17] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			pl._PlayBackRate = 0.95
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() + 1.3
			--timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end





GM.CalcMainActivityZombies[18] = function ( pl, vel )
	-- Default zombie act
	local iSeq, iIdeal = pl:LookupSequence ( "Idle_Grenade" )

	local fVelocity = vel:Length2D()
	
	-- Walk animation or idle
	if fVelocity > 30 then 
		iSeq = pl:LookupSequence ( "walk_All_Grenade" )
		if fVelocity > 180 then
			iSeq = pl:LookupSequence ( "Run_All_grenade" )
		end
	else 
		iSeq = pl:LookupSequence ( "Idle_Grenade" ) 
	end
	
	if (pl.IsAttacking and pl.IsAttacking >= CurTime() ) then iSeq = pl:LookupSequence ( pl.AttackSequence ) else pl._PlayBackRate = nil end
	
	local revive = pl.Revive
	if revive and revive:IsValid() then
		if revive:IsRising() then
			iSeq = pl:LookupSequence ( "slumprise_b" ) 
		else
			iSeq = pl:LookupSequence ( "slump_b" ) 
		end
	end
	
	return iIdeal, iSeq
end

local Attacks = { "swatleftlow", "swatleftlow", "attackE" }
GM.DoAnimationEventZombies[18] = function ( pl, event, data )
	if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		if ( data == CUSTOM_PRIMARY ) then
			-- pl:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_MELEE_ATTACK1 )
			--pl.IsAttacking = true
			pl.AttackSequence = table.Random ( Attacks )
			pl._PlayBackRate = 0.95
			-- Get sequence and restart it
			pl:AnimRestartMainSequence()
			
			pl.IsAttacking = CurTime() + 1.3
			--timer.Simple ( 1.3, function( pl ) if IsEntityValid ( pl ) then pl.IsAttacking = false end end, pl )

			return ACT_VM_PRIMARYATTACK
		elseif ( data == CUSTOM_SECONDARY ) then

			return ACT_INVALID
		end
	end
end


GM.UpdateClassAnimation[18] = function(pl, vel, maxseqgroundspeed)
	local revive = pl.Revive
	if revive and revive:IsValid() then
		pl:SetCycle(0.4 + (1 - math.Clamp((revive:GetReviveTime() - CurTime()) / 1.9, 0, 1)) * 0.6)
		pl:SetPlaybackRate(0)
	end
	
	if pl:GetSequence() == 10 then
		local zvel = pl:GetVelocity().z
		if math.abs(zvel) < 8 then zvel = 0 end
		pl:SetPlaybackRate(math.Clamp(zvel / 60 * 0.25, -1, 1))
	end
	
	

end

--Copy from Zombine for Smoker
GM.CalcMainActivityZombies[17] = GM.CalcMainActivityZombies[1]
GM.DoAnimationEventZombies[17] = GM.DoAnimationEventZombies[1]

--Copy from Infected for Lillith
GM.CalcMainActivityZombies[16] = GM.CalcMainActivityZombies[0]
GM.DoAnimationEventZombies[16] = GM.DoAnimationEventZombies[0]

--Attack for SeekerII
GM.CalcMainActivityZombies[18] = GM.CalcMainActivityZombies[0]
GM.DoAnimationEventZombies[18] = GM.DoAnimationEventZombies[0]

--Attack for Pumpking!s
--GM.CalcMainActivityZombies[19] = GM.CalcMainActivityZombies[0]
--GM.DoAnimationEventZombies[19] = GM.DoAnimationEventZombies[0]

--Ghouler!
GM.CalcMainActivityZombies[1] = GM.CalcMainActivityZombies[0]
GM.DoAnimationEventZombies[1] = GM.DoAnimationEventZombies[0]

-- Poison Zombie - Activity handle
GM.CalcMainActivityZombies[19] = function ( pl, vel )

	-- Default zombie act
	--local iSeq, iIdeal = -1
	local iSeq, iIdeal = pl:LookupSequence ( "zombie_walk_04" )

	local fVelocity = vel:Length2D()
	if fVelocity > 30 then iIdeal = ACT_WALK else iIdeal = ACT_IDLE end
	
	return iIdeal, iSeq
end

--  Poison Zombie - Called on events like primary attack
GM.DoAnimationEventZombies[19] = function ( pl, event, data )
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then
		pl:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1,true)
		return ACT_INVALID
	end
end