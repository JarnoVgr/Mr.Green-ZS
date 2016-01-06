AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Pufulet"
ENT.Purpose			= ""
--ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

util.PrecacheSound("items/ammo_pickup.wav")
util.PrecacheModel("models/items/boxmrounds.mdl")

function ENT:Initialize()
	if SERVER then	
		self:DrawShadow(false)
		self.Entity:SetModel("models/items/boxmrounds.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(true) 
		end
	end
end

if SERVER then
	function ENT:Use(activator, caller)
	
		if not IsValid(activator) then
			return
		end
		
		if activator:IsZombie() then
			return
		end
	
		if activator:IsPlayer() and activator:IsHuman() then
			activator:GiveAmmoPack()	
			self:EmitSound("items/gift_pickup.wav" )
			self:Remove()			
		end
	end
end
	
--[[	
if CLIENT then
	--ENT.LineColor = Color(210, 0, 0, 100)
	function ENT:Draw()
	    self:DrawModel()
		
	    if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
	        return
		end

	    self.LineColor = Color(0, 200, 100, 100)
	end

	--function ENT:OnRemove()
	--    hook.Remove("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self))
	--end
end
]]--