-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local util = util
local render = render

function EFFECT:Init(data)
	self.EfOwner = data:GetEntity()
	self.Entity:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
end

function EFFECT:Think()
	
	if not ValidEntity(self.EfOwner) then return false end
	if not ValidEntity(self.EfOwner:GetActiveWeapon()) then return false end
	if self.EfOwner:GetActiveWeapon():GetClass() ~= "map_tool" then return false end
	if not self.EfOwner:Alive() then return false end
	if not self.EfOwner:IsHuman() then return false end
	
	local ent = self.Entity
	
	local wep = self.EfOwner:GetActiveWeapon()
	local switch = wep:GetDTBool(0) or false
	
	local trace = self.EfOwner:GetEyeTrace()

	self.Entity:SetPos(trace.HitPos+vector_up*25)
	
	local ang = self.Entity:GetAngles()
	ang.p = 0 -- - (switch and 90 or 0)
	ang.r = 90 -- + (switch and 90 or 0)
	ang.y = 0 + (switch and 90 or 0)
	
	ent:SetAngles(ang)
	
	ent:SetColor (Color(0,255,0,200))

	
	return (self and self.EfOwner and IsValid(self.EfOwner) and self.EfOwner:GetActiveWeapon() and self.EfOwner:GetActiveWeapon():GetClass() == "map_tool" and self.EfOwner:Alive() and self.EfOwner:Team() ~= TEAM_UNDEAD)
end

function EFFECT:Render()
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:DrawModel()
end
