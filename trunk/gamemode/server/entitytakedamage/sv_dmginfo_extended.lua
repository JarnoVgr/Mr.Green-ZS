-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

metaDamage = FindMetaTable( "CTakeDamageInfo" )

-- Check if it's friendly fire
function metaDamage:IsPlayerFriendlyFire( mVictim )
	if not ( IsEntityValid( mVictim ) ) then return false end
	
	-- Player friendly fire
	if not mVictim:IsPlayer() then return false end
	
	-- Check attacker 
	if self:IsAttackerPlayer() then
		if mVictim:Team() == self:GetAttacker():Team() then
			if self:GetAttacker() ~= mVictim then
				return true
			end
		end
	end
	
	-- Check inflictor
	if not IsEntityValid ( self:GetInflictor() ) then return false end
	local dmgInflictorOwner, dmgInflictor = self:GetInflictor():GetOwner(), self:GetInflictor()
		
	-- Inflictor is a player
	if self:IsInflictorPlayer() then
		if self:GetInflictor():Team() == mVictim:Team() then
			if self:GetAttacker() ~= mVictim then
				return true
			end
		end
	end
			
	-- Inflictor owner related
	if IsEntityValid( dmgInflictorOwner ) then
		if dmgInflictorOwner:IsPlayer() then
			if dmgInflictorOwner:Team() == mVictim:Team() then
				if dmgInflictorOwner ~= mVictim then
					return true
				end
			end
		end
	end
	
	-- Related to first human death
	if self:GetAttacker().IsHumanDeath then return true end
	
	return false
end

-- Check if it's headshot damage
function metaDamage:IsHeadshot( mVictim )
	--if IsEntityValid( mVictim ) then
		if mVictim:GetAttachment( 1 ) then --and not mVictim:IsZombine()  Zombines not headless anymore
			return ( self:IsBulletDamage() and self:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos ) < 15 )
		else	
			return false	
		end
	--end
	

end

-- Get player attacker from attacker/inflictor list, w/e
function metaDamage:GetPlayerAttacker()
	if self:IsAttackerPlayer() then 
		return self:GetAttacker() 
	elseif self:IsInflictorPlayer() then 
		return self:GetInflictor()
	elseif IsEntityValid( self:GetInflictor() ) and IsEntityValid( self:GetInflictor():GetOwner() ) then
		if self:GetInflictor():GetOwner():IsPlayer() then
			return self:GetInflictor():GetOwner()
		end
	end
end

-- Return if the player attacker is valid
function metaDamage:IsPlayerAttackerValid()
	return IsEntityValid( self:GetPlayerAttacker() ) and self:GetPlayerAttacker():IsPlayer()
end

-- Check if it's damage caused by props
function metaDamage:IsPhysDamage()
	return self:GetDamageType() == DMG_CRUSH
end

-- Check if it's melee damage
function metaDamage:IsMeleeDamage()
	local truth = false
	if self:GetInflictor() then
		if self:GetInflictor().IsMelee then
			if self:GetInflictor():IsMelee() then
				truth = true
			end
		end
	end 
	return truth or self:GetDamageType() == DMG_SLASH 
end

function metaDamage:IsDecapitationDamage()
	local truth = false
	if self:GetInflictor() then
		if self:GetInflictor().CanDecapitate then
			truth = true
		end
	end 
	return truth
end

-- Damage null (0)
function metaDamage:IsDamageNull()
	return self:GetDamage() == 0
end

-- Phys gun damage
function metaDamage:IsPhysGunDamage()
	return self:GetDamageType() == 8388609
end

-- Attacker is a physbox object
function metaDamage:IsAttackerPhysbox()
	return self:GetAttacker():GetClass() == "func_physbox" or self:GetAttacker():GetClass() == "func_physbox_multiplayer"-- string.find( self:GetAttacker():GetClass(), "physbox" )
end

-- Check if attacker is a prop
function metaDamage:IsPhysDamageBetweenProps( mProp )
	return ( IsEntityValid( mProp ) and not mProp:IsPlayer() and self:GetInflictor() == self:GetAttacker() and self:IsPhysDamage() )
end

-- Check if attacker the world (props hitting world)
function metaDamage:IsAttackerWorld()
	return self:GetAttacker() == GetWorldEntity() or self:GetInflictor() == GetWorldEntity()
end

-- See if the attacker is hurting himself with physdamage
function metaDamage:IsPhysHurtingSelf( mVictim )
	return ( IsEntityValid( mVictim ) and mVictim:IsPlayer() and mVictim == self:GetAttacker() and self:IsPhysDamage() )
end

-- Check if it's explosive damage
function metaDamage:IsExplosiveDamage()
	return self:GetDamageType() == DMG_BLAST_SURFACE
end

-- Check if it's bullet damage
--function metaDamage:IsBulletDamage()
--	return self:GetDamageType() == DMG_BULLET
--end

-- Check if it's fire damage
function metaDamage:IsFireDamage()
	return self:GetDamageType() == DMG_BURN or self:GetDamageType() == DMG_DIRECT
end

-- Check if its drowning damage
function metaDamage:IsDrownDamage()
	return self:GetDamageType() == DMG_DROWN
end

-- Check if the attacker is human
function metaDamage:IsAttackerHuman()
	return ( self:GetAttacker():IsPlayer() and self:GetAttacker():IsHuman() )
end

-- Check if the attacker is zombo
function metaDamage:IsAttackerZombie()
	return ( self:GetAttacker():IsPlayer() and self:GetAttacker():IsZombie() )
end

-- Check if attacker is player
function metaDamage:IsAttackerPlayer()
	return ( self:GetAttacker():IsPlayer() )
end

-- Check if victim is player
function metaDamage:IsVictimPlayer( mVictim )
	return ( IsEntityValid( mVictim ) and mVictim:IsPlayer() ) 
end

-- Check if victim is human
function metaDamage:IsVictimHuman( mVictim )
	return ( IsEntityValid( mVictim ) and mVictim:IsPlayer() and mVictim:IsHuman() )
end

-- Check if victim is zombie
function metaDamage:IsVictimZombie( mVictim )
	return ( IsEntityValid( mVictim ) and mVictim:IsPlayer() and mVictim:IsZombie() )
end

-- Check if inflictor is player
function metaDamage:IsInflictorPlayer()
	return ( IsEntityValid( self:GetInflictor() ) and self:GetInflictor():IsPlayer() )
end

-- Check if inflictor is human
function metaDamage:IsInflictorHuman()
	return ( self:IsInflictorPlayer() and self:GetInflictor():IsHuman() )
end

-- Check if inflictor is zombie
function metaDamage:IsInflictorZombie()
	return ( self:IsInflictorPlayer() and self:GetInflictor():IsZombie() )
end

