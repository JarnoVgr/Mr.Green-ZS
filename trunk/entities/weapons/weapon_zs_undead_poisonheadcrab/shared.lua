-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Poison Headcrab"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.ViewModel = Model ( "models/weapons/v_knife_t.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.DistanceCheck = 700
SWEP.AimFailSounds = { Sound( "npc/headcrab_poison/ph_talk1.wav" ), Sound( "npc/headcrab_poison/ph_talk2.wav" ), Sound( "npc/headcrab_poison/ph_talk3.wav" ) }

-- On deploy
function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
	end
end

-- Main think function

function SWEP:Think()
	if IsValid( self.Owner ) and ( self.Owner:KeyPressed( IN_JUMP ) ) then
		self:Jump()
	end	
	
	self:CheckJump()
	self:CheckSpitting()
	
	if SERVER then
		local mOwner = self.Owner

		if IsValid(self.Owner) and self.Owner:Alive() then
			if self.Leaping then
				if mOwner:OnGround() or 0 < mOwner:WaterLevel() then
					self.Leaping = false
				else
					local vStart = Vector(0,0,14) + mOwner:GetPos()
					local ang = mOwner:GetAimVector() 
					ang.z = 0
					local tr = {}
					tr.start = vStart
					tr.endpos = vStart + ang * 45
					tr.filter = mOwner
					local trace = util.TraceLine(tr)
					local ent = trace.Entity
					
					local pos = vStart + mOwner:GetAimVector() * 16
					
					for _, fin in pairs(team.GetPlayers(TEAM_HUMAN)) do
						if fin:IsPlayer() and fin:Alive() and TrueVisible(vStart, fin:NearestPoint(vStart)) and fin:GetPos():Distance(pos) <= 16 then
							ent = fin
							break
						end
					end
						
					if ent and IsValid(ent) then
						local phys = ent:GetPhysicsObject()

						if phys:IsValid() and not ent:IsNPC() and not ent:IsPlayer() and phys:IsMoveable() then
							local vel = 120 * mOwner:EyeAngles():Forward()

							phys:ApplyForceOffset(vel, (ent:NearestPoint(vStart) + ent:GetPos() * 2) / 3)
							ent:SetPhysicsAttacker(mOwner)
						end

						mOwner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30)))

						if ent:IsPlayer() and ent:Team() ~= mOwner:Team() then
							ent:TakeDamage(5, mOwner)
							ent:TakeDamageOverTime( math.Rand(2.1,3.1), 1.5, math.random(13,20), mOwner, self.Weapon )
							
							local Infect = EffectData()
							Infect:SetEntity( ent )
							util.Effect( "infected_human", Infect, true, true )
						else
							ent:TakeDamage(25, mOwner)
						end
						self.Leaping = false
					end
				end
			end
		end
	end
	
	--self:NextThink(CurTime()+0.5)
	--return true
end

function SWEP:CalculateSpitDelay()
local iCrabs = 0
		for k,v in pairs ( team.GetPlayers(TEAM_UNDEAD) ) do-- ents.FindInSphere( self.Owner:GetPos(), 200 )
			if IsValid(v) and v:IsPlayer() and v:Alive() and v:IsPoisonCrab() and self.Owner ~= v and v:GetPos():Distance(self.Owner:GetPos()) <= 200 then
				iCrabs = iCrabs + 1
			end
		end
return iCrabs
end


-- Random chance to deploy bomb on death
hook.Add( "OnZombieDeath", "DeployPoisonCrabBomb", function( mVictim, mAttacker, mInflictor, dmginfo )
	if IsValid( mVictim ) and mVictim:IsPoisonCrab() then
		if IsValid( mAttacker ) and not dmginfo:IsSuicide( mVictim ) then
			if math.random( 1, 2 ) == 1 then 
				local Bomb = ents.Create( "projectile_spit_bomb" )
				if not IsValid( Bomb ) then return end
				
				-- Blast off!
				Bomb:SetOwner( mVictim )
				Bomb:SetPos( mVictim:GetPos() + Vector( 0,0,3 ) )
				Bomb:SetFuse( math.Rand( 5, 6 ) )
				Bomb:Spawn()
			end
		end
	end
end ) 

-- Check to see if you can shoot
function SWEP:CanSpit()
	if not IsValid( self.Owner ) then return false end
	local mOwner = self.Owner
	
	-- Trace down
	local checkTrace = util.TraceLine( { start = self:GetPos() + Vector( 0,0,15 ), endpos = self:GetPos() + Vector( 0,0,15 ) + mOwner:GetAimVector() * 1000, filter = mOwner } )
	local fDistance = checkTrace.StartPos:Distance( checkTrace.HitPos )
	
	-- Distance not suitable
		--if fDistance < 125 or not mOwner:OnGround() then 
		--	return false
		--end
	
	-- Check eye angles
		--if mOwner:GetAngles().pitch > 24 then
		--	return false
		--end
	
	return true
