--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(2177.5068359375, 1538.3937988281, 122.03125))

hook.Add("PostKeyValues", "TriggerDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(4477.09, 1560.06, 374.17), 256)) do
		if(v:GetClass() == "trigger_teleport") then
			v:Remove()
		end
	end
end)

-- Side wall exploit prevention.
STGamemodes.TouchEvents:Setup(Vector(1600, -2208, 224), Vector(3456, -2176, 368), function(ply)
	ply:SetPos(Vector(3328, -1920, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(1600, -1664, 224), Vector(3456, -1632, 368), function(ply)
	ply:SetPos(Vector(3328, -1920, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(4192, 432, 224), Vector(4384, 688, 368), function(ply)
	ply:SetPos(Vector(4480, 688, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(4576, 432, 224), Vector(4768, 688, 368), function(ply)
	ply:SetPos(Vector(4480, 688, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(4192, 688, 224), Vector(4224, 2432, 368), function(ply)
	ply:SetPos(Vector(4480, 688, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(4736, 688, 224), Vector(4768, 2432, 368), function(ply)
	ply:SetPos(Vector(4480, 688, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(1408, 3072, 224), Vector(3584, 3104, 368), function(ply)
	ply:SetPos(Vector(3456, 3360, 133))
end)

STGamemodes.TouchEvents:Setup(Vector(1408, 3616, 224), Vector(3584, 3648, 368), function(ply)
	ply:SetPos(Vector(3456, 3360, 133))
end)