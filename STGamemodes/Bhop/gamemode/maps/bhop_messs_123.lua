--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(0, 0, 320))

-- Removes the problematic teleporters at the start.
hook.Add("PostKeyValues", "EntityDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(0, 0, -68), 512)) do
		if v:GetClass() == "func_door" then
			v:Remove()
		end
	end
end)

-- Side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(2288, 1168, 48), Vector(2816, 1184, 128), function(ply)
	local tele = ents.FindByName("1t1")[1]
	ply:SetPos(tele:GetPos())
	ply:SetEyeAngles(tele:GetAngles())
end)