AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medkit"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false

	SWEP.NoHUD = true
		
	killicon.AddFont( "weapon_zs_medkit", "CSKillIcons", "F", Color(255, 255, 255, 255 ) )
	
end
SWEP.UseHands = true
SWEP.ViewModel				= Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_medkit.mdl" )


SWEP.Base = "weapon_zs_base_dummy"

SWEP.Primary.Delay = 0.01

SWEP.Primary.Heal = 10
SWEP.Primary.HealDelay = 10
SWEP.Primary.ClipSize = 100
SWEP.Primary.Ammo = "Battery"
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 10
SWEP.Secondary.HealDelay = 20

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = SPEED_LIGHT

SWEP.NoMagazine = true

SWEP.HoldType = "slam"

SWEP.NoDeployDelay = true

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
	if (self:GetNextCharge() > CurTime()) then return end

	if self:CanSecondaryAttack() then
		local owner = self.Owner
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 95 then
			local ent = self.Owner:GetEyeTrace().Entity

		-- local ent = owner:MeleeTrace(32, 2).Entity
			if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then
			local health, maxhealth = ent:Health(), ent:GetMaximumHealth()
			
				if (owner:GetPerk("medic_overheal")) then
					maxhealth = maxhealth * 1.1
				end					
				local multiplier = 1.0
						
				if owner.DataTable["ShopItems"][48] then
					multiplier = multiplier + 0.2
				end		
				
				local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Primary.Heal * multiplier, maxhealth - health)))
				local totake = math.ceil(toheal / multiplier)				
				if toheal > 0 then
					self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Owner:SetAnimation(PLAYER_ATTACK1)						
					local delay = self.Primary.HealDelay
					if owner.DataTable["ShopItems"][48] then
						delay = math.Clamp(self.Primary.HealDelay - 1.5,0,self.Primary.HealDelay)
					end
					
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 15)
						skillpoints.AddSkillPoints(owner,toheal or 15)
						ent:FloatingTextEffect2( toheal or 15, owner )
						owner:AddXP(toheal*2 or 5)
						
						self:TakeCombinedPrimaryAmmo(totake)
						if owner:GetPerk("medic_reward") then
							skillpoints.AddSkillPoints(owner,toheal*0.4 or 15)		
							toheal = toheal + toheal * 1.15
						end	
						
						if (owner:GetPerk("Medic")) then
							toheal = toheal + (toheal * (owner:GetRank()*0.03))
						end							
						
						--log.PlayerOnPlayerAction( self.Owner, ent, "heal_other", {["amount"] = (toheal or 10)})
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
	if (self:GetNextCharge() > CurTime()) then return end

	if self:CanSecondaryAttack() then
		local health, maxhealth = owner:Health(), owner:GetMaximumHealth()
		
		local multiplier = 1
		
		local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
		local totake = math.ceil(toheal / multiplier)
		
		if toheal > 0 then
		
			local delay = self.Secondary.HealDelay

			self:SetNextCharge(CurTime() + delay)
			owner.NextMedKitUse = self:GetNextCharge()
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Owner:SetAnimation(PLAYER_ATTACK1)				
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
		return false
	end
	
	return true
end