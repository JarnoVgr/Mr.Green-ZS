if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.PrintName = "mine"
end

if ( CLIENT ) then
	SWEP.PrintName = "Combat Grenade"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	killicon.AddFont( "weapon_zs_grenade", "HL2MPTypeDeath", "4", Color(255, 255, 255, 255 ) )
	
	function SWEP:DrawHUD()
		MeleeWeaponDrawHUD()
	end
end


SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.TotalDamage = "~300-350"
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.Delay = 3

SWEP.HoldType = "grenade"

SWEP.Secondary.ClipSize = 3
SWEP.Secondary.DefaultClip = 3
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = 205

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["grenade"] = { type = "Model", model = "models/Weapons/w_grenade.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0, -0.082, 3.581), angle = Angle(0, -139.025, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	self.WElements = {} 
	
end

function SWEP:Precache()
	util.PrecacheSound("WeaponFrag.Throw")
end


function SWEP:CanPrimaryAttack()
	if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end

	if self:Clip1() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:OnDeploy()

	self.NextDeploy = CurTime() + 0.025

end

function SWEP:OnHolster()

	self.NextDeploy = nil
	
end



function SWEP:Think()
	if SERVER then
		local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
		if 0 < ammocount then
			self:SetClip1(ammocount + self:Clip1())
			self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
		end

		if self.NextDeploy and self.NextDeploy < CurTime() then
			if 0 < self:Clip1() then
				self:SendWeaponAnim(ACT_VM_DRAW)
			else
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			end
		end
	end	
	
	if CLIENT then
		if not self.VElements then return end
		if util.tobool(GetConVarNumber("_zs_clhands")) then
			self.VElements["grenade"].color = Color(255,255,255,255)
		else
			self.VElements["grenade"].color = Color(255,255,255,0)
		end
		
	end
	
end


function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self.Owner
	if SERVER then
		local ent = ents.Create("projectile_zsgrenade")
		if IsValid(ent) then
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent:Spawn()
			ent:Activate()
			ent:EmitSound("WeaponFrag.Throw")
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 5)
				phys:SetVelocityInstantaneous(self.Owner:GetAimVector() * 800)
			end
		end
	end

	self:TakePrimaryAmmo(1)
	self.NextDeploy = CurTime() + 1.5

	self:SendWeaponAnim(ACT_VM_THROW)
	owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Reload()
return false
end
function SWEP:SecondaryAttack()
	return false
end 