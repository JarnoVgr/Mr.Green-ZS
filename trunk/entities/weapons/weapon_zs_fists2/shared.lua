
AddCSLuaFile()

SWEP.Author			= "robotboy655 & MaxOfS2D"
SWEP.Purpose		= "Well we sure as heck didn't use guns! We would wrestle Hunters to the ground with our bare hands! I would get ten, twenty a day, just using my fists."
SWEP.Base = "weapon_zs_melee_base"
SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel			= ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.MeleeDamage			= 15
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Type = "Melee"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 0
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Fists"
SWEP.Slot				= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.WalkSpeed = SPEED

local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Flesh.ImpactHard" )

if CLIENT then killicon.Add( "weapon_zs_fists2", "killicon/fists", Color(255, 255, 255, 255 ) ) end

function SWEP:Initialize()

	self:SetWeaponHoldType( "fist" )

end

function SWEP:PreDrawViewModel( vm, wep, ply )

	vm:SetMaterial( "engine/occlusionproxy" ) -- Hide that view model with hacky material

end

SWEP.HitDistance = 48
SWEP.AttackAnims = { "fists_left", "fists_right", "fists_uppercut" }
function SWEP:PrimaryAttack()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( !SERVER ) then return end

	-- We need this because attack sequences won't work otherwise in multiplayer
	local vm = self.Owner:GetViewModel()
	vm:ResetSequence( vm:LookupSequence( "fists_idle_01" ) )

	local anim = self.AttackAnims[ math.random( 1, #self.AttackAnims ) ]

	timer.Simple( 0, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
	
		local vm = self.Owner:GetViewModel()
		vm:ResetSequence( vm:LookupSequence( anim ) )

		self:Idle()
	end )

	timer.Simple( 0.4, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
		self:DealDamage( anim )
	end )

	self:SetNextPrimaryFire( CurTime() + 0.4 )
end

function SWEP:DealDamage( anim )
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = self.Owner:OBBMins() / 3,
			maxs = self.Owner:OBBMaxs() / 3
		} )
	end

	if SERVER and( tr.Hit ) then self.Owner:EmitSound( HitSound )

		if ( IsValid( tr.Entity ) ) then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage( self.MeleeDamage )

			dmginfo:SetInflictor( self )
			local attacker = self.Owner
			if ( !IsValid( attacker ) ) then attacker = self end
			dmginfo:SetAttacker( attacker )
			tr.Entity:TakeDamageInfo( dmginfo )
			local phys = tr.Entity:GetPhysicsObject()
			phys:ApplyForceCenter(self.Owner:EyeAngles():Forward() * (self.MeleeDamage * 200))
			if tr.Entity:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				tr.Entity:SetPhysicsAttacker(attacker)
			end	
		end
	end
	
end

function SWEP:SecondaryAttack()
end

function SWEP:Idle()

	local vm = self.Owner:GetViewModel()
	timer.Create( "fists_idle" .. self:EntIndex(), vm:SequenceDuration(), 1, function()
		vm:ResetSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
	end )

end

function SWEP:OnRemove()

	if ( IsValid( self.Owner ) ) then
		local vm = self.Owner:GetViewModel()
		if ( IsValid( vm ) ) then vm:SetMaterial( "" ) end
	end

	timer.Stop( "fists_idle" .. self:EntIndex() )

end

function SWEP:Holster( wep )

	self:OnRemove()

	return true
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:ResetSequence( vm:LookupSequence( "fists_draw" ) )

	self:Idle()

	return true
end
