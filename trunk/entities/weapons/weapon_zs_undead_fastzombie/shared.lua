-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end


local math = math
local team = team
local util = util
local timer = timer
local ents = ents
local pairs = pairs
local ipairs = ipairs

SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Fast Zombie"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

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

SWEP.DistanceCheck = 48
SWEP.NextRoar = 0
function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( false )
	end
end

function SWEP:Initialize()
	if CLIENT then
		self.BreathSound = CreateSound(self.Weapon,Sound("npc/fast_zombie/breathe_loop1.wav"))
				
		if self.BreathSound then
			self.BreathSound:Play()
		end
	end
end

function SWEP:Think()
	local Owner = self.Owner
	if not ValidEntity ( Owner ) then return end
	
	local ct = CurTime()
	
	-- Leaping
	if self.Leaping then
		local trFilter = team.GetPlayers( TEAM_UNDEAD )
		local nTrace = Owner:TraceLine ( 45, MASK_SHOT, trFilter )
		-- local Sphere = ents.FindInSphere ( Owner:GetShootPos() + Owner:GetAimVector() * 15, 20 )
		
		local pos = Owner:GetShootPos() + Owner:GetAimVector() * 15
		
		-- Easier way to bump players
		local Victim = NULL		
		for k,v in ipairs ( team.GetPlayers(TEAM_HUMAN) ) do
			if IsValid(v) and v:GetPos():Distance(pos) <= 20 and v:IsPlayer() and v ~= Owner then
				local vStart, vEnd = Owner:GetShootPos(), v:LocalToWorld ( v:OBBCenter() )
				local glitchTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
				
				-- Trace matches with entity found in sphere
				if glitchTrace.Entity == v then
					Victim = v
					break
				end
			end
		end

		--We hit something while leaping
		if nTrace.Hit or ValidEntity ( Victim ) then
			if Owner.ViewPunch then Owner:ViewPunch( Angle( math.random(0, 70), math.random(0, 70), math.random(0, 70) ) ) end
			if SERVER then Owner:EmitSound( "physics/flesh/flesh_strider_impact_bullet1.wav" ) end
			
			--Bump the victim!
			if ValidEntity ( Victim ) then self:DamageEntity ( Victim, math.random(0,1) ) end
			
			--Stopped leaping
			self.Leaping = false
			
			--Stop, so we don't bounce around
			Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
			
			--Leap Cooldown
			self.NextLeap = ct + 3
			
			return
		end
		
		-- always update leap status
		if Owner:OnGround() or Owner:WaterLevel() > 0 then
			self.Leaping = false
		end
	end

	if Owner:KeyDown( IN_ATTACK ) and not self.Leaping then
		if self:GetRoar() >= 8 and not self:IsRoar() then
			self:SetRoar(0)
			self.NextAttack = ct + 2
			--self.Owner.IsRoar = true
			self.Owner:DoAnimationEvent( CUSTOM_SECONDARY )
			self:SetRoarEndTime(ct + 2)
			
			if SERVER then
				GAMEMODE:SetPlayerSpeed( self.Owner, 1 )
				self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
				self.Owner:SetJumpPower( 0 ) 
				self.Owner:EmitSound("NPC_FastZombie.Frenzy") 
			end 
	
				--[==[timer.Simple ( 2, function( pl )
				if not ValidEntity ( pl ) then return end
					if not pl:Alive() or not pl:IsFastZombie() then return end
						GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
						pl:SetJumpPower( ZombieClasses[ pl:GetZombieClass() ].JumpPower ) 
					end, self.Owner )
					
					if SERVER then self.Owner:EmitSound("NPC_FastZombie.Frenzy") end]==]
					
		end
	end	
	
	self:CheckRoar()
	
	-- Attacking
	if not Owner:KeyDown( IN_ATTACK ) then
		self.Swinging = false
		--self.NextRoar = 0
		-- return
	end
	
	self:NextThink(ct)
	return true

