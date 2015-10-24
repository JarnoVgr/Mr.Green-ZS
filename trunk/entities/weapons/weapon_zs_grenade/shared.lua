AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Grenade"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
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
SWEP.HumanClass = "commando"
SWEP.Base = "weapon_zs_base_dummy"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.TotalDamage = "~450-500"
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.Delay = 2

SWEP.HoldType = "grenade"

SWEP.Secondary.ClipSize = 4
SWEP.Secondary.DefaultClip = 4
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = SPEED_LIGHT

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:Precache()
	util.PrecacheSound("WeaponFrag.Throw")
	util.PrecacheSound("WeaponFrag.Roll")
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

function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	if self.Weapon.FirstSpawn then
		self.Weapon.FirstSpawn = false	
	
	--if self.Owner:GetPerk("_plankamount") then
	if self.Owner:GetPerk("commando_grenadier") then
		self.Weapon:SetClip1( 6 ) 	
	end
	
	end
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
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
end


function SWEP:SecondaryAttack()
local owner = self.Owner

	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	if not self:CanPrimaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	
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
				phys:SetVelocityInstantaneous(self.Owner:GetAimVector() * 300)
			end
		end
	end

	self:TakePrimaryAmmo(1)
	self.NextDeploy = CurTime() + 1.5

	self:SendWeaponAnim(ACT_VM_THROW)
	owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:PrimaryAttack()
local owner = self.Owner

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
