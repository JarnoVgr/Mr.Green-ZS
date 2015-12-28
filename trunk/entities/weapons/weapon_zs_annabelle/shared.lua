AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Annabelle"
	SWEP.Author	= "Pufulet"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 60
	
SWEP.ViewModelBoneMods = {
	["v_weapon.xm1014_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, -0.018, 0), angle = Angle(0, 0, 0) },
	["v_weapon.xm1014_Shell"] = { scale = Vector(3, 3, 3), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.509, 0), angle = Angle(0, 0, 0) }
}
	SWEP.IronSightsPos = Vector(-6.72, -10.947, 3.599)
	SWEP.IronSightsAng = Vector(0, 0, 0)

	SWEP.VElements = {
		["Annabelle Shells"] = { type = "Model", model = "models/Items/Flare.mdl", bone = "v_weapon.xm1014_Shell", rel = "", pos = Vector(0, 1.437, 0), angle = Angle(143.281, 22.684, -93.509), size = Vector(0.208, 0.208, 0.208), color = Color(255, 255, 0, 255), surpresslightning = false, material = "models/player/shared/ice_player", skin = 0, bodygroup = {} },
		["Annabelle"] = { type = "Model", model = "models/weapons/w_annabelle.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(1.057, -3.066, -13.523), angle = Angle(83.584, -89.225, -2.462), size = Vector(1.011, 0.898, 0.805), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}


	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_musket", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.IronSightsPos = Vector(-6.441, -12.207, 3.319)
SWEP.IronSightsAng = Vector(-1.3, 1.065, 4.887)

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.HumanClass = "sharpshooter"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"
SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 80
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 2
SWEP.Primary.Delay			= 0.7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.ReloadDelay	= 0.40

SWEP.Cone = 0.05
SWEP.ConeMoving = SWEP.Cone *1.5
SWEP.ConeCrouching = SWEP.Cone *0.6
SWEP.ConeIron = SWEP.Cone *0.1
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.1

SWEP.WalkSpeed = SPEED_RIFLE

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.Secondary.Delay = 0.5
function SWEP:Reload()
	if self.reloading then return end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		--self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
	end

	self:SetIronsights(false)
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)
		
		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
        self:EmitSound("Weapon_Shotgun.Reload")		
		
		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self.nextreloadfinish = 0
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end

function SWEP:OnDeploy()
	if self.Owner:GetPerk("sharpshooter_double") then
		self.Primary.ClipSize = 4
	
	end
end

function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel(self.ViewModel)
end