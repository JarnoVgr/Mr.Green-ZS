-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(Model("models/crossbow_bolt.mdl"))
	--self:PhysicsInit(SOLID_BBOX)
	-- self.Heal = 700 * math.Clamp(GetInfliction()+0.3,0.5,1)

	--Initial and Maximum Health
	self.Heal = 165
	
	--Increase health when having a perk
	local Owner = self:GetOwner()
	if IsValid(Owner) then
		if Owner:GetPerk("_nailhp") then
			self.Heal = math.Round(self.Heal + (self.Heal*0.4))
		end
		if Owner:GetSuit() == "supportsuit" then
			self.Heal = math.Round(self.Heal + (self.Heal*0.6))
		end
	end

	--Health and Max Health
	self.Entity:SetDTInt(0, self.Heal)
	self.Entity:SetDTInt(1, self.Heal)
	
	--Remove nail immediately in Arena Mode (WHY?)
	if ARENA_MODE then
		timer.Simple(0,function()
			if IsValid(self) then
				sound.Play(Sound("ambient/machines/catapult_throw.wav"), self:GetPos(), 80, math.random(90, 110))
				self:Remove()
			end
		end)
	end

	--self:SetUseType(SIMPLE_USE)
end

function ENT:SetNailHealth(am)
	self.Entity:SetDTInt(0,am)
end

--[[function ENT:Think()
	self:NextThink(CurTime() + 1)

	--And not a single fuck was given that beautiful day! :D
	if self.toworld then
		return true
	end

	--??
	if self.Ents then
		for i=1,2 do
			local Ent = self.Ents[i]
			local Phys = Ent:GetPhysicsObject()
			if (IsValid(Ent) and Phys and Phys:GetVelocity():Length() > 580 and Ent.Nails) then
				sound.Play(Sound("ambient/machines/catapult_throw.wav"), self:GetPos(), 80, math.random(90, 110))
				Ent:TakeDamage(self.Entity:GetDTInt(0)+1,nil)
			end
		end
	end

	return true
end]]