SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/weapons/v_rpg.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_rocket_launcher.mdl" )

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 3
SWEP.SlotPos = 2


SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = 2
SWEP.Secondary.DefaultClip = 4
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "CombineCannon"
SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = 150

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:CanPrimaryAttack()
	if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end
	if self.Owner:GetNetworkedBool("IsHolding") then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

util.PrecacheSound("npc/dog/dog_servo12.wav")
