-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/weapons/v_wraith.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.PrintName = "Ethereal"

if CLIENT then
	SWEP.ViewModelFOV = 82
	SWEP.ViewModelFlip = false
end

SWEP.Primary.Duration = 1.5
SWEP.Primary.Delay = 0.3
SWEP.Primary.Reach = 56
SWEP.Primary.Damage = 30
SWEP.Primary.Next = 2
--SWEP.Secondary.Next = 6.8
SWEP.Secondary.Next = 2.6
SWEP.Secondary.Duration = 1

SWEP.EmitWraithSound = 0
SWEP.Screams = {
	Sound("npc/stalker/stalker_alert1b.wav"),
	Sound("npc/stalker/stalker_alert2b.wav"),
	Sound("npc/stalker/stalker_alert3b.wav")
}

-- Human scream sounds
SWEP.HumanScreams = {
	Sound("ambient/voices/m_scream1.wav"),
	Sound("ambient/voices/f_scream1.wav")
}

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("npc/stalker/breathing3.wav")
	
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

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	--Hide
	if CLIENT then
		self.Owner:DestroyShadow()
	end

	if SERVER then
		self.ScarySound = CreateSound(self.Owner, Sound("ambient/voices/crying_loop1.wav"))
	end
end

function SWEP:StartPrimaryAttack()		
	-- Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(Sound("npc/antlion/distract1.wav"), 100, math.random(92, 107))
	 
	local stopPlayer = true

	--Stop movement
	--self.Primary.Speed = 1
	self.Primary.Speed = 80
	 
	if SERVER then
		if stopPlayer then
			self.Owner:SetLocalVelocity(Vector(80, 80, 80))
		end
	end
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		mv:SetMaxSpeed(self.Primary.Speed)
		return true
	end
end

