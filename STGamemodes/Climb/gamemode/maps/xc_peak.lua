--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:CreateHostage(Vector(1550, 1325, 2240), Angle(0, -180, 0))
STGamemodes:CreateHostage(Vector(1550, 1350, 2240), Angle(0, -180, 0))
STGamemodes:CreateHostage(Vector(1550, 1375, 2240), Angle(0, -180, 0))
STGamemodes:CreateHostage(Vector(1550, 1400, 2240), Angle(0, -180, 0))
STGamemodes:CreateHostage(Vector(1550, 1425, 2240), Angle(0, -180, 0))
STGamemodes:CreateHostage(Vector(1550, 1450, 2240), Angle(0, -180, 0))

hook.Add("InitPostEntity", "RemoveHeli", function()
	for k,v in pairs(ents.FindInSphere(Vector(1592.625, 580.5625, 2240.03125), 1024)) do
		if(v:GetClass() == "func_physbox" or v:GetClass() == "func_rotating") then
			v:Remove()
		end
	end
end)
