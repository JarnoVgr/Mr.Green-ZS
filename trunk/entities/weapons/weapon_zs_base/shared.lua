SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Cone = 0.02
SWEP.ConeMoving = 0.03
SWEP.ConeCrouching = 0.013
SWEP.ConeIron = 0.018
SWEP.ConeIronCrouching = 0.01
SWEP.FirstSpawn = true
SWEP.CurrentCone = 0

SWEP.Primary.BulletsUsed = 1

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50
SWEP.DefaultViewModelFOV = 50
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"



SWEP.Type = "N/A"
SWEP.Weight = 0
SWEP.ConeMax = 0.03
SWEP.ConeMin = 0.01
SWEP.ConeRamp = 6
SWEP.TracerName = "Tracer"

SWEP.LastShot = 0

SWEP.ActualClipSize = -1

SWEP.RecoilMultiplier = 1
SWEP.AccuracyBonus = 1
SWEP.ForceBonus = 1
SWEP.HumanClass = "medic"

SWEP.WalkSpeed = SPEED

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.IronSightsPos = Vector(0, 0, 0)

function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
end

function SWEP:Initialize()
	self:DrawShadow(false)
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.0)
	self.ActualClipSize	= self.Primary.ClipSize
	if CLIENT then

		--Create a new table for every weapon instance
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)

		self:CreateModels(self.VElements) --Create viewmodels
		self:CreateModels(self.WElements) --Create worldmodels
	end
	
	self:OnInitialize() 
end

function SWEP:OnInitialize()

end

function SWEP:GetCone()
	if not self.Owner:OnGround() or self.ConeMax == self.ConeMin then return self.ConeMax end

	local basecone = self.ConeMin * self.AccuracyBonus
	local conedelta = ( self.ConeMax  * self.AccuracyBonus )- basecone 
	
	local multiplier = math.min(self.Owner:GetVelocity():Length() / self.WalkSpeed, 1) * 0.65
	if not self.Owner:Crouching() then multiplier = multiplier + 0.175 end
	if not self:GetIronsights() then multiplier = multiplier + 0.1 end

	return basecone + conedelta * multiplier ^ self.ConeRamp
end


function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if not self:CanPrimaryAttack() then
		return
	end

	self:EmitFireSound()
	self:TakeAmmo()
	
	local Owner = self.Owner
	
	local recoilm = 2 - self.RecoilMultiplier
	
	--Recoil multiplier
	if self.Owner:Crouching() then
		recoilm = recoilm * 0.8
	end
	
	if self:GetIronsights()then
		recoilm = recoilm * 0.5
	end	

	local recoil = self.Primary.Recoil * recoilm
	
	if Owner.ViewPunch then
		Owner:ViewPunch(Angle((recoil * -1)*0.5, math.random(0.01,-0.01), 0))
	end
	
	recoil = recoil * 0.25

	if (game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT and IsFirstTimePredicted() ) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())		

	--Knockback
	--local aimVec = self.Owner:GetAimVector()
	--aimVec.z = 0
	self.LastShot = CurTime()
	
	--self.Owner:SetVelocity(-5 * (recoil * aimVec))
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:GetWalkSpeed()
	if self:GetIronsights() then
		return math.min(self.WalkSpeed, math.max(90, self.WalkSpeed * 0.6))
	end

	return self.WalkSpeed
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:SetIronsights(b)
	self:SetDTBool(0, b)

	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end
	if CLIENT then return end
	self.Owner:CheckSpeedChange()
end

function SWEP:Deploy()

	if not self:SequenceDuration() then
		return
	end
	
	self.Primary.ClipSize = self.ActualClipSize	
	
	if self.Owner:GetPerk("Commando") then		
		local bonus = 0
		if self.Owner:GetPerk("commando_enforcer") then
			bonus = self.ActualClipSize * 0.25
		end
		self.Primary.ClipSize = self.ActualClipSize * 0.1 + self.ActualClipSize + (self.ActualClipSize * (self.Owner:GetRank() * 2) / 100) + bonus
		
		if self.Owner.DataTable["ShopItems"][52] then
			self.Primary.ClipSize = self.Primary.ClipSize + self.ActualClipSize * 0.2
		end
	end		
	
	self:SetNextReload(0)
	self:SetIronsights(false)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.IdleAnimation = CurTime() + self:SequenceDuration()		
	self.AccuracyBonus = 1
	--commando
	if self.Owner:GetPerk("commando_marksman") or self.Owner:GetPerk("sharpshooter_marksman") then
		self.AccuracyBonus = 0.6
	end
	
	--sharpshooter
	
	if (self.Owner:GetPerk("Sharpshooter")) then
		self.AccuracyBonus = self.AccuracyBonus - (((self.Owner:GetRank() * 2)*0.01) + 0.1)
	end
	
	if (self.Owner:GetPerk("commando_viper")) and self.Primary.Ammo == "ar2" then
		self.AccuracyBonus = self.AccuracyBonus + 0.25
		self.Primary.BulletsUsed = 2
	end
	
	if CLIENT then
		self:CheckCustomIronSights()
		self:ResetBonePositions()
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.8 )
	
	self.Owner:StopAllLuaAnimations()
	
	self:OnDeploy()
	
	--Speed change
	if SERVER then
		self.Owner:CheckSpeedChange()
		return true
	else
		self:SetViewModelColor( Color(255,255,255,255) ) 
	end

	return true
end

function SWEP:OnDeploy()
end

function SWEP:Holster()
	self:SetIronsights(false)

	if CLIENT then
		self:OnRemove()
	end
	
	return true
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) then
		self.HadFirstDraw = false

		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)

			vm:SetMaterial("")
			vm:SetColor(Color(255,255,255,255))

			--vm:SetColor(Color(255,255,255,255))
			--vm:SetMaterial("")
		end
	end
