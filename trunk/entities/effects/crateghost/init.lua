-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init(data)
	self.EfOwner = data:GetEntity()
	
	--Prevent drawing till first Think
	self.FirstThink = true
	self:SetNoDraw(true)

	--Set model and model's material
	self.Entity:SetModel("models/Items/item_item_crate.mdl")
	self.Entity:SetMaterial("models/debug/debugwhite")
end

function EFFECT:Think()
	if not ValidEntity(self.EfOwner) or not ValidEntity(self.EfOwner:GetActiveWeapon()) or self.EfOwner:GetActiveWeapon():GetClass() ~= "weapon_zs_tools_supplies" or not self.EfOwner:Alive() or not self.EfOwner:IsHuman() then
		return false
	end
	
	local vecAim = self.EfOwner:GetAimVector()
	local posShoot = self.EfOwner:GetShootPos()
	
	local tr = util.TraceLine({start = posShoot, endpos = posShoot+300*vecAim, filter = self.EfOwner})

	self.Entity:SetPos(tr.HitPos)	
	
	local canPlaceCrate, ghostHidden = false, false

	--Check if we really need to draw the crate
	if tr.HitSky or tr.HitPos:Distance(self.EfOwner:GetPos()) > 100 or not tr.HitPos then
		ghostHidden = true
	elseif tr.HitWorld and tr.HitPos:Distance(self.EfOwner:GetPos()) > 10 and tr.HitPos:Distance(self.EfOwner:GetPos()) <= 70 then
		--Check traceline position area
		local hTrace = util.TraceHull({start = tr.HitPos, endpos = tr.HitPos, mins = Vector(-28,-28,0), maxs = Vector(28,28,25)})

		if hTrace.Entity == NULL then
			canPlaceCrate = true
		end
	end

	--Check distance to Supply Crates
	--[[for _, point in pairs(RealCrateSpawns) do
		if tr.HitPos:Distance(point) > 100 then
			continue
		end
		
		canPlaceCrate = false
	end]]

	--Set colour
	if canPlaceCrate then
		self.Entity:SetColor(Color(0, 255, 0, 200))
	else
		self.Entity:SetColor(Color(255, 0, 0, 200))
	end
	
	local angles = vecAim:Angle()
	self.Entity:SetAngles(Angle(0, angles.y, angles.r))

	--Draw from now on (since position etc. is set)
	if self.FirstThink then
		self:SetNoDraw(false)
		self.FirstThink = false
	end

	if ghostHidden and self:GetNoDraw() == false then
		self.Entity:SetNoDraw(true)
	elseif not ghostHidden and self:GetNoDraw() == true then
		self.Entity:SetNoDraw(false)
	end
	
	return (self and self.EfOwner and ValidEntity(self.EfOwner) and self.EfOwner:GetActiveWeapon() and self.EfOwner:GetActiveWeapon():GetClass() == "weapon_zs_tools_supplies" and self.EfOwner:Alive() and self.EfOwner:Team() ~= TEAM_UNDEAD) or false
end

function EFFECT:Render()
	self.Entity:DrawModel()
end
