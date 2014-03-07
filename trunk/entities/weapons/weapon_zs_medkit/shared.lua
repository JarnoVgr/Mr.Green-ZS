AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 54
	SWEP.PrintName = "Medkit"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
		
	-- SWEP.IgnoreBonemerge = true
	-- SWEP.UseHL2Bonemerge = true
	--SWEP.ShowViewModel = true
	--SWEP.AlwaysShowViewModel = true
	--SWEP.ShowWorldModel = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	--SWEP.IgnoreBonemerge = true
	
	--SWEP.IgnoreThumbs = true
	
	--SWEP.NoHUD = true
		
	killicon.AddFont( "weapon_zs_medkit", "CSKillIcons", "F", Color(255, 255, 255, 255 ) )
	
end

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")

SWEP.Base = "weapon_zs_base_dummy"

SWEP.Primary.Delay = 0.01

SWEP.Primary.Heal = 15
SWEP.Primary.HealDelay = 10
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1

SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 10
SWEP.Secondary.HealDelay = 20
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "CombineCannon"
SWEP.Secondary.Delay = SWEP.Primary.Delay

SWEP.WalkSpeed = 200

SWEP.NoMagazine = true

SWEP.HoldType = "slam"

SWEP.NoDeployDelay = true

function SWEP:OnInitialize()
	if not SERVER then
		return
	end
	
	self.Weapon.FirstSpawn = true
end

util.PrecacheSound("items/medshot4.wav")
util.PrecacheSound("items/medshotno1.wav")
util.PrecacheSound("items/smallmedkit1.wav")
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		if SERVER then
			self.Owner:EmitSound(Sound("items/medshotno1.wav"))
		end

		return
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	local owner = self.Owner
	
	local trace = self.Owner:GetEyeTrace()

	--Check if not too far away
	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 80 then
		return
	end

	--Get trace entity
	local ent = trace.Entity

	--Several checks for guy to heal
	if not ent:IsValid() or not ent:IsPlayer() or not ent:Alive() or ent:Team() ~= TEAM_HUMAN then
		return
	end

	--Get vars
	local health, maxhealth = ent:Health(), 100

	--Set max health higher if ent has certain perks
	if ent:GetPerk("_kevlar") then
		maxhealth = 110
	elseif ent:GetPerk("_kevlar2") then
		maxhealth = 120
	end

	--Medical upgrade (multiplier)
	local multiplier = 1
	if owner:GetPerk("_medupgr1" ) then
		multiplier = 1.35
	end

	local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Primary.Heal * multiplier, maxhealth - health)))
	local totake = math.ceil(toheal / multiplier)
	if toheal <= 0 then
		return
	end

	local delay = self.Primary.HealDelay

	--Check for suit
	if owner:GetSuit() == "medicsuit" then
		delay = math.Clamp(self.Primary.HealDelay - 3,0,self.Primary.HealDelay)
	end

	if not SERVER then
		return
	end
	
	owner.HealingDone = owner.HealingDone + (toheal or 10)
	skillpoints.AddSkillPoints(owner,toheal or 10)
	ent:FloatingTextEffect( toheal or 10, owner)
	owner:AddXP(toheal or 5)

	--log.PlayerOnPlayerAction( self.Owner, ent, "heal_other", {["amount"] = (toheal or 10)})

	--self:TakeCombinedPrimaryAmmo(totake)
	self:TakePrimaryAmmo(totake)

	ent:SetHealth(health + toheal)
	ent:EmitSound(Sound("items/medshot4.wav"))

	--HERE PATCH YOURSELF UP
	if math.random(9) == 9 then
		if VoiceSets[owner.VoiceSet] then
			local snd = VoiceSets[owner.VoiceSet].HealSounds or {}
			local toplay = snd[math.random(1, #snd)]
			if toplay then
				owner:EmitSound(toplay)
			end
		end
	end
		
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then
		if SERVER then
			self.Owner:EmitSound(Sound("items/medshotno1.wav"))
		end

		return
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	--Define vars
	local owner = self.Owner
	local health, maxhealth = owner:Health(), 100-- owner:GetMaxHealth()
	
	--Check for perks
	if owner:GetPerk("_kevlar") then
		maxhealth = 110
	elseif owner:GetPerk("_kevlar2") then
		maxhealth = 120
	end
	
	--Check for medical upgrade (multiplier)
	local multiplier = 1
	if owner:GetPerk("_medupgr1") then
		multiplier = 1.35
	end
	
	--
	local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
	local totake = math.ceil(toheal / multiplier)
	if toheal <= 0 then
		return
	end
	
	--
	local delay = self.Secondary.HealDelay
	if owner:GetSuit() == "medicsuit" then
		delay = math.Clamp(self.Secondary.HealDelay - 3,0,self.Secondary.HealDelay)
	end
	
	if not SERVER then
		return
	end
			
	self:TakeCombinedPrimaryAmmo(totake)

	--log.PlayerAction( self.Owner, "heal_self", {["amount"] = toheal})
	
	owner:SetHealth(health + toheal)
		
	owner:EmitSound(Sound("items/smallmedkit1.wav"))

	--
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

SWEP.RechargeTimer = 0
function SWEP:Think()
	self.BaseClass.Think(self)

	--Set secondary ammo in clip
	local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
	if 0 < ammocount then
		self:SetClip1(ammocount + self:Clip1())
		self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
	end
	
	if SERVER then
		if not self.Owner:KeyDown(IN_ATTACK) and self.RechargeTimer < CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize then	
			--Give 1
			self.Weapon:SetClip1(math.min(self.Primary.ClipSize, self.Weapon:Clip1() + 1))
			
			--Next recharge
			self.RechargeTimer = CurTime() + 1

			print("Recharged")
		end
	end
end

function SWEP:CanPrimaryAttack()
	local owner = self.Owner
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return false
	end

	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	return true
end

function SWEP:Equip(NewOwner)
	if CLIENT then
		return
	end
	
	--[[if self.Weapon.FirstSpawn then
		self.Weapon.FirstSpawn = false
		if NewOwner:GetPerk("_medupgr2") then
			NewOwner:GiveAmmo( 70, self:GetPrimaryAmmoTypeString() )
		end
	else
		if self.Ammunition then
			self:TakePrimaryAmmo ( self:Clip1() - self.Ammunition )
		end
	
		NewOwner:RemoveAmmo ( 1500, self:GetPrimaryAmmoTypeString() )
		if self.Weapon.RemainingAmmunition then
			NewOwner:GiveAmmo( self.Weapon.RemainingAmmunition or self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
		end
	end	]]
	
	--Call this function to update weapon slot and others
	gamemode.Call("OnWeaponEquip", NewOwner, self)
end
