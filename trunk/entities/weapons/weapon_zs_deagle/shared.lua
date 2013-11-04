-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Desert Eagle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFOV = 50
	killicon.AddFont( "weapon_zs_deagle", "CSKillIcons", "f", Color(255, 255, 255, 255 ) )

	SWEP.IgnoreThumbs = true

end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(-0.038, 1.526, -3.725), angle = Angle(90, 90, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.365, 0.629, -1.385), angle = Angle(0, 0, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_deagle.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_deagle.mdl" )

SWEP.Weight				= 5

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 41
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.32
SWEP.Primary.DefaultClip	= 45
SWEP.MaxAmmo			    = 70
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.WalkSpeed = 200

SWEP.ConeMoving = 0.075
SWEP.Cone = 0.054
SWEP.ConeIron = 0.032
SWEP.ConeCrouching = 0.039
SWEP.ConeIronCrouching = 0.018

SWEP.IronSightsPos = Vector(-6.372, -9.00, 2)
SWEP.IronSightsAng = Vector(0.456, 0, 0)

SWEP.OverridePos = Vector(1.48, -1.282, 1.679)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(1.48, -1.282, 1.679)
--SWEP.IronSightsAng = Vector(0, 0, 0)

