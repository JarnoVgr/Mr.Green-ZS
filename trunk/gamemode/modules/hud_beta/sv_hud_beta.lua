-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

//Add client-side
AddCSLuaFile ( "cl_hud_beta.lua" )

DRAW_BETA_HUD = true
if not DRAW_BETA_HUD then return end

//Resource files
resource.AddFile ( "materials/zombiesurvival/hud/splash_health.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/splash_health.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/splash_top.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/splash_top.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/danger_sign.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/danger_sign.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/hud_friend_splash.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/hud_friend_splash.vmt" )


//Avatar textures
resource.AddFile ( "materials/zombiesurvival/hud/avatar_medic.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_medic.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_commando.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_commando.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_berserker.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_berserker.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_engineer.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_engineer.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_support.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/avatar_support.vmt" )




