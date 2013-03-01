-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table

//Set the assistant
function metaDamage:SetAssist( mAssist )
	if IsEntityValid( mAssist ) and mAssist:IsPlayer() then
		if self:IsAttackerPlayer() and self:GetAttacker():Team() == mAssist:Team() then
			self:GetAttacker().AttackerAssistant = mAssist
		end
	end
end

//Is suicide damage
function metaDamage:IsSuicide( mVictim )
	return ( IsEntityValid( mVictim ) and mVictim:IsPlayer() ) and self:GetAttacker():IsPlayer() and self:GetAttacker() == mVictim or self:GetAttacker():GetClass() == "env_explosion" or self:GetAttacker():GetClass() == "env_fire" or self:GetAttacker():GetClass() == "trigger_hurt" or self:GetAttacker():IsWorld() -- haters gonna hate
end

//Get the assistant
function metaDamage:GetAssist()
	if self:IsAttackerPlayer() then
		local Assist = self:GetAttacker().AttackerAssistant
		if IsValid( Assist ) and Assist:IsPlayer() and Assist:Team() == self:GetAttacker():Team() then
			return Assist
		end
	end
end

//Clear assist
function metaDamage:ClearAssist()
	self:GetAttacker().AttackerAssistant = nil
end

//Check if the assist is valid
function metaDamage:IsAssistValid()
	return IsEntityValid( self:GetAssist() ) and self:GetAssist():IsPlayer() and self:GetAssist() != self:GetAttacker()
end

//Process assist
function metaDamage:ProcessAssist( mVictim )
	if not mVictim.Shooters or not mVictim:IsPlayer() or not self:IsAttackerPlayer() then return end

	//Initialize assist 
	local Assist = NULL
	mVictim.Assistants = {}
	
	// See who has more than half of the victim health as damage and add him
	for attackers, Table in pairs ( mVictim.Shooters ) do
		if IsEntityValid ( attackers ) then
			if attackers != self:GetAttacker() and ( self:GetAttacker():Team() != mVictim:Team() and Table.Team != mVictim:Team() ) then
				if attackers != mVictim then
					if mVictim:IsHuman() then
						if ( table.Count( mVictim.Shooters ) == 2 ) or ( Table.Damage >= mVictim:GetMaximumHealth() * 0.25 ) then
							table.insert( mVictim.Assistants, attackers )
						end  
					end
					
					if mVictim:IsZombie() then
						if ( table.Count( mVictim.Shooters ) == 2 ) or ( Table.Damage >= mVictim:GetMaximumHealth() * 0.4 ) then
							table.insert( mVictim.Assistants, attackers )
						end
					end
					
					//Debug ( "[ASSIST] Adding assist to victim "..tostring ( mVictim ).." - "..tostring ( GetStringTeam ( mVictim ) )..". Assist is "..tostring ( attackers )..". Team is "..tostring ( GetStringTeam ( mVictim ) ) )
				end
			end
			
			//Sort the assist table by damage
			table.sort( mVictim.Assistants, function( a, b ) return mVictim.Shooters[a].Damage > mVictim.Shooters[b].Damage end ) 
		end
	end  
	
	//Reset the shooters table
	mVictim.Shooters = nil  
	//Debug ( "[ASSIST] Resetting Assist Table for "..tostring ( mVictim ) )
	
	//Finally set the assist
	self:SetAssist( mVictim.Assistants[1] )
end
