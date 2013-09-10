-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Props take damage from any source
function GM:OnPropTakeDamage( ent, attacker, inflictor, dmginfo )
end

-- Player takes damage from any source
function GM:ScalePlayersDamage( ent, attacker, inflictor, dmginfo )
end

-- Human takes damage from any source
function GM:OnHumanTakeDamage( ent, attacker, inflictor, dmginfo )
end

-- Zombie takes damage from any source
function GM:OnZombieTakeDamage( ent, attacker, inflictor, dmginfo )
end

-- Final - Player takes damage from any source
function GM:OnPlayerTakeDamage( ent, attacker, inflictor, dmginfo )
end

-- Spectator takes damage from any source( very rare )
function GM:OnSpectatorTakeDamage( ent, attacker, inflictor, dmginfo )
end