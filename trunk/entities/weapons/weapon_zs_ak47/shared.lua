-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "ak47"
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	
	SWEP.IconLetter = "b"
	killicon.AddFont( "weapon_zs_ak47", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.368, 4.8, -5.954), angle = Angle(-6.625, 88.426, 1.447), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.517, 0.296, -3.316), angle = Angle(91.203, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
	end

end

SWEP.MenuSlot 			= 0

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_ak47.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.PrintName			= "AK-47"

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil			= 8
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.storeclipsize			= 25
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 220
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.MaxBulletDistance 		= 3500
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.ConeMoving = 0.096
SWEP.Cone = 0.069
SWEP.ConeIron = 0.048
SWEP.ConeCrouching = 0.039
SWEP.ConeIronCrouching = 0.028


SWEP.MaxAmmo			    = 9999


SWEP.WalkSpeed = 195

SWEP.IronSightsPos = Vector(-6.64, -12, 2.279)
SWEP.IronSightsAng = Vector(3.03, 0, 0)

SWEP.OverridePos = Vector(3.16, -4.755, 1.639)
SWEP.OverrideAng = Vector( 0,0,0 )
--SWEP.IronSightsPos = Vector(3.16, -4.755, 1.639)
--SWEP.IronSightsAng = Vector(0, 0, 0)

