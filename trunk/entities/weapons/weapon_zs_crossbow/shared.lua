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
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false

	SWEP.Slot = 0
	SWEP.SlotPos = 2
SWEP.ViewModelBonescales = {["Crossbow_model.bolt"] = Vector(0.009, 0.009, 0.009)}
SWEP.VElements = {
	["bolts"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "Crossbow_model.bolt", pos = Vector(-0.062, -0.051, 4.743), angle = Angle(89.856, -25.019, 6.669), size = Vector(0.792, 0.792, 0.792), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["bolts"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", pos = Vector(16.93, -0.714, -3.914), angle = Angle(0, 10.355, -0.181), size = Vector(0.861, 0.861, 0.861), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


end
if CLIENT then killicon.AddFont( "weapon_zs_crossbow", "HL2MPTypeDeath", "1", Color(255, 80, 0, 255 ) ) 
killicon.AddFont( "projectile_arrow", "HL2MPTypeDeath", "1", Color(255, 80, 0, 255 ) )
end	
SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.TotalDamage = "~150-220"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.PrimaryDelay = 2.0
SWEP.MaxAmmo			    = 22

SWEP.SecondaryDelay = 0.5

SWEP.WalkSpeed = 150

SWEP.NextZoom = 0

function SWEP:Initialize()
	self:SetWeaponHoldType("crossbow")
	self:SetDeploySpeed(1.1)
	
		    if CLIENT then
     
        self:CreateModels(self.VElements) // create viewmodels
        self:CreateModels(self.WElements) // create worldmodels
         
        // init view model bone build function
        self.BuildViewModelBones = function( s )
            if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBonescales then
                for k, v in pairs( self.ViewModelBonescales ) do
                    local bone = s:LookupBone(k)
                    if (!bone) then continue end
                    local m = s:GetBoneMatrix(bone)
                    if (!m) then continue end
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
				ent:SetPos(pl:GetShootPos()) --+ pl:GetAimVector() * 40)
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
