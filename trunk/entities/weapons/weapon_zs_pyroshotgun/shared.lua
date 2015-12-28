-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Dragon's Breath"			
	SWEP.Author	= "Pufulet"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	SWEP.ViewModelFlip = true
	SWEP.FlipYaw = true
	SWEP.IconLetter = "v"
	killicon.AddFont("weapon_zs_pyroshotgun", "CSKillIcons", SWEP.IconLetter, Color(255, 200, 200, 255 ))
	SWEP.ViewModelFOV = 60
	
SWEP.VElements = {

	["PyroShotgun7"] = { type = "Model", model = "models/Items/AR2_Grenade.mdl", bone = "v_weapon.galil", rel = "PyroShotgun4", pos = Vector(-1.147, -17.821, -18.261), angle = Angle(136.11, 93.406, -0.239), size = Vector(1.462, 0.681, 0.771), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_radiostation/metal_truss", skin = 0, bodygroup = {} },
	["PyroShotgun8"] = { type = "Model", model = "models/props_interiors/pot02a.mdl", bone = "v_weapon.bolt", rel = "", pos = Vector(-0.21, 0.308, -0.754), angle = Angle(0.407, 141.466, -0.398), size = Vector(0.143, 0.181, 0.882), color = Color(255, 117, 0, 255), surpresslightning = false, material = "models/props_animated_breakable/smokestack/brickwall002a", skin = 0, bodygroup = {} },
	["PyroShotgun"] = { type = "Model", model = "models/props_combine/suit_charger001.mdl", bone = "v_weapon.galil", rel = "", pos = Vector(0.238, -0.046, 1.516), angle = Angle(0, -0.779, -180), size = Vector(0.146, 0.146, 0.146), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PyroShotgun10"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.galil", rel = "PyroShotgun", pos = Vector(0.544, -0.817, -11.15), angle = Angle(0.939, -5.657, -1.66), size = Vector(0.048, 0.098, 0.064), color = Color(255, 103, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PyroShotgun9"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.bolt", rel = "PyroShotgun8", pos = Vector(-0.16, 0.171, 1.08), angle = Angle(2.121, -180, 10.805), size = Vector(0.308, 0.308, 0.308), color = Color(255, 157, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["PyroShotgun3"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "v_weapon.galil", rel = "PyroShotgun", pos = Vector(-0.357, 1.25, -19.048), angle = Angle(179.531, 2.026, 180), size = Vector(0.026, 0.025, 0.236), color = Color(255, 28, 0, 255), surpresslightning = false, material = "models/effects/vortshield", skin = 0, bodygroup = {} }
}



SWEP.WElements = {
	["PyroShotgun7"] = { type = "Model", model = "models/Items/AR2_Grenade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23.172, -0.127, -7.775), angle = Angle(10.336, -180, -63.396), size = Vector(1.985, 1.009, 1.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_radiostation/metal_truss", skin = 0, bodygroup = {} },
	--["PyroShotgun3"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.101, 1.039, -4.547), angle = Angle(74.075, -49.332, -129.851), size = Vector(0.032, 0.032, 0.115), color = Color(255, 28, 0, 255), surpresslightning = false, material = "models/effects/vortshield", skin = 0, bodygroup = {} },
	["PyroShotgun"] = { type = "Model", model = "models/props_combine/suit_charger001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.874, 0.948, -4.139), angle = Angle(-13.379, -96.417, -100.057), size = Vector(0.116, 0.116, 0.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PyroShotgun10"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.057, 1.598, -5.013), angle = Angle(-180, 90.914, -100.662), size = Vector(0.043, 0.092, 0.048), color = Color(255, 103, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

	SWEP.ViewModelBoneMods = {
		["v_weapon.bolt"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.magazine"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.galil", rel = "", pos = Vector(0.317, -2.356, -7.257), angle = Angle(87.903, 90, 0), size = Vector(0.5, 0.5, 1.238), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(26.448, 0, -5.019), angle = Angle(84.732, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_galil.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_galil.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("weapons/galil/galil-1.wav")
SWEP.Primary.Recoil			= 2.3
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 4
SWEP.Primary.ClipSize		= 28
SWEP.Primary.Delay			= 0.44
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "alyxgun"
 SWEP.TracerName = "AirboatGunHeavyTracer"
SWEP.HumanClass = "pyro"

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

function SWEP:EmitFireSound()
	self:TakePrimaryAmmo(3);
	self:EmitSound(self.Primary.Sound, 90, math.random(75,80))
end

SWEP.WalkSpeed = (SPEED_SHOTGUN + 7)
SWEP.MaxBulletDistance 		= 2750 

SWEP.Cone = 0.11
SWEP.ConeMoving = SWEP.Cone *1.1
SWEP.ConeCrouching = SWEP.Cone *0.95
SWEP.ConeIron = SWEP.Cone *0.85
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.85
SWEP.ConeIronMoving = SWEP.ConeMoving *0.85

SWEP.IronSightsPos = Vector(-6.361, -14.29, 2.519)
SWEP.IronSightsAng = Vector(0, 0, 0)