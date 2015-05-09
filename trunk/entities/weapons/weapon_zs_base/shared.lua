SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Cone = 0.02
SWEP.ConeMoving = 0.03
SWEP.ConeCrouching = 0.013
SWEP.ConeIron = 0.018
SWEP.ConeIronCrouching = 0.01
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"


SWEP.WalkSpeed = SPEED

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.IronSightsPos = Vector(0, 0, 0)

function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.1)

	if CLIENT then
		--Set default FOV
		if self.ViewModelFOV then
			self.ViewModelDefaultFOV = self.ViewModelFOV
		end

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
	local bonus = 0
	
	if self.Owner:GetPerk("_commando") then
		bonus = (self.Owner:GetRank()*0.3)/100	
	end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay - bonus)
	if not self:CanPrimaryAttack() then
		return
	end

	
	self:EmitFireSound()
	self:TakeAmmo()
	
	
	local Owner = self.Owner

	local bullet = {}
	bullet.Force = 3000

	--Recoil multiplier
	local recoilMultiplier = 0.8
	if self:GetIronsights() then
		--Less recoil when in ironsight
		recoilMultiplier = recoilMultiplier * 0.75
		if self.Owner:GetPerk("_accuracy") then
			recoilMultiplier = recoilMultiplier * 0.4
			
		end
		if self.Owner:GetPerk("_accuracy2") then
			recoilMultiplier = recoilMultiplier * 0.4
		end
	end
	if self.Owner:Crouching() then
		--Less recoil when crouching
		recoilMultiplier = recoilMultiplier * 0.75
		if self.Owner:GetPerk("_accuracy") then
			recoilMultiplier = recoilMultiplier * 0.4
		end
		if self.Owner:GetPerk("_accuracy2") then
			recoilMultiplier = recoilMultiplier * 0.4
		end
	end

	local recoil = self.Primary.Recoil * recoilMultiplier
	
	if Owner.ViewPunch then
		Owner:ViewPunch(Angle(recoil * -1, math.random(0.1,-0.1), 0))
	end

	if (game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT and IsFirstTimePredicted() ) then
		local eyeang = self.Owner:EyeAngles()
		local permaRecoil = recoil * 0.9
		eyeang.pitch = eyeang.pitch - permaRecoil
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
	local aimVec = self.Owner:GetAimVector()
	aimVec.z = 0

	self.Owner:SetVelocity(-5 * (recoil * aimVec))
	
		

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:GetWalkSpeed()
	if self:GetIronsights() then
		if self.Owner:GetPerk("_accuracy") then
				return math.min(self.WalkSpeed, math.max(150, self.WalkSpeed * 0.5))
			end
		if self.Owner:GetPerk("_accuracy2") then
			return math.min(self.WalkSpeed, math.max(150, self.WalkSpeed * 0.2))
		end	
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

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
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

	if self.Owner:GetPerk("_commando") then

		local chance = 12 - self.Owner:GetRank()
		
		if self.Owner.DataTable["ShopItems"][52] then
			chance = chance - 1
		end
		
		if math.random(1,chance) != 1 then
		self:TakePrimaryAmmo(1)	
		end
	else
		self:TakePrimaryAmmo(1)	
	end
	
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

function SWEP:GetIronsights()
	return self:GetDTBool(0) or false
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end

	if self:Clip1() <= 0 then
		self:EmitSound(Sound("Weapon_Pistol.Empty"))
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
		if self.Owner:GetPerk("_highcal") then
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.1 + prevvel)
		end
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.0125 + prevvel)
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
	
	--GetViewPunchAngles
	local aim = self.Owner:GetAimVector()
	local punch = self.Owner:GetViewPunchAngles():Forward()
	punch.x = punch.x - 1

	
	if self.Primary.Ammo == "pistol" and self.Owner:GetPerk("_medic") then
		dmg = dmg + (dmg * (4*self.Owner:GetRank() / 100))
	
	elseif self.Primary.Ammo == "rifle" and self.Owner:GetPerk("_commando") then
		dmg = dmg + (dmg * (5*self.Owner:GetRank() / 100))
		
	elseif self.Primary.Ammo == "smg1" and self.Owner:GetPerk("_support") or self.Primary.Ammo == "buckshot" and self.Owner:GetPerk("_support") then
		dmg = dmg + (dmg * (5*self.Owner:GetRank() / 100))		
		
	elseif self.Primary.Ammo == "357" and self.Owner:GetPerk("_sharpshooter") then
		dmg = dmg + (dmg * (5*self.Owner:GetRank() / 100))	
	elseif self.Primary.Ammo == "Battery" and self.Owner:GetPerk("_medic") then --mediguns
		dmg = dmg + (dmg * (4*self.Owner:GetRank() / 100))			
	end	

	
	self:StartBulletKnockback()
	self.Owner:FireBullets({
		Num = numbul,
		Src = self.Owner:GetShootPos(),
		Dir = aim + punch,
		Spread = Vector(cone * 0.8, cone * 0.8, 0),
		Tracer = 1,
		TracerName = self.TracerName,
		Force = dmg * 0.06,
		Damage = dmg,
		Callback = self.BulletCallback
	})

	self:DoBulletKnockback()
	self:EndBulletKnockback()
end
