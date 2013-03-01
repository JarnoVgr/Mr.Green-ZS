-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end


local math = math
local team = team
local util = util
local timer = timer

SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/weapons/v_zombine.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrintName = "Zombine"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.7

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DistanceCheck = 85

function SWEP:Deploy()
	
	//Hide world model
	if SERVER then
		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( false )
	end
	
	//Animation vars
	local mOwner = self.Owner
	mOwner.HoldingGrenade, mOwner.IsAttacking, mOwner.IsGettingNade = false, false, false
	
	//Idle sounds
	if SERVER then timer.Simple( 1.5,function() if IsValid(self) then self:IdleVOX() end end ) end
	
	//Initialize sprint 
	mOwner.bCanSprint, mOwner.Sprint = false, 100
	
	//Set speed
	GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[8].Speed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
	
	//Idle animation
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end

//Sets speed
//sound\npc\zombine\zombine_charge1.wav
//Sprint limiter
function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	self:DoPrimaryAttack()
end


function SWEP:Think()
	if not IsValid( self.Owner ) then return end
	local mOwner = self.Owner
	
	self:CheckMeleeAttack()
	self:CheckGrenade()
	self:CheckAttackAnim()
	
	--if SERVER then
	--PrintMessageAll(HUD_PRINTCENTER,"Rage: "..tostring(mOwner.bCanSprint)..", Holding nade: "..tostring(mOwner.HoldingGrenade)..", Getting nade: "..tostring(mOwner.IsGettingNade))
	--end
	
		//Infinite sprint while holding nade
	--if mOwner.HoldingGrenade or CLIENT then mOwner.bCanSprint = true return end
	
	//Think cooldown
	if ( self.ThinkTimer or 0 ) > CurTime() then return end
	
	local Speed = ZombieClasses[8].Speed
	--if mOwner:KeyDown( IN_SPEED ) then
			if mOwner.bCanSprint then
				if mOwner:GetMaxSpeed() < ZombieClasses[8].RunSpeed then
					if not self:IsAttackingAnim() and not self:IsGettingNade() then
						GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
						--GAMEMODE:SetPlayerSpeed( mOwner, Speed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
					end
				end
			else
				if mOwner:GetMaxSpeed() > Speed then
					if not self:IsAttackingAnim() and not self:IsGettingNade() then
						GAMEMODE:SetPlayerSpeed( mOwner, Speed, Speed )
					end
				end	
				
			end
	--end
	self.ThinkTimer = CurTime() + 0.25
	--[[
	//Infinite sprint while holding nade
	if mOwner.HoldingGrenade or CLIENT then mOwner.bCanSprint = true return end
	
	//Think cooldown
	if ( self.ThinkTimer or 0 ) > CurTime() then return end
	
	//Normal speed
	local Speed = ZombieClasses[8].Speed
	
	//Check for speed button
	if mOwner:KeyDown( IN_SPEED ) then
		mOwner.Sprint = math.Clamp( mOwner.Sprint - 4.5, 0, 100 )
		if mOwner.Sprint <= 0 then
			if mOwner:GetMaxSpeed() > Speed then
				if not mOwner.IsAttacking and not mOwner.IsGettingNade then
					GAMEMODE:SetPlayerSpeed( mOwner, Speed )
				end
			end
		else
			if mOwner.bCanSprint then
				if mOwner:GetMaxSpeed() < ZombieClasses[8].RunSpeed then
					if not mOwner.IsAttacking and not mOwner.IsGettingNade then
						GAMEMODE:SetPlayerSpeed( mOwner, Speed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
					end
				end
			end
		end
	else
		mOwner.Sprint = math.Clamp( mOwner.Sprint + 5, 0, 100 )
	end
	
	//Set status
	mOwner.bCanSprint = ( mOwner.Sprint > 10 )
	
	//Think timer
	self.ThinkTimer = CurTime() + 0.25
	]]
end

SWEP.IdleTimer = 0
function SWEP:IdleVOX()
	if not IsValid ( self.Owner ) then return end
	
	//Stop on endround
	if ENDROUND then return end
	
	//Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	if mOwner.HoldingGrenade then return end
	
	//Not alive
	if not mOwner:Alive() then return end
	
	//Emit idle sounds
	local mSound = table.Random ( ZombieClasses[8].IdleSounds )

	//Sound duration
	local fDuration = math.Rand( 1.6, 2.2 ) + 1.7
	if fDuration == 0 then fDuration = 1.5 end
	
	if not mOwner.IsAttacking and not mOwner.IsGettingNade then mOwner:EmitSound ( mSound ) else fDuration = 0.7 end

	//Cooldown
	timer.Simple( fDuration, function() if IsValid(self) and self.IdleVOX then self:IdleVOX() end end )
end

function SWEP:CheckAttackAnim()
	local swingend = self:GetAttackAnimEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopAttackAnim()

	local pl = self.Owner
	
	if !IsValid(pl) then return end
	
	if pl.bCanSprint then
		GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
	else
		GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[8].Speed, ZombieClasses[8].Speed, ZombieClasses[8].Speed ) 
	end
end

SWEP.NextSwing = 0
SWEP.ZombineAttacks = { "attackD", "attackE", "attackF", "attackB" }
function SWEP:PrimaryAttack()

	//Cannot attack in mid-air
	if not self.Owner:OnGround() then return end
	
	//Delay secondary attack
	self.Weapon:SetNextSecondaryFire ( CurTime() + 1.65 )

	//Make things easier
	local pl = self.Owner
	self.PreHit = nil
	self.Trace = nil
	//Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	//Sequence to play
	local iSequence = table.Random ( self.ZombineAttacks ) 
	
	//Set the thirdperson animation and emit zombie attack sound
	if SERVER then 
		self.Owner:EmitSound( Sound ( "npc/zombine/zombine_alert"..math.random ( 1,3 )..".wav" ) ) 
		
		//Stop when we get grenade

		GAMEMODE:SetPlayerSpeed ( mOwner, 0,0)
		mOwner:SetLocalVelocity ( Vector ( 0,0,0 ) )
	end
	
	//Attack animation
	//self.Owner.AttackSequence = iSequence
	
	self:SetAttackSeq(iSequence)
	
	self:SetAttackAnimEndTime(CurTime() + 1.2)
	/*timer.Simple ( 1.2, function() 
		if not IsEntityValid ( self ) then return end 
		self.Owner.IsAttacking = nil 
			if self.Owner.bCanSprint then
				GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
			else
				GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[8].Speed, ZombieClasses[8].Speed, ZombieClasses[8].Speed ) 
			end
	end)*/
	
	//Hacky way for the animations
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	mOwner:DoAnimationEvent ( CUSTOM_PRIMARY )
	
	//Trace filter
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	
	//Trace an object
	//if SERVER then
		local trace = pl:TraceLine( 85, MASK_SHOT, trFilter )
		if trace.Hit and ValidEntity ( trace.Entity ) and not trace.Entity:IsPlayer() then
			self.PreHit = trace.Entity
			self.Trace = trace
		end
		
		self:SetSwingEndTime(CurTime() + 0.5)
	//end
		
	//Delayed attack function (claw mechanism)
	//if SERVER then timer.Simple ( 0.5, function() if IsValid(self) and self.DoPrimaryAttack then self:DoPrimaryAttack(trace, pl, self.PreHit) end end ) end
				
	// Set the next swing attack for cooldown
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	//Idle animation
	timer.Simple( 1.5, function() if not IsValid ( self ) then return end self.Weapon:SendWeaponAnim( ACT_VM_IDLE ) end)
	
	self.NextHit = CurTime() + 0.5
end

function SWEP:DoPrimaryAttack ()
	local pl = self.Owner
	if not ValidEntity ( pl ) or CLIENT then return end
	
	local victim = self.PreHit
	
	//Calculate damage done
	local Damage = math.Clamp ( 22 + math.random( 2, 5 ), 17, 30 )
	local TraceHit, HullHit = false, false

	//Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * math.Clamp ( Damage * 1000, 25000, 37000 )
	if self.Owner.Suicided == true then
		Velocity = Velocity * 0.4
	end
	
	//Tracehull attack
	local trHull = util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 18 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector ( 20,20,20 ) } )
	
	//Trace filter
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	
	if not ValidEntity ( victim ) then	
		local tr = pl:TraceLine ( 85, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = ValidEntity ( victim )
	HullHit = ValidEntity ( trHull.Entity )
	
	//Play miss sound anyway
	pl:EmitSound( "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav" )
	
	//Punch the prop / damage the player if the pretrace is valid
	if ValidEntity ( victim ) then
		local phys = victim:GetPhysicsObject()
		
		//Break glass
		if victim:GetClass() == "func_breakable_surf" then
			victim:Fire( "break", "", 0 )
		end
						
		//Take damage
		victim:TakeDamage ( Damage, self.Owner, self )
			
		//Claw sound
		pl:EmitSound( Sound ( "npc/zombie/claw_strike"..math.random( 1, 3 )..".wav" ) )
				
		//Case 2: It is a valid physics object
		if phys:IsValid() and not victim:IsNPC() and phys:IsMoveable() and not victim:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			//Apply force to prop and make the physics attacker myself
			phys:ApplyForceCenter( Velocity )
			victim:SetPhysicsAttacker( pl )
		end
	end
	
	//Verify tracehull entity
	if HullHit and not TraceHit then
		local ent = trHull.Entity
		local phys = ent:GetPhysicsObject()
		
		//Do a trace so that the tracehull won't push or damage objects over a wall or something
		local vStart, vEnd = self.Owner:GetShootPos(), ent:LocalToWorld ( ent:OBBCenter() )
		local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
		if ent != ExploitTrace.Entity then return end
		
		//Break glass
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire( "break", "", 0 )
		end
		
		//Play the hit sound
		pl:EmitSound( Sound ( "npc/zombie/claw_strike"..math.random( 1, 3 )..".wav" ) )
		
		//Take damage
		ent:TakeDamage ( Damage, self.Owner, self )
	
		//Apply force to the correct object
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			phys:ApplyForceCenter( Velocity )
			ent:SetPhysicsAttacker( pl )
		end	
	end
end

function SWEP:StopAttackAnim()
	self:SetAttackAnimEndTime(0)
end

function SWEP:SetAttackAnimEndTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetAttackAnimEndTime()
	return self:GetDTFloat(2)
end

function SWEP:IsAttackingAnim()
	return self:GetAttackAnimEndTime() > 0
end

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end

function SWEP:SetSwingEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:SetAttackSeq(str)
	self:SetDTString(0,str)
end

function SWEP:GetAttackSeq()
	return self:GetDTString(0)
end

function SWEP:GetSwingEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsAttacking()
	return self:GetSwingEndTime() > 0
end

function SWEP:IsGettingNade()
	return self:GetGettingNadeEndTime() > 0
end

function SWEP:SetGettingNadeEndTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetGettingNadeEndTime()
	return self:GetDTFloat(1)
end

function SWEP:StopGettingNade()
	self:SetGettingNadeEndTime(0)
end

function SWEP:HoldGrenade(bl)
	self:SetDTBool(0,bl)
end

function SWEP:IsHoldingGrenade()
	return self:GetDTBool(0)
end

function SWEP:CheckGrenade()
	local swingend = self:GetGettingNadeEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopGettingNade()

	local pl = self.Owner
	
	if !IsValid(pl) then return end
	
	self:HoldGrenade(true)
		
	if pl.bCanSprint then
		GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
	else
		GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[8].Speed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed ) 
	end
end

SWEP.GrenadeUsed = false
function SWEP:SecondaryAttack()
	--if !self.Owner.bCanSprint then return end
	//Disable primary attack
	self.Weapon:SetNextPrimaryFire ( CurTime() + ROUNDTIME ) 
	
	//Cooldown
	if self.GrenadeUsed or not self.Owner:OnGround() then return end
	
	//Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	//Stop when we get grenade
	if SERVER then		
		GAMEMODE:SetPlayerSpeed ( mOwner, 0 )
		mOwner:SetLocalVelocity ( Vector ( 0,0,0 ) )

	end

	//Emit both claw attack sound and weird funny sound
	if SERVER then mOwner:EmitSound( Sound ( "npc/zombine/zombine_readygrenade"..math.random ( 1,2 )..".wav" ) ) end
	
	//Alert VOX
	if SERVER then timer.Simple ( 1,function() if IsValid(self) and self.AlertVOX then self:AlertVOX() end end) end
	
	//Used grenade
	self.GrenadeUsed = true
	
	//Create grenade
	if SERVER then
		local mGrenade = ents.Create ( "zombine_grenade" )
		mGrenade:SetOwner ( mOwner )
		mGrenade:Spawn()
		mGrenade:Activate()
		
		//Parent the shit
		mGrenade:SetParent ( mOwner )
	end
	
	//Animation status
	//mOwner.IsGettingNade = true
	mOwner:DoAnimationEvent ( CUSTOM_SECONDARY )
	
	//Set the first person animaiton and restart the third one
	mWeapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	
	local pl = self.Owner
	
	self:SetGettingNadeEndTime(CurTime() + 1)
	
	//Disable getting nade animation
	/*timer.Simple ( 1, function() 
		if not ValidEntity ( pl ) then return end -- anti error clusterfuck :/
		if not pl:Alive() or not pl:IsZombine() then return end
		pl.IsGettingNade = false 
		pl.HoldingGrenade = true 
		
		if pl.bCanSprint then
			GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed )
		else
			GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[8].Speed, ZombieClasses[8].RunSpeed, ZombieClasses[8].RunSpeed ) 
		end
	
	end)*/
	
	//Cooldown
	timer.Simple ( 0.5, function()
		if not IsEntityValid ( mWeapon ) or not IsEntityValid ( mOwner ) then return end
		
		//Player changed team/class
		if not mOwner:IsZombie() or not mOwner:Alive() or not mOwner:IsZombine() then return end
		
		//Second part animation
		mWeapon:SendWeaponAnim ( ACT_VM_THROW )
	end)
end

function SWEP:AlertVOX()
	if not IsEntityValid ( self.Owner ) then return end
	
	//Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	//Not alive
	if not mOwner:Alive() then return end
	
	//Emit idle sounds
	local mSound = table.Random ( ZombieClasses[8].AlertSounds )

	//Sound duration
	local fDuration = math.Rand( 1.6, 2.2 ) + 0.7
	if fDuration == 0 then fDuration = 1.5 end
	
	//Emit sound
	mOwner:EmitSound ( mSound )

	//Cooldown
	timer.Simple( fDuration,function() if IsValid(self) then self:AlertVOX() end end )
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombine/zombine_readygrenade1.wav")
	util.PrecacheSound("npc/zombine/zombine_readygrenade2.wav")
	util.PrecacheSound("npc/zombine/zombine_charge1.wav")
	util.PrecacheSound("npc/zombine/zombine_charge2.wav")
	
	util.PrecacheModel(self.ViewModel)
	
	//Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[8].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[8].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[8].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[8].AlertSounds) do
		util.PrecacheSound(snd)
	end
	
end

local function OnZombineDeath( pl, attacker )
	if not pl:IsPlayer() then return end
	if not pl:IsZombine() and not pl:IsZombie() then return end
	
	//Disable grenade hold animation
	pl.HoldingGrenade = false
end
hook.Add ( "DoPlayerDeath", "ZombineDeath", OnZombineDeath )

function SWEP:Reload()
	return false
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end
