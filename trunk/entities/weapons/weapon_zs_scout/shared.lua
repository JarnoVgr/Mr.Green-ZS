if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if CLIENT then
	SWEP.PrintName = "Scout Sniper"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	
	
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil			= 3.0
SWEP.Primary.Damage			= 55
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 1.8
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 1.5

SWEP.Cone = 0.06
SWEP.ConeMoving = 0.075
SWEP.ConeCrouching = 0.01
SWEP.ConeIron = 0.01
SWEP.ConeIronCrouching = 0

SWEP.WalkSpeed = 185

SWEP.MaxAmmo			    = 40

SWEP.Secondary.Delay = 0.5

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25
	--SWEP.MinFOV = GetConVarNumber("fov_desired") * 0.25
	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local scope = surface.GetTextureID("zombiesurvival/scope/scope")
	function SWEP:DrawHUD()
		if self:IsScoped() then
				surface.SetDrawColor( 0, 0, 0, 255 )
						
				        local x = ScrW() / 2.0
						 local y = ScrH() / 2.0
						 local scope_size = ScrH()

						 -- crosshair
						 local gap = 80
						 local length = scope_size
						 surface.DrawLine( x - length, y, x - gap, y )
						 surface.DrawLine( x + length, y, x + gap, y )
						 surface.DrawLine( x, y - length, x, y - gap )
						 surface.DrawLine( x, y + length, x, y + gap )

						 gap = 0
						 length = 50
						 surface.DrawLine( x - length, y, x - gap, y )
						 surface.DrawLine( x + length, y, x + gap, y )
						 surface.DrawLine( x, y - length, x, y - gap )
						 surface.DrawLine( x, y + length, x, y + gap )


						 -- cover edges
						 local sh = scope_size / 2
						 local w = (x - sh) + 2
						 surface.DrawRect(0, 0, w, scope_size)
						 surface.DrawRect(x + sh - 2, 0, w, scope_size)

						 surface.SetDrawColor(255, 0, 0, 255)
						 surface.DrawLine(x, y, x + 1, y + 1)

						 -- scope
						 surface.SetTexture(scope)
						 surface.SetDrawColor(1, 1, 1, 255)

						 surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

				local dist = 0
				
				local tr = MySelf:GetEyeTrace()
				
				if tr.Hit then
					dist = math.Round(MySelf:GetShootPos():Distance(tr.HitPos))
					draw.SimpleTextOutlined("Distance: "..dist, "ChatFont",ScrW()/2+100,ScrH()/2,Color(255,255,255,255),TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,0.1, Color(0,0,0,255))
				end
		end
	end	
end


function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	
	util.PrecacheModel(self.ViewModel)
end