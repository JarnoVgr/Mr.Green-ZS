-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/crossbow_bolt.mdl")
	-- self.Heal = 700 * math.Clamp(GetInfliction()+0.3,0.5,1)

	--Initial and Maximum Health
	self.Heal = 150
	
	--Increase health when having a perk
	if self:GetOwner():GetPerk("_nailhp") then
		self.Heal = math.Round(self.Heal + self.Heal*0.4)
	end

	--Health
	self.Entity:SetDTInt(0,self.Heal)
	
	---
	-- TODO: Use a shared fixed value for maximum health
	-- instead of a DT
	-- 
	--Max. Health
	self.Entity:SetDTInt(1,self.Heal)
	
	--Remove nail immediately in Arena Mode (WHY?)
	if ARENA_MODE then
		timer.Simple(0,function()
			if IsValid(self) then
				sound.Play(Sound("ambient/machines/catapult_throw.wav"), self:GetPos(), 80, math.random(90, 110))
				self:Remove()
			end
		end)
	end
end

function ENT:SetNailHealth(am)
	self.Entity:SetDTInt(0,am)
end

--[[function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end]]

function ENT:Think()
	--And not a single fuck was given that beautiful day! :D
	if self.toworld then
		return
	end

	self.Next = self.Next or 0
	if self.Next >= CurTime() then
		return
	end
	self.Next = CurTime() + 1

	if self.Ents then
		local Ent1,Ent2 = self.Ents[1], self.Ents[2]
		
		if (Ent1 and self.Ents[1]:GetPhysicsObject() and self.Ents[1]:GetPhysicsObject():GetVelocity():Length() > 580 and Ent1.Nails) then
			sound.Play(Sound("ambient/machines/catapult_throw.wav"), self:GetPos(), 80, math.random(90, 110))
			Ent1:TakeDamage(self.Entity:GetDTInt(0)+10,nil)
			-- Ent1:TakeDamage(self.Entity:GetNWInt("NailHealth")+10,nil)
		elseif (Ent2 and self.Ents[2]:GetPhysicsObject() and self.Ents[2]:GetPhysicsObject():GetVelocity():Length() > 580 and Ent2.Nails) then
			sound.Play(Sound("ambient/machines/catapult_throw.wav"), self:GetPos(), 80, math.random(90, 110))
			-- Ent2:TakeDamage(self.Entity:GetNWInt("NailHealth")+10,nil)
			Ent2:TakeDamage(self.Entity:GetDTInt(0)+10,nil)
		end
	end
end
