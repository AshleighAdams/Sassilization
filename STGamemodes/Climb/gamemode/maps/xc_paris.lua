--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.TouchEvents:Setup(Vector(1070.65625, -1888.5625, 1012.03125), 64, function(ply)
	ply:KillSilent()
end)

STGamemodes.TouchEvents:Setup(Vector(1006.4375, -1857.03125, 1018.875), 64, function(ply)
	ply:KillSilent()
end)

STGamemodes:CreateHostage(Vector(3509.8125, -654.78125, 3168.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3510.46875, -595.78125, 3168.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3511.28125, -527.46875, 3170.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3511.96875, -466.03125, 3168.03125), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3704.00, -346.00, 3168.03125), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(3583.00, -279.00, 3168.03125), Angle(0, -90, 0))


hook.Add("InitPostEntity", "Paris.InitPostEntity", function()
	for k,v in pairs(ents.FindInSphere(Vector(1079.5, -1689.9375, 1176.03125), 128)) do
		if(v:GetClass() == "func_button") then
			v:Remove()
		end
	end
end)
