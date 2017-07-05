SWEP.Base = "weapon_zs_base"

SWEP.Pulse_Fired = false
SWEP.Pulse_LastFire = 0
SWEP.Pulse_RechargeDelay = 1.5

SWEP.Pulse_StartCharge = 0

SWEP.Pulse_RechargeRate = 0
SWEP.Pulse_ClipSize = 0

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true
SWEP.Pulse_Static_RechargeRate = 0.55
SWEP.Pulse_Static_ClipSize = 8

SWEP.TracerName = "AR2Tracer"

SWEP.Primary.Ammo = "none"

SWEP.ConeMax = 0.07
SWEP.ConeMin = 0.035

SWEP.Primary.ClipSize = Pulse_Static_ClipSize
SWEP.Primary.DefaultClip	= Pulse_Static_ClipSize

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Bing = false
SWEP.Primary.Recoil = 1.0

SWEP.Primary.BulletsUsed = 1

SWEP.Weight = 1

function SWEP:Deploy()
	if self:GetOwner():GetPerk("Engineer") then
		self.Pulse_ClipSize = self.Pulse_Static_ClipSize + (self.Pulse_Static_ClipSize *(5*self:GetOwner():GetRank())/100)
		self.Pulse_RechargeRate = self.Pulse_Static_RechargeRate - (self.Pulse_Static_RechargeRate*(2*self:GetOwner():GetRank())/100)				
	else
		self.Pulse_ClipSize = self.Pulse_Static_ClipSize
		self.Pulse_RechargeRate = self.Pulse_Static_RechargeRate
	end
end

function SWEP:OnInitialize()
	self.Weapon:SetClip1(self.Pulse_Static_ClipSize)
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(100,100))
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end
	
	if self:Clip1() < self.Primary.BulletsUsed then
		self:EmitSound(Sound("npc/roller/mine/rmine_blip3.wav"))
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)

		return false
	end

	return true
end


function SWEP:Think()
	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	if self.Owner:KeyDown(IN_ATTACK) then
		if not self.Pulse_Fired then
			self.Pulse_Fired = true
		end
		self.Pulse_LastFire = CurTime()	
	else
		
		if (self.Weapon:Clip1() >= self.Pulse_ClipSize) then
			return
		end
		
		--if SERVER then
		if (self.Pulse_LastFire + self.Pulse_RechargeDelay < CurTime() and CurTime() > self.Pulse_RechargeRate) then
			
			self.Weapon:SetClip1(math.min(self.Pulse_ClipSize, self.Weapon:Clip1() + 1))
			self.Pulse_RechargeRate = CurTime() + self.Pulse_Static_RechargeRate
		end
			--end
		if self.Weapon:Clip1() == self.Pulse_ClipSize then
			self.Bing = true
		end
	

		
		if self.Pulse_Fired then 
			self.Pulse_Fired = false
		end
	end

	

	if (self.Weapon:Clip1() == self.Pulse_ClipSize and self.Bing) then
		self:EmitSound(Sound("buttons/combine_button3.wav"))
		self.Bing = false
	end			
	

	--return self.BaseClass.Think(self)
end

function SWEP:Reload()
	return false
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(0.5)
		e:SetMagnitude(0.1)
		e:SetScale(0.1)
	util.Effect("cball_bounce", e)

	GenericBulletCallback(attacker, tr, dmginfo)
end