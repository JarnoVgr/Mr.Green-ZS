-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local util = util

//Returns achievement table by keyname( eg: "rambo" )
function util.GetAchievementTableByKey( Key )
	if achievementDesc then
		for k,v in pairs ( achievementDesc ) do
			if v.Key == Key then
				return v
			end
		end
	end
end

//Returns item table by keyname( eg: "crab" )
function util.GetItemTableByKey( Key )
	if shopData then
		for k,v in pairs ( shopData ) do
			if v.Key == Key then
				return v
			end
		end
	end
end

//Returns achievement ID by keyname( eg: "rambo" )
function util.GetAchievementID( Name )
	if achievementDesc then
		for k,v in pairs ( achievementDesc ) do
			if v.Key == Name then
				return v.ID
			end
		end
	end
end

//Returns item by name
function util.GetItemID( Name )
	if shopData then
		for k,v in pairs ( shopData ) do
			if v.Key == Name then
				return v.ID
			end
		end
	end
end
