
include("shared.lua")
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

function ENT:Initialize()   
	self.Entity:DrawShadow(false)
	self.Entity:SetSolid(false)
end 

function ENT:Think()
end

function ENT:CreateFromTable( suittable )
	
	self:SetModel(suittable.model)
	self:SetNWString("bone", suittable.bone)
	self:SetDTVector(0, suittable.pos)
	self:SetDTAngle(0, suittable.ang)
	self:SetDTVector(1, suittable.scale)
	
	if suittable.mat and suittable.mat ~= "" then
		self:SetMaterial(suittable.mat)
	end
	self:SetColor( 255, 255, 255, 255 )

end