AddCSLuaFile()
--Made by Duby, used some of Pufu's code and the model was created by BrainDawg
if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 03"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
	
	SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.943, 0.138), angle = Angle(0, 0, 0) },
	["v_weapon.AK47_Clip"] = { scale = Vector(0.148, 0.148, 0.148), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.AK47_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
	
		
	SWEP.VElements = {
	["MediShotgun5+"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.848, -5.488, 5.625), angle = Angle(14.109, -180, -89.084), size = Vector(0.204, 0.204, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun"] = { type = "Model", model = "models/props_interiors/BathTub01a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.057, -5.785, -4.639), angle = Angle(-93.547, 89.041, -180), size = Vector(0.305, 0.052, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun7"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.071, -3.122, -16.664), angle = Angle(93.608, -112.109, -65.61), size = Vector(0.284, 0.704, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun6"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.AK47_Parent", rel = "MediShotgun5", pos = Vector(-0.26, 0.096, 1.422), angle = Angle(-89.329, 0, 0), size = Vector(0.395, 0.395, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun5++"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.848, -5.473, 6.349), angle = Angle(14.109, -180, -89.084), size = Vector(0.204, 0.204, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun6+"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.AK47_Parent", rel = "MediShotgun5+", pos = Vector(-0.26, 0.096, 1.422), angle = Angle(-89.329, 0, 0), size = Vector(0.395, 0.395, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun8"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.16, -4.476, 8.621), angle = Angle(-91.79, -4.442, -2.72), size = Vector(0.284, 0.284, 0.284), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun11"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.178, -0.04, 1.784), angle = Angle(-57.126, -97.029, -4.822), size = Vector(0.393, 0.393, 0.393), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun10"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.408, -5.888, 1.615), angle = Angle(3.2, -101.379, -90.067), size = Vector(0.083, 0.071, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_wall/combine_innerwall001", skin = 0, bodygroup = {} },
	["MediShotgun6++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.AK47_Parent", rel = "MediShotgun5++", pos = Vector(-0.26, 0.096, 1.422), angle = Angle(-89.329, 0, 0), size = Vector(0.395, 0.395, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun2"] = { type = "Model", model = "models/props_wasteland/cargo_container01.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.244, -4.051, -3.302), angle = Angle(-177.25, -91.707, -89.936), size = Vector(0.017, 0.067, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun9"] = { type = "Model", model = "models/props_trainstation/pole_448Connection002b.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.372, -5.932, -1.864), angle = Angle(-0.176, -1.583, -3.095), size = Vector(0.048, 0.048, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun3"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Clip", rel = "", pos = Vector(0.272, 5.165, -1.568), angle = Angle(-6.65, 2.308, -173.286), size = Vector(1.001, 0.773, 2.522), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_dropship/dropshipsheet", skin = 0, bodygroup = {} },
	["MediShotgun5"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.848, -5.488, 4.846), angle = Angle(14.109, -180, -89.084), size = Vector(0.204, 0.204, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun10+"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(-0.487, -0.677, 6.355), angle = Angle(2.835, -105.53, -90.775), size = Vector(0.104, 0.105, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phxtended/metal", skin = 0, bodygroup = {} },
	["MediShotgun4"] = { type = "Model", model = "models/effects/medicyell.mdl", bone = "v_weapon.AK47_Clip", rel = "MediShotgun3", pos = Vector(-0.169, 2.052, 0.032), angle = Angle(0, 0, 0), size = Vector(0.245, 0.418, 0.254), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["MediShotgun"] = { type = "Model", model = "models/props_interiors/BathTub01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.678, 0.716, -6.923), angle = Angle(-8.863, 0.165, 0), size = Vector(0.305, 0.052, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun7"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.917, 0.483, -5.985), angle = Angle(170.477, -1.127, -102.912), size = Vector(0.284, 0.704, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun2"] = { type = "Model", model = "models/props_wasteland/cargo_container01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.362, 0.578, -5.661), angle = Angle(-3.414, -91.294, 171.38), size = Vector(0.017, 0.067, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun3"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.145, 0.828, -0.831), angle = Angle(-1.26, 87.049, 97.689), size = Vector(1.001, 0.773, 2.522), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_dropship/dropshipsheet", skin = 0, bodygroup = {} },
	["MediShotgun9"] = { type = "Model", model = "models/props_trainstation/pole_448Connection002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MediShotgun", pos = Vector(2.19, 0.028, -0.091), angle = Angle(-1.089, -92.372, -88.423), size = Vector(0.048, 0.048, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun11"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.977, 0.653, 0.344), angle = Angle(13.394, 0, 0), size = Vector(0.393, 0.393, 0.393), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun4"] = { type = "Model", model = "models/effects/medicyell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MediShotgun3", pos = Vector(-0.169, 2.052, 0.032), angle = Angle(0, 0, 0), size = Vector(0.245, 0.418, 0.254), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true

	SWEP.IconLetter = "d"
	killicon.AddFont( "weapon_zs_medigun", "CSKillIcons", SWEP.IconLetter, Color(120, 255, 255, 255 ) )
	
end

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.Base = "weapon_zs_base"

SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 5
SWEP.Primary.NumShots		= 7
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 6
SWEP.UseHands = true

SWEP.Cone = 0.09
SWEP.ConeMoving = SWEP.Cone *1.12
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
SWEP.TracerName = "AR2Tracer"
SWEP.WalkSpeed = SPEED_SHOTGUN
SWEP.HoldType = "smg"

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 90, math.random(100,110))
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end



function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end

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
				
				if owner:GetPerk("_medic") then
					multiplier = multiplier + multiplier*((5*owner:GetRank())/100)
				end						
				
				if owner.DataTable["ShopItems"][48] then
					multiplier = multiplier + 0.2
				end		
				
				local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
				local totake = math.ceil(toheal / multiplier)			

				
				if toheal > 0 then
					
					local delay = self.Secondary.HealDelay
					if owner.DataTable["ShopItems"][48] then
						delay = math.Clamp(self.Secondary.HealDelay - 1.5,0,self.Secondary.HealDelay)
					end
					
					if owner:GetPerk("_medic") then
						multiplier = multiplier + multiplier*((5*owner:GetRank())/100)
					end					
					
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 14)
						skillpoints.AddSkillPoints(owner,toheal or 14)
						ent:FloatingTextEffect( toheal or 14, owner )
						owner:AddXP(toheal*3 or 5)
						
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

		return false
	end
	
	return (owner.NextMedKitUse or 0) <= CurTime()
end
