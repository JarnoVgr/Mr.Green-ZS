-- Yes, its based off Exploit Blocker :v

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

-- General info
SWEP.PrintName = "Poison Spawner Tool"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false
SWEP.Author	= "ClavusElite"
SWEP.Slot = 4
SWEP.SlotPos = 4
SWEP.Contact = "None"
SWEP.Purpose = "None"
SWEP.Instructions = "None"

-- View and world models
SWEP.ViewModel = "models/weapons/v_toolgun.mdl"
SWEP.WorldModel	= "models/weapons/w_toolgun.mdl"

SWEP.Spawnable = false
SWEP.AdminSpawnable	= true

SWEP.Primary.Recoil	= 2
SWEP.Primary.Unrecoil = 7
SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.5
SWEP.Primary.Cone = 0
SWEP.ConeMoving	= 0
SWEP.ConeCrouching = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"
SWEP.Secondary.Delay = 0.3

SWEP.HoldType = "pistol"
SWEP.Primary.Sound = Sound( "buttons/button9.wav" )


if CLIENT then
	usermessage.Hook( "umsg_gasses_update", function( msg )
		local First = msg:ReadBool()
		if ( First ) then
			PoisonGasses = {}
		end
		
		local Index = msg:ReadShort()
		local Pos = msg:ReadVector()
		local Radius = msg:ReadShort()
		
		PoisonGasses[Index] = { origin = Pos, radius = Radius }
	end )
end

function SWEP:Initialize()

