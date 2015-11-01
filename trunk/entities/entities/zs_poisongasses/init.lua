AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.iPoisonTimer = 0
ENT.iPoisonDamageRadius = 460
ENT.objFoundEnemys = nil
ENT.iTakeDamageDelay = 1.0
--ENT.iTakeDamageDelay = 0.25
ENT.iDamageAmount = 5
--ENT.iDamageAmount = 1
ENT.iHealAmount = 25

  
function ENT:Initialize()
	pos = self:GetPos()
	self:DrawShadow( false )
	self:PhysicsInit( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end	

local tr = {
	start = nil, 
	endpos = nil, 
	filter = nil,
} 

function ENT:IsVisiblePlayer( objPlayer )

tr.start = self:GetPos()
tr.endpos = objPlayer:GetPos()
tr.filter = function( ent ) if ent == objPlayer then return true end end 
local trace = util.TraceLine( tr )

	if !trace.HitWorld || trace.Entity:IsPlayer()  then 
		return true
	else
		return false
	end

end

function ENT:Think()
	if ( self.iPoisonTimer <= CurTime() ) then
		self.iPoisonTimer = CurTime() + 1.5
		self.objFoundEnemys = ents.FindInSphere( self:GetPos(), self.iPoisonDamageRadius )
		for k, v in pairs( self.objFoundEnemys ) do
			if ( IsValid( v ) &&  v:IsPlayer()  ) then
				if ( !v.iCanTakePoisonDamage ) then
					v.iCanTakePoisonDamage = CurTime()
				end
				if ( CurTime()  >= v.iCanTakePoisonDamage && self:IsVisiblePlayer( v ) ) then
					v.iCanTakePoisonDamage = CurTime() + self.iTakeDamageDelay
					if ( v:Team() == 4   ) then
						v:TakeDamage( self.iDamageAmount, self, self:GetClass() )
					end
					if ( v:Team() == 3  ) then
						if ( v:Health() + self.iHealAmount >= v:GetMaximumHealth() ) then
							v:SetHealth(v:GetMaximumHealth())		
						else
							v:SetHealth(v:Health() + self.iHealAmount)	
						end
					end
				end
			end
		end
	end
end


function ENT:OnRemove()

end