-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function GM:_HUDWeaponPickedUp(weapon)
	self:Rewarded(weapon)
end

function GM:HUDItemPickedUp(itemname)
	return false
end

function GM:HUDAmmoPickedUp(itemname, amount)
	return false
end