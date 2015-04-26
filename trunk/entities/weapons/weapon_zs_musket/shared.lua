AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Musket"
	SWEP.Author	= "Pufulet"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 60
	
	SWEP.VElements = {
	["scope"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -3.636, -10.91), angle = Angle(180, 1.169, 0), size = Vector(0.4, 0.4, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["stock2"] = { type = "Model", model = "models/props_phx/gears/bevel12.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -2.597, -2), angle = Angle(0, 125.065, 0), size = Vector(0.153, 0.153, 0.153), color = Color(183, 181, 180, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
	["stock2+"] = { type = "Model", model = "models/Mechanics/gears2/pinion_20t1.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -2.8, 1), angle = Angle(115.713, 90, 90), size = Vector(0.1, 0.1, 0.1), color = Color(183, 181, 180, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
	["scope3"] = { type = "Model", model = "models/weapons/w_eq_flashbang_thrown.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -5.12, -7.7), angle = Angle(0, 129.74, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scope2"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -2.401, -13), angle = Angle(90, 0, 0), size = Vector(1, 0.2, 0.14), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
	["stock"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.65, -2.597, -9.87), angle = Angle(90, 90, 90), size = Vector(0.3, 0.25, 0.3), color = Color(72, 65, 65, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}	
	
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_musket", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound = Sound("weapons/scout/scout_fire-1.wav")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 70
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 1.6

SWEP.Cone = 0.033
SWEP.ConeMoving = SWEP.Cone *1.4
SWEP.ConeCrouching = SWEP.Cone *0.7
SWEP.ConeIron = SWEP.Cone *0.80
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80

SWEP.WalkSpeed = SPEED_LIGHT

SWEP.MaxAmmo			    = 40

SWEP.Secondary.Delay = 0.5

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 120, 85)
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.145, -3.422, -0.694), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 0.944), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.6, 0.638, -4.731), angle = Angle(-11.266, 0, 0), size = Vector(0.768, 0.768, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	
	util.PrecacheModel(self.ViewModel)
end