end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	--local pos = self.Owner:GetAimVector()
	if SERVER then
		local trace = self.Owner:GetEyeTrace()
		
		local firstgas = (#PoisonGasses <= 0)
		
		local pos = trace.HitPos + Vector(0,0,45)
		local ent = ents.Create ( "zs_poisongasses" )
		ent:SetPos ( pos )
		ent:SetAngles(Angle(90,0,0))
		-- ent:SetNWInt("GasRadius", self:GetDTInt( 0 ))
		ent:SetDTInt(0,self:GetDTInt( 0 ))
		-- ent:SetNWBool("GasPipe", ( firstgas ))
		ent:SetDTBool(0,firstgas)
		ent:Spawn()	
		
		table.insert( PoisonGasses, { origin = pos, radius = self:GetDTInt( 0 ) or 0 } )
	
		self.Owner:PrintMessage ( HUD_PRINTTALK, "You have created gas spawn!")
		for k,v in ipairs ( PoisonGasses ) do
			umsg.Start( "umsg_gasses_update", self.Owner )
				umsg.Bool( ( k == 1 ) )
				umsg.Short( k )
				umsg.Vector( v.origin)
				umsg.Short( v.radius )
			umsg.End()
		end
	
	self:EmitSound( self.Primary.Sound )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end
end

function SWEP:SecondaryAttack()
	return false
end

SWEP.SizeTimer = 0
function SWEP:Think()

	self.Origin = self.Owner:GetEyeTrace().HitPos + Vector(0,0,45)
		
	if SERVER then
		if self.SizeTimer < CurTime() then
			if self.Owner:KeyDown( IN_ATTACK2 ) then
				self:SetDTInt( 0, ( self:GetDTInt( 0 ) or 0 ) + 1 )
			elseif self.Owner:KeyDown( IN_USE ) then
				self:SetDTInt( 0, ( self:GetDTInt( 0 ) or 0 ) - 1 )
			end
		end
		
		if SERVER then
			if self.Owner:KeyPressed( IN_ZOOM ) then
				MapPoisonGassesWrite()
			self.Owner:ChatPrint( "[TOOL] Saved gasses in: 'data/poisongasses/"..game.GetMap()..".txt'" )	
			end	
		end
	end
end

SWEP.TimerReload = 0
function SWEP:Reload()
	if CurTime() < self.TimerReload then return end
	
	if #PoisonGasses <= 0 then 
		self.Owner:ChatPrint( "-- You haven't placed any gasses yet! --" )
		self.TimerReload = CurTime() + 0.5
		
		return 
	end
	
	local count = 0
	local tokeep = {}
	for k, v in pairs( PoisonGasses ) do
		if v.origin:Distance( self.Owner:GetPos() + self.Owner:GetAimVector() * 84 ) < 128 then
			count = count + 1			
		else
			table.insert( tokeep,v )
		end
	end
	
	PoisonGasses = tokeep
	
	if CLIENT then
		if count == 0 then
			self.Owner:ChatPrint( "-- No gasses nearby! --" )
		else
			self.Owner:ChatPrint( "-- Deleted "..count.." nearby gasses --" )
		end
	end
	
	self.TimerReload = CurTime() + 0.5	
end

function SWEP:Holster( wep )
	return true
end 

--[==[-------------------------------------------------------------------------
	Called when you make it active 
--------------------------------------------------------------------------]==]
function SWEP:Deploy()
	self:SetDTInt( 0, 110 )
	self.Origin = self.Owner:GetEyeTrace().HitPos + Vector(0,0,45)
	-- Initialize exploits table if not
	PoisonGasses = PoisonGasses or {}
	self:SendWeaponAnim( ACT_VM_DRAW )

	if SERVER then
		for k,v in ipairs ( PoisonGasses ) do
			umsg.Start( "umsg_gasses_update", self.Owner )
				umsg.Bool( ( k == 1 ) )
				umsg.Short( k )
				umsg.Vector( v.origin)
				umsg.Short( v.radius )
			umsg.End()
		end

	end
	
	return true
end 

--[==[-------------------------------------------------------------------------
	Called when you equip it
--------------------------------------------------------------------------]==]
function SWEP:Equip ( NewOwner )
	if SERVER then
		local EntClass = self:GetClass()
		local PrintName = self.PrintName or "weapon"
		if NewOwner:IsPlayer() then
			if NewOwner:Team() == TEAM_HUMAN then
				local category = WeaponTypeToCategory[ self:GetType() ]
				NewOwner.CurrentWeapons[ category ] = NewOwner.CurrentWeapons[ category ] + 1
				WeaponPickupNotify ( NewOwner, PrintName )				
			end
		end
	end
end

if CLIENT then

function SWEP:DrawHUD()
	if not self.Owner:Alive() then return end
	if ENDROUND then return end
	
	local points = {}
	local screen = nil

	local blocklist = table.Copy( PoisonGasses )
	table.insert( blocklist, { origin = self.Origin, radius = self:GetDTInt( 0 ) or 0, current = true } )

	
	
	for k, v in pairs(blocklist) do
		screen = (v.origin+Vector(0,0,41)):ToScreen()
		
		draw.SimpleText( "- Gas "..k.." | Radius: "..v.radius, "default", screen.x, screen.y, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
			if not v.current then 
				surface.SetDrawColor(Color(255,0,0))
			else
				surface.SetDrawColor( Color( 0,255,0 ) )
			end

		--surface.DrawCircle( screen.x, screen.y, v.radius) 
	
		local center = screen
		local scale = Vector( v.radius, v.radius, 0 )
		local segmentdist = 360 / ( 2 * math.pi * math.max( scale.x, scale.y ) / 2 )
 
		for a = 0, 360 - segmentdist, segmentdist do
			surface.DrawLine( center.x + math.cos( math.rad( a ) ) * scale.x, center.y - math.sin( math.rad( a ) ) * scale.y, center.x + math.cos( math.rad( a + segmentdist ) ) * scale.x, center.y - math.sin( math.rad( a + segmentdist ) ) * scale.y )
		end
		
		local low = v.origin:ToScreen()
		
		surface.DrawLine(low.x,low.y,screen.x,screen.y)
		
		one = (v.origin + Vector(v.radius,0,0)):ToScreen()
		oneend = (v.origin - Vector(v.radius,0,0)):ToScreen()
		two = (v.origin + Vector(0,v.radius,0)):ToScreen()
		twoend = (v.origin - Vector(0,v.radius,0)):ToScreen()
		three = (v.origin + Vector(v.radius,v.radius,0)):ToScreen()
		threeend = (v.origin - Vector(v.radius,v.radius,0)):ToScreen()
		four = (v.origin + Vector(v.radius,-v.radius,0)):ToScreen()
		fourend = (v.origin - Vector(v.radius,-v.radius,0)):ToScreen()
		
		surface.DrawLine(one.x,one.y,oneend.x,oneend.y)
		surface.DrawLine(two.x,two.y,twoend.x,twoend.y)
		surface.DrawLine(three.x,three.y,threeend.x,threeend.y)
		surface.DrawLine(four.x,four.y,fourend.x,fourend.y)


	
	end
	
	
	
	local Mode = self:GetNetworkedInt ( "Mode" )
	local Description1 = "Left mouse to place"
	local Description2 = "USE to shrink, RMB to grow"
	local Description3 = "R to delete nearby gases (broken). ZOOM to save."

	surface.SetFont ( "ArialNine" )
	local DescWide1 = surface.GetTextSize ( Description1 )
	local DescWide2 = surface.GetTextSize ( Description2 )
	local DescWide3 = surface.GetTextSize ( Description3 )

	local BoxWide = math.max ( DescWide1, DescWide2, DescWide3 ) + ScaleW(50)

	draw.RoundedBox ( 8, ScaleW(673) - BoxWide * 0.5, ScaleH(761) - ScaleH(117) * 0.5, BoxWide, ScaleH(117), Color ( 1,1,1,180 ) )
	draw.SimpleText ( Description1,"ArialNine",ScaleW(673),ScaleH(726), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText ( Description2 ,"ArialNine",ScaleW(673),ScaleH(756), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText ( Description3 ,"ArialNine",ScaleW(673),ScaleH(788), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

end
