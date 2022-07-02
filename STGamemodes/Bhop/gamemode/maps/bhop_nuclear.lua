--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-282.78125, -479.65625, 0.03125))

STGamemodes.TouchEvents:Setup(Vector(-455.1875, -476.4375, 0.03125), 64, function(ply)
	if(!ply.Winner) then
		ply:SetPos(Vector(-801.0625, -381.71875, 0.03125))
	end
end)
