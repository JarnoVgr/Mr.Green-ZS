AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medigun"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
		
	SWEP.VElements = {
	["battery"] = { type = "Model", model = "models/items/battery.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -1.558, -3.636), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["silencer1"] = { type = "Model", model = "models/gibs/manhack_gib03.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -5, 0.518), angle = Angle(90, -64.287, -31.559), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["silencer"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -3.401, -1.558), angle = Angle(0, 153.117, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -3.401, -12.988), angle = Angle(90, 52.597, 0), size = Vector(0.699, 0.899, 0.899), color = Color(0, 255, 0, 255), surpresslightning = false, material = "phoenix_storms/white_brushes", skin = 0, bodygroup = {} },
	["front+"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -3.401, -11.9), angle = Angle(90, -57.273, 0), size = Vector(0.699, 0.899, 0.899), color = Color(0, 249, 0, 255), surpresslightning = false, material = "phoenix_storms/smallwheel", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
	["front+"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.519, -5.901, 16.104), angle = Angle(80.649, 94.675, 92.337), size = Vector(0.6, 1, 1), color = Color(0, 255, 0, 255), surpresslightning = false, material = "phoenix_storms/smallwheel", skin = 0, bodygroup = {} },
	["front"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.519, -5.901, 16.104), angle = Angle(80.649, 90, 0.87), size = Vector(0.6, 1, 1), color = Color(0, 255, 0, 255), surpresslightning = false, material = "phoenix_storms/white_brushes", skin = 0, bodygroup = {} },
	["front+++"] = { type = "Model", model = "models/gibs/manhack_gib03.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.558, -4.676, 3.635), angle = Angle(-82.987, -29.222, -106.364), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front++++"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.7, -2.597, 6.752), angle = Angle(-5.844, 90, -180), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front++"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.5, -4.676, 6.752), angle = Angle(0, 0, 171.817), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}		
		
	-- SWEP.IgnoreBonemerge = true
	-- SWEP.UseHL2Bonemerge = true
	--SWEP.ShowViewModel = true
	--SWEP.AlwaysShowViewModel = true
	--SWEP.ShowWorldModel = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true
	

	SWEP.IconLetter = "d"		
	killicon.AddFont( "weapon_zs_medigun", "CSKillIcons", SWEP.IconLetter, Color(120, 255, 255, 255 ) )
	
end

SWEP.ViewModel = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"

SWEP.Base = "weapon_zs_base"
SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay = 0.17
SWEP.Primary.DefaultClip	= 80
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo = "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 6
SWEP.UseHands = true
SWEP.Cone = 0.05
SWEP.ConeMoving = SWEP.Cone *1.12
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9

SWEP.WalkSpeed = SPEED_LIGHT
SWEP.HoldType = "smg"


function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 60, math.random(140,150))
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
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 512 then
			local ent = self.Owner:GetEyeTrace().Entity

		-- local ent = owner:MeleeTrace(32, 2).Entity
			if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then

				local health, maxhealth = ent:Health(), 100-- owner:GetMaxHealth()
				local multiplier = 1.0

				if owner:GetPerk("_medupgr1" ) then
					multiplier = 1.35
				end
				local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
				local totake = math.ceil(toheal / multiplier)
				if toheal > 0 then
					
					local delay = self.Secondary.HealDelay
					if owner:GetSuit() == "medicsuit" then
						delay = math.Clamp(self.Secondary.HealDelay - 1.6,0,self.Secondary.HealDelay)
						multiplier = 1.45
					end
					
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 14)
						skillpoints.AddSkillPoints(owner,toheal or 14)
						ent:FloatingTextEffect( toheal or 14, owner )
						owner:AddXP(toheal or 5)
						
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


function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	if self.Weapon.FirstSpawn then
		self.Weapon.FirstSpawn = false
		if NewOwner:GetPerk("_medupgr2") then
			NewOwner:GiveAmmo( 70, self:GetSecondaryAmmoTypeString() )
		end
	else
		if self.Ammunition then
			self:TakePrimaryAmmo ( self:Clip1() - self.Ammunition )
		end
	
		NewOwner:RemoveAmmo ( 1500, self:GetSecondaryAmmoTypeString() )
		if self.Weapon.RemainingAmmunition then
			NewOwner:GiveAmmo( self.Weapon.RemainingAmmunition or self.Secondary.DefaultClip, self:GetPrimaryAmmoTypeString() )
		end
	end	
	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end
