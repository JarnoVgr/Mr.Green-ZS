ENT.Type = "anim"
ENT.Base = "pickup__base"


util.PrecacheModel("models/props_junk/metalgascan.mdl")
util.PrecacheModel("models/BarneyHelmet_faceplate.mdl")

if SERVER then
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	
	self.Entity:SetModel("models/props_junk/metalgascan.mdl")-- 
	self.Entity:SetColor(Color(0,0,0,0))
	self.Entity:SetRenderMode(RENDERMODE_NONE)
	self.Entity:DrawShadow(false)
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Ent = ents.Create("prop_dynamic_override")
	self.Ent:SetModel("models/BarneyHelmet_faceplate.mdl")
	self.Ent:SetPos(self:GetPos())
	self.Ent:SetAngles(self:GetAngles())
	self.Ent:SetParent(self)
	self.Ent:Spawn()
	
	
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	--self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(60)
	end
	
end

function ENT:SetUse()
	if self.Activator.CurrentWeapons["Misc"] < 1 then
		self.Activator:Give("weapon_zs_pickup_gasmask")
		self:Remove()
	end
end

function ENT:OnRemove()
	if self.Ent and IsValid(self.Ent) then
		self.Ent:Remove()
	end
end


end

