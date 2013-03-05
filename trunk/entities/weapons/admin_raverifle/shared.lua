-- Just for you, Darkstar :V

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Ravebreak Rifle!"			
	SWEP.Slot = 5
	SWEP.SlotPos = 6

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 58
	SWEP.IconLetter = "2"
	SWEP.SelectFont = "HL2MPTypeDeath"
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.ViewModelBonescales = {}
	
	SWEP.VElements = {
	["ball1"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "Shell1", pos = Vector(0, 0, -1.487), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thing2"] = { type = "Model", model = "models/props_lab/HEV_case.mdl", bone = "Base", pos = Vector(1.093, 0.55, 2.969), angle = Angle(0, 0, 0), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["ball2"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "Shell2", pos = Vector(0, 0, -0.489), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thing1"] = { type = "Model", model = "models/props_combine/introomarea.mdl", bone = "Base", pos = Vector(-0.095, -2.751, 1.18), angle = Angle(0, 90.474, 6.58), size = Vector(0.016, 0.016, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
	["ball1"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", pos = Vector(15.675, 0.837, -6.824), angle = Angle(86.206, 1.463, 4.218), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thing1"] = { type = "Model", model = "models/props_combine/introomarea.mdl", pos = Vector(9.13, 0.5, -7.987), angle = Angle(-99.245, 0.256, 0), size = Vector(0.016, 0.016, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thing2"] = { type = "Model", model = "models/props_lab/HEV_case.mdl", pos = Vector(6.361, 1.787, -4.189), angle = Angle(-4.757, -88.363, -100.868), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["ball2"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", pos = Vector(15.081, 1.799, -4.952), angle = Angle(78.099, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}


	
	
	killicon.AddFont("admin_raverifle", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_IRifle.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_IRifle.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AR2.Single")
SWEP.Primary.Recoil			= 1.25 * 12.5 -- 1.25
SWEP.Primary.Unrecoil		= 8
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 0
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0.13
SWEP.ConeMoving				= 0.23
SWEP.ConeCrouching			= 0.06

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

-- Deluvas will kill me for it D:
-- Or not
function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire ( CurTime() + 5 )
local tr = self.Owner:GetEyeTrace();
self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

if SERVER then
if not tr.Hit then return end
if tr.HitWorld then self.Owner:EmitSound("vo/k_lab/kl_fiddlesticks.wav") return end

if tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.Entity:Alive() then
local victim = tr.Entity
	if not victim.IsRaving then
		umsg.Start("RaveBreak", victim)
		umsg.End()

		victim.IsRaving = true
	
		-- 1 second buildup
		--timer.Simple(1,function()
			--hook.Add("Think","RaveThink",RaveThink)
		--end)
	
		timer.Simple(24,function()
		--hook.Remove("Think","RaveThink")
		umsg.Start("RaveEnd", victim)
		umsg.End()
		victim.IsRaving = false
		end)

		self.Owner:EmitSound("weapons/awp/awp1.wav")
	else
		self.Owner:ChatPrint("This dude is already raving!")
	end
end

end
end

function SWEP:SecondaryAttack()
return false
end

function SWEP:Reload()
return false
end

function SWEP:Think()
if CLIENT then
local CosReal, SinReal = math.cos(RealTime()*4)*127.5 + 127.5,math.sin(RealTime()*4)*127.5 + 127.5
if math.sin(RealTime()*0.2) == 1 then
CosReal, SinReal = math.cos(RealTime()*4)*127.5 + 127.5,math.sin(RealTime()*4)*127.5 + 127.5
elseif math.sin(RealTime()*0.2) == -1 then
CosReal, SinReal = SinReal, CosReal
elseif math.sin(RealTime()*0.2) == 0 then
CosReal, SinReal = CosReal, CosReal
end
self.VElements["ball1"].color = Color(SinReal,CosReal,CosReal,0)
self.WElements["ball1"].color = Color(SinReal,CosReal,CosReal,0)
self.VElements["ball2"].color = Color(CosReal,SinReal,CosReal,0)
self.WElements["ball2"].color = Color(CosReal,SinReal,CosReal,0)
end
end

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() then return end
		if ENDROUND then return end
		
		local tr = self.Owner:GetEyeTrace();
		local name
		local color 
		if tr.Hit and tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.Entity:Alive() then
			name = tr.Entity:Nick()
			color = Color(0,255,0,255)
		else
			name = "someone"
			color = Color(255,0,0,255)
		end
		local Description1 = "Ravebreak Rifle. Version #"..math.Round(self.Owner:GetVelocity():Length())..""
		local Description2 = "Today's cool user is "..self.Owner:Nick().."."
		local Description3 = "Push the buttons to make "..name.." happy!"
		surface.SetFont ( "ArialNine" )
		local DescWide1 = surface.GetTextSize ( Description1 )
		local DescWide2 = surface.GetTextSize ( Description2 )
		local DescWide3 = surface.GetTextSize ( Description3 )

		local BoxWide = math.max ( DescWide1, DescWide2, DescWide3 ) + ScaleW(50)
		
		draw.RoundedBox ( 8, ScaleW(673) - BoxWide * 0.5, ScaleH(761) - ScaleH(117) * 0.5 + ScaleH(150), BoxWide, ScaleH(117), Color ( 1,1,1,180 ) )
		draw.SimpleText ( Description1,"ArialNine",ScaleW(673),ScaleH(876), Color ( 100,255,100,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText ( Description2 ,"ArialNine",ScaleW(673),ScaleH(906), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText ( Description3 ,"ArialNine",ScaleW(673),ScaleH(938), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		local x = ScrW() / 2
		local y = ScrH() / 2
 
		surface.SetDrawColor( color )
 
		local length = 20

		surface.DrawLine( x - length, y, x - 5, y )
		surface.DrawLine( x + length, y, x + 5, y )
		surface.DrawLine( x, y - length, x, y - 5 )
		surface.DrawLine( x, y + length, x, y + 5 )
		
	end
end
