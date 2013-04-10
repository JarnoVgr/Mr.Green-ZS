-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local team = team
local util = util
local timer = timer

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.PrintName = "weapon"
end

if CLIENT then
	SWEP.PrintName = "Zombie"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -18.619, -9.325) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.551, 6.58, -33.668) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.663, 4.375, 33.555) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -16.632, 0) }
	}

	
end
SWEP.Base = "weapon_zs_base_undead_dummy"
-- Remade by Deluvas
SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/Weapons/v_zombiearms.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DistanceCheck = 88
SWEP.MeleeDelay = 0.6

SWEP.SwapAnims = false
SWEP.AttackAnimations = { "attackD", "attackE", "attackF" }

SWEP.Damage = 30

function SWEP:Reload()
	return false
end

function SWEP:OnDeploy()
	if SERVER then
		self.Owner.Moaning = false
	end
	self.Owner.IsMoaning = false 
	self.Owner.ZomAnim = math.random(1, 3)
end

function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	self:Swung()
end

function SWEP:Think()	
	self:CheckMeleeAttack()
end


SWEP.NextSwing = 0
function SWEP:PrimaryAttack()

	if CurTime() < self.NextSwing then return end
	
	self.Weapon:SetNextPrimaryFire ( CurTime() + self.MeleeDelay ) 
	self.Weapon:SetNextSecondaryFire ( CurTime() + 1.2 )
	self:StartSwinging()
	
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 0.6	
end

function SWEP:StartSwinging()

	local pl = self.Owner
	self.PreHit = nil
	self.Trace = nil
	-- pl.IsMoaning = false
	
	if SERVER then
	self:SetMoaning(false)
		if self.MoanSound then
			self.MoanSound:Stop()
			self.MoanSound = nil
		end
	end
	
	local trFilter = team.GetPlayers( TEAM_ZOMBIE )
		
	-- Hacky way for the animations
	if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	
	-- Set the thirdperson animation and emit zombie attack sound
	pl:DoAnimationEvent( CUSTOM_PRIMARY )
	if SERVER then self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav") end

	if self.MeleeDelay > 0 then
		self:SetSwingEndTime(CurTime() + self.MeleeDelay)

		local trace = pl:TraceLine( self.DistanceCheck, MASK_SHOT, trFilter )
		if trace.Hit and ValidEntity ( trace.Entity ) and not trace.Entity:IsPlayer() then -- no more Mr. Long arms
			self.PreHit = trace.Entity
			self.Trace = trace
		end
	else
		self:Swung()
	end
end

function SWEP:Swung()
	
	if CLIENT then return end
	
	if not ValidEntity ( self.Owner ) then return end

	local pl = self.Owner
	local victim = self.PreHit
	
	
	-- Trace filter
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	-- Calculate damage done
	local Damage = self.Damage or 30
	local TraceHit, HullHit = false, false

	-- Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * math.Clamp ( Damage * 1000, 25000, 37000 )
	if self.Owner.Suicided == true then
	-- 	Velocity = Velocity * 0.4
	end
	
	-- Tracehull attack
	local trHull = self.Owner:MeleeTrace(30, 13, trFilter)
	-- util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 20 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector( 15,10,18 ) } )
	
	if not ValidEntity ( victim ) then	
		local tr = pl:TraceLine ( self.DistanceCheck, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = ValidEntity ( victim )
	HullHit = ValidEntity ( trHull.Entity )
	
	-- Play miss sound anyway
	pl:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	
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
		pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
				
		-- Case 2: It is a valid physics object
		if phys:IsValid() and not victim:IsNPC() and phys:IsMoveable() and not victim:IsPlayer() and not victim.Nails then
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
		pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
		
		-- Take damage
		ent:TakeDamage ( Damage, self.Owner, self )
	
		-- Apply force to the correct object
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() and not ent.Nails then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			phys:ApplyForceCenter( Velocity )
			ent:SetPhysicsAttacker( pl )
		end	
	end
	
end

function SWEP:SetMoaning(bl)
	self:SetDTBool(0,bl)
end

function SWEP:IsMoaning()
	return self:GetDTBool(0)
end

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

-- Disables rage on player
function playerRevertRage( pl )
	if not IsValid( pl ) then 
		if CLIENT then pl = MySelf else return end
	end
	
	-- Predict duration
	local iDuration = math.Clamp( ( 1 - ( pl:Health() / pl:GetMaximumHealth() ) ) * 4, 1.8, 3.5 )

	-- Run timer
	timer.Simple( iDuration, function()
		if IsValid( pl ) then
			if pl:IsZombie() and pl:IsCommonZombie() then
				if SERVER then
					GAMEMODE:SetPlayerSpeed( pl, ZombieClasses[1].Speed )
				end
			end
				
			-- Revert color
			if not pl:IsInvisible() then
				pl:SetColor( 255,255,255,255 )
			end
				
			-- Reset status
			pl.IsInRage = false
		end
	end )
end

-- Enrage player
function playerEnrage( pl )
	if not IsValid( pl ) then 
		if CLIENT then pl = MySelf else return end
	end
	
	-- Check if not healed or protected
	if pl:HasHowlerProtection() or pl:IsZombieInAura() or pl:IsZombieInRage() then return end
	
	-- Duration of rage
	local iDuration, iPitch = math.Clamp( ( 1 - ( pl:Health() / pl:GetMaximumHealth() ) ) * 4, 1.8, 3.5 )
	iPitch = ( ( ( iDuration - 1.8 ) / 1.7 ) * 55 ) * 1.03
	
	-- Status
	pl.IsInRage = true
	if CLIENT then RageScream( iDuration ) end
	
	-- Increase speed and set color
	pl:SetColor( 255,0,0,255 )
	if SERVER then GAMEMODE:SetPlayerSpeed( pl, pl:GetMaxSpeed() * 1.25 ) end
	
	-- Play activation sound
	if SERVER then pl:EmitSound( "npc/antlion/attack_double"..math.random( 1,3 )..".wav", 100, 100 - iPitch ) end

	-- Send PP to client
	if SERVER then 
		pl:SendLua( "playerEnrage()" ) 
	end
	
	-- Show effect
	if SERVER then
		local Effect = EffectData()
			Effect:SetEntity( pl )
		util.Effect( "rage_cloud", Effect, true, true )
	end
	
	-- Revert shit
	playerRevertRage( pl )
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	local mOwner = self.Owner
	
	-- Can't moan while raging
	if mOwner:IsZombieInRage() then return end
	
	-- Thirdperson animation
	mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
	
	local moan = "npc/zombie/moan_loop"..math.random(1,4)..".wav"
	
	if SERVER then
	self.MoanSound = CreateSound(self.Owner,Sound(moan))
		if not self:IsMoaning() then
			if self.MoanSound then
				-- self.Owner.Moaning = true 
				self:SetMoaning(true)
				self.MoanSound:Play()
				timer.Simple ( SoundDuration( "../../hl2/sound/"..moan ), function() 
														if self and ValidEntity(self.Weapon) and ValidEntity(self.Owner) then 
															if self:IsMoaning() then
																self:SetMoaning(false)
																if self.MoanSound then
																	self.MoanSound:Stop()
																	self.MoanSound = nil
																end
															end
														end 
													end )
			end
		else
			-- self.Owner.Moaning = false 
			self:SetMoaning(false)
			if self.MoanSound then
				self.MoanSound:Stop()
				self.MoanSound = nil
			end
		end
	end
	timer.Simple ( SoundDuration( "../../hl2/sound/"..moan ), function() 
	   if IsValid( self ) and IsValid( self.Owner ) then 
	       if self.Owner.IsMoaning then 
	           self.Owner.IsMoaning = false 
	       end 
	   end 
	end )
		
	-- Emit both claw attack sound and weird funny sound
	-- if SERVER then self.Owner:EmitSound( "npc/zombie/zombie_voice_idle"..math.random( 1, 14 )..".wav" ) end
	if self.Owner.IsMoaning then
		self.NextYell = CurTime() + 2
	else
		self.NextYell = CurTime() + SoundDuration( "../../hl2/sound/"..moan )
	end
	
end

function SWEP:_OnRemove()
	if SERVER then
		if self.MoanSound then
			self.MoanSound:Stop()
		end
	end
	self.Owner.IsMoaning = false 
return true
end

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

function SWEP:Precache()
	for i = 1, 14 do
		util.PrecacheSound("npc/zombie/zombie_voice_idle"..i..".wav")
	end

	for i = 1, 3 do
		util.PrecacheSound("npc/zombie/claw_strike"..i..".wav")
	end
	
	for i = 1, 2 do
		util.PrecacheSound("npc/zombie/claw_miss"..i..".wav")
	end
	
	for i = 1, 2 do
		util.PrecacheSound("npc/zombie/zo_attack"..i..".wav")
	end
	
	for i = 1,3 do
		util.PrecacheSound("npc/zombie/zombie_die"..i..".wav")
	end
	
	for i = 1,4 do
		util.PrecacheSound("npc/zombie/moan_loop"..i..".wav")
	end
	
	
end