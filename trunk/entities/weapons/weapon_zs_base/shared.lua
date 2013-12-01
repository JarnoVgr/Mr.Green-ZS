SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Cone = 0.02
SWEP.ConeMoving = 0.03
SWEP.ConeCrouching = 0.013
SWEP.ConeIron = 0.018
SWEP.ConeIronCrouching = 0.01

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.IronSightsPos = Vector(0, 0, 0)

function SWEP:Precache()
	--util.PrecacheModel(self.ViewModel)
	--util.PrecacheModel(self.WorldModel)
	util.PrecacheSound(self.Primary.Sound)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.1)

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

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then
		return
	end
	
	self:EmitFireSound()

	self:TakeAmmo()
	
	local Owner = self.Owner

	--Recoil multiplier
	local recoilMultiplier = 1
	if self:GetIronsights() then
		--Less recoil when in ironsight
		recoilMultiplier = recoilMultiplier * 0.6
	end
	if self.Owner:Crouching() then
		--Less recoil when crouching
		recoilMultiplier = recoilMultiplier * 0.6
	end
	
	if Owner.ViewPunch then
		Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * (self.Primary.Recoil * recoilMultiplier), math.Rand(-0.1,0.1) * (self.Primary.Recoil * recoilMultiplier), 0))
	end

	if ( ( SinglePlayer() and SERVER ) or ( not SinglePlayer() and CLIENT and IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		local recoil = math.Rand( 0.1, 0.2 )
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end

	if self:GetIronsights() then
		if self.Owner:Crouching() then
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.ConeIronCrouching)
		else
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.ConeIron)
		end
	elseif 25 < self.Owner:GetVelocity():Length() then
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.ConeMoving)
	else
		if self.Owner:Crouching() then
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.ConeCrouching)
		else
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self.Cone)
		end
	end

	--Knockback
	self.Owner:SetVelocity(-6 * (self.Primary.Recoil * recoilMultiplier) * self.Owner:GetAimVector())

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:GetWalkSpeed()
	if self:GetIronsights() then
		return math.min(self.WalkSpeed, math.max(90, self.WalkSpeed * 0.5))
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
	GAMEMODE:WeaponDeployed ( self.Owner, self, b )
end

function SWEP:Deploy()
	self:SetNextReload(0)
	self:SetIronsights(false)

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		self:CheckCustomIronSights()

		self:ResetBonePositions()
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.8 )
	
	self.Owner:StopAllLuaAnimations()
	
	self:OnDeploy()
	
	--Speed change
	if SERVER then
		GAMEMODE:WeaponDeployed( self.Owner, self )
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
	
	-- If the weapon is dropped and has 10 bullets less in the current clip, then substract that amount for the new owner
	if self.Primary.RemainingAmmo then
		self:TakePrimaryAmmo ( self:Clip1() - self.Primary.RemainingAmmo )
	end
	
	-- Magazine clip is stored in the weapon, instead of player
	NewOwner:RemoveAmmo( 1500, self:GetPrimaryAmmoTypeString() )
	NewOwner:GiveAmmo( self.Primary.Magazine or self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
			
	-- Call this function to update weapon slot and others
	gamemode.Call( "OnWeaponEquip", NewOwner, self)
end

function SWEP:OnDrop()
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
	self:TakePrimaryAmmo(1)
end

function SWEP:Reload()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	if self:GetNextReload() <= CurTime() and self:DefaultReload(ACT_VM_RELOAD) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		self.Owner:DoReloadEvent()
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end

		--Reload sounds
		if SERVER then
			if self.Weapon:Clip1() <= math.floor(self.Primary.ClipSize / 1.5) and math.random(1,2) == 1 then
				local rlsnd = VoiceSets[self.Owner.VoiceSet].ReloadSounds
				if rlsnd then
					timer.Simple( 0.2, function ()
						if ValidEntity(self) then
							self:EmitSound(rlsnd[math.random(1, #rlsnd)])
						end
					end, self)
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

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))

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
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.25 + prevvel)
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
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)-- SendWeaponAnimation()
	-- owner:DoAttackEvent()
	owner:SetAnimation(PLAYER_ATTACK1)

	self:StartBulletKnockback()
	owner:FireBullets({Num = numbul, Src = owner:GetShootPos(), Dir = owner:GetAimVector(), Spread = Vector(cone, cone, 0), Tracer = 1, TracerName = self.TracerName, Force = dmg * 0.1, Damage = dmg, Callback = self.BulletCallback})
	self:DoBulletKnockback()
	self:EndBulletKnockback()
end

