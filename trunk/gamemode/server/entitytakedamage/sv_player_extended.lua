-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Get meta table
metaPlayer = FindMetaTable("Player")

-- Insert last attacker in table
function metaPlayer:InsertLastDamage(mAttacker, mInflictor)
	if not IsEntityValid(mAttacker) then
		return
	end
	
	-- Init. table
	self.LastAttackers = self.LastAttackers or {}
	
	-- Is a player
	if mAttacker ~= self then
		local iTeam
		if mAttacker:IsPlayer() then
			iTeam = mAttacker:Team()
		end
		table.insert(self.LastAttackers, {Attacker = mAttacker, Inflictor = mInflictor, Team = iTeam})
	end
end

-- Is attacker a player
function metaPlayer:IsAttackerPlayer( iPosition )
	return (self:IsAttackersTableValid() and IsValid( self.LastAttackers[iPosition].Attacker ) and self.LastAttackers[iPosition].Attacker:IsPlayer() )
end

-- Remove a position from the stack
function metaPlayer:RemoveDamage( iPosition )
	if self:IsAttackersTableValid() then
		self.LastAttackers[ iPosition ] = nil
	end
end

-- Check to see if attackers table is valid
function metaPlayer:IsAttackersTableValid()
	return self.LastAttackers ~= nil
end

-- Get attackers table
function metaPlayer:GetAttackers()
	return self.LastAttackers
end

-- Get last inflictor from the table
function metaPlayer:GetLastInflictor()
	if not self.LastAtackers then
		return
	end
	
	return self.LastAttackers[ ( #self.LastAttackers or 1 ) ].Inflictor
end

-- Check if inflictor is player
function metaPlayer:IsLastInflictorPlayer()
	return IsEntityValid( self:GetLastInflictor() ) and self:GetLastInflictor():IsPlayer()
end

-- Clear last damage
function metaPlayer:ClearLastDamage()
	if not self.LastAtackers then
		return
	end
	
	self.LastAttackers[ ( #self.LastAttackers or 1 ) ] = nil
end

-- Get last attacker entity
function metaPlayer:GetLastAttacker()
	if not self.LastAtackers then
		return
	end
	
	return self.LastAttackers[ ( #self.LastAttackers or 1 ) ].Attacker
end

-- Get last attacker team
function metaPlayer:GetLastAttackerTeam()
	if not self.LastAtackers then
		return
	end
	
	return self.LastAttackers[ ( #self.LastAttackers or 1 ) ].Team
end

