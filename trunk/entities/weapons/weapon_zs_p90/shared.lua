-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "P90"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.ViewModelFOV = 65
	SWEP.SlotPos = 13
	SWEP.IconLetter = "m"
	killicon.AddFont("weapon_zs_p90", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.p90_Parent", rel = "", pos = Vector(0.241, 2.676, -12.311), angle = Angle(6.506, -90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8.839, 1.111, -2.053), angle = Angle(-93.301, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_smg_p90.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg_p90.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_P90.Single")
SWEP.Primary.Recoil			= 6
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 50
SWEP.MaxAmmo			    = 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Cone			= 0.09
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.07
SWEP.ConeMoving = 0.09
SWEP.ConeCrouching = 0.05
SWEP.ConeIron = 0.08
SWEP.ConeIronCrouching = 0.06

SWEP.WalkSpeed = 185
SWEP.MaxBulletDistance 		= 1800

SWEP.IronSightsPos = Vector(4.659, -5.738, 1.769)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.OverridePos = Vector(2.299, -2.46, 1.967)
SWEP.OverrideAng = Vector(0, 0, 0)