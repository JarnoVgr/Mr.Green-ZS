-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Magnum"
	killicon.AddFont( "weapon_zs_magnum", "HL2MPTypeDeath", ".",Color(255, 255, 255, 255 ) )
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "Python", rel = "", pos = Vector(0, -2.645, -3.49), angle = Angle(90, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.497, 0.989, -2.882), angle = Angle(0, 0, 180), size = Vector(0.356, 0.356, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end
SWEP.HumanClass = "sharpshooter"
SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_357.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_357.mdl" )

SWEP.Weight				= 2
SWEP.Slot = 1
SWEP.Type = "Pistol"

SWEP.HoldType = "revolver"

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 47
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.52
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.ConeMax = 0.1
SWEP.ConeMin = 0.035

SWEP.IronSightsPos = Vector(-4.59,25,0.65)
SWEP.IronSightsAng = Vector( 0, 0, 0 )

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	attacker.RicochetBullet = true
	attacker:FireBullets({Num = 1, Src = hitpos, Dir = 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "rico_trace", Force = damage * 0.15, Damage, Callback = GenericBulletCallback})
	attacker.RicochetBullet = nil
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER and tr.HitWorld and not tr.HitSky then
		timer.Simple(0, function()
			DoRicochet( attacker, tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 2)
		end)
	end

	GenericBulletCallback(attacker, tr, dmginfo)
end


