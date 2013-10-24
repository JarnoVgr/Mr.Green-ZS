AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 54
	--[[SWEP.BobScale = 2
	SWEP.SwayScale = 1.5]]
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
	
	SWEP.NoHUD = true
		
	killicon.AddFont( "weapon_zs_medkit", "CSKillIcons", "F", Color(255, 255, 255, 255 ) )
	
end

SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_medkit.mdl"

SWEP.Base = "weapon_zs_base_dummy"

SWEP.Primary.Delay = 0.01

SWEP.Primary.Heal = 15
SWEP.Primary.HealDelay = 10

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "Battery"

SWEP.Secondary.Delay = 0.01

SWEP.Secondary.Heal = 10
SWEP.Secondary.HealDelay = 20

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = 200

SWEP.NoMagazine = true

SWEP.HoldType = "slam"

SWEP.NoDeployDelay = true

--[[function SWEP:InitializeClientsideModels()
end]]

function SWEP:OnInitialize()
	if not SERVER then
		return
	end
	
	self.Weapon.FirstSpawn = true
end

--[[function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		--self:SendWeaponAnim(ACT_VM_IDLE)
	end
end]]

util.PrecacheSound("items/medshot4.wav")
util.PrecacheSound("items/medshotno1.wav")
util.PrecacheSound("items/smallmedkit1.wav")
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		if SERVER then
			self.Owner:EmitSound("items/medshotno1.wav")	
		end

		return
	end

	local owner = self.Owner
	
	local trace = self.Owner:GetEyeTrace()
	--Check distance
	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 80 then
		return
	end

	local ent = self.Owner:GetEyeTrace().Entity

	--Several checks for guy to heal
	if not ent:IsValid() or not ent:IsPlayer() or not ent:Alive() or not ent:Team() == TEAM_HUMAN then
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
					
	self:SetNextCharge(CurTime() + delay)
	owner.NextMedKitUse = self:GetNextCharge()
		
	if not SERVER then
		return
	end
	
	owner.HealingDone = owner.HealingDone + (toheal or 10)
	skillpoints.AddSkillPoints(owner,toheal or 10)
	ent:FloatingTextEffect( toheal or 10, owner )
	owner:AddXP(toheal or 5)
						
	--log.PlayerOnPlayerAction( self.Owner, ent, "heal_other", {["amount"] = (toheal or 10)})

	self:TakeCombinedPrimaryAmmo(totake)

	ent:SetHealth(health + toheal)
	ent:EmitSound("items/medshot4.wav")

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

	--self.IdleAnimation = CurTime() + self:SequenceDuration()
	timer.Simple( self:SequenceDuration(), function() if ( !IsValid( self ) ) then return end self:SendWeaponAnim( ACT_VM_IDLE ) end )
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then
		if SERVER then
			self.Owner:EmitSound("items/medshotno1.wav")
		end

		return
	end


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
	
	--	
	self:SetNextCharge(CurTime() + delay)
	owner.NextMedKitUse = self:GetNextCharge()
			
	self:TakeCombinedPrimaryAmmo(totake)

	if SERVER then	
		--log.PlayerAction( self.Owner, "heal_self", {["amount"] = toheal})
	
		owner:SetHealth(health + toheal)
		
		owner:EmitSound("items/smallmedkit1.wav")
	end

	--
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	--self.IdleAnimation = CurTime() + self:SequenceDuration()
	timer.Simple( self:SequenceDuration(), function() if ( !IsValid( self ) ) then return end self:SendWeaponAnim( ACT_VM_IDLE ) end )
end
	
--[[function SWEP:OnDeploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self:SendWeaponAnim(ACT_VM_IDLE)
end]]

function SWEP:SetNextCharge(tim)
	self:SetDTFloat(0, tim)
end

function SWEP:GetNextCharge()
	return self:GetDTFloat(0)
end

if CLIENT then
	local texGradDown = surface.GetTextureID("VGUI/gradient_down")
	function SWEP:DrawHUD()
		local wid, hei = ScaleW(150), ScaleH(33)
		local space = 12+ScaleW(7)
		local x, y = ScrW() - wid - 12, ScrH() - ScaleH(73) - 12
		y = y + ScaleH(73)/2 - hei/2
		surface.SetFont("ssNewAmmoFont13")
		local tw, th = surface.GetTextSize("Medical Kit")
		local texty = y + hei/2 
		
		surface.SetDrawColor( 0, 0, 0, 150)
		
		surface.DrawRect(x, y, wid, hei)
		surface.DrawRect(x+3, y+3, wid-6, hei-6)

		local timeleft = self:GetNextCharge() - CurTime()
		if 0 < timeleft then
			surface.SetDrawColor(255, 255, 255, 180)
			surface.SetTexture(texGradDown)
			surface.DrawTexturedRect(x+3, y+3, math.min(1, timeleft / math.max(self.Primary.HealDelay, self.Secondary.HealDelay)) * (wid-6), hei-6)
		end

		-- surface.SetDrawColor(255, 0, 0, 180)
		-- surface.DrawOutlinedRect(x, y, wid, hei)

		-- draw.SimpleText("Medical Kit", "ZSHUDFontSmall", x, texty, COLOR_GREEN, TEXT_ALIGN_LEFT)

		local charges = self:GetPrimaryAmmoCount()
		if charges > 0 then
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		else
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, COLOR_DARKRED, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
	end
end

function SWEP:CanPrimaryAttack()
	local owner = self.Owner
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextCharge(CurTime() + 0.75)
		owner.NextMedKitUse = self:GetNextCharge()
		--self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		--owner.NextMedKitUse = self:GetNextPrimaryFire()
		return false
	end
	
	return --[=[self:GetNextCharge() <= CurTime() and]=] (owner.NextMedKitUse or 0) <= CurTime()
end

function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	if self.Weapon.FirstSpawn then
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
	end	
	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end
