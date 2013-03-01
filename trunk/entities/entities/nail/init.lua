-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local math = math

function ENT:Initialize()
	self:SetModel("models/crossbow_bolt.mdl")
	//self.Heal = 700 * math.Clamp(GetInfliction()+0.3,0.5,1)
	self.Heal = 225
	
	if self:GetOwner():GetPerk("_nailhp") then
		self.Heal = math.Round(self.Heal + self.Heal*0.4)
	end
	--print("Debugging nail health: "..self.Heal)
	//self.Entity:SetNWInt("NailHealth", self.Heal)
	//self.Entity:SetNWInt("MaxNailHealth", self.Heal)
	
	self.Entity:SetDTInt(0,self.Heal) //health
	self.Entity:SetDTInt(1,self.Heal) //max health
	
	if ARENA_MODE then
		timer.Simple(0,function()
			if IsValid(self) then
				WorldSound("ambient/machines/catapult_throw.wav", self:GetPos(), 80, math.random(90, 110))
				self:Remove()
			end
		end)
	end
	
end

function ENT:SetNailHealth(am)
	self.Entity:SetDTInt(0,am)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Think()
/*if self.Entity:GetNWInt("NailHealth") != self.Heal then
	self.Entity:SetNWInt("NailHealth", self.Heal)
end*/

//if self.Entity:GetDTInt(0) != self.Heal then
//	self.Entity:SetDTInt(0, self.Heal)
//end

--And not a single fuck was given that beautiful day! :D
if self.toworld then return end

self.Next = self.Next or 0

if self.Next >= CurTime() then return end

self.Next = CurTime() + 1

if self.Ents then
	
	local Ent1,Ent2 = self.Ents[1], self.Ents[2]
	
	if (Ent1 and self.Ents[1]:GetPhysicsObject() and self.Ents[1]:GetPhysicsObject():GetVelocity():Length() > 580 and Ent1.Nails) then
		
		WorldSound("ambient/machines/catapult_throw.wav", self:GetPos(), 80, math.random(90, 110))
		Ent1:TakeDamage(self.Entity:GetDTInt(0)+10,nil)
		//Ent1:TakeDamage(self.Entity:GetNWInt("NailHealth")+10,nil)
				
	elseif (Ent2 and self.Ents[2]:GetPhysicsObject() and self.Ents[2]:GetPhysicsObject():GetVelocity():Length() > 580 and Ent2.Nails) then
	
		WorldSound("ambient/machines/catapult_throw.wav", self:GetPos(), 80, math.random(90, 110))
		//Ent2:TakeDamage(self.Entity:GetNWInt("NailHealth")+10,nil)
		Ent2:TakeDamage(self.Entity:GetDTInt(0)+10,nil)

	end
end
end
