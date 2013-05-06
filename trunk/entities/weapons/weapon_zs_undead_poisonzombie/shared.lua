-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end


local math = math
local team = team
local util = util
local timer = timer
local pairs = pairs
local ents = ents

SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/weapons/v_pza.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.PrintName = "Poison Zombie"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 52
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.DistanceCheck = 95

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( false )
	end
	
end

function SWEP:Initialize()
	if CLIENT then
		self.BreathSound = CreateSound(self.Weapon,Sound("npc/zombie_poison/pz_breathe_loop1.wav"));
		if self.BreathSound then
			self.BreathSound:Play()
		end
	end
end

function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	self:Swung()
end

function SWEP:CheckPuke()
	local swingend = self:GetPukeEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopPuking(0)

	self:DoPuke()
end

function SWEP:Think()

	self:CheckMeleeAttack()
	self:CheckPuke()
end

function SWEP:Swung()

	if not ValidEntity ( self.Owner ) then return end

	local pl = self.Owner
	local victim = self.PreHit
	
	if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	
	if CLIENT then return end
	-- Trace filter
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	-- Calculate damage done
	local Damage = 55
	local TraceHit, HullHit = false, false

	-- Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * Damage * 1000
	if Velocity.z < 1800 then Velocity.z = 1800 end
	
	-- Tracehull attack
	local trHull = util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 20 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector( 20,20,20 ) } )
	
	if not ValidEntity ( victim ) then	
		local tr = pl:TraceLine ( self.DistanceCheck, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = ValidEntity ( victim )
	HullHit = ValidEntity ( trHull.Entity )
	
	-- Play miss sound anyway
	pl:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, math.random( 70, 80 ) )
	
	-- Punch the prop / damage the player if the pretrace is valid
	if ValidEntity ( victim ) then
		local phys = victim:GetPhysicsObject()
		
		-- Break glass
		if victim:GetClass() == "func_breakable_surf" then
			victim:Fire( "break", "", 0 )
		end
						
		-- Take damage
		victim:TakeDamage ( Damage, self.Owner, self )
			
		-- Claw sound
		pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 90, math.random( 70, 80 ) )
				
		-- Case 2: It is a valid physics object
		if phys:IsValid() and not victim:IsNPC() and phys:IsMoveable() and not victim:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			-- Apply force to prop and make the physics attacker myself
			phys:ApplyForceCenter( Velocity )
			victim:SetPhysicsAttacker( pl )
		end
	end
	
	-- -- Verify tracehull entity
	if HullHit and not TraceHit then
		local ent = trHull.Entity
		local phys = ent:GetPhysicsObject()
		
		-- Do a trace so that the tracehull won't push or damage objects over a wall or something
		local vStart, vEnd = self.Owner:GetShootPos(), ent:LocalToWorld ( ent:OBBCenter() )
		local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
		if ent ~= ExploitTrace.Entity then 

		return end
		
		-- Break glass
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire( "break", "", 0 )
		end
		
		-- Play the hit sound
		pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 90, math.random( 70, 80 ) )
		
		-- Take damage
		ent:TakeDamage ( Damage, self.Owner, self )
	
		-- Apply force to the correct object
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			phys:ApplyForceCenter( Velocity )
			ent:SetPhysicsAttacker( pl )
		end	
	end
	
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()

	if CurTime() < self.NextSwing then return end
	
	self.Weapon:SetNextPrimaryFire ( CurTime() + 1.8) 
	self.Weapon:SetNextSecondaryFire ( CurTime() + 1.8 )
	self:StartSwinging()
	
	self.NextSwing = CurTime() + 1.8
	self.NextHit = CurTime() + 1	
end

function SWEP:StartSwinging()

	local pl = self.Owner
	self.PreHit = nil
	self.Trace = nil
	
	local trFilter = team.GetPlayers( TEAM_ZOMBIE )
	
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if SERVER then self.Owner:EmitSound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav")  end

	self:SetSwingEndTime(CurTime() + 1)

	local trace = pl:TraceLine( self.DistanceCheck, MASK_SHOT, trFilter )
	if trace.Hit and ValidEntity ( trace.Entity ) and not trace.Entity:IsPlayer() then
		self.PreHit = trace.Entity
		self.Trace = trace
	end
end

--[==[function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	-- Trace filter
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	
	if SERVER then self.Owner:EmitSound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav") end
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextSwingAnim = CurTime() + 0.6
	self.NextHit = CurTime() + 1
	local trace = self.Owner:TraceLine( 95, MASK_SHOT, trFilter )
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
end]==]




