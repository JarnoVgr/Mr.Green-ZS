-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Magnum"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 7
	SWEP.ViewModelFlip = false

	killicon.AddFont( "weapon_zs_magnum", "HL2MPTypeDeath", ".",Color(255, 255, 255, 255 ) )
	
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "Hand", rel = "", pos = Vector(0.34, -2.938, 4.329), angle = Angle(91.225, -89.616, 0.488), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.497, 0.989, -2.882), angle = Angle(0, 0, 180), size = Vector(0.356, 0.356, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_357.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_357.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 6
SWEP.Primary.Damage			= 67
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.55
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"--?
SWEP.WalkSpeed = 200
SWEP.MaxAmmo			    = 60

SWEP.ConeMoving = 0.071
SWEP.Cone = 0.064
SWEP.ConeIron = 0.054
SWEP.ConeCrouching = 0.055
SWEP.ConeIronCrouching = 0.044

SWEP.IronSightsPos = Vector(-4.64, -9.056, 0.6)
SWEP.IronSightsAng = Vector(0.275, 0, 0)

SWEP.OverridePos = Vector(-1.481, -6.394, 1.559)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(-1.481, -6.394, 1.559)
--SWEP.IronSightsAng = Vector(0, 0, 0)

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	attacker.RicochetBullet = true
	attacker:FireBullets({Num = 1, Src = hitpos, Dir = 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "rico_trace", Force = damage * 0.15, Damage = damage * 2, Callback = GenericBulletCallback})
	attacker.RicochetBullet = nil
end
function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER and tr.HitWorld and not tr.HitSky then
		timer.Simple(0, function() DoRicochet( attacker, tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 2) end)
	end

	GenericBulletCallback(attacker, tr, dmginfo)
end


