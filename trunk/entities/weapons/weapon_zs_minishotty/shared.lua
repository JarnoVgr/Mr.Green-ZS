-- ? Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.

-- See LICENSE.txt for license information

if SERVER then

        AddCSLuaFile("shared.lua")

        SWEP.PrintName = "'Farter' Shotgun"

end

if CLIENT then

        SWEP.PrintName = "'Farter' Shotgun"                        

        SWEP.Author        = "NECROSSIN"

        SWEP.Slot = 0

        SWEP.SlotPos = 17

        SWEP.ViewModelFOV = 60

        SWEP.ViewModelFlip = false

        

        SWEP.IconLetter = "0"

        killicon.AddFont( "weapon_zs_minishotty", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 255, 255, 255 ) )

end

SWEP.Base                                = "weapon_zs_base"

SWEP.UseHands = true

SWEP.Spawnable                        = true

SWEP.AdminSpawnable                = true

SWEP.ViewModel                        = Model ( "models/weapons/v_supershorty/v_supershorty.mdl" )

SWEP.WorldModel                        = Model ( "models/weapons/w_supershorty.mdl" )

SWEP.Weight                                = 5

SWEP.AutoSwitchTo                = true

SWEP.AutoSwitchFrom                = true

SWEP.HoldType = "shotgun"

SWEP.Primary.Sound                        = Sound("Weapon_Shotgun.Single")

SWEP.Primary.Recoil                        = 5

SWEP.Primary.Unrecoil                = 2

SWEP.Primary.Damage                        = 7

SWEP.Primary.NumShots                = 6

SWEP.Primary.ClipSize                = 6

SWEP.Primary.Delay                        = 0.8

SWEP.Primary.DefaultClip        = 40

SWEP.Primary.Automatic                = false

SWEP.Primary.Ammo                        = "buckshot"

SWEP.Cone                        = 0.11

SWEP.ConeMoving                                = 0.15

SWEP.ConeCrouching                        = 0.1075

SWEP.IsShotgun = true

SWEP.WalkSpeed = 185 //but it has better speed

---SWEP.IronSightsPos = Vector(-3.36, -9.016, 2.2)

---SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.ReloadDelay = 0.5

SWEP.reloadtimer = 0

SWEP.nextreloadfinish = 0

function SWEP:Reload()

        if self.reloading then return end

        if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then

                self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)

                self.reloading = true

                self.reloadtimer = CurTime() + self.ReloadDelay

                self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

                self.Owner:SetAnimation(PLAYER_RELOAD)

        end

        self:SetIronsights(false)

end

function SWEP:Think()

        if self.reloading and self.reloadtimer < CurTime() then

                self.reloadtimer = CurTime() + self.ReloadDelay

                self:SendWeaponAnim(ACT_VM_RELOAD)

                self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)

                self:SetClip1(self:Clip1() + 1)

                self:EmitSound("Weapon_Shotgun.Reload")

                if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then

                        self.nextreloadfinish = CurTime() + self.ReloadDelay

                        self.reloading = false

                        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

                end

        end

        local nextreloadfinish = self.nextreloadfinish

        if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then

                self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

                //self:EmitSound("Weapon_Shotgun.Special1")

                self.nextreloadfinish = 0

        end

end

function SWEP:CanPrimaryAttack()

        if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end

        if self:Clip1() <= 0 then

                self:EmitSound("Weapon_Shotgun.Empty")

                self:SetNextPrimaryFire(CurTime() + 0.25)

                return false

        end

        if self.reloading then

                if 0 < self:Clip1() then

                        self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

                else

                        self:SendWeaponAnim(ACT_VM_IDLE)

                end

                self.reloading = false

                self:SetNextPrimaryFire(CurTime() + 0.25)

                return false

        end

        return true

end
