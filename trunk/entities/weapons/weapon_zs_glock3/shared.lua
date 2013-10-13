-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Glock"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 1
	SWEP.ViewModelFOV = 68
	SWEP.SlotPos = 6
	SWEP.IconLetter = "c"
	killicon.AddFont( "weapon_zs_glock3", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.Glock_Slide", rel = "", pos = Vector(-3.116, -2.368, -0.486), angle = Angle(1.274, -4.382, 76.323), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.482, 0.46, -0.691), angle = Angle(0, 0, 180), size = Vector(0.474, 0.474, 0.474), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_glock18.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_glock18.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 14.5
SWEP.Primary.NumShots		= 3
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 28
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.MaxAmmo			    = 100
SWEP.WalkSpeed = 200

SWEP.ConeMoving = 0.061
SWEP.Cone = 0.041
SWEP.ConeIron = 0.035
SWEP.ConeCrouching = 0.024
SWEP.ConeIronCrouching = 0.016

SWEP.IronSightsPos = Vector(-5.781, -13.466, 2.92)
SWEP.IronSightsAng = Vector(0.275, 0, 0)

SWEP.OverridePos = Vector(1.159, -0.913, 1.84)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(1.159, -0.913, 1.84)
--SWEP.IronSightsAng = Vector(0, 0, 0)
