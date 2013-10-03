-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile ( "shared.lua" )
end

SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/weapons/v_wraith.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.PrintName = "Ethereal"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 82
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.EmitWraithSound = 0
SWEP.Screams = { "npc/stalker/stalker_alert1b.wav", "npc/stalker/stalker_alert2b.wav", "npc/stalker/stalker_alert3b.wav"}

-- Human scream sounds
SWEP.HumanScreams = { Sound( "ambient/voices/m_scream1.wav" ), Sound( "ambient/voices/f_scream1.wav" ) }

SWEP.DistanceCheck = 75

function SWEP:Precache()
	
	util.PrecacheSound("npc/stalker/breathing3.wav")
	
	util.PrecacheModel(self.ViewModel)
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[4].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[4].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.Screams) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.HumanScreams) do
		util.PrecacheSound(snd)
	end
	
	for i=1, 4 do
		util.PrecacheSound("npc/stalker/stalker_scream"..i..".wav")
	end
	
end

-- On deploy
function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( false )
		
		self.ScarySound = CreateSound( self.Owner, "ambient/voices/crying_loop1.wav" )  
		--self.ScarySound = CreateSound( self.Owner, "npc/zombie_poison/pz_breathe_loop2.wav" ) 
		
	end
end

-- No reloading
function SWEP:Reload()
	return false
end

-- Primary attack
SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextAttack then return end
	
	-- Make things easier
	local pl = self.Owner
	self.PreHit = nil
	
	-- Trace filter
	local trFilter = team.GetPlayers( TEAM_ZOMBIE )
		
	-- Hacky way for the animations
	if self.SwapAnims then self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER ) else self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) end
	self.SwapAnims = not self.SwapAnims
	
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:EmitSound( "npc/antlion/distract1.wav", 100, math.random( 92, 107 ) )
	 
	local speed = 1
	local stopplayer = true
	
	if self:IsDisguised() then
		speed = 100
		stopplayer = false
	end
	 
	if SERVER then
		GAMEMODE:SetPlayerSpeed( self.Owner, speed,speed )
		if stopplayer then
			self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
		end
	end 
	
	self:SetAnimSwingEndTime(CurTime() + 1.3)
	
	--[==[timer.Simple ( 1.3, function()
		if not ValidEntity ( pl ) then return end
		
		-- Conditions
		if not pl:Alive() or not pl:IsWraith() then return end
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed, ZombieClasses[ pl:GetZombieClass() ].Speed )
	end)]==]
	 
	-- Trace an object
	local trace = pl:TraceLine( self.DistanceCheck, MASK_SHOT, trFilter )
	if trace.Hit and ValidEntity ( trace.Entity ) and not trace.Entity:IsPlayer() then
		self.PreHit = trace.Entity
	end
	
	-- Delayed attack function (claw mechanism)
	
	self:SetSwingEndTime(CurTime() + 0.6)
	
	--[==[if SERVER then 
		timer.Simple ( 0.6, function()
							if not IsValid(self.Weapon) then return end
							self:DoPrimaryAttack(trace, pl, self.PreHit)
					end) 
	end]==]
				
	--  Set the next swing attack for cooldown
	self.NextAttack = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 0.6
	
	-- Teleport CD
	self.TeleportTimer = CurTime() + 2.2
end

function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	self:DoPrimaryAttack()
end

function SWEP:CheckMeleeAnimAttack()
	local swingend = self:GetAnimSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopAnimSwinging(0)

	local pl = self.Owner
	
	if not IsValid(pl) then return end
	
	if not pl:Alive() or not pl:IsWraith() then return end

	GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed, ZombieClasses[ pl:GetZombieClass() ].Speed )
	
end

-- Primary attack function
function SWEP:DoPrimaryAttack ( )
	if CLIENT then return end
	if not ValidEntity ( self.Owner ) then return end
	local mOwner = self.Owner
	local pl = self.Owner
	
	-- Trace filter
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	
	local victim = self.PreHit
	
	-- Calculate damage done
	local Damage = math.random( 15, 20 )
	Damage = Damage + Damage * ( ( 1 - ( mOwner:GetVelocity():Length() / ZombieClasses[4].Speed ) ) )
	local TraceHit, HullHit = false, false
	
	-- Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * 5000
	
	-- Tracehull attack
	local trHull = util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 17 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector( 15,10,18 ) } )
	
	local tr
	if not ValidEntity ( victim ) then	
		tr = pl:TraceLine ( self.DistanceCheck, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = ValidEntity ( victim )
	HullHit = ValidEntity ( trHull.Entity )
	
	-- Punch the prop / damage the player if the pretrace is valid
	if ValidEntity ( victim ) then
		local phys = victim:GetPhysicsObject()
		
		-- Break glass
		if victim:GetClass() == "func_breakable_surf" then
			victim:Fire( "break", "", 0 )
		end
		
		if self:IsDisguised() then 
			Damage = Damage * 1.5
		end
		
		-- From behind
		if victim:IsPlayer() then
			if FromBehind ( self.Owner, victim ) then 
			--	Damage = Damage * 2
			--	victim:EmitSound( "vo/npc/barney/ba_pain0"..math.random( 1, 5 )..".wav", 100, math.random( 95, 105 ) )
			--	pl:EmitSound( "ambient/machines/slicer2.wav", 100, math.random( 90, 110 ) ) 
			end
		end
		
		-- Take damage
		victim:TakeDamage ( math.Clamp( Damage, 1, 50 ), self.Owner, self )

		-- Claw sound
		pl:EmitSound( "ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
				
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
		
		if ent ~= ExploitTrace.Entity then return end
		
		-- Break glass
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire( "break", "", 0 )
		end
		
		-- Play the hit sound
		pl:EmitSound( "ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
		
		-- From behind
		if ent:IsPlayer() then
			if FromBehind ( self.Owner, ent ) then 
				--Damage = Damage * 2
				--ent:EmitSound( "vo/npc/barney/ba_pain0"..math.random( 1, 5 )..".wav", 100, math.random( 95, 105 ) )
				--pl:EmitSound( "ambient/machines/slicer2.wav", 100, math.random( 90, 110 ) ) 
			end
		end
		
		-- Take damage
		ent:TakeDamage ( math.Clamp( Damage, 1, 40 ), self.Owner, self )
	
		-- Apply force to the correct object
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			phys:ApplyForceCenter( Velocity )
			ent:SetPhysicsAttacker( pl )
		end	
	end
end

function SWEP:SetDisguise(bl)
	self:SetDTBool(0,bl)
	self:DrawShadow(bl)
end

function SWEP:IsDisguised()
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


function SWEP:StopAnimSwinging()
	self:SetAnimSwingEndTime(0)
end

function SWEP:SetAnimSwingEndTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetAnimSwingEndTime()
	return self:GetDTFloat(1)
end



-- Secondary attack 
SWEP.TeleportTimer = 0
SWEP.Disguised = false
function SWEP:SecondaryAttack()
	
	-- if self.Disguised then return end
	if self:IsDisguised() then return end
		
	self:SetDisguise(true)
	
	-- self.Disguised = true
	-- self.Owner.Disguised = true
	
	local humans = team.GetPlayers(TEAM_HUMAN)
	
	local model = "models/player/kleiner.mdl"-- "models/zombie/classic_legs.mdl"
	
	if #humans > 0 then
		model = table.Random(humans):GetModel()
	end
	
	if SERVER then		
		self.Owner:SetModel(model)
		
		self.Owner:EmitSound( "npc/stalker/stalker_scream"..math.random(1,4)..".wav", 80, math.random( 100, 115 ) )		
	end
end

-- Play teleport fail sound
function SWEP:TeleportFail()
	if SERVER then
		if ( self.TeleportWarnTime or 0 ) <= CurTime() then
			-- self.Owner:EmitSound( "npc/zombie_poison/pz_idle4.wav", 70, math.random( 92, 105 ) ) --Moo
			self.Owner:EmitSound( "npc/stalker/stalker_ambient01.wav", 70, 100 ) 
			self.TeleportWarnTime = CurTime() + 0.97
		end
	end
end


if CLIENT then

	-- Make all wraiths shiver out of existance
	--[==[hook.Add( "Think", "WraithShiverEffect", function()
		for k,v in pairs( team.GetPlayers( TEAM_UNDEAD ) ) do
			if v:IsWraith() then
				if v:KeyDown(IN_ATTACK) or v.Disguised then
					v:SetColor( Color(255,255,255,255) ) 
				else
					if math.random( 1, 35 ) == 1 then
						v:SetColor( Color(255,255,255,255) ) 
					else
						v:SetColor( Color(255,255,255,1) )
					end
				end
			end
		end
	end )
	
	-- Reset color
	hook.Add( "PlayerSpawn", "WraithResetColor", function( pl )
		if IsValid( pl ) then
			if not FIRSTAPRIL then
				-- pl:SetColor( 255,255,255,255 )
			end
		end
	end )]==]
end

function SWEP:OnRemove()
	if self.Owner and self.Owner:IsValid() then
		self.Owner.Disguised = false
		if SERVER then
			self.ScarySound:Stop()
		end
	end
end 

-- Main think
function SWEP:Think()
	if not ValidEntity ( self.Owner ) then return end
	local mOwner = self.Owner
	-- if self.Disguised then 
	
	self:CheckMeleeAttack()
	self:CheckMeleeAnimAttack()
	
	if SERVER then
		if self.ScarySound then
			self.ScarySound:PlayEx(0.2, 95 + math.sin(RealTime())*8) 
		end 
	end
	
	-- return end
	-- Idle sounds
	--[[if SERVER then
		if self.EmitWraithSound <= CurTime() then
			self.Owner:EmitSound ( table.Random ( self.Screams ), 100, math.random( 95, 110 ) )
			self.EmitWraithSound = CurTime() + 6.5
		end
	end]]
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

-- Precache sounds
util.PrecacheSound( "npc/antlion/distract1.wav" )
util.PrecacheSound( "ambient/machines/slicer1.wav" )
util.PrecacheSound( "ambient/machines/slicer2.wav" )
util.PrecacheSound( "ambient/machines/slicer3.wav" )
util.PrecacheSound( "ambient/machines/slicer4.wav" )
util.PrecacheSound( "npc/zombie/claw_miss1.wav" )
util.PrecacheSound( "npc/zombie/claw_miss2.wav" )
