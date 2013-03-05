-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_pipe.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_crowbar.mdl" )

-- Name and fov
SWEP.PrintName = "Pipe"
SWEP.ViewModelFOV = 60

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 8

-- Damage, distane, delay
SWEP.Primary.Damage = 46
SWEP.Primary.Delay = 0.75
SWEP.Primary.Distance = 73

-- Killicons
if CLIENT then killicon.AddFont( "weapon_zs_melee_pipe", "HL2MPTypeDeath", "6", Color( 255, 80, 0, 255 ) ) end

