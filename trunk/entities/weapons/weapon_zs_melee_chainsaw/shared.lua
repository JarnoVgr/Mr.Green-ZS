-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Duby"

SWEP.UseHands = true

if CLIENT then
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.704, 3.443, -0.055), angle = Angle(-6.298, 3.278, -7.829) },
		["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["Chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "Base", rel = "", pos = Vector(6.877, 9.47, -13.148), angle = Angle(-2.674, -10.464, -106.545), size = Vector(1.157, 1.157, 1.157), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_chainsaw.mdl"

-- Name and fov
SWEP.HoldType = "physgun"
SWEP.PrintName = "Chainsaw"

SWEP.DeploySpeed = 0.8
-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 8
SWEP.HumanClass = "berserker"
-- Damage, distane, delay
SWEP.Primary.Automatic	= true
SWEP.MeleeDamage = 11
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.5
SWEP.Primary.Delay = 0.1
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 0.5
SWEP.WalkSpeed = SPEED_MELEE_HEAVY

SWEP.SwingTime = 0.1
SWEP.SwingRotation = Angle(4, 0, 0)
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
--[[
--//
--// Logic to fix iron sights bug - Josh 'Acecool' Moser
--//
function SWEP:FixIronSightsBug( _time )
if ( SERVER ) then
timer.Create( "FixIronSightsBug", ( _time or 0 ) + 0.05, 1, function( )
if ( !IsValid( self ) ) then return; end

local _anim = ACT_VM_IDLE
if ( self && self.GetSuppressed && self:GetSuppressed( ) ) then
_anim = ACT_VM_IDLE_SILENCED
end
self:SendWeaponAnim( _anim )

if ( !IsValid( self ) || !IsValid( self.Owner ) || !IsValid( self.Owner:GetViewModel() ) ) then return; end
self.Owner:GetViewModel():SetPlaybackRate( 0 )
end )
end
end]]--


function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav", 85, math.random(80,90))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav", 85, math.random(80,90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(1, 4)..".wav", 85, math.random(110,115))
end

function SWEP:OnDeploy()
	if SERVER then
		self.DeployTime = CurTime() + 3.1
		self.ChainSound = CreateSound( self.Owner, "weapons/melee/chainsaw_idle.wav" ) 
		if not self.Deployed then
			self.Owner:EmitSound("weapons/melee/chainsaw_start_0"..math.random(1,2)..".wav")
			self.Deployed = true
		end
	end
	
end


function SWEP:_OnRemove() --Cheers Necro, this code is from the hate swep
	if SERVER then
		if self.Owner and self.Owner:IsValid() then
			self.Owner:EmitSound("weapons/melee/chainsaw_die_01.wav")
		end
		self.ChainSound:Stop()
	end
end 