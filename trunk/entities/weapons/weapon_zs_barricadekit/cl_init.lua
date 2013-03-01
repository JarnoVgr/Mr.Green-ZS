-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

SWEP.PrintName = "Barricade Kit"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

CreateClientConVar("zs_barricadekityaw", 0, false, true)


function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
	RunConsoleCommand("zs_barricadekityaw", math.NormalizeAngle(GetConVarNumber("zs_barricadekityaw") + 10))
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Think()
	if 0 < self:Clip1() then
		local owner = self.Owner
		local effectdata = EffectData()
			effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
			effectdata:SetNormal(owner:GetAimVector())
		util.Effect("barricadeghost", effectdata, true, true)
	end
end
	function SWEP:DrawHUD()
		if not self.Owner:Alive() then return end
		if ENDROUND then return end
		local Description1 = "Left click to make barricade (Aim at the walls or between them)."
		local Description2 = "Right click to rotate."
		local Description3 = "Try to not get stuck in your own plank."
		surface.SetFont ( "ArialNine" )
		local DescWide1 = surface.GetTextSize ( Description1 )
		local DescWide2 = surface.GetTextSize ( Description2 )
		local DescWide3 = surface.GetTextSize ( Description3 )

		local BoxWide = math.max ( DescWide1, DescWide2, DescWide3 ) + ScaleW(50)
		
		draw.RoundedBox ( 8, ScaleW(673) - BoxWide * 0.5, ScaleH(761) - ScaleH(117) * 0.5, BoxWide, ScaleH(117), Color ( 1,1,1,180 ) )
		draw.SimpleText ( Description1,"ArialNine",ScaleW(673),ScaleH(726), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText ( Description2 ,"ArialNine",ScaleW(673),ScaleH(756), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText ( Description3 ,"ArialNine",ScaleW(673),ScaleH(788), Color ( 250,30,30,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end