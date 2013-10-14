-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "AUG"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 2
	SWEP.ViewModelFlip = true
	SWEP.ShowViewModel = false
	SWEP.IconLetter = "e"
	killicon.AddFont("weapon_zs_aug", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.aug_Parent", rel = "", pos = Vector(0.476, 2.634, 8.081), angle = Angle(180, -90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.575, 1.294, -3.518), angle = Angle(91.344, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_aug.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_aug.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.PrintName			= "Inferno'"

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AUG.Single")
SWEP.Primary.Recoil			= 7
SWEP.Primary.Damage			= 17.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.storeclipsize			= 31
SWEP.Primary.Delay			= 0.095
SWEP.Primary.DefaultClip	= 93
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.05
SWEP.MaxBulletDistance 		= 3500
SWEP.MaxAmmo			    = 250

SWEP.ConeMoving = 0.079
SWEP.Cone = 0.071
SWEP.ConeIron = 0.065
SWEP.ConeCrouching = 0.064
SWEP.ConeIronCrouching = 0.049

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.WalkSpeed = 195

--SWEP.IronSightsPos = Vector(5.99,-3,.985)
--SWEP.IronSightsAng = Vector(2.4,1.9,45)

SWEP.OverridePos = Vector(1.6, -2.029, 0.839)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(1.6, -2.029, 0.839)
--SWEP.IronSightsAng = Vector(0, 0, 0)