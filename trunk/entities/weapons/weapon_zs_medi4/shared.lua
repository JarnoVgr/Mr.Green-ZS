AddCSLuaFile()

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 04"

	SWEP.VElements = {
		["pyrorifle3"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.094, -4.303, 24.413), angle = Angle(-0.42, -1.201, -179.42), size = Vector(0.303, 0.31, 1.575), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pyrorifle2"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.583, -0.942, 17.603), angle = Angle(180, 180, -180), size = Vector(0.068, 0.079, 0.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["pyrorifle1"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.243, -0.675, 2.976), angle = Angle(0.939, 89.924, -91.034), size = Vector(0.238, 0.217, 0.092), color = Color(0, 255, 0, 255), surpresslightning = true, material = "models/combine_dropship/combine_fenceglow", skin = 0, bodygroup = {} },
		--["pyrorifle5"] = { type = "Model", model = "models/props_combine/health_charger001.mdl", bone = "v_weapon.magazine", rel = "", pos = Vector(-0.699, -1.203, 0.25), angle = Angle(0.799, 0, 88.424), size = Vector(0.2, 0.131, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pyrorifle4"] = { type = "Model", model = "models/props/cs_assault/wirepipe.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "pyrorifle3", pos = Vector(0.421, -2.392, 15.286), angle = Angle(71.436, -55.73, 144.425), size = Vector(0.063, 0.014, 0.014), color = Color(0, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["pyrorifle3"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0.953, -7.554), angle = Angle(-99.564, 3.006, 2.368), size = Vector(0.303, 0.31, 1.575), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pyrorifle2"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.545, 1.409, -3.692), angle = Angle(1.725, -90.358, 82.495), size = Vector(0.068, 0.079, 0.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["pyrorifle5"] = { type = "Model", model = "models/props_combine/health_charger001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.918, 0.239, 0.136), angle = Angle(1.69, -93.728, 2.203), size = Vector(0.215, 0.215, 0.215), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
	

	SWEP.IconLetter = "v"		
	killicon.AddFont( "weapon_zs_medigun", "CSKillIcons", SWEP.IconLetter, Color(120, 255, 255, 255 ) )
	
end

SWEP.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"

SWEP.Base = "weapon_zs_base"
SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 40
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo = "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 12
SWEP.UseHands = true
SWEP.Cone = 0.04
SWEP.ConeMoving = SWEP.Cone *1.12
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9

SWEP.WalkSpeed = SPEED_LIGHT-5
SWEP.HoldType = "ar2"
SWEP.HumanClass = "medic"

function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(125,130))
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
				
				if owner:GetPerk("_medic") then
					multiplier = multiplier + multiplier*((2*owner:GetRank())/100)
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
						multiplier = multiplier + multiplier*((2*owner:GetRank())/100)
					end					
					
					self:SetNextCharge(CurTime() + delay)
					owner.NextMedKitUse = self:GetNextCharge()
					
					if SERVER then
						owner.HealingDone = owner.HealingDone + (toheal or 14)
						skillpoints.AddSkillPoints(owner,toheal or 14)
						ent:FloatingTextEffect2( toheal or 14, owner )
						owner:AddXP(toheal*3 or 5)
						
						if owner:GetPerk("_medupgr1") then
							skillpoints.AddSkillPoints(owner,toheal*0.3 or 15)				
						end		
						
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
		owner.NextMedKitUse = self:GetNextCharge()
		--self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		--owner.NextMedKitUse = self:GetNextPrimaryFire()
		return false
	end
	
	return --[=[self:GetNextCharge() <= CurTime() and]=] (owner.NextMedKitUse or 0) <= CurTime()
end

