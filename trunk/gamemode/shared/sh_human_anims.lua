-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
--[==[
function GM:HandlePlayerJumping( ply, velocity )
	
	if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
		ply.m_bJumping = false;
		return
	end

	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	if ( not ply.m_bJumping and not ply:OnGround() and ply:WaterLevel() <= 0 ) then
	
		if ( not ply.m_fGroundTime ) then

			ply.m_fGroundTime = CurTime()
			
		elseif (CurTime() - ply.m_fGroundTime) > 0 and velocity:Length2D() < 0.5 then

			ply.m_bJumping = true
			ply.m_bFirstJumpFrame = false
			ply.m_flJumpStartTime = 0

		end
	end
	
	if ply.m_bJumping then
	
		if ply.m_bFirstJumpFrame then

			ply.m_bFirstJumpFrame = false
			ply:AnimRestartMainSequence()

		end
		
		if ( ply:WaterLevel() >= 2 ) or	( (CurTime() - ply.m_flJumpStartTime) > 0.2 and ply:OnGround() ) then

			ply.m_bJumping = false
			ply.m_fGroundTime = nil
			ply:AnimRestartMainSequence()

		end
		
		if ply.m_bJumping then
			ply.CalcIdeal = ACT_MP_JUMP
			return true
		end
	end
	
	return false
end

function GM:HandlePlayerDucking( ply, velocity )

	if ( not ply:Crouching() ) then return false end

	if ( velocity:Length2D() > 0.5 ) then
		ply.CalcIdeal = ACT_MP_CROUCHWALK
	else
		ply.CalcIdeal = ACT_MP_CROUCH_IDLE
	end
		
	return true

end

function GM:HandlePlayerNoClipping( ply, velocity )

	if ( ply:InVehicle() ) then return end

	if ( ply:GetMoveType() ~= MOVETYPE_NOCLIP ) then 

		if ( ply.m_bWasNoclipping ) then

			ply.m_bWasNoclipping = nil
			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
			if ( CLIENT ) then ply:SetIK( true ); end

		end

		return

	end

	if ( not ply.m_bWasNoclipping ) then

		ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, false )
		if ( CLIENT ) then ply:SetIK( false ); end

	end

			
	return true

end

function GM:HandlePlayerVaulting( ply, velocity )

	if ( velocity:Length() < 1000 ) then return end
	if ( ply:IsOnGround() ) then return end

	ply.CalcIdeal = ACT_MP_SWIM		
	return true

end

function GM:HandlePlayerSwimming( ply, velocity )

	if ( ply:WaterLevel() < 2 ) then 
		ply.m_bInSwim = false
		return false 
	end
	
	if ( velocity:Length2D() > 10 ) then
		ply.CalcIdeal = ACT_MP_SWIM
	else
		ply.CalcIdeal = ACT_MP_SWIM_IDLE
	end
		
	ply.m_bInSwim = true
	return true
	
end

function GM:HandlePlayerLanding( ply, velocity, WasOnGround ) 

	if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end

	if ( ply:IsOnGround() and not WasOnGround ) then
		ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_LAND, true );
	end

end

function GM:HandlePlayerDriving( ply )

	if ply:InVehicle() then
		local pVehicle = ply:GetVehicle()
		
		if ( pVehicle.HandleAnimation ~= nil ) then
		
			local seq = pVehicle:HandleAnimation( ply )
			if ( seq ~= nil ) then
				ply.CalcSeqOverride = seq
				return true
			end
			
		else
		
			local class = pVehicle:GetClass()
			
			if ( class == "prop_vehicle_jeep" ) then
				ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )
			elseif ( class == "prop_vehicle_airboat" ) then
				ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )
			elseif ( class == "prop_vehicle_prisoner_pod" and pVehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
				-- HACK!!
				ply.CalcSeqOverride = ply:LookupSequence( "drive_pd" )
			else
				ply.CalcSeqOverride = ply:LookupSequence( "sit_rollercoaster" )
			end
			
			return true
		end
	end
	
	return false
end

function GM:GrabEarAnimation( ply )	

	ply.ChatGestureWeight = ply.ChatGestureWeight or 0

	if ( ply:IsSpeaking() ) then
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 5.0 );
	else
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime()  * 5.0 );
	end
	
	if ( ply.ChatGestureWeight > 0 ) then
	
		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )
		
	end

	local FlexNum = ply:GetFlexNum() - 1
	if ( FlexNum <= 0 ) then return end
	
	for i=0, FlexNum-1 do
	
		local Name = ply:GetFlexName( i )

		if ( Name == "jaw_drop" or Name == "right_part" or Name == "left_part" or Name == "right_mouth_drop" or Name == "left_mouth_drop"  ) then

			if ( ply:IsSpeaking() ) then
				ply:SetFlexWeight( i, math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) )
			else
				ply:SetFlexWeight( i, 0 )
			end
		end
		
	end
	
end
]==]