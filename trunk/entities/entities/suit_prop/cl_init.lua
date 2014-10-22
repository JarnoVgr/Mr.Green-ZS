include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:SetScaling()

		self.scale = self:GetDTVector(1)
		self:SetModelScale(self.scale)
end

function ENT:DrawTranslucent() 
	if (not IsValid(self:GetOwner())) then return end

	local owner = self:GetOwner()
	if not owner:IsValid() or not owner:Alive() or owner == MySelf or not ENABLE_HATS then return end
	if not owner:IsHuman() then return end
	
	self:SetScaling()
	
	local bonename = self:GetNWString("bone")

	local ply = self:GetOwner():GetRagdollEntity() or owner
	local bone = ply:LookupBone(bonename)  
	if bone then  
		local position, angles = ply:GetBonePosition(bone)
		
		local localpos = self:GetDTVector(0)
		local localang = self:GetDTAngle(0)

		local newpos, newang = LocalToWorld( localpos, localang, position, angles ) 

		self:SetPos(newpos)  
		self:SetAngles(newang)  
		
		self:DrawModel()
	end 
	
end  

function ENT:Draw()
	self:DrawTranslucent()	
end

