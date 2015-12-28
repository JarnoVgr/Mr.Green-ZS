AddCSLuaFile()

SWEP.Base = "weapon_zs_medi_base"

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 04"

	SWEP.VElements = {
		["pyrorifle3"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.094, -4.303, 24.413), angle = Angle(-0.42, -1.201, -179.42), size = Vector(0.303, 0.31, 1.575), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pyrorifle2"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.583, -0.942, 17.603), angle = Angle(180, 180, -180), size = Vector(0.068, 0.079, 0.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["pyrorifle1"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.243, -0.675, 2.976), angle = Angle(0.939, 89.924, -91.034), size = Vector(0.238, 0.217, 0.092), color = Color(0, 255, 0, 255), surpresslightning = true, material = "models/combine_dropship/combine_fenceglow", skin = 0, bodygroup = {} },
		--["pyrorifle5"] = { type = "Model", model = "models/props_combine/health_charger001.mdl", bone = "v_weapon.magazine", rel = "", pos = Vector(-0.699, -1.203, 0.25), angle = Angle(0.799, 0, 88.424), size = Vector(0.2, 0.131, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pyrorifle4"] = { type = "Model", model = "models/props/cs_assault/wirepipe.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "pyrorifle3", pos = Vector(0.421, -2.392, 15.286), angle = Angle(71.436, -55.73, 144.425), size = Vector(0.063, 0.014, 0.014), color = Color(0, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["pyrorifle3"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0.953, -7.554), angle = Angle(-99.564, 3.006, 2.368), size = Vector(0.303, 0.31, 1.575), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pyrorifle2"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.545, 1.409, -3.692), angle = Angle(1.725, -90.358, 82.495), size = Vector(0.068, 0.079, 0.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["pyrorifle5"] = { type = "Model", model = "models/props_combine/health_charger001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.918, 0.239, 0.136), angle = Angle(1.69, -93.728, 2.203), size = Vector(0.215, 0.215, 0.215), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true
	

	SWEP.IconLetter = "v"		
	killicon.AddFont( "weapon_zs_medigun", "CSKillIcons", SWEP.IconLetter, Color(120, 255, 255, 255 ) )
	
end

SWEP.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"

SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 40
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo = "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 12
SWEP.UseHands = true
SWEP.Cone = 0.048
SWEP.ConeMoving = SWEP.Cone *1.12
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9

SWEP.WalkSpeed = SPEED_LIGHT-5
SWEP.HoldType = "ar2"
SWEP.HumanClass = "medic"

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(125,130))
end