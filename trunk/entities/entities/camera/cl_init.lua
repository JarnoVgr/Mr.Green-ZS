-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
--
-- This particular file contains code by Night Eagle

include('shared.lua')

function ENT:Initialize()
	self.Crow = ClientsideModel("models/crow.mdl")
	self.Cycle = 0
	self.DrawLast = UnPredictedCurTime()
end

function ENT:OnRemove()
	self.Crow:Remove()
end

function ENT:Draw()
	local delta = UnPredictedCurTime() - self.DrawLast
	self.DrawLast = UnPredictedCurTime()
	self.Crow:FrameAdvance( RealFrameTime( ) )

	local pl = self.Entity:GetOwner() or LocalPlayer()
	if not (IsValid(pl) and pl:IsPlayer()) then
		pl = LocalPlayer()
	end
	
	local vel = self.Entity:GetVelocity()
	
	local tr = util.TraceLine{
		start = self.Entity:GetPos(),
		endpos = self.Entity:GetPos() - Vector(0,0,16),
		filter = self.Entity,
	}
	
	local ground = tr.Hit
	local rate = 1
	
	local setang = true
	if vel:Length() < 16 and not ground then
		local ang = pl:EyeAngles()
		ang.p = -15
		self.Crow:SetAngles(ang)
		self.Crow:SetSequence(0)
		rate = .7
		
		setang = false
	elseif ground then
		if vel:Length() > 90 then
			local ang = vel:Angle()
			self.Crow:SetAngles(ang)
			rate = 2
			
			self.Crow:SetSequence(3)
		elseif vel:Length() > 7 then
			local ang = vel:Angle()
			self.Crow:SetAngles(ang)
			rate = 1
			
			self.Crow:SetSequence(2)
		else
			local ang = self.Crow:EyeAngles()
			ang.p = 0
			self.Crow:SetAngles(ang)
			
			self.Crow:SetSequence(1)
			rate = .1
		end
		
		setang = false
	elseif vel.z > 2 then
		self.Crow:SetSequence(0)
	elseif vel:Length() < 16 and ground then
	else
		self.Crow:SetSequence(7)
	end
	
	if setang then
		self.Crow:SetAngles(pl:EyeAngles())
	end
	
	self.Crow:SetPos(self.Entity:GetPos()-Vector(0,0,8))
	
	self.Cycle = self.Cycle + delta*rate
	if self.Cycle > 1 then
		self.Cycle = self.Cycle - 1
	end
	self.Crow:SetCycle(self.Cycle)
	self.Crow:DrawModel()
end

function ENT:Think()
	if not IsValid(self.Crow) then
		self.Crow = ClientsideModel("models/crow.mdl")
	end
	
	-- Play the animation even if you are not looking really at them
	local pos = self.Entity:GetPos()
	self.Entity:SetRenderBoundsWS( Vector(pos.x-30,pos.y-30,pos.z), Vector(pos.x+30,pos.y+30,pos.z+30) )
end