function SWEP:PerformSecondaryAttack()
	local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end

	--Delay next teleport
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
	
	--Not enough health
	if mOwner:Health() < mOwner:GetMaximumHealth() * 0.15 then
		self:TeleportFail()
		return
	end
	
	--Don't teleport in air
	if not mOwner:OnGround() then
		self:TeleportFail()
		return
	end

	--Trace from aim
	local aimTrace = util.TraceLine({
		start = mOwner:GetShootPos(),
		endpos = mOwner:GetShootPos() + (mOwner:GetAimVector() * 1000),
		filter = mOwner,
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})
	if not aimTrace.Hit then -- or aimTrace.HitNormal ~= Vector(0, 0, 1) then
		self:TeleportFail()
		return
	end
	
	--Check distance
	if aimTrace.HitPos:Distance(aimTrace.StartPos) < 100 or aimTrace.HitPos:Distance(aimTrace.StartPos) > 1000 then
		self:TeleportFail()
		return
	end

	--Hulltrace that position
	--Keep trying with higher Z-axis value to allow teleporting on steep spots
	local safeHull, safeHullAttempts = false, 0
	local hullTrace
	while not safeHull and safeHullAttempts <= 26 do
		hullTrace = util.TraceHull({
			start = aimTrace.HitPos,
			endpos = aimTrace.HitPos,
			filter = mOwner,
			mins = Vector(-16, -16, 0),
			maxs = Vector(16, 16, 72)
		})

		if not hullTrace.Hit then
			safeHull = true
			break
		end

		--Raise Z-axis value with 1 unit for next loop
		aimTrace.HitPos.z = aimTrace.HitPos.z + 0.5

		safeHullAttempts = safeHullAttempts + 1
	end

	if not safeHull then
		self:TeleportFail()
		return
	end

	--Change damage once teleported
	self.Primary.Damage = 20
	
	mOwner.IsWraithTeleporting = true
	
	-- Emit crazy sound
	if SERVER then
		mOwner:EmitSound(Sound("npc/stalker/stalker_scream"..math.random(1,4)..".wav"), 80, math.random(100, 115))
	end
	timer.Simple(0.2, function()
		if not SERVER or not IsValid( mOwner ) or not mOwner:IsZombie() then
			return
		end
		
		mOwner:EmitSound(Sound("npc/stalker/breathing3.wav"))
	end)
	
	--For effect
	timer.Simple(1.7, function()
		if not IsValid( mOwner ) then
			return
		end
		
		mOwner.IsWraithTeleporting = false
	end)
	
	--Take damage
	if SERVER then
		mOwner:SetHealth(mOwner:Health() - (mOwner:GetMaximumHealth() * 0.1))
		
		--Pre-teleport smoke
		--TODO: Fix. This ain't working
		local eData = EffectData()
		eData:SetEntity( mOwner )
		eData:SetOrigin( mOwner:GetPos() )
		util.Effect("wraith_teleport_smoke", eData)

		-- Shake screen
		mOwner:SendLua("WraithScream()")
	
		--Teleport
		mOwner:SetPos(hullTrace.HitPos)
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Next)
	
	--Post teleport smoke
	timer.Simple(0.1, function()
		if not IsValid(mOwner) then
			return
		end

		local eData = EffectData()
		eData:SetEntity(mOwner)
		eData:SetOrigin(mOwner:GetPos())
		util.Effect("wraith_teleport_smoke", eData)
	end)
	
	if CLIENT then
		return
	end
	--[[
	--Distract ability (random chance)
	local Humans = ents.FindInSphere(mOwner:GetPos(), 300)
	local Affected = 0
	
	-- Count em
	local iHumans = 0
	for k,v in pairs(Humans) do
		if v:IsPlayer() and v:IsHuman() and v:Alive() then
			iHumans = iHumans + 1
		end
	end
	
	-- Filter
	local Filter = { mOwner }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	for k,v in pairs( Humans ) do
		if IsValid( v ) and v:IsPlayer() then
			if v:IsHuman() and v:Alive() and Affected < 4 then
				if ( iHumans <= 2 ) or ( iHumans > 3 and math.random( 1, 2 ) == 1 ) then
					if ( v.NextDistract or 0 ) <= CurTime() and IsEntityVisible ( v, mOwner:GetPos() + mOwner:OBBCenter(), Filter ) then
						Affected = Affected + 1
						local SnapAngle = ( mOwner:EyePos() - v:EyePos() ):Angle()
						if math.random(1,2) == 1 then
							v:SnapEyeAngles( SnapAngle )
						end
						
						-- Emit crazy sound
						local sSound = self.HumanScreams[1]
						if v:IsFemale() then sSound = self.HumanScreams[2] end
						v:EmitSound( sSound, 100, math.random( 90, 110 ) )
						
						-- Stop player
						v:SetLocalVelocity( Vector( 0,0,0 ) )
						
						-- Scare the shit out of him
						v:SendLua( "StalkerFuck(1)" )
						
						-- Cooldown
						v.NextDistract = CurTime() + 3.5
					end
				end
			end
		end
	end]]
end

-- Play teleport fail sound
function SWEP:TeleportFail()
	if not SERVER then
		return
	end
	
	if (self.TeleportWarnTime or 0) <= CurTime() then
		-- self.Owner:EmitSound( "npc/zombie_poison/pz_idle4.wav", 70, math.random( 92, 105 ) ) --Moo
		self.Owner:EmitSound(Sound("npc/stalker/stalker_ambient01.wav"), 70, 100)
		self.TeleportWarnTime = CurTime() + 0.97
	end
end


function SWEP:OnRemove()
	if SERVER then
		self.ScarySound:Stop()
	end

	self.BaseClass.OnRemove(self)
end 

-- Main think
function SWEP:Think()
	self.BaseClass.Think(self)

	if SERVER then
		if self.ScarySound then
			self.ScarySound:PlayEx(0.2, 95 + math.sin(RealTime())*8) 
		end 
	end
end

-- Precache sounds
util.PrecacheSound("npc/antlion/distract1.wav")
util.PrecacheSound("ambient/machines/slicer1.wav")
util.PrecacheSound("ambient/machines/slicer2.wav")
util.PrecacheSound("ambient/machines/slicer3.wav")
util.PrecacheSound("ambient/machines/slicer4.wav")
util.PrecacheSound("npc/zombie/claw_miss1.wav")
util.PrecacheSound("npc/zombie/claw_miss2.wav")

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
		draw.SimpleTextOutlined("Right click to Teleport!", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
end