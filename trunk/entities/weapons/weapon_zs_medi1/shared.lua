AddCSLuaFile()

SWEP.Base = "weapon_zs_medi_base"

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 01"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
		
	SWEP.VElements = {
		["MedicPistol3"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.clip", rel = "", pos = Vector(0.075, -1.788, -0.742), angle = Angle(-92.993, -10.379, 84.253), size = Vector(0.307, 0.256, 0.439), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["MedicPistol2"] = { type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.052, 1.57, -2.141), angle = Angle(-3.086, -5.483, 92.481), size = Vector(0.174, 0.174, 0.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["MedicPistol"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(-0.021, 0, -0.219), angle = Angle(-0.359, 93.147, -180), size = Vector(0.495, 0.495, 0.495), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["MedicPistol2"] = { type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.194, 1.485, -2.609), angle = Angle(0.536, -2.589, 97.573), size = Vector(0.209, 0.175, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["MedicPistol"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.434, 1.835, -3.415), angle = Angle(-98.016, -5.217, 0), size = Vector(0.625, 0.625, 0.625), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true
	
	killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(120, 255, 255, 255 ) )
	
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 90, math.random(110,115))
end


SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 0.9
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 14
SWEP.Primary.Delay = 0.12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Automatic		= false
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 12
SWEP.UseHands = true

SWEP.Cone = 0.04
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9

SWEP.WalkSpeed = SPEED_PISTOL
SWEP.HoldType = "pistol"

SWEP.IronSightsPos = Vector(-5.52, -12.15, 2.859)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.HumanClass = "medic"


