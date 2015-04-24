-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include( "shared.lua" )

function ENT:Initialize()
	self.BoomTime = CurTime() + 5
	
	self.OwnerDied = false
end

function ENT:Think()
	if not IsEntityValid ( self ) then return end
	
	if not IsEntityValid ( self:GetOwner() ) then return end
	
	-- Owner died before nade xploded
	if self.OwnerDied and not self:GetOwner():Alive() then self.OwnerDied = true self:GetOwner().HoldingGrenade = false end
	
	-- BOOM time
	if CurTime() < self.BoomTime then return end
end

function ENT:Draw()
		
	-- Set position to hand
	if IsEntityValid ( self:GetOwner() ) then
		if not self.OwnerDied then
			local hand = self:GetOwner():LookupBone( "ValveBiped.Bip01_L_Hand" ) 
			local tbTable = self:GetOwner():GetAttachment( self:GetOwner():LookupAttachment( "grenade_attachment" ) )
			if hand then  
				local position, angles = self:GetOwner():GetBonePosition(hand)
				
				local x = angles:Up() * 2.70
				local y = angles:Right() * 2.44 
				local z = angles:Forward() * 4.79
	  
				local pitch = -109.58
				local yaw = -0.93
				local roll = 0.00

				angles:RotateAroundAxis(angles:Forward(), pitch)  
				angles:RotateAroundAxis(angles:Right(), yaw)  
				angles:RotateAroundAxis(angles:Up(), roll)  
				
				self:SetPos(position + x + y + z)  
				self:SetAngles(angles)  
			end  
		end
	end
	
	-- Apply grenade glow
	if IsValid( self:GetOwner() ) and self:GetOwner() ~= MySelf then
		if not self.GlowActive then
			local Glow = EffectData()
				Glow:SetEntity( self )
				self.GlowActive = true
			util.Effect( "zombine_grenade_glow", Glow, true, true )
		end
	
		-- Draw model
		self:DrawModel()
	end
	
	-- Make the nade smaller
	self:SetModelScale ( 0.7,0 )
end

