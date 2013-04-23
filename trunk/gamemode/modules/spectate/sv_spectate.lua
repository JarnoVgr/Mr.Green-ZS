-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Open the player meta table
local mPlayer = FindMetaTable ( "Player" )
if not mPlayer then return end

--[==[------------------------------------------------------------
	                 Spectates a player
--------------------------------------------------------------]==]
--[=[mPlayer.BaseSpec = mPlayer.Spectate
function mPlayer:Spectate ( mEnt, iType )
	if not IsEntityValid ( mEnt ) then return end
	
	-- Player is alive
	if self:Alive() then return end
		
	-- Default type is chase
	if iType == nil then iType = OBS_MODE_CHASE end
	
	-- Same person
	if mEnt == self then return end
	
	-- Stats vars
	self.SpectateEnt = mEnt
	
	-- Set spec on spectated
	if not mEnt.Spectators then mEnt.Spectators = {} end
	mEnt.Spectators[ self:EntIndex() ] = self
	
	-- Set spec. type
	self:BaseSpec ( iType )
	
	-- Spectate the entity
	self:SpectateEntity ( mEnt )
	
	-- Debug
	Debug ( "[SPECTATE] Player "..tostring ( self ).." is now spectating "..tostring ( mEnt ) )
end

--[==[-------------------------------------------------------------------
	               Unspectates a player
--------------------------------------------------------------------]==]
mPlayer.BaseUnSpec = mPlayer.UnSpectate
function mPlayer:UnSpectate()
	if not self:IsSpectator() then return end
	
	-- Unspectate him
	self:BaseUnSpec()
	
	-- Remove spectator from table
	local mSpectated = self:GetSpectated()
	mSpectated.Spectators[ self:EntIndex() ] = nil
	
	-- Status vars
	self.SpectateEnt = nil
end

--[==[--------------------------------------------------
       Returns if the player is a spectator
---------------------------------------------------]==]
function mPlayer:IsSpectator()
	return IsEntityValid ( self.SpectateEnt )
end

--[==[---------------------------------------------------
       Returns spectated entity of a player
----------------------------------------------------]==]
function mPlayer:GetSpectated()
	return self.SpectateEnt
end

--[==[---------------------------------------------------
            Returns spectator of a player
----------------------------------------------------]==]
function mPlayer:GetSpectators()
	return self.Spectators
end
]=]
-- Unspectate a player on spawn. Automatically ignores the function if player isn't spectator
hook.Add ( "PlayerSpawn", "OnSpawnUnSpectate", function ( pl ) pl:UnSpectate() pl.Spectators = {} end )

--[==[------------------------------------------------------------------------------------------------------
                            Check for players that die while being spectated
--------------------------------------------------------------------------------------------------------]==]
--[=[local function SpectatorThink( mEnt, mAttacker, tbDmginfo )
	
	-- Stop at endround
	if ENDROUND then return end
	
	-- Reset spectators
	if ( mEnt.Spectators and table.Count ( mEnt.Spectators ) > 0 ) then 
	
		-- Get another player for spectators
		for k,v in pairs ( mEnt.Spectators ) do
			if v:IsSpectator() then v:Spectate ( GetAvailableSpectator ( mEnt ) ) end
		end
	
		-- Reset table
		mEnt.Spectators = {} 
		
		Debug ( "[SPECTATOR] Reseting spectator list for "..tostring ( mEnt ) )
	end
	
	-- Change spectator
	if mEnt:IsHuman() or mEnt:IsZombie() then timer.Simple ( 1, function( mEnt, mAttacker ) if IsEntityValid ( mEnt ) and ( IsEntityValid ( mAttacker ) or mAttacker:IsWorld() ) then mEnt:Spectate ( GetAvailableSpectator ( mEnt, mAttacker ) ) end end, mEnt, mAttacker ) end
end
hook.Add ( "DoPlayerDeath", "SpectatorDeath", SpectatorThink )

--[==[----------------------------------------------------------------------------
          Check for players that disconnect while being spec'd
-----------------------------------------------------------------------------]==]
local function OnSpectateDisconnect ( mEnt )
	
	-- Stop at endround
	if ENDROUND then return end
	
	-- Reset spectators
	if ( mEnt.Spectators and table.Count ( mEnt.Spectators ) > 0 ) then 
	
		-- Get another player for spectators
		for k,v in pairs ( mEnt.Spectators ) do
			if v:IsSpectator() then v:BaseUnSpec() timer.Simple ( 0.01, function( v, mEnt ) if IsEntityValid ( v ) then v:Spectate ( GetAvailableSpectator ( mEnt ) ) end end, v, mEnt ) end
		end
	
		-- Reset table
		mEnt.Spectators = {} 
		
		Debug ( "[SPECTATOR] Reseting spectator list for "..tostring ( mEnt ) )
	end
end
hook.Add ( "PlayerDisconnected", "SpectatorDisconnect", OnSpectateDisconnect )

--[==[-------------------------------------------------------------------------------------------------
                             Returns a player to spectate to ( mEntity )
--------------------------------------------------------------------------------------------------]==]
function GetAvailableSpectator ( mSpectator, mAttacker )
	
	-- Human and zombies
	local tbHumans, tbZombies = team.GetPlayers ( TEAM_HUMAN ), team.GetPlayers ( TEAM_UNDEAD )
	
	-- Default person to spec
	local mSpectated = mAttacker
		
	-- Remove the victim from table
	for k,v in pairs ( tbZombies ) do
		if v == mSpectator then
			tbZombies[k] = nil
		end
	end
	
	if ( IsEntityValid ( mAttacker ) and mAttacker:IsPlayer() and not mAttacker:Alive() ) or mSpectator == mAttacker or ( IsEntityValid ( mAttacker ) and mAttacker:IsPlayer() and mAttacker:IsZombie() ) or ( ( IsEntityValid ( mAttacker ) or mAttacker == GetWorldEntity() ) and not mAttacker:IsPlayer() ) then mSpectated = nil end	
	
	-- Player to be spectated
	if IsEntityValid ( mSpectated ) and ( mSpectated:IsPlayer() ) then return mSpectated end

	-- Spectate human
	if #tbHumans > 0 then mSpectated = table.Random ( tbHumans ) end
	
	-- No humans, spec zombos
	if not IsEntityValid ( mSpectated ) then if #tbZombies > 0 then mSpectated = table.Random ( tbZombies ) end end

	return mSpectated 
end]=]

Debug ( "[MODULE] Loaded Spectate Script!" )
