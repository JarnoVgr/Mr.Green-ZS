SWEP.Author = "Duby"
SWEP.Contact = ""
SWEP.Purpose = "Make cading easier."
SWEP.Instructions = "Click on the ground and find out!"

SWEP.ViewModel = Model ( "models/weapons/c_rpg.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_rocket_launcher.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1
SWEP.DrawCrosshair = true
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
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

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()

		draw.SimpleTextOutlined("Aegis Kit: (Beta)", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Left click 0'c Right click 90'c", "ArialBoldFive", w-ScaleW(150), h-ScaleH(40), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		--draw.SimpleTextOutlined("look at the direction which you want the prop to go! ", "ArialBoldFive", w-ScaleW(150), h-ScaleH(25), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
end






