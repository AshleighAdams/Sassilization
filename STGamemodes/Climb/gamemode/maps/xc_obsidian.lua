--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:CreateHostage(Vector(-1625, -2875, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2850, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2825, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2800, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2775, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2750, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2725, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2700, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2675, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2650, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2625, 7936), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-1625, -2600, 7936), Angle(0, 0, 0))

STGamemodes.TouchEvents:Setup(Vector(3475.5625, 1495.28125, 4576.5625), 64, function(ply)
	ply:SetPos(Vector(4063.28125, 1498.65625, 4640.03125))
end)

hook.Add("InitPostEntity", "RemoveHeli", function()
	for k,v in pairs(ents.FindInSphere(Vector(2322.8125, -2772.09375, 7678.3125), 1024)) do
		if(v:GetClass() == "func_physbox" or v:GetClass() == "func_rotating") then
			v:Remove()
		end
	end
end)
