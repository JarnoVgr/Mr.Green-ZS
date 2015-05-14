AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 01"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
		
	SWEP.VElements = {
		["MedicPistol3"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.clip", rel = "", pos = Vector(0.075, -1.788, -0.742), angle = Angle(-92.993, -10.379, 84.253), size = Vector(0.307, 0.256, 0.439), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["MedicPistol2"] = { type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.052, 1.57, -2.141), angle = Angle(-3.086, -5.483, 92.481), size = Vector(0.174, 0.174, 0.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["MedicPistol"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(-0.021, 0, -0.219), angle = Angle(-0.359, 93.147, -180), size = Vector(0.495, 0.495, 0.495), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["MedicPistol2"] = { type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.194, 1.485, -2.609), angle = Angle(0.536, -2.589, 97.573), size = Vector(0.209, 0.175, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["MedicPistol"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.434, 1.835, -3.415), angle = Angle(-98.016, -5.217, 0), size = Vector(0.625, 0.625, 0.625), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

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
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 16
SWEP.Primary.Delay = 0.15
SWEP.Primary.DefaultClip	= 64
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo = "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 6
SWEP.UseHands = true

SWEP.Cone = 0.038
SWEP.ConeMoving = SWEP.Cone *1.12
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9

SWEP.WalkSpeed = SPEED_PISTOL
SWEP.HoldType = "pistol"

SWEP.IronSightsPos = Vector(-5.52, -12.15, 2.859)
SWEP.IronSightsAng = Vector(0, 0, 0)


function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(150,155))
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
	if self:CanSecondaryAttack() then
		local owner = self.Owner
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 1024 then
			local ent = self.Owner:GetEyeTrace().Entity

		-- local ent = owner:MeleeTrace(32, 2).Entity
			if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then

				local health, maxhealth = ent:Health(), 100-- owner:GetMaxHealth()
				local multiplier = 1.0

				if owner:GetPerk("_medupgr1" ) then
					multiplier = 1.3
				end
				local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
				local totake = math.ceil(toheal / multiplier)
				if toheal > 0 then
					
					local delay = self.Secondary.HealDelay
					
					if owner.DataTable["ShopItems"][48] then
						delay = math.Clamp(self.Secondary.HealDelay - 1.5,0,self.Secondary.HealDelay)
						multiplier = multiplier + 0.2
					end
					
					if owner.GetPerk("_medic") then
						multiplier = multiplier + multiplier*((5*owner.GetRank())/100)
					end					
					
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 14)
						skillpoints.AddSkillPoints(owner,toheal or 14)
						ent:FloatingTextEffect( toheal or 14, owner )
						owner:AddXP(toheal*3 or 5)
						
						--log.PlayerOnPlayerAction( self.Owner, ent, "heal_other", {["amount"] = (toheal or 10)})
						
						self:TakeCombinedPrimaryAmmo(totake)

						ent:SetHealth(health + toheal)
						ent:EmitSound(Sound("items/medshot4.wav"),80,115)
						
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
					-- end
					-- self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

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

		local charges = self:GetPrimaryAmmoCount()
		if charges > 0 then
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		else
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, COLOR_DARKRED, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
	end
end



function SWEP:CanSecondaryAttack()
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