end

SWEP.NextSpit = 0
function SWEP:PrimaryAttack()
	if not IsValid( self.Owner ) then return end
	local mOwner = self.Owner
	
	local spitdelay = self:CalculateSpitDelay()
	
	-- Check cooldown
	if ( mOwner.PrimaryAttackTimer or 0 ) > CurTime() then return end
	mOwner.PrimaryAttackTimer, mOwner.LastCrabJump = CurTime() + 4.78 + spitdelay, CurTime() + 4.78
	
	-- Secondary attack cooldown
	mOwner.NextSecondarySpit = CurTime() + 4.78 + spitdelay
	
	-- Check if we can shoot
	if not self:CanSpit() then
		mOwner.PrimaryAttackTimer, mOwner.LastCrabJump = CurTime() + 4.78 + spitdelay, CurTime() + 0.55
		if SERVER then mOwner:EmitSound( table.Random( self.AimFailSounds ) ) end 
		return
	end
	
	-- Spitting status
	self.IsSpitting = true
	
	-- Call secondary animation
	mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
	if SERVER then mOwner:EmitSound( "npc/headcrab_poison/ph_scream"..math.random( 1,3 )..".wav", math.random( 120, 145 ) ) end
	
	self:SetSpitEndTime(CurTime() + 0.8)
	
	-- Actual spitting
	--[==[timer.Simple( 0.8, function() 
		if IsValid( self ) then
			if IsValid( mOwner ) and mOwner:IsZombie() then
				if mOwner:IsPoisonCrab() then
					self.IsSpitting = false	
					
					-- Check if we can shoot
					if not self:CanSpit() then
						mOwner.PrimaryAttackTimer = CurTime() + 4.5  --0.5
						if SERVER then mOwner:EmitSound( table.Random( self.AimFailSounds ) ) end 
						return
					end

					if SERVER then 
						mOwner:EmitSound( "weapons/crossbow/bolt_fly4.wav", 80, math.random( 120, 150 ) )
						
						-- Create entity
						local Spit = ents.Create( "projectile_spit" )
						if not IsValid( Spit ) then return end
						
						-- Blast off!
						Spit:SetOwner( mOwner )
						Spit:SetPos( mOwner:GetPos() + Vector( 0,0,15 ) )
						Spit:Spawn()
						
						-- Apply velocity
						local Vel = mOwner:GetAimVector() * 3500
						local phys = Spit:GetPhysicsObject()
						if phys:IsValid() then
							if Vel.Z > 0 and Vel.Z < 150 then Vel.Z = 250 end
							phys:ApplyForceCenter( Vel )
						end
					end				
				end
			end
		end
	end)]==]
	
	-- Stopped the whole spit process
	GAMEMODE:SetPlayerSpeed( mOwner, 0,0 )
	--[==[timer.Simple( 1, function( ) 
		if IsValid( mOwner ) and mOwner:IsZombie() then
			if mOwner:IsPoisonCrab() then
				GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[7].Speed, ZombieClasses[7].Speed ) 	
			end
		end
	end )]==]
end

function SWEP:ActualSpit()
	local mOwner = self.Owner
	if IsValid( self ) then
		if IsValid( mOwner ) and mOwner:IsZombie() then
			if mOwner:IsPoisonCrab() then
				self.IsSpitting = false	
					
				-- Check if we can shoot
				if not self:CanSpit() then
					mOwner.PrimaryAttackTimer = CurTime() + 4.5  --0.5
					if SERVER then mOwner:EmitSound( table.Random( self.AimFailSounds ) ) end 
					return
				end

				if SERVER then 
					mOwner:EmitSound( "weapons/crossbow/bolt_fly4.wav", 80, math.random( 120, 150 ) )
						
					-- Create entity
					local Spit = ents.Create( "projectile_spit" )
						if not IsValid( Spit ) then return end
						
						-- Blast off!
						Spit:SetOwner( mOwner )
						Spit:SetPos( mOwner:GetPos() + Vector( 0,0,15 ) )
						Spit:Spawn()
						
						-- Apply velocity
						local Vel = mOwner:GetAimVector() * 3500
						local phys = Spit:GetPhysicsObject()
						if phys:IsValid() then
							if Vel.Z > 0 and Vel.Z < 150 then Vel.Z = 250 end
							phys:ApplyForceCenter( Vel )
						end
					end
				GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[7].Speed, ZombieClasses[7].Speed ) 						
				end
			end
		end
	

end

SWEP.NextSecondarySpit = 0
function SWEP:SecondaryAttack()
return false
--[[
	local mOwner = self.Owner

	-- Cooldown
	if CurTime() < ( mOwner.NextSecondarySpit or 0 ) then return end
	mOwner.NextSecondarySpit, mOwner.PrimaryAttackTimer = CurTime() + 4.78 + self:CalculateSpitDelay(), CurTime() + 4.78 + self:CalculateSpitDelay()
	mOwner.LastCrabJump = CurTime() + 1.85
	
	-- Check if we can shoot
	if not self:CanSpit() then
		mOwner.NextSecondarySpit, mOwner.PrimaryAttackTimer, mOwner.LastCrabJump = CurTime() + 0.5, CurTime() + 0.78, CurTime() + 0.55
		if SERVER then mOwner:EmitSound( table.Random( self.AimFailSounds ) ) end 
		return
	end

	-- Spitting status
	self.IsSpitting = true
	
	-- Call secondary animation
	mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
	if SERVER then mOwner:EmitSound( "npc/headcrab_poison/ph_scream"..math.random( 1,3 )..".wav", math.random( 130, 150 ) ) end
	
	-- Actual spitting
	timer.Simple( 0.8, function( mOwner ) 
		if IsValid( self ) and IsValid( mOwner ) and mOwner:IsZombie() then
			if mOwner:IsPoisonCrab() then
				self.IsSpitting = false	
				
				-- Check if we can shoot
				if not self:CanSpit() then
					mOwner.NextSecondarySpit, mOwner.PrimaryAttackTimer = CurTime() + 4.5, CurTime() + 4.78 --0.5, 0.78
					if SERVER then mOwner:EmitSound( table.Random( self.AimFailSounds ) ) end 
					return
				end

				if SERVER then 
					mOwner:EmitSound( "weapons/crossbow/bolt_fly4.wav", 80, math.random( 120, 150 ) )
					
					-- Create entity
					local Spit = ents.Create( "projectile_spit" )
					if not IsValid( Spit ) then return end
					
					-- Blast off!
					Spit:SetOwner( mOwner )
					Spit:SetPos( mOwner:GetPos() + Vector( 0,0,15 ) )
					Spit:Spawn()
					
					-- Apply velocity
					local Vel = mOwner:GetAimVector() * 3500
					local phys = Spit:GetPhysicsObject()
					if phys:IsValid() then
						if Vel.Z > 0 and Vel.Z < 150 then Vel.Z = 250 end
						phys:ApplyForceCenter( Vel )
					end
				end				
			end
		end
	end, mOwner )
	
	-- Stopped the whole spit process
	--GAMEMODE:SetPlayerSpeed( mOwner, 0 )
--	timer.Simple( 1, function( mOwner ) 
	--	if IsValid( mOwner ) and mOwner:IsZombie() then
		--	if mOwner:IsPoisonCrab() then
		--		GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[7].Speed ) 	
		--	end
	--	end
	--end, mOwner )
	]]
end

-- Fail jump
function SWEP:JumpFail()
	if SERVER then
		if IsValid( self.Owner ) then
			if ( self.JumpFailTimer or 0 ) <= CurTime() then
				self.Owner:EmitSound( "npc/headcrab_poison/ph_hiss1.wav", 100, math.random( 100, 115 ) )
				self.JumpFailTimer = CurTime() + 0.85
			end
		end
	end
end

-- Jumps!
function SWEP:Jump()
	local mOwner = self.Owner
	if not IsValid( mOwner ) then return end
	
	-- Can't jump while in air
	if ( mOwner.LastCrabJump or 0 ) > CurTime() then return end
	if not mOwner:OnGround() then self:JumpFail() return end
	
	-- Check eye angles
	if mOwner:GetAngles().pitch > 28 or mOwner:GetAngles().pitch < -48 then self:JumpFail() return end
	
	-- Play jump sound
	local Pitch = math.random( 90, 108 )
	
	if SERVER then
		mOwner:EmitSound( "npc/headcrab_poison/ph_scream1.wav", 100, Pitch )
		GAMEMODE:SetPlayerSpeed( mOwner, 0 )
	end
	
	-- Status for animation(hacky)
	self.IsSpitting = true
	
	-- Cooldown other abilities
	mOwner.NextSecondarySpit, mOwner.PrimaryAttackTimer = CurTime() + 2, CurTime() + 2
	
	-- Call secondary animation
	mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
	
	self:SetJumpEndTime(CurTime() + 0.7 * ( Pitch / 100 ))
	
	-- Jump
	--[==[timer.Simple( 0.7 * ( Pitch / 100 ), function()
		if IsValid( mOwner ) then
			local Aim, Velocity = mOwner:GetAimVector()
			
			-- Reset speed
			if IsValid( self ) then self.IsSpitting = false end
			if SERVER then GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[ mOwner:GetZombieClass() ].Speed ) end
			
			-- Check eye angles
			if mOwner:GetAngles().pitch > 28 or mOwner:GetAngles().pitch < -55 then 
				mOwner.NextSecondarySpit, mOwner.PrimaryAttackTimer = CurTime() + 4.78, CurTime() + 4.78
				self:JumpFail() 
				return 
			end
			
			
			-- Calculate velocity
			if SERVER then
				self.Leaping = true
				Velocity = Aim * 230
				Velocity = Vector( math.Clamp( Velocity.X, -350, 350 ), math.Clamp( Velocity.Y, -350, 350 ), math.Clamp( Velocity.Z, 250, 320 ) )
				
				mOwner:SetLocalVelocity( Vector( 0,0,0 ) )
				mOwner:SetVelocity( Velocity )
				

				
				-- Emit crazy sound
				mOwner:EmitSound( "npc/headcrab_poison/ph_jump"..math.random( 1,3 )..".wav", 100, math.random( 95, 105 ) )
				mOwner:EmitSound( "npc/headcrab_poison/ph_poisonbite"..math.random( 1,3 )..".wav", 100, math.random( 95, 105 ) )
			end
		end
	end )	]==]
	
	-- Cooldown
	mOwner.LastCrabJump = CurTime() + 2.1
end

function SWEP:CheckJump()
	local rend = self:GetJumpEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetJumpEndTime(0)
	
	self:ActualJump()

end

function SWEP:CheckSpitting()
	local rend = self:GetSpitEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetSpitEndTime(0)
	
	self:ActualSpit()

end
	

function SWEP:ActualJump()
	
	local mOwner = self.Owner
	
	if IsValid( mOwner ) then
		local Aim, Velocity = mOwner:GetAimVector()
			
			-- Reset speed
		if IsValid( self ) then self.IsSpitting = false end
		if SERVER then GAMEMODE:SetPlayerSpeed( mOwner, ZombieClasses[ mOwner:GetZombieClass() ].Speed ) end
			
		-- Check eye angles
		if mOwner:GetAngles().pitch > 28 or mOwner:GetAngles().pitch < -55 then 
			mOwner.NextSecondarySpit, mOwner.PrimaryAttackTimer = CurTime() + 4.78, CurTime() + 4.78
			self:JumpFail() 
			return 
		end
			
			

		if SERVER then
			self.Leaping = true
			Velocity = Aim * 230
			Velocity = Vector( math.Clamp( Velocity.X, -350, 350 ), math.Clamp( Velocity.Y, -350, 350 ), math.Clamp( Velocity.Z, 250, 320 ) )
				
			mOwner:SetLocalVelocity( Vector( 0,0,0 ) )
			mOwner:SetVelocity( Velocity )
				

				
			-- Emit crazy sound
			mOwner:EmitSound( "npc/headcrab_poison/ph_jump"..math.random( 1,3 )..".wav", 100, math.random( 95, 105 ) )
			mOwner:EmitSound( "npc/headcrab_poison/ph_poisonbite"..math.random( 1,3 )..".wav", 100, math.random( 95, 105 ) )
		end
	end
end

function SWEP:SetJumpEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:SetSpitEndTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetJumpEndTime()
	return self:GetDTFloat(0)
end

function SWEP:GetSpitEndTime()
	return self:GetDTFloat(1)
end

function SWEP:IsSpitting()
	return self:GetSpitEndTime() > 0
end

function SWEP:IsJumping()
	return self:GetJumpEndTime() > 0
end

-- Cancel out reload
function SWEP:Reload()
	return false
end

-- Delete on drop
if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

-- Drop crosshair
if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end

-- Precache some sounds
util.PrecacheSound("npc/headcrab_poison/ph_hiss1.wav") 
util.PrecacheSound("npc/headcrab_poison/ph_scream1.wav")
util.PrecacheSound("npc/headcrab_poison/ph_scream2.wav")
util.PrecacheSound("npc/headcrab_poison/ph_scream3.wav")
util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
util.PrecacheSound("npc/headcrab_poison/ph_poisonbite1.wav")
util.PrecacheSound("npc/headcrab_poison/ph_poisonbite2.wav")
util.PrecacheSound("npc/headcrab_poison/ph_poisonbite3.wav") 