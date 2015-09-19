if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "crossbow"
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Crossbow"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false

	SWEP.Slot = 0
	SWEP.SlotPos = 2
SWEP.ViewModelBonescales = {["Crossbow_model.bolt"] = Vector(0.009, 0.009, 0.009)}
SWEP.VElements = {
	["bolts"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "Crossbow_model.bolt", pos = Vector(-0.062, -0.051, 4.743), angle = Angle(89.856, -25.019, 6.669), size = Vector(0.792, 0.792, 0.792), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

	
	["Crossbow2"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.bolt", rel = "", pos = Vector(0, -3.293, -11.57), angle = Angle(-178.568, -77.974, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Crossbow4"] = { type = "Model", model = "models/props_combine/tpcontroller.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0.221, -0.452, 1.164), angle = Angle(180, -91.1, -180), size = Vector(0.035, 0.009, 0.056), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Crossbow3"] = { type = "Model", model = "models/props_combine/combine_tptrack.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(-0.281, -1.247, 12.675), angle = Angle(-89.456, 5.339, -78.834), size = Vector(0.264, 0.264, 0.264), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Crossbow1"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.bolt", rel = "", pos = Vector(-0.084, -0.077, 2.605), angle = Angle(91.444, 0, 0), size = Vector(0.788, 0.788, 0.788), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}
	
	
SWEP.WElements = {
	["bolts"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", pos = Vector(16.93, -0.714, -3.914), angle = Angle(0, 10.355, -0.181), size = Vector(0.861, 0.861, 0.861), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

	
	["Crossbow2"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.246, 2.124, -6.803), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Crossbow4"] = { type = "Model", model = "models/props_combine/tpcontroller.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.69, 1.575, -2.76), angle = Angle(-89.548, 6.032, -3.393), size = Vector(0.065, 0.009, 0.065), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Crossbow3"] = { type = "Model", model = "models/props_combine/combine_tptrack.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.272, 0.257, -4.711), angle = Angle(-178.879, 9.326, 0), size = Vector(0.264, 0.264, 0.264), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Crossbow1"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.227, -0.457, -3.863), angle = Angle(1.376, 10.527, -19.451), size = Vector(0.898, 0.898, 1.24), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	

}
end
if CLIENT then killicon.AddFont( "weapon_zs_crossbow", "HL2MPTypeDeath", "1", Color(255, 80, 0, 255 ) ) 
killicon.AddFont( "projectile_arrow", "HL2MPTypeDeath", "1", Color(255, 80, 0, 255 ) )
end	
SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.TotalDamage = "~190-200"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = true
--SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Ammo = "pistol"
SWEP.PrimaryDelay = 4.0
SWEP.MaxAmmo			    = 22
SWEP.Slot = 5
SWEP.SecondaryDelay = 0.5

SWEP.WalkSpeed = 200

SWEP.NextZoom = 0

function SWEP:Initialize()
	self:SetWeaponHoldType("crossbow")
	self:SetDeploySpeed(1.1)
	
		    if CLIENT then
     
        self:CreateModels(self.VElements) --  create viewmodels
        self:CreateModels(self.WElements) --  create worldmodels
         
        --  init view model bone build function
        self.BuildViewModelBones = function( s )
            if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBonescales then
                for k, v in pairs( self.ViewModelBonescales ) do
                    local bone = s:LookupBone(k)
                    if (not bone) then continue end
                    local m = s:GetBoneMatrix(bone)
                    if (not m) then continue end
                    m:Scale(v)
                    s:SetBoneMatrix(bone, m)
					end
				end
			end
         end
end

if SERVER then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)

			local ent = ents.Create("projectile_arrow")
			if ent:IsValid() then
				local pl = self.Owner
				ent:SetOwner(pl)
				ent:SetPos((pl:GetShootPos()) + pl:GetAimVector() * 40)
				ent:Spawn()
				ent:Activate()
				ent:SetPhysicsAttacker(self.Owner)
				self.Weapon.Inflictor = ent

			end
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			self:TakePrimaryAmmo(1)
		end
	end

	function SWEP:Reload()
		if self:GetNextReload() <= CurTime() and self:Clip1() == 0 and 0 < self.Owner:GetAmmoCount("XBowBolt") then
			self:EmitSound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav", 50, 100)
			self:DefaultReload(ACT_VM_RELOAD)
			self:SetNextReload(CurTime() + self:SequenceDuration())
		end
	end
end

if CLIENT then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
			self:TakePrimaryAmmo(1)
		end
	end

	function SWEP:Reload()
		if self:GetNextReload() <= CurTime() and self:Clip1() == 0 and 0 < self.Owner:GetAmmoCount("XBowBolt") then
			surface.PlaySound("weapons/crossbow/bolt_load"..math.random(1,2)..".wav")
			self:DefaultReload(ACT_VM_RELOAD)
			self:SetNextReload(CurTime() + self:SequenceDuration())
		end
	end
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomin.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomout.wav")
