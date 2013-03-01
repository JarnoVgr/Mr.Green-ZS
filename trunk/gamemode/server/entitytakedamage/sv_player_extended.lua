-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table

//Get meta table
metaPlayer = FindMetaTable( "Player" )

//Insert last attacker in table
function metaPlayer:InsertLastDamage( mAttacker, mInflictor )
	if IsEntityValid ( mAttacker ) then
	
		//Init. table
		self.LastAttackers = self.LastAttackers or {}
	
		//Is a player
		if mAttacker != self then
			local iTeam	if mAttacker:IsPlayer() then iTeam = mAttacker:Team() end
			table.insert( self.LastAttackers, { Attacker = mAttacker, Inflictor = mInflictor, Team = iTeam } )
		end
	end
end

//Is attacker a player
function metaPlayer:IsAttackerPlayer( iPosition )
	return ( self:IsAttackersTableValid() and IsValid( self.LastAttackers[iPosition].Attacker ) and self.LastAttackers[iPosition].Attacker:IsPlayer() )
end

//Remove a position from the stack
function metaPlayer:RemoveDamage( iPosition )
	if self:IsAttackersTableValid() then
		self.LastAttackers[ iPosition ] = nil
	end
end

//Check to see if attackers table is valid
function metaPlayer:IsAttackersTableValid()
	return self.LastAttackers != nil
end

//Get attackers table
function metaPlayer:GetAttackers()
	return self.LastAttackers
end

//Get last inflictor from the table
function metaPlayer:GetLastInflictor()
	if self.LastAtackers then
		return self.LastAttackers[ ( #self.LastAttackers or 1 ) ].Inflictor
	end
end

//Check if inflictor is player
function metaPlayer:IsLastInflictorPlayer()
	return IsEntityValid( self:GetLastInflictor() ) and self:GetLastInflictor():IsPlayer()
end

//Clear last damage
function metaPlayer:ClearLastDamage()
	if self.LastAtackers then
		self.LastAttackers[ ( #self.LastAttackers or 1 ) ] = nil
	end
end

//Get last attacker entity
function metaPlayer:GetLastAttacker()
	if self.LastAtackers then
		return self.LastAttackers[ ( #self.LastAttackers or 1 ) ].Attacker
	end
end

//Get last attacker team
function metaPlayer:GetLastAttackerTeam()
	if self.LastAtackers then
		return self.LastAttackers[ ( #self.LastAttackers or 1 ) ].Team
	end
end