end

function SWEP:CheckRoar()
	local rend = self:GetRoarEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetRoarEndTime(0)
	
	if SERVER then
		local pl = self.Owner
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
		pl:SetJumpPower( ZombieClasses[ pl:GetZombieClass() ].JumpPower ) 
	end
	
end

function SWEP:Move(mv)
	if self and self.Owner and self.Owner:KeyDown(IN_ATTACK) then
		mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*0.35)
		return true
	end
end

function SWEP:SetRoarEndTime(time)
	self:SetDTFloat(0,time)
end

function SWEP:GetRoarEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsRoar()
	return self:GetRoarEndTime() > 0
end

function SWEP:SetRoar(count)
	self:SetDTInt(0,count)
end

function SWEP:AddRoar(am)
	self:SetRoar(self:GetRoar()+am)
end

function SWEP:GetRoar()
	return self:GetDTInt(0)
end



SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	local ct = CurTime()

	if self.NextAttack > ct then
		return
	end
	if self.Leaping then
		return
	end
	if self.Owner.IsRoar then
		return
	end
	self.Owner:DoAnimationEvent ( CUSTOM_PRIMARY )
	local Owner = self.Owner
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	self:AddRoar(1)
	-- Cooldown
	self.NextAttack = ct + self.Primary.Delay
	
	-- Calculate damage done
	local Damage = math.Rand(6,8)
	
	-- Trace an object
	local nTrace = Owner:TraceLine ( 75, MASK_SHOT, trFilter )
	local Victim = nTrace.Entity
	
	-- Play miss sound anyway
	if SERVER then Owner:EmitSound( "npc/zombie/claw_miss"..math.random(1, 2)..".wav" ) end
	
	-- Animation
	Owner:SetAnimation( PLAYER_ATTACK1 )
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	else
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	end
	self.SwapAnims = not self.SwapAnims
	
	-- First trace
	if CLIENT then
		return
	end

	if ValidEntity ( Victim ) then
		self:DamageEntity ( Victim, Damage )
		return
	end
	
	-- Tracehull attack (second trace if the first one doesn't hit)
	local TraceHull = util.TraceHull( { start = Owner:GetShootPos(), endpos = Owner:GetShootPos() + ( Owner:GetAimVector() * 20 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector ( 20,20,20 ) } )
	local TraceHit = ValidEntity ( TraceHull.Entity )	

	-- Hit nothing
	if not TraceHit then return end
	
	-- Do a trace so that the tracehull won't push or damage objects over a wall or something
	local vStart, vEnd = Owner:GetShootPos(), TraceHull.Entity:LocalToWorld ( TraceHull.Entity:OBBCenter() )
	local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
	-- Hitting through wall
	if TraceHull.Entity ~= ExploitTrace.Entity then return end
	
	-- Damage entity with tracehull
	self:DamageEntity ( TraceHull.Entity, Damage ) 
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
		if ent:OnGround() then ent:SetVelocity( Velocity * 0.5 ) else ent:SetVelocity ( Velocity * 0.1 ) end
		if ent.ViewPunch then ent:ViewPunch( Angle( math.random(-20, 20), math.random(-20, 20), math.random(-20, 20) ) ) end
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
	if self:IsRoar() then return end
	local Owner = self.Owner
	
	-- See where the player is ( on ground or flying )
	local bOnGround, bCrouching = Owner:OnGround(), Owner:Crouching()
	
	-- Trace filtering climb factors
	local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,20 ), Owner:GetAimVector()
	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 35 ), filter = Owner } )
	
	-- Climbing
	if CurTime() >= self.NextClimb and not bCrouching and trClimb.HitWorld and not trClimb.HitSky then

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

function SWEP:OnRemove()
	if CLIENT then
		if self.BreathSound then
			self.BreathSound:Stop()
		end
	end
return true
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
	util.PrecacheSound("npc/fast_zombie/gurgle_loop1.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[2].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[2].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end