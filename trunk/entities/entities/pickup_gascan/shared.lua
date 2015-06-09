ENT.Type = "anim"
ENT.Base = "pickup__base"

util.PrecacheModel("models/props_junk/metalgascan.mdl")

if SERVER then
AddCSLuaFile("shared.lua")
end

function ENT:Initialize()
	
	self.Entity:SetModel("models/props_junk/metalgascan.mdl")-- 
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


	
	self.Entity:_SetHealth(90)
	
	self.AllowDamage = true
	
end

function ENT:OnZeroHealth(dmginfo)
	
	if self.Exploded then return end
	self.Exploded = true
	
	if self:GetOwner():IsValid() and self:GetOwner():Team() == TEAM_HUMAN then
		util.BlastDamage2(self, self:GetOwner(), self:GetPos(), 250, 300)
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)	
	end
	
	self.Entity:Remove() -- end)


end

function ENT:SetUse()
	if self.Activator.CurrentWeapons["Misc"] < 1 then
		self.Activator:Give("weapon_zs_pickup_gascan2")
		self:Remove()
	end
end


