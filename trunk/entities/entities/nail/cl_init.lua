-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

local matOutlineWhite = Material("white_outline")
function ENT:Draw() 
	--Only draw model when far way or being an Undead
	if self:GetPos():Distance(EyePos()) > 105 or MySelf:IsZombie() then
		self:DrawModel()
		return
	end

	cam.Start3D(EyePos(), EyeAngles())

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
	render.SetStencilReferenceValue(1)
	
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride( matOutlineWhite )
		
	local health = self:GetDTInt(0) / self:GetDTInt(1)
		
	-- render.SetColorModulation( (255 - self.Entity:GetNWInt("NailHealth")) / 255, (self.Entity:GetNWInt("NailHealth") ) / 255, 0 )
	render.SetColorModulation(1 - health, health, 0)
	self:SetModelScale(1.2, 0)
	self:DrawModel()
	self:SetModelScale(1, 0)
	render.ModelMaterialOverride( nil )
	render.SetColorModulation(1,1,1)
	render.SuppressEngineLighting(false)

	
	render.SetStencilReferenceValue(2)
	
	self:DrawModel()
 
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilReferenceValue(1)

	render.SetStencilEnable(false)
 
	cam.End3D()
end

function ENT:OnRemove()
	local normal = self:GetForward() * -1
	local pos = self:GetPos() + normal * 8

	WorldSound(Sound("physics/metal/metal_box_impact_bullet"..math.random(1, 3)..".wav"), pos, 80, math.random(90, 110))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(28, 32)
	for i=1, math.random(10, 20) do
		local vNormal = (VectorRand() * 0.35 + normal):GetNormal()
		local particle = emitter:Add("effects/spark", pos + vNormal * 2)
		particle:SetVelocity(vNormal * math.Rand(24, 90))
		particle:SetDieTime(math.Rand(2.5, 3))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(2, 3))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5, 5))
		particle:SetCollide(true)
		particle:SetBounce(0.8)
		particle:SetGravity(Vector(0,0,-500))
	end
	emitter:Finish()
end
