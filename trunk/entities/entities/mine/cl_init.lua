-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include('shared.lua')
local light = Material( "particle/fire" )

local render = render
local math = math

function ENT:Draw()
	self.Entity:SetColor(Color(255,255,255,255))
	self.Entity:DrawModel()
	local FixAngles = self.Entity:GetAngles()
	local FixRotation = Vector(0, 270,0) -- Vector(0, 270, 0)

	FixAngles:RotateAroundAxis(FixAngles:Right(), 	FixRotation.x)
	FixAngles:RotateAroundAxis(FixAngles:Up(), 		FixRotation.y)
	FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)
	local TargetPos = self.Entity:GetPos()
   --  cam.Start3D2D(TargetPos, FixAngles, 0.15)
   local Size = math.abs(math.sin(RealTime() * 1)*30) + 12
		render.SetMaterial(light)
	

		
		render.DrawSprite( TargetPos, Size, Size, Color(255,20,20,80 ) )
		-- debugging
	--[=[render.SetMaterial( matLaser )
	
	render.DrawBeam( self.Entity:GetPos() + (self.Entity:GetUp() * 25), self.Entity:GetPos(), 7, 1, 1, Color( 255,0 , 0 , 255 ))
	render.DrawBeam( self.Entity:GetPos() + (self.Entity:GetForward() * 25), self.Entity:GetPos(), 7, 1, 1, Color( 0,255 , 0 , 255 ))
	render.DrawBeam( self.Entity:GetPos() + (self.Entity:GetRight() * 25), self.Entity:GetPos(), 7, 1, 1, Color( 0,0 , 255 , 255 ))
	]=]
	-- cam.End3D2D() 
end

function ENT:Think()

end
