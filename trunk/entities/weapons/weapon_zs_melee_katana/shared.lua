-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Models paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_katana.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_katana.mdl" )

-- Name and fov
SWEP.PrintName = "Katana"
SWEP.ViewModelFOV = 57
SWEP.HoldType = "melee2"
-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6
SWEP.DeploySpeed = 0.6
-- Damage, distane, delay
SWEP.Primary.Damage = 80
SWEP.Primary.Delay = 0.45
SWEP.Primary.Distance = 75
SWEP.TotalDamage = SWEP.Primary.Damage
-- Killicon
if CLIENT then killicon.AddFont( "weapon_zs_melee_katana", "ZSKillicons", "h", Color(255, 255, 255, 255 ) ) end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
	util.PrecacheSound("weapons/katana/draw.wav")
	util.PrecacheSound("weapons/katana/katana_01.wav")
	util.PrecacheSound("weapons/katana/katana_02.wav")
	util.PrecacheSound("weapons/katana/katana_03.wav")
end
function SWEP:Deploy()
	if SERVER then
		if self.Owner:FlashlightIsOn() and self.Owner:GetHumanClass() ~= 3 then
			--self.Owner:Flashlight( false )
		end
	
	end
	self.Weapon:EmitSound("weapons/katana/draw.wav")
	-- Draw animation
	self.Weapon:SendWeaponAnim ( ACT_VM_DRAW )
	
	-- Deploy speed
	self.Weapon:SetNextPrimaryFire ( CurTime() + self.DeploySpeed )
	
	if SERVER then
		GAMEMODE:WeaponDeployed( self.Owner, self )
	end
	
	return true
end

SWEP.KatanaSounds = {}

for i = 1, 3 do
	SWEP.KatanaSounds[i] = Sound ( "weapons/katana/katana_0"..i..".wav" )
end