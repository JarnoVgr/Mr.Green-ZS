-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "AK-47"
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = true
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

SWEP.ViewModel			= Model ( "models/weapons/v_rif_ak47.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_rif_ak47.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.PrintName			= "AK-47"

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil			= 2 * 2.7 -- 2
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31 
SWEP.storeclipsize			= 30
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.09 -- 0.05
SWEP.ConeMoving				= 0.13 -- 0.16
SWEP.ConeCrouching			= 0.04 -- 0.05
SWEP.MaxBulletDistance 		= 3500
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.06
SWEP.ConeMoving = 0.065
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.03
SWEP.ConeIronCrouching = 0.0275

SWEP.MaxAmmo			    = 250


SWEP.WalkSpeed = 175

SWEP.IronSightsPos = Vector(6.02,-3,2.3)
SWEP.IronSightsAng = Vector(2.5,-.21,0)

SWEP.OverridePos = Vector(3.16, -4.755, 1.639)
SWEP.OverrideAng = Vector( 0,0,0 )
--SWEP.IronSightsPos = Vector(3.16, -4.755, 1.639)
--SWEP.IronSightsAng = Vector(0, 0, 0)

