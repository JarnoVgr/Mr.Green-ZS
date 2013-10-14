-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Sound table
SWEP.HitSounds, SWEP.BloodyFleshSounds, SWEP.FleshSounds, SWEP.ConcreteSounds, SWEP.WoodSounds, SWEP.MetalSounds, SWEP.GlassSounds, SWEP.PlasticSounds, SWEP.TileSounds, SWEP.SandSounds = {}, {}, {}, {}, {}, {}, {}, {}, {}, {} , {}

-- Generic hit
for i = 1, 4 do
	SWEP.HitSounds[i] = Sound ( "weapons/melee/keyboard/keyboard_hit-0"..i..".wav" )
end

-- Flesh sounds
for i = 1, 5 do
	SWEP.FleshSounds[i] = Sound ( "physics/flesh/flesh_impact_bullet"..i..".wav" )
end

-- Bloody flesh
for i = 1, 4 do
	SWEP.BloodyFleshSounds[i] = Sound ( "physics/flesh/flesh_squishy_impact_hard"..i..".wav" )
end

-- Wood hit sounds
for i = 1, 5 do
	SWEP.WoodSounds[i] = Sound ( "physics/wood/wood_solid_impact_bullet"..i..".wav" )
end

-- Concrete sounds
for i = 1, 4 do
	SWEP.ConcreteSounds[i] = Sound ( "physics/concrete/concrete_impact_bullet"..i..".wav" )
end

-- Metal sounds
for i = 1, 4 do
	SWEP.MetalSounds[i] = Sound ( "physics/metal/metal_solid_impact_bullet"..i..".wav" )
end

-- Sandsounds
for i = 1, 4 do
	SWEP.SandSounds[i] = Sound ( "physics/surfaces/sand_impact_bullet"..i..".wav" )
end

-- Glass sounds
for i = 1, 4 do
	SWEP.GlassSounds[i] = Sound ( "physics/glass/glass_impact_bullet"..i..".wav" )
end

-- Plastic sounds
for i = 1, 5 do
	SWEP.PlasticSounds[i] = Sound ( "physics/plastic/plastic_box_impact_bullet"..i..".wav" )
end

-- Tile sounds
for i = 1, 4 do
	SWEP.TileSounds[i] = Sound ( "physics/surfaces/tile_impact_bullet"..i..".wav" )
end

-- Material to table translation
SWEP.TranslateMaterial = { [MAT_FLESH] = SWEP.FleshSounds, [MAT_BLOODYFLESH] = SWEP.BloodyFleshSounds, [MAT_SLOSH] = SWEP.BloodyFleshSounds, [MAT_ALIENFLESH] = SWEP.BloodyFleshSounds, [MAT_WOOD] = SWEP.WoodSounds, [MAT_CONCRETE] = SWEP.ConcreteSounds, [MAT_METAL] = SWEP.MetalSounds, [MAT_SAND] = SWEP.SandSounds, [MAT_FOLIAGE] = SWEP.SandSounds, [MAT_DIRT] = SWEP.SandSounds, [MAT_GLASS] = SWEP.GlassSounds, [MAT_VENT] = SWEP.MetalSounds, [MAT_GRATE] = SWEP.MetalSounds, [MAT_PLASTIC] = SWEP.PlasticSounds, [MAT_COMPUTER] = SWEP.MetalSounds, [MAT_TILE] = SWEP.TileSounds }