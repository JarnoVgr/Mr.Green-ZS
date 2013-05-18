-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "USP"
	SWEP.Author	= "Ywa"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 68
	killicon.AddFont( "weapon_zs_usp", "CSKillIcons", "a", Color(255, 255, 255, 255 ) )
	
	
	SWEP.IgnoreThumbs = true

end

if XMAS_2012 then
	function SWEP:InitializeClientsideModels()

		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.USP_Parent", rel = "", pos = Vector(-0.113, 0.839, -3.115), angle = Angle(95.246, 89.982, 0), size = Vector(0.307, 0.307, 0.307), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.082, 0.662, -1.106), angle = Angle(0, 0, -180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_pist_usp.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_usp.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 3.8
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.05

SWEP.FlipYaw = true

SWEP.Cone = 0.07
SWEP.ConeMoving = 0.09
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.035
SWEP.ConeIronCrouching = 0.025

SWEP.MaxAmmo			    = 130

SWEP.IronSightsPos = Vector( 4.485,-2,2.745 )
SWEP.IronSightsAng = Vector( -.2,-.025,0 )

SWEP.OverridePos = Vector(1.36, -1.624, 1.639)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(1.36, -1.624, 1.639)
--SWEP.IronSightsAng = Vector(0, 0, 0)