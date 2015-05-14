AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medkit"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false


	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true
	
	SWEP.NoHUD = true
		
	killicon.AddFont( "weapon_zs_medkit", "CSKillIcons", "F", Color(255, 255, 255, 255 ) )
	
end

SWEP.WorldModel = "models/Weapons/w_package.mdl"
SWEP.ViewModel = "models/weapons/v_c4.mdl"


SWEP.Base = "weapon_zs_base_dummy"

SWEP.Primary.Delay = 0.01

SWEP.Primary.Heal = 10
SWEP.Primary.HealDelay = 7

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "Battery"

SWEP.Secondary.Delay = 0.01

SWEP.Secondary.Heal = 10
SWEP.Secondary.HealDelay = 14

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = SPEED_LIGHT

SWEP.NoMagazine = true

SWEP.HoldType = "slam"

SWEP.NoDeployDelay = true

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["v_weapon.button2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.486, 0.456, 0.785), angle = Angle(0, 0.638, 0) },
		["v_weapon.button3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.224, 3.197, -1.892) },
		["v_weapon.button6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button8"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button9"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button7"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
	self.VElements = {
		["medkit"] = { type = "Model", model = "models/items/HealthKit.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-2.849, 0.319, 1.254), angle = Angle(-93, 90, 5), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		
	}
	
	self.WElements = {
		["medkit"] = { type = "Model", model = "models/items/HealthKit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.224, 5.181, -1.887), angle = Angle(40.43, 174.731, -180), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end
util.PrecacheSound("items/medshot4.wav")
util.PrecacheSound("items/medshotno1.wav")
util.PrecacheSound("items/smallmedkit1.wav")
function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		local owner = self.Owner
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 90 then
			local ent = self.Owner:GetEyeTrace().Entity

		-- local ent = owner:MeleeTrace(32, 2).Entity
			if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then

				local health, maxhealth = ent:Health(), 100-- owner:GetMaxHealth()
				local multiplier = 1.0

				if owner:GetPerk("_medupgr1" ) then
					multiplier = 1.3
				end
				local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Primary.Heal * multiplier, maxhealth - health)))
				local totake = math.ceil(toheal / multiplier)
				if toheal > 0 then
					
					local delay = self.Primary.HealDelay
					if owner.DataTable["ShopItems"][48] then
						delay = math.Clamp(self.Primary.HealDelay - 1.5,0,self.Primary.HealDelay)
						multiplier = multiplier + 0.2
					end
					
					if owner.GetPerk("_medic") then
						multiplier = multiplier + multiplier*((5*owner.GetRank())/100)
					end
					
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 15)
						skillpoints.AddSkillPoints(owner,toheal or 15)
						ent:FloatingTextEffect( toheal or 15, owner )
						owner:AddXP(toheal*2 or 5)
						
						--log.PlayerOnPlayerAction( self.Owner, ent, "heal_other", {["amount"] = (toheal or 10)})
						
						self:TakeCombinedPrimaryAmmo(totake)

						ent:SetHealth(health + toheal)
						ent:EmitSound(Sound("items/medshot4.wav"))
						
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


					owner:SetAnimation( PLAYER_ATTACK1 )

					self.IdleAnimation = CurTime() + self:SequenceDuration()

				end
			end
		end
	else
		if SERVER then
			self.Owner:EmitSound(Sound("items/medshotno1.wav"))
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self.Owner
	if self:CanPrimaryAttack() then
		local health, maxhealth = owner:Health(), 100-- owner:GetMaxHealth()
		if owner:GetPerk("_kevlar") then maxhealth = 110 elseif owner:GetPerk("_kevlar2") then maxhealth = 120 elseif owner:GetPerk("_kevlarsupport") then maxhealth = 150 end 
		
		local multiplier = 1
		
		local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
		local totake = math.ceil(toheal / multiplier)
		
		if toheal > 0 then
		
			local delay = self.Secondary.HealDelay

			self:SetNextCharge(CurTime() + delay)
			owner.NextMedKitUse = self:GetNextCharge()
			
			self:TakeCombinedPrimaryAmmo(totake)
			if SERVER then	
			
				owner:SetHealth(health + toheal)
				
				owner:EmitSound("items/smallmedkit1.wav")
			end


			owner:SetAnimation( PLAYER_ATTACK1 )
			self.IdleAnimation = CurTime() + self:SequenceDuration()
		end
	else
		if SERVER then self.Owner:EmitSound("items/medshotno1.wav") end
	end
end
	
function SWEP:OnDeploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	--self:SendWeaponAnim(ACT_VM_IDLE)
end

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
			NewOwner:GiveAmmo( 100, self:GetPrimaryAmmoTypeString() )
			self.Weapon.FirstSpawn = false	
		end
		
		if NewOwner:GetPerk("_medic") then
			NewOwner:GiveAmmo(self.Owner:GetRank()*15, self:GetPrimaryAmmoTypeString())	
			self.Weapon.FirstSpawn = false			
		end		
	--else
	--	if self.Ammunition then
		--	self:TakePrimaryAmmo ( self:Clip1() - self.Ammunition )
		--end
	
		--NewOwner:RemoveAmmo ( 1500, self:GetPrimaryAmmoTypeString() )
		--if self.Weapon.RemainingAmmunition then
		--	NewOwner:GiveAmmo( self.Weapon.RemainingAmmunition or self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
		--end
	end	
	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end
