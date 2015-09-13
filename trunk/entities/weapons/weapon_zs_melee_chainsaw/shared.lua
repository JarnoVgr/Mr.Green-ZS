-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Duby"

SWEP.UseHands = true

if CLIENT then
	SWEP.ShowViewModel = false 
	
	SWEP.VElements = {
		
		["chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.941, 2.631, -6.678), angle = Angle(180, 90, -53.116), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Blowtorch2"] = { type = "Model", model = "models/props_pipes/valvewheel002a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "chainsaw", pos = Vector(3.868, 2.633, -5.016), angle = Angle(-0.617, 33.426, 0), size = Vector(0.294, 0.294, 0.294), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	}

	SWEP.WElements = {
		["1"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.752, 0, -5.715), angle = Angle(-3.507, 66.623, 75.973), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.ViewModel = "models/weapons/v_chainsaw.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"

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
SWEP.MeleeDamage = 23
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1.25
SWEP.Primary.Delay = 0.3
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 0.5
SWEP.WalkSpeed = SPEED_MELEE_HEAVY

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(0, -40, 0)
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
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

 function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/melee/chainsaw_gore_03.wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer1.wav")
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