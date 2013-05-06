-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end


local math = math
local team = team
local util = util
local timer = timer
local pairs = pairs
local ents = ents

if SERVER then
	local umsg = umsg
end


SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Howler"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.ViewModel = Model ( "models/weapons/v_pza.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.ProtectionDistance = 220
SWEP.PropTKDistance = 450
SWEP.DistanceCheck = 450

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
	end
end

function SWEP:Precache()
	
	util.PrecacheSound("ambient/energy/zap6.wav")
	util.PrecacheSound("npc/barnacle/barnacle_bark1.wav")
	
	util.PrecacheModel(self.ViewModel)
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[5].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].AttackSounds) do
		util.PrecacheSound(snd)
	end
	
	
end

SWEP.NextSwing = 0
function SWEP:DoAttack( bPull ) 
	if CurTime() < self.NextSwing then return end
	
	-- Get owner
	local mOwner = self.Owner
	if not ValidEntity ( mOwner ) then return end
	
	-- Cannot scream while in air
	if not mOwner:OnGround() then return end
	
	-- Cooldown
	self.NextSwing = CurTime() + self.Primary.Delay
	
	-- Stop
	if SERVER then
		-- GAMEMODE:SetPlayerSpeed( self.Owner, 1 )
		-- self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
	end
	
	-- Thirdperson animation and sound
	mOwner:DoAnimationEvent( CUSTOM_PRIMARY )
	
	self:SetScreamEndTime(CurTime() + 1.3)
	-- Restore speed
	--[==[timer.Simple ( 1.3, function( mOwner )
		if not ValidEntity ( mOwner ) then return end
		
		-- Conditions
		if not mOwner:Alive() or not mOwner:IsHowler() then return end
		GAMEMODE:SetPlayerSpeed ( mOwner, ZombieClasses[ mOwner:GetZombieClass() ].Speed )
	end, mOwner )]==]
	
	-- Sound
	if SERVER then
		mOwner:EmitSound( table.Random ( ZombieClasses[ mOwner:GetZombieClass() ].AttackSounds ), 100, math.random ( 95,135 ) )
	end
	
	-- Just server
	if CLIENT then return end
	
	-- Get nearby howlers
	local iHowlers = #GetHowlers( mOwner:GetPos(), 450 ) or 1
	if iHowlers == 0 then iHowlers = 1 end
	
	-- Find in sphere
	local iDistance, iRandom = 450, math.Rand( 1, 2.5 )
	-- for k,v in pairs ( ents.FindInSphere ( self.Owner:GetPos(), iDistance ) ) do
	for k,v in ipairs ( team.GetPlayers(TEAM_HUMAN) ) do
	
		-- Players
		if v:IsPlayer() and v:IsHuman() and v:Alive() and v:GetPos():Distance(self.Owner:GetPos()) <= iDistance then
			local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * iDistance )
			local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
			-- Exploit trace
			if Trace.Hit then
				if ValidEntity ( Trace.Entity ) then
					if Trace.Entity == v then
						local fDistance = v:GetPos():Distance( self.Owner:GetPos() )
						local iFuckIntensity = math.Clamp ( 4.5 - ( ( fDistance / iDistance ) * 10 ), 1, 2 )
						-- if v:GetHumanClass() == 3 then iFuckIntensity = iFuckIntensity * math.Rand(1.8,2.3) end
						-- Event
						GAMEMODE:OnPlayerHowlered ( v, iFuckIntensity )
											
						-- Inflict damage
						local fDamage = math.Round ( math.Clamp ( ( 22 - ( fDistance / 10 ) ) / iHowlers, 0, 5 ) * 4 )
						-- if v:GetHumanClass() == 3 then fDamage = fDamage * math.Rand(1.8,2.3) end
						if fDamage > 0 then v:TakeDamage ( fDamage, self.Owner, self ) end
					end
				end
			end
		end
		
		-- Shield zombies in range
		if iRandom <= 1.5 then
			if v:IsPlayer() and v:IsZombie() and v:Alive() then
				if not v:HasHowlerProtection() and self.Owner:GetPos():Distance( v:GetPos() ) <= self.ProtectionDistance then
					local iDuration = 1.3 + 2.5 
					v.HowlerProtection = iDuration + CurTime()
					
					-- Send usermessage
					net.Start( "howlerDoProtection" ) net.Send(v)
				end
			end
		end
	end
	
	-- On trigger play sound
	if iRandom <= 1.5 then
		self.Owner:EmitSound( "ambient/energy/zap6.wav" )
	end
	
	-- Scream effect for myself
	self.Owner:SendLua( "WraithScream()" )
	
	-- Pull or push targeted object
	local Filter = { mOwner }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	-- Trace to object, see if you see it
	local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.PropTKDistance )
	local Trace = util.TraceLine ( { start = vPos, endpos = vEnd, filter = Filter, mask = MASK_SOLID } )
	
	-- Check object
	if IsValid( Trace.Entity ) then
		local mTK = Trace.Entity
		
		-- Calculate velocity
		local Velocity = -1 * mOwner:GetForward() * 225
		if not bPull then Velocity = -1 * Velocity * 2 end
		
		-- Apply velocity
		if mTK:IsPlayer() and mTK:IsHuman() then
			if ( mTK.HowlerKickTimer or 0 ) <= CurTime() then
				Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random( 250, 270 )
				if not bPull then Velocity = Vector( Velocity.x * 0.4, Velocity.y * 0.4, Velocity.z ) end
			
				-- Player cooldown and apply velocity
				mTK.HowlerKickTimer = CurTime() + 3.2
				mTK:SetVelocity( Velocity )
				
				-- Play sound
				timer.Simple( 0.2, function()
					if IsValid( mTK ) then
						WorldSound( "npc/barnacle/barnacle_bark1.wav", mTK:GetPos() + Vector( 0,0,20 ), 120, math.random( 60, 75 ) )
					end
				end )
			end
		else
			if IsValid( mTK:GetPhysicsObject() ) then
			
				-- Calculate needed velocity
				local fMass = mTK:GetPhysicsObject():GetMass()
				Velocity = -1 * ( mOwner:GetForward() * 225 ) / ( fMass * 0.02 )
				if not bPull then Velocity = -1 * Velocity * 1.3 end
				
				-- Play sound
				-- timer.Simple( 0.2, function()
					if IsValid( mTK ) then
						WorldSound( "npc/barnacle/barnacle_bark1.wav", mTK:GetPos() + Vector( 0,0,20 ), 120, math.random( 60, 75 ) )
					end
				-- end)
				
				-- Apply velocity
				mTK:SetPhysicsAttacker( mOwner )
				mTK:GetPhysicsObject():SetVelocity( Velocity )
			end
		end
	end
end

function SWEP:Think()
	self:CheckScream()
end

function SWEP:CheckScream()
	local rend = self:GetScreamEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetScreamEndTime(0)
	
	if SERVER then
		local pl = self.Owner
		-- GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
	end
	
end

function SWEP:SetScreamEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetScreamEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsScreaming()
	return self:GetScreamEndTime() > 0
end

function SWEP:PrimaryAttack()
	self:DoAttack( true )
end

function SWEP:SecondaryAttack()
	self:DoAttack( false )
end

function SWEP:Move(mv)
	if self:IsScreaming() then
		mv:SetMaxSpeed(0)
		return true
	end
end

if SERVER then
	util.AddNetworkString( "howlerDoProtection" )
elseif CLIENT then
	net.Receive( "howlerDoProtection", function( len )
		for k,v in pairs ( ents.FindInSphere ( MySelf:GetPos(), 220 ) ) do
			if v:IsPlayer() and v:IsZombie() and v:Alive() and not (v:IsZombine() and v.bCanSprint) then
				if not v:HasHowlerProtection() then
					local iDuration = 1.3 + 2.5 
					v.HowlerProtection = iDuration + CurTime()
				end
			end
		end	
			
		-- Predict for self
		if not MySelf:HasHowlerProtection() then
			local iDuration = 1.3 + 2.5
			MySelf.HowlerProtection = iDuration + CurTime()
		end	
		
		-- Wraith scream
		WraithScream()
	end)
end

-- Prediction trick
local function howlerDoProtection()
	for k,v in pairs ( ents.FindInSphere ( MySelf:GetPos(), 220 ) ) do
		if v:IsPlayer() and v:IsZombie() and v:Alive() and not (v:IsZombine() and v.bCanSprint) then
			if not v:HasHowlerProtection() then
				local iDuration = 1.3 + 2.5 
				v.HowlerProtection = iDuration + CurTime()
			end
		end
	end	
		
	-- Predict for self
	if not MySelf:HasHowlerProtection() then
		local iDuration = 1.3 + 2.5
		MySelf.HowlerProtection = iDuration + CurTime()
	end	
	
	-- Wraith scream
	WraithScream()
end
if CLIENT then usermessage.Hook( "howlerDoProtection", howlerDoProtection ) end

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

 