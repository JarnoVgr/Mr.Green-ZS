-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "MP5 Navy"			
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFlip = true
	SWEP.IconLetter = "x"
	SWEP.ViewModelFOV = 65
	killicon.AddFont("weapon_zs_mp5", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.063, 4.046, 12.883), angle = Angle(-165.982, 94.841, 0), size = Vector(0.671, 0.671, 0.671), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.881, 0.867, -6.048), angle = Angle(-79.633, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_smg_mp5.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg_mp5.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Recoil			= 2.2 * 3 --2.2
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Cone			= 0.05 --0.1
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.MaxAmmo			    = 250

SWEP.Cone = 0.09
SWEP.ConeMoving				= 0.1
SWEP.ConeCrouching			= 0.02
SWEP.ConeIron = 0.06
SWEP.ConeIronCrouching = 0.05

SWEP.WalkSpeed = 175
SWEP.MaxBulletDistance 		= 2300

SWEP.IronSightsPos = Vector(4.72,-2,1.86)
SWEP.IronSightsAng = Vector(1.2,-.15,0)

SWEP.OverridePos = Vector(1.6, -2.623, 1.559)
SWEP.OverrideAng = Vector(0, 0, 0)

--SWEP.IronSightsPos = Vector(1.6, -2.623, 1.559)
--SWEP.IronSightsAng = Vector(0, 0, 0)