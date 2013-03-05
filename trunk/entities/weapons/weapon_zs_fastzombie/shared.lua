-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/weapons/v_fza.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.SwapAnims = false

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( false )
	end
end

function SWEP:Initialize()

self.Think = function()
	local Owner = self.Owner
	if not ValidEntity ( Owner ) then return end
	
	-- Leaping
	if self.Leaping then
		local nTrace = Owner:TraceLine ( 45, MASK_SHOT )
		local Sphere = ents.FindInSphere ( Owner:GetShootPos() + Owner:GetAimVector() * 15, 20 )
		
		-- Easier way to bump players
		local Victim = NULL		
		for k,v in pairs ( Sphere ) do
			if v:IsPlayer() and v ~= Owner then
				local vStart, vEnd = Owner:GetShootPos(), v:LocalToWorld ( v:OBBCenter() )
				local glitchTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = Owner } )
				
				-- Trace matches with entity found in sphere
				if glitchTrace.Entity == v then
					Victim = v
					break
				end
			end
		end

		-- We hit something while leaping
		if nTrace.Hit or ValidEntity ( Victim ) then
			if Owner.ViewPunch then Owner:ViewPunch( Angle( math.random(0, 70), math.random(0, 70), math.random(0, 70) ) ) end
			if SERVER then Owner:EmitSound( "physics/flesh/flesh_strider_impact_bullet1.wav" ) end
			
			-- Bump the victim!
			if ValidEntity ( Victim ) then self:DamageEntity ( Victim, 5 ) end
			
			-- Stopped leaping
			self.Leaping = false
			
			-- Stop, so we don't bounce around
			Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
			
			-- Cooldown
			self.NextLeap = CurTime() + 1.5
			
			return
		end
		
		-- always update leap status
		if Owner:OnGround() or Owner:WaterLevel() > 0 then
			self.Leaping = false
		end
	end

	-- Attacking
	if not Owner:KeyDown( IN_ATTACK ) then
		self.Swinging = false
		return
	end
end

end

SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if self.NextAttack > CurTime() then return end
	if self.Leaping then return end

	local Owner = self.Owner
	
	-- Cooldown
	self.NextAttack = CurTime() + self.Primary.Delay
	
	-- Calculate damage done
	local Damage = math.Clamp ( 2.5 + ( 3 * math.min( GetZombieFocus( Owner, 300, 0.0005, 0 ) - 0.15, 1 ) ), 1.7, 6 )

	-- Trace an object
	local nTrace = Owner:TraceLine ( 85, MASK_SHOT )
	local Victim = nTrace.Entity
	
	-- Play miss sound anyway
	if SERVER then Owner:EmitSound( "npc/zombie/claw_miss"..math.random(1, 2)..".wav" ) end
	
	-- Animation
	Owner:SetAnimation( PLAYER_ATTACK1 )
	if self.SwapAnims then self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER ) else self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) end
	self.SwapAnims = not self.SwapAnims
	
	-- First trace
	if CLIENT then return end
	if ValidEntity ( Victim ) then self:DamageEntity ( Victim, Damage ) return end
	
	-- Tracehull attack ( second trace if the first one doesn't hit )
	local TraceHull = Owner:TraceHullAttack ( Owner:GetShootPos(), Owner:GetShootPos() + ( Owner:GetAimVector() * 23 ), Vector ( -15,-10,-18 ), Vector ( 20,20,20 ), 0, DMG_GENERIC, 0 , true )
	local TraceHit = ValidEntity ( TraceHull )	

	-- Hit nothing
	if not TraceHit then return end
	
	-- Do a trace so that the tracehull won't push or damage objects over a wall or something
	local vStart, vEnd = Owner:GetShootPos(), TraceHull:LocalToWorld ( TraceHull:OBBCenter() )
	local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = Owner } )
		
	-- Hitting through wall
	if TraceHull ~= ExploitTrace.Entity then return end
	
	-- Damage entity with tracehull
	self:DamageEntity ( TraceHull, Damage ) 
end
	
function SWEP:DamageEntity ( ent, Damage )
	if not ValidEntity ( ent ) then return end
	local Owner = self.Owner
	
	if CLIENT then return end
	
	-- Don't hurt other zombies
	if ent.Team and ent:Team() == TEAM_UNDEAD then return end
	
	-- Get phys object
	local phys = ent:GetPhysicsObject()
	
	-- Break glass
	if ent:GetClass() == "func_breakable_surf" then
		ent:Fire( "break", "", 0 )
	end
	
	-- Play the hit sound
	Owner:EmitSound( "npc/zombie/claw_strike"..math.random(1, 3)..".wav" )
		
	-- Take damage
	ent:TakeDamage ( Damage, Owner, self )
	
	-- Push for whatever it hits
	local Velocity = Owner:EyeAngles():Forward() * 1000
	
	-- Push the target off is leaping
	if self.Leaping and ent:IsPlayer() then
		Velocity.z = 150
		ent:SetVelocity( Velocity * 0.5 )
		if ent.ViewPunch then ent:ViewPunch( Angle( math.random(0, 80), math.random(0, 80), math.random(0, 80) ) ) end
	end
	
	-- Apply force to the correct object
	if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
		if Velocity.z < 200 then Velocity.z = 200 end
				
		phys:ApplyForceCenter( Velocity * 2 )
		ent:SetPhysicsAttacker( Owner )
	end	
end

SWEP.NextLeap = 0
SWEP.NextClimb = 0
function SWEP:SecondaryAttack()
	if self.Swinging then return end
	local Owner = self.Owner
	
	-- See where the player is ( on ground or flying )
	local bOnGround, bCrouching = Owner:OnGround(), Owner:Crouching()
	
	-- Trace filtering climb factors
	local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,20 ), Owner:GetAimVector()
	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 35 ), filter = Owner } )
	
	-- Climbing
	if CurTime() >= self.NextClimb and not bCrouching and trClimb.HitWorld then

		-- Climb!
		local Velocity = Vector ( 0,0,150 )
		if bOnGround then Velocity.z = 280 end
		Owner:SetLocalVelocity( Velocity )
			
		-- Cooldown
		self.NextClimb = CurTime() + self.Secondary.Delay
		
		-- Set the thirdperson animation
		local iSeq, iDuration = Owner:LookupSequence( "climbloop" )
		Owner.iZombieSecAttack = iDuration + CurTime()
			
		-- Sound
		if SERVER then Owner:EmitSound( "player/footsteps/metalgrate"..math.random(1,4)..".wav" ) end
			
		-- Climbing animation
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		Owner:SetAnimation( PLAYER_SUPERJUMP )
		
		return
	end
	
	if trClimb.HitWorld then return end
	
	-- Leap cooldown / player flying
	if CurTime() < self.NextLeap or not bOnGround or self.Leaping then return end
	
	-- Set flying velocity
	local Velocity = self.Owner:GetAngles():Forward() * 800
	if Velocity.z < 200 then Velocity.z = 200 end
	
	-- Apply velocity and set leap status to true
	Owner:SetGroundEntity( NULL )
	Owner:SetLocalVelocity( Velocity )
	
	self.Leaping = true
	
	-- Leap cooldown
	self.NextLeap = CurTime() + 1.5
	
	-- Fast zombie scream
	if SERVER then Owner:EmitSound( "npc/fast_zombie/fz_scream1.wav" ) end
end

function SWEP:Reload()
	return false
end

function SWEP:OnDrop()
	if self and self:IsValid() then
		self:Remove()
	end
end

-- Shutup.
function SWEP:Precache()
	util.PrecacheSound("npc/fast_zombie/fz_scream1.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombie/zo_attack1.wav")
	util.PrecacheSound("npc/fast_zombie/fz_alert_close1.wav")
	util.PrecacheSound("npc/zombie/zombie_die1.wav")
	util.PrecacheSound("npc/fast_zombie/fz_frenzy1.wav")
	util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	util.PrecacheSound("player/footsteps/metalgrate1.wav")
	util.PrecacheSound("player/footsteps/metalgrate2.wav")
	util.PrecacheSound("player/footsteps/metalgrate3.wav")
	util.PrecacheSound("player/footsteps/metalgrate4.wav")
end

if SERVER then return end

SWEP.PrintName = "Fast Zombie"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.DotColor = Color (240,0,0,210)
SWEP.CrossHairScale = 1
SWEP.CHalpha = 255
SWEP.CColor = Color (210,210,210,255)
function SWEP:DrawHUD()
	local MySelf = LocalPlayer()
	if not MySelf:IsValid() then return end
	if ENDROUND or IsClassesMenuOpen() then return end
	
	local scale
	local scalebywidth = (ScrW() / 1024) * 10
	local distance = 50
	local gap = 10
	if MySelf:GetVelocity():Length() > 25 then
			scale = scalebywidth * 0.075
		else
			if MySelf:Crouching() then
				scale = scalebywidth * 0.036
			else
				scale = scalebywidth * 0.05
			end
		end
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	
	-- Color change script
	local owner = self.Owner
	local mypos = owner:GetShootPos()
	local angle = owner:GetAimVector()
		
	local tracedata = { }
	tracedata.start = mypos
	tracedata.endpos =  mypos + ((angle)*32000)
	tracedata.filter = owner
		
	local tr = util.TraceLine (tracedata)
		
	if tr.Hit then
		if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() then
			local ent = tr.Entity
			if ent:Team() ~= owner:Team() and ent:Alive() then
				self.CColor = Color (245,5,5,self.CHalpha)
				self.DotColor = Color (255, 255, 255, 255)
			end
		elseif tr.Entity and tr.Entity:IsValid() and string.find (tr.Entity:GetClass(),"prop") then
			self.CColor = Color (210,210,210,255)
			self.DotColor = Color (255, 0, 0, 255)
		else
			self.CColor = Color (210,210,210,255)
			self.DotColor = Color (255, 0, 0, 255)
		end
	end
	
	distance = math.abs(self.CrossHairScale - scale)
	self.CrossHairScale = math.Approach(self.CrossHairScale, scale, FrameTime() * 2 + distance * 0.05)

	local dispscale = self.CrossHairScale
	local length = 17 * dispscale
	gap = 40 * dispscale
	
	surface.SetDrawColor (self.CColor)
	surface.DrawLine(x - gap, y - gap, x - length, y - length)
	surface.DrawLine(x - gap, y + gap, x - length, y + length)
	surface.DrawLine(x + gap, y - gap, x + length, y - length)
	surface.DrawLine(x + gap, y + gap, x + length, y + length)
	
	surface.SetDrawColor(self.DotColor)
	surface.DrawRect(x - 1, y - 1, 2, 2)
end
