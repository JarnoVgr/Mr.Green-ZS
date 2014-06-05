AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 54
	SWEP.PrintName = "MedKit"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	--Hide HUD. We have a custom display
	SWEP.NoHUD = true
		
	killicon.AddFont( "weapon_zs_medkit", "CSKillIcons", "F", Color(255, 255, 255, 255 ) )
	
end

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")

SWEP.Base = "weapon_zs_base_dummy"

SWEP.Primary.Delay = 0.7
SWEP.Primary.Automatic	= true
SWEP.Primary.Heal = 10
SWEP.Primary.ClipSize = 80
SWEP.Primary.DefaultClipSize = 80
SWEP.Primary.UpgradedClipSize = 150
SWEP.Primary.DefaultClip = 80
SWEP.Primary.Ammo = "SniperRound"


SWEP.Secondary.Delay = 0.7
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Heal = 10
SWEP.Secondary.ClipSize = 80
SWEP.Secondary.DefaultClipSize = 80
SWEP.Secondary.UpgradedClipSize = 150
SWEP.Secondary.DefaultClip = 80
SWEP.Secondary.Ammo = "SniperRound"

SWEP.Secondary.Automatic	= true
SWEP.WalkSpeed = 190

SWEP.NoMagazine = true

SWEP.HoldType = "slam"

--SWEP.NoDeployDelay = true

function SWEP:OnInitialize()
	if CLIENT then
		return
	end
	
	self.Weapon.FirstSpawn = true
end

util.PrecacheSound("items/medshot4.wav")
util.PrecacheSound("items/medshotno1.wav")
util.PrecacheSound("items/smallmedkit1.wav")
function SWEP:PrimaryAttack()

localplayer = pl
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
		maxhealth = 130
	end

	--Medical upgrade (multiplier)
	local multiplier = 1
	if owner:GetPerk("_medupgr1" ) then
		--multiplier = 1.35
		skillpoints.AddSkillPoints( pl, 3)
	end

	if ValidEntity(self:GetOwner()) and self:GetOwner():GetSuit() == "medicsuit" then --Walk slower with the medsuit and  heal
			Walkspeed = 150
			Primary.DefaultClipSize = 120
			Primary.Heal = 20	
		end
	
	
	local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Primary.Heal * multiplier, maxhealth - health)))
	local totake = math.ceil(toheal / multiplier)
	if toheal <= 0 then
		return
	end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if CLIENT then
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
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then
		if SERVER then
			self.Owner:EmitSound(Sound("items/medshotno1.wav"))
		end

		return
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if CLIENT then
		return
	end

	if ValidEntity(self:GetOwner()) and self:GetOwner():GetSuit() == "medicsuit" then --Walk slower with the medsuit and  heal
			Walkspeed = 150
			Heal = 20
			DefaultClipSize = 120
		end
	
	--Define vars
	local owner = self.Owner
	local health, maxhealth = owner:Health(), 100-- owner:GetMaxHealth()
	
	--Check for perks
	if owner:GetPerk("_kevlar") then
		maxhealth = 110
	elseif owner:GetPerk("_kevlar2") then
		maxhealth = 130
	end
	
	--Check for medical upgrade (multiplier)
	local multiplier = 1
	if owner:GetPerk("_medupgr1") then
		multiplier = 1.35
	end
	
	--
	local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Primary.Heal * multiplier, maxhealth - health)))
	local totake = math.ceil(toheal / multiplier)
	if toheal <= 0 then
		return
	end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if CLIENT then
		return
	end
			
	self:TakeCombinedPrimaryAmmo(totake)

	--log.PlayerAction( self.Owner, "heal_self", {["amount"] = toheal})
	
	owner:SetHealth(health + toheal)
		
	owner:EmitSound(Sound("items/smallmedkit1.wav"))
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
			--Give 5
			self.Weapon:SetClip1(math.min(self.Primary.ClipSize, self.Weapon:Clip1() + 10))
			
			--Next recharge
			self.RechargeTimer = CurTime() + 10
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

function SWEP:Deploy()
	--Medical Pack perk
	if self.Owner:GetPerk("_medupgr2") then
		self.Weapon.Primary.ClipSize = self.Weapon.Primary.UpgradedClipSize
	else
		self.Weapon.Primary.ClipSize = self.Weapon.Primary.DefaultClipSize
	end

	--Adjust current amount if max is lower
	if self.Weapon:Clip1() > self.Weapon.Primary.ClipSize then
		self.Weapon:SetClip1(self.Weapon.Primary.ClipSize)
	end
end

function SWEP:Equip(NewOwner)
	if CLIENT then
		return
	end
	
	--Call this function to update weapon slot and others
	gamemode.Call("OnWeaponEquip", NewOwner, self)
end


if CLIENT then
	local texGradDown = surface.GetTextureID("VGUI/gradient_down")
	function SWEP:DrawHUD()
		local wid, hei = ScaleW(150), ScaleH(33)
		local x, y = ScrW() - wid - 12, ScrH() - ScaleH(73) - 12
		y = y + ScaleH(73)/2 - hei/2
		
		surface.SetDrawColor(0, 0, 0, 150)

		--Draw background box
		surface.DrawRect(x, y, wid, hei)
		surface.DrawRect(x+3, y+3, wid-6, hei-6)

		--Draw filled box based on current clipsize
		local clipFillSizePercentage = math.Clamp(self.Weapon:Clip1() / self.Primary.ClipSize, 0, 1)
		if clipFillSizePercentage > 0 then
			surface.SetDrawColor(255, 255, 255, 180)
			surface.SetTexture(texGradDown)
			surface.DrawTexturedRect(x+3, y+3, clipFillSizePercentage * (wid-6), hei-6)
		end
	end
end