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
		--self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,22))
		--self:SetModelScale(0.3,0)
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

	if CLIENT then
		hook.Add("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self), function()
			if not util.tobool(GetConVarNumber("zs_drawcrateoutline")) then
				return
			end
			
			if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
				return
			end
			
			halo.Add({self}, self.LineColor, 2, 2, 2, true, false)
		end)
	end
end

if SERVER then
	function ENT:Use(activator, caller)
	
		if not IsValid(activator) then
			return
		end
	
		local mul = 1
	
		if activator:GetPerk("_support2") then
			mul = mul + 0.1
		end					
		
		if activator:GetPerk("_support2") then
			mul = mul + activator:GetRank()*0.02
		end	
		
		if activator:GetPerk("_supportammo") then
			mul = mul + 0.35
		end		
	
		if activator:IsPlayer() and activator:IsHuman() then
			activator:GiveAmmo( 20 * mul, "pistol" )	
			activator:GiveAmmo( 30 * mul, "ar2" )
			activator:GiveAmmo( 30 * mul, "SMG1" )	
			activator:GiveAmmo( 12 * mul, "buckshot" )		
			activator:GiveAmmo( 8 * mul, "357" )
			activator:GiveAmmo( 30 * mul, "alyxgun" )		
			self:Remove()
		end
	end
end
	
if CLIENT then
	ENT.LineColor = Color(210, 0, 0, 100)
	function ENT:Draw()
	    self:DrawModel()
		
	    if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
	        return
		end

	    self.LineColor = Color(0, 200, 100, 100)
	end

	function ENT:OnRemove()
	    hook.Remove("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self))
	end
end