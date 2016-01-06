AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 01"
	SWEP.Slot = 4
	SWEP.SlotPos = 0
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	SWEP.IgnoreThumbs = true
	killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(120, 255, 255, 255 ) )
end

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Base = "weapon_zs_base"
SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 16
SWEP.Primary.Delay 			= 0.15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo 			= "Battery"
SWEP.Secondary.Delay 		= 0.01
SWEP.Secondary.Heal 		= 5
SWEP.Secondary.HealDelay 	= 10
SWEP.UseHands = true

SWEP.Cone = 0.04
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
SWEP.WalkSpeed = SPEED_PISTOL
SWEP.HoldType = "pistol"
SWEP.HumanClass = "medic"

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

function SWEP:SecondaryAttack()
	if (self:GetNextCharge() > CurTime()) then return end

	if self:CanSecondaryAttack() then
		local owner = self.Owner
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 1024 then		
		local ent = self.Owner:GetEyeTrace().Entity
			owner:SetAnimation( PLAYER_ATTACK1 )
			if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then

				local health, maxhealth = ent:Health(), ent:GetMaximumHealth()
				
				if (owner:GetPerk("medic_overheal")) then
					maxhealth = maxhealth * 1.1
				end			
				
				local multiplier = 1.0
				if owner.DataTable["ShopItems"][48] then
					multiplier = multiplier + 0.2
				end		
				
				local toheal 
				
				local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
				local totake = math.ceil(toheal / multiplier)
				if toheal > 0 then
					
					local delay = self.Secondary.HealDelay
					
					if owner.DataTable["ShopItems"][48] then
						delay = math.Clamp(self.Secondary.HealDelay - 1.5,0,self.Secondary.HealDelay)
					end
								
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Owner:SetAnimation(PLAYER_ATTACK1)	
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 14)
						skillpoints.AddSkillPoints(owner,toheal or 14)
						ent:FloatingTextEffect2( toheal or 14, owner )
						owner:AddXP(toheal*3 or 5)
						self:TakeCombinedPrimaryAmmo(totake)
						if owner:GetPerk("medic_reward") then
							skillpoints.AddSkillPoints(owner,toheal*0.4 or 15)		
							toheal = toheal + toheal * 1.15
						end

						if (owner:GetPerk("Medic")) then
							toheal = toheal + (toheal * (owner:GetRank()*0.03))
						end						

						ent:SetHealth(health + toheal)
						ent:EmitSound(Sound("items/medshot4.wav"),80,115)
						
						if math.random(7) == 7 then
							if VoiceSets[owner.VoiceSet] then
								local snd = VoiceSets[owner.VoiceSet].HealSounds or {}
								local toplay = snd[math.random(1, #snd)]
								if toplay then
									owner:EmitSound(toplay)
								end
							end
						end
					end
					self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
					owner:SetAnimation( PLAYER_ATTACK1 )
					self.IdleAnimation = CurTime() + self:SequenceDuration()
				end
			elseif ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
				if (self:GetPrimaryAmmoCount() >= 10) then
					self:TakeCombinedPrimaryAmmo(10)
					ent:EmitSound(Sound("items/medshot4.wav"),80,90)	
					ent:SetColor(Color(10,245,10))		
					self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Owner:SetAnimation(PLAYER_ATTACK1)						
					if (SERVER) then	
						ent:TakeDamageOverTime(8, 1, 5 ,self.Owner,self)							
					end					
					self:SetNextCharge(CurTime() + 10)
				end
			end
		end
	else
		if SERVER then
			self.Owner:EmitSound(Sound("items/medshotno1.wav"))
		end
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
		self:DrawCrosshair()	
		local wid, hei = ScaleW(150), ScaleH(33)
		local space = 12+ScaleW(7)
		local x, y = ScrW() - wid - 200, ScrH() - ScaleH(73) - 6
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
			surface.DrawTexturedRect(x+3, y+3, math.min(1, timeleft / math.max(self.Secondary.HealDelay, self.Secondary.HealDelay)) * (wid-6), hei-6)
		end
	end
end

function SWEP:CanSecondaryAttack()
	local owner = self.Owner
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextCharge(CurTime() + 0.75)
		return false
	end
	
	return true --[=[self:GetNextCharge() <= CurTime() and]=]-- (owner.NextMedKitUse or 0) <= CurTime()
end