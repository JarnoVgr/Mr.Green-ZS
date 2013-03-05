ENT.Type = "anim"
ENT.Base = "pickup_gascan"

util.PrecacheModel("models/props_junk/propane_tank001a.mdl")

if SERVER then
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	
	self.Entity:SetModel("models/props_junk/propane_tank001a.mdl")-- 
	self.Entity:SetColor(Color(255,0,0,255))
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS )
	self.Entity:SetSolid(SOLID_VPHYSICS)
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	--self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
	local phys = self.Entity:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:Wake()
		--phys:SetMass(30)
		--phys:EnableMotion( true ) 
	end


	
	self.Entity:_SetHealth(70)
	
	self.AllowDamage = true
	
end


function ENT:SetUse()
	if self.Activator.CurrentWeapons["Misc"] < 1 then
		self.Activator:Give("weapon_zs_pickup_propane")
		self:Remove()
	end
end

end

