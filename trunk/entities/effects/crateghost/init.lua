-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local util = util

function EFFECT:Init(data)
	self.EfOwner = data:GetEntity()
	self.Entity:SetModel("models/Items/item_item_crate.mdl")

	//self.DieTime = RealTime() + 0.01
end

function EFFECT:Think()
	
	if !ValidEntity(self.EfOwner) then return false end
	if !ValidEntity(self.EfOwner:GetActiveWeapon()) then return false end
	if self.EfOwner:GetActiveWeapon():GetClass() ~= "weapon_zs_tools_supplies" then return false end
	if not self.EfOwner:Alive() then return false end
	if not self.EfOwner:IsHuman() then return false end
	
	local ent = self.Entity
	
	local aimvec = self.EfOwner:GetAimVector()
	local shootpos = self.EfOwner:GetPos()+Vector(aimvec.x,aimvec.y,0)*25+Vector(0,0,1)
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 70, filter = self.EfOwner})

	self.Entity:SetPos(tr.HitPos)

	local htrace = util.TraceHull ( { start = tr.HitPos, endpos = tr.HitPos,  mins = Vector (-28,-28,0), maxs = Vector (28,28,25)} )//filter = self.EfOwner,
	local trground = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos - Vector(0,0,1.5)})
	
	local Crate = false
	if trground.HitWorld then
		if htrace.Entity == NULL and tr.HitPos:Distance(self.EfOwner:GetPos()) > 25 then
			Crate = true
		else
			Crate = false
		end
	else
		Crate = false
	end
	
	if Crate then
		ent:SetColor (Color(0,255,0,200))
	else
		ent:SetColor (Color(255,0,0,200))
	end
	
	local angles = aimvec:Angle()
	self.Entity:SetAngles( Angle (0,angles.y,angles.r) )
	
	return (self and self.EfOwner and ValidEntity(self.EfOwner) and self.EfOwner:GetActiveWeapon() and self.EfOwner:GetActiveWeapon():GetClass() == "weapon_zs_tools_supplies" and self.EfOwner:Alive() and self.EfOwner:Team() ~= TEAM_UNDEAD) or false
	//return RealTime() < self.DieTime
end

function EFFECT:Render()
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:DrawModel()
end