end

function SWEP:Equip(NewOwner)		
	if CLIENT then
		return
	end
	
	if SERVER then
		self.Owner.Weight = self.Owner.Weight + self.Weight
		self.Owner:CheckSpeedChange()
	end

	--self.Owner.SpeedMultiplier = self.Owner.SpeedMultiplier - (self.Weight * 0.1)
	
	if self.FirstSpawn then
		if self.Owner:GetPerk("Commando") then		
			local bonus = 0
			if self.Owner:GetPerk("commando_enforcer") then
				bonus = self.Primary.ClipSize * 0.25
			end
			self.Primary.ClipSize = self.Primary.ClipSize * 0.1 + self.Primary.ClipSize + (self.Primary.ClipSize * (self.Owner:GetRank() * 3) / 100) + bonus
			
			if self.Owner.DataTable["ShopItems"][52] then
				self.Primary.ClipSize = self.Primary.ClipSize + self.Primary.ClipSize * 0.2
			end
		end		
		self:SetClip1(self.Primary.ClipSize)
		self.FirstSpawn = false
	end
	-- If the weapon is dropped and has 10 bullets less in the current clip, then substract that amount for the new owner
	if self.Primary.RemainingAmmo then
		self:TakePrimaryAmmo ( self:Clip1() - self.Primary.RemainingAmmo )
	end
	
	-- Magazine clip is stored in the weapon, instead of player
	--NewOwner:RemoveAmmo( 1500, self:GetPrimaryAmmoTypeString() )
	--NewOwner:GiveAmmo( self.Primary.Magazine or self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
	
	--self:RemoveAmmo(1500, self:GetPrimaryAmmoTypeString())

	-- Call this function to update weapon slot and others
	gamemode.Call( "OnWeaponEquip", NewOwner, self)
end

function SWEP:OnDrop()



	--self.Owner.Weight = self.Owner.Weight - self.Weight

	if CLIENT then
		self:OnRemove()
	end	
end

function SWEP:TranslateActivity(act)
	if self:GetIronsights() and self.ActivityTranslateIronSights then
		return self.ActivityTranslateIronSights[act] or -1
	end

	return self.ActivityTranslate[act] or -1
end

function SWEP:TakeAmmo()
	self:TakePrimaryAmmo(self.Primary.BulletsUsed)	
end

function SWEP:Reload()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	if CurTime() < self:GetNextReload() or not self:DefaultReload(ACT_VM_RELOAD) then
		return
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self:SetNextReload(self.IdleAnimation)

	--3rdperson view animation
	self.Owner:DoReloadEvent()

	--Emit sound
	if self.ReloadSound then
		self:EmitSound(Sound(self.ReloadSound))
	end

	
	--Voice
	if SERVER then
		if self.Weapon:Clip1() <= math.floor(self.Primary.ClipSize / 1.5) and math.random(1, 2) == 1 then
			if (VoiceSets[self.Owner.VoiceSet].ReloadSounds) then
				local rlsnd = VoiceSets[self.Owner.VoiceSet].ReloadSounds
				if rlsnd then
					local that = self
					timer.Simple(0.2, function ()
						if IsValid(that) then
							self:EmitSound(rlsnd[math.random(1, #rlsnd)])
						end
					end)
				end
			end
		end
	end
end

function SWEP:GetIronsights()
	return self:GetDTBool(0) or false
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end

	if self:Clip1() < self.Primary.BulletsUsed then
		self:EmitSound(Sound("Weapon_Pistol.Empty"))
		self.Weapon:SetNextPrimaryFire(CurTime() + math.max(1, self.Primary.Delay))

		--Auto-reloading
		self:Reload()

		return false
	end

	return true
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not (self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding()) then
		self:SetIronsights(true)
	end
end

function SWEP:OnRestore()
	self:SetIronsights(false)
end

local tempknockback
function SWEP:StartBulletKnockback()
	tempknockback = {}
end

function SWEP:EndBulletKnockback()
	tempknockback = nil
end

function SWEP:DoBulletKnockback()
	for ent, prevvel in pairs(tempknockback) do
		local curvel = ent:GetVelocity()
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * (0.01 * self.ForceBonus) + prevvel)
	end
end

function GenericBulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if not IsValid(ent) then
		return
	end

	if ent:IsPlayer() then
		if ent:Team() == TEAM_UNDEAD and tempknockback then
			tempknockback[ent] = ent:GetVelocity()
		end
	else
		local phys = ent:GetPhysicsObject()
		if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
			ent:SetPhysicsAttacker(attacker)
		end
	end
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

SWEP.BulletCallback = GenericBulletCallback
function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self.Owner
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if (self.Owner:GetPerk("commando_viper") and self.Primary.Ammo == "ar2") then
		numbul = 2		
		cone = cone * 1.5
	elseif(math.random(1,4) == 1 and self.Owner:GetPerk("sharpshooter_fragments") and self.Primary.Ammo == "357") then
		numbul = math.random(5,8)
		dmg = dmg*0.4
	end
	
	--GetViewPunchAngles
	local aim = self.Owner:GetAimVector()
	local punch = self.Owner:GetViewPunchAngles():Forward()
	punch.x = punch.x - 1

	self:StartBulletKnockback()
	self.Owner:FireBullets({
		Num = numbul,
		Src = self.Owner:GetShootPos(),
		Dir = aim + punch,
		Spread = Vector(cone, cone, 0),
		Tracer = 1,
		TracerName = self.TracerName,
		Force = dmg * 0.1,
		Damage = dmg,
		Callback = self.BulletCallback
	})

	self:DoBulletKnockback()
	self:EndBulletKnockback()
end
