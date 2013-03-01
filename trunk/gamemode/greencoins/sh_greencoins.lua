/*-------------------------------
Green-Coins system
sh_greencoins.lua
Shared
--------------------------------*/


// Metatable expanding
local meta = FindMetaTable("Player")
if meta then

	function meta:GreenCoins()
		if not self.GCData then return 0 end
		return self.GCData["amount_current"] or 0
	end
	
	function meta:GetGreenCoins()
		return self:GreenCoins()
	end

end