SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""


if CLIENT then

SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["Aegis1"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "base", rel = "", pos = Vector(6.572, -0.675, 5.586), angle = Angle(-169.111, -180, 88.586), size = Vector(0.111, 0.115, 0.115), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Aegis2"] = { type = "Model", model = "models/combine_room/combine_monitor001temp.mdl", bone = "base", rel = "", pos = Vector(0.115, -4.156, -0.958), angle = Angle(0, -11.415, 0), size = Vector(0.263, 0.263, 0.263), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Aegis"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "base", rel = "", pos = Vector(6.693, 3.345, 6.106), angle = Angle(168.369, 0, 0), size = Vector(0.068, 0.068, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Aegis3"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "base", rel = "", pos = Vector(-0.792, -0.187, 27.577), angle = Angle(-97.635, 0, 0), size = Vector(0.726, 0.726, 0.726), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/wireframe", skin = 0, bodygroup = {} },
	["Aegis+"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "base", rel = "", pos = Vector(6.505, -4.869, 4.863), angle = Angle(173.404, 0, 176.412), size = Vector(0.068, 0.068, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Aegis1"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.245, 11.451, -4.712), angle = Angle(-4.621, -69.971, -6.397), size = Vector(0.111, 0.111, 0.111), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Aegis1+"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.268, 10.567, -4.922), angle = Angle(-3.922, -75.223, -7.884), size = Vector(0.111, 0.111, 0.111), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Aegis2"] = { type = "Model", model = "models/combine_room/combine_monitor001temp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.208, 5.671, -5.794), angle = Angle(3.217, -87.098, -5.46), size = Vector(0.263, 0.263, 0.263), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Aegis3"] = { type = "Model", model = "models/weapons/w_models/w_nail.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-18.632, 1.274, -1.543), angle = Angle(-12.183, 0.234, 0), size = Vector(2.852, 2.852, 2.852), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

end

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_rocket_launcher.mdl" )

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
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
SWEP.Secondary.DefaultClip = 2
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "SniperRound"
SWEP.Secondary.Delay = 1

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

		draw.SimpleTextOutlined("Left click to spawn a wooden beam.(Floor)", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Pay attention to gaps when placing!", "ArialBoldFive", w-ScaleW(150), h-ScaleH(40), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
end
