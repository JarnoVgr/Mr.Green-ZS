-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"
ENT.Author = "Amps" -- Original code by Amps
ENT.Purpose	= ""
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Detonating = false
ENT.DetonationTime = 1
ENT.IgnoreClasses = {4,7}
ENT.damage = 225
ENT.radius = 150
ENT.scan = 1
ENT.range = 140
ENT.WarningSound = Sound("weapons/c4/c4_beep1.wav")
ENT.planted = 0

util.PrecacheModel("models/Weapons/w_package.mdl")
util.PrecacheSound("weapons/c4/c4_beep1.wav")
