-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local util = util
local render = render

function EFFECT:Init(data)
	self.EfOwner = data:GetEntity()
	self.Entity:SetModel("models/Combine_turrets/Floor_turret.mdl")
	
	self.Entity:SetSequence(self.Entity:LookupSequence("deploy"))

	-- self.DieTime = RealTime() + 0.01
end

function EFFECT:Think()
	
	if not IsValid(self.EfOwner) then return false end
	if not IsValid(self.EfOwner:GetActiveWeapon()) then return false end
	if self.EfOwner:GetActiveWeapon():GetClass() ~= "weapon_zs_turretplacer" then return false end
	if not self.EfOwner:Alive() then return false end
	if not self.EfOwner:IsHuman() then return false end
	
	local ent = self.Entity
	
	local wep = self.EfOwner:GetActiveWeapon()
	local rot = math.NormalizeAngle(wep:GetDTInt(0)) or 0
	
	local aimvec = self.EfOwner:GetAimVector()
	local shootpos = self.EfOwner:GetPos()+Vector(0,0,32)
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 70, filter = self.EfOwner})

	self.Entity:SetPos(tr.HitPos)

	local htrace = util.TraceHull ( { start = tr.HitPos, endpos = tr.HitPos,  mins = Vector (-24,-24,0), maxs = Vector (24,24,80)} )-- filter = self.EfOwner,
	local trground = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos - Vector(0,0,2)})
	-- local trground = util.TraceLine({start = self.Entity:GetPos(), endpos = self.Entity:GetPos() - Vector(0,0,1.5)})-- , filter = self.Entity
	
	
	
	self.CanCreateTurret = false
	if trground.HitWorld then
		if htrace.Entity == NULL and tr.HitPos:Distance(self.EfOwner:GetPos()) > 30 then
			self.CanCreateTurret = true
		-- elseif htrace.Entity == self.EfOwner then
		-- 	ent:SetColor (255,0,0,200)
		else
			self.CanCreateTurret = false
		-- 	ent:SetColor (255,0,0,200)
		end
	else
		self.CanCreateTurret = false
		-- ent:SetColor (255,0,0,200)
	end
	
	if self.CanCreateTurret then
		ent:SetColor (Color(0,255,0,200))
	else
		ent:SetColor (Color(255,0,0,200))
	end
	
	local AngleYaw = math.Clamp(math.sin( RealTime()*0.8)*60,-60,60)
	local AnglePitch = math.Clamp(math.sin( RealTime()*0.4)*15,-15,15)
	
	local angles = aimvec:Angle()
	self.Entity:SetAngles( Angle (0,angles.y+rot,angles.r) )
	
	self.Entity:SetPoseParameter("aim_yaw",AngleYaw)
	self.Entity:SetPoseParameter("aim_pitch",AnglePitch)
	
	-- self.Entity:SetPoseParameter("aim_yaw",0)
	-- self.Entity:SetPoseParameter("aim_pitch",0)
	
	return (self and self.EfOwner and IsValid(self.EfOwner) and self.EfOwner:GetActiveWeapon() and self.EfOwner:GetActiveWeapon():GetClass() == "weapon_zs_turretplacer" and self.EfOwner:Alive() and self.EfOwner:Team() ~= TEAM_UNDEAD)
	-- return RealTime() < self.DieTime
end
local matLaser 		= Material( "sprites/bluelaser1" )
function EFFECT:Render()
	self.Entity:SetMaterial("models/wireframe")
	self.Entity:DrawModel()
end
