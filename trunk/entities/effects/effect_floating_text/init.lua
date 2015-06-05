
function EFFECT:Init( data )
	self:SetRenderBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 32 ) )
	self.Seed = math.Rand( 0, 3 )
	self.Pos = data:GetOrigin()
	self.Color = Color( 35, 235, 35, 255 )
	self.Color2 = Color( 35, 200, 35, 255 )
	self.DeathTime = CurTime() + 3
	self.Points = data:GetMagnitude() or 0	
end

function EFFECT:Think()
	self.Pos.z = self.Pos.z + FrameTime() * 32
	return CurTime() < self.DeathTime
end
local KillWords = {"Slaughtered"} --We can make this into a really cool system sometime, when ever we can be assed :) 
function EFFECT:Render()
	local delta = math.max( 0, self.DeathTime - CurTime() )
	self.Color.a = delta * 80

	local ang = EyeAngles()
	local right = ang:Right()
	
	ang:RotateAroundAxis( ang:Up(), 270 )
	ang:RotateAroundAxis( ang:Forward(), 90 + math.sin( RealTime() * 4 ) * delta * 20 )
	
	cam.IgnoreZ( true )
    	cam.Start3D2D( self.Pos + math.sin( CurTime() + self.Seed ) * 10 * delta * right, ang, delta * 0.08 + 0.09 )
    		draw.SimpleTextOutlined( "+"..tostring( self.Points ), "CorpusCareFifteen", 0, 0, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.1, Color( 0,0,0,255 ) )
    		--draw.SimpleTextOutlined( table.Random(KillWords) , "CorpusCareSeven", 0, 50, self.Color2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.1, Color( 0,0,0,255 ) )
    	cam.End3D2D()
    cam.IgnoreZ( false )
end