SWEP.NextYell = 0

function SWEP:DoPuke()

		local pl = self.Owner
		local wep = self.Weapon
		
		
		
		-- GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed ) 
		if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then 
			if SERVER then pl:EmitSound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav") end
			return 
		end
		
		if wep.SwapAnims then wep:SendWeaponAnim(ACT_VM_HITCENTER) else wep:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		wep.SwapAnims = not wep.SwapAnims
		
		if CLIENT then return end

		local shootpos = pl:GetShootPos()
		local startpos = pl:GetPos()
		startpos.z = shootpos.z
		local aimvec = pl:GetAimVector()
		aimvec.z = math.max(aimvec.z, -0.7)
		for i=1, 8 do
			local ent = ents.Create("projectile_poisonpuke")
			if ent:IsValid() then
				local heading = (aimvec + VectorRand() * 0.2):GetNormal()
				ent:SetPos(startpos + heading * 8)
				ent:SetOwner(pl)
				ent:Spawn()
				ent.TeamID = pl:Team()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(heading * math.Rand(300, 550))
				end
				ent:SetPhysicsAttacker(pl)
			end
		end

		pl:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 80, math.random(70, 80))

		pl:TakeDamage(math.random(10,25), pl, wep)
end

function SWEP:DoSwing()

	local pl = self.Owner
	local wep = self.Weapon	
	
	if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then pl:EmitSound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav") return end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:SetPukeEndTime(CurTime() + 1)
		
	if SERVER then pl:EmitSound("npc/zombie_poison/pz_throw"..math.random(2,3)..".wav") end

end

function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	self.NextYell = CurTime() + 4
	
	self:DoSwing()
end

function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*0.8)
		return true
	end
	if self:IsPuking() then
		mv:SetMaxSpeed(0)
		return true
	end
end

--[==[function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	self.NextYell = CurTime() + 4
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if CLIENT then return end
	-- self.Owner:RestartGesture(ACT_RANGE_ATTACK2)
	if self.Owner:GetAngles().pitch > 55 or self.Owner:GetAngles().pitch < -55 then self.Owner:EmitSound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav") return end
	
	self.Owner:EmitSound("npc/zombie_poison/pz_throw"..math.random(2,3)..".wav")
	GAMEMODE:SetPlayerSpeed(self.Owner, 1)
	self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) ) 
	--timer.Simple(1, ThrowHeadcrab, self.Owner, self)
	timer.Simple(0.6, function() DoSwing(self.Owner, self) end)
	timer.Simple(1, function() DoPuke(self.Owner, self) end)
end]==]

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end

function SWEP:SetSwingEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetSwingEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEndTime() > 0
end

function SWEP:StopPuking()
	self:SetPukeEndTime(0)
end

function SWEP:SetPukeEndTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetPukeEndTime()
	return self:GetDTFloat(1)
end

function SWEP:IsPuking()
	return self:GetPukeEndTime() > 0
end

--[=[function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	local mOwner = self.Owner
	
	-- Thirdperson animation
	--mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
		
	-- Emit both claw attack sound and weird funny sound
	if SERVER then self.Owner:EmitSound( table.Random ( ZombieClasses[3].IdleSounds ) ) end

	self.NextYell = CurTime() + math.random(3,4)
end]=]

function SWEP:DamageEntity ( ent, Damage, IsPush )
	if not ValidEntity ( ent ) or CLIENT then return end
	local Owner = self.Owner
	
	-- Don't hurt other zombies
	if ent.Team and ent:Team() == TEAM_UNDEAD then return end
	
	-- Get phys object
	local phys = ent:GetPhysicsObject()
	
	-- Break glass
	if ent:GetClass() == "func_breakable_surf" then
		ent:Fire( "break", "", 0 )
	end
	
	-- Take damage
	ent:TakeDamage ( Damage, Owner, self )
	
	-- Push for whatever it hits
	local Velocity = Owner:EyeAngles():Forward() * 28000 * 20
	
	-- Apply force to the correct object
	if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and ent:IsPlayer() then
		Velocity.z = 3000
		phys:ApplyForceCenter( Velocity )
		ent:SetPhysicsAttacker( Owner )
	end	
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

function SWEP:Precache()
	util.PrecacheSound("npc/zombie_poison/pz_throw2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_throw3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn1.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle4.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_breathe_loop1.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[3].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end
