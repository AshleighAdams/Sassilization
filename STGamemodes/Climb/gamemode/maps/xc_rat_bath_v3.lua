--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:CreateHostage(Vector(-113, 2922, 238.54125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-88, 2922, 238.54125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-63, 2922, 238.54125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(-38, 2922, 238.54125), Angle(0, 90, 0))


-- Shortcut 01
STGamemodes.TouchEvents:Setup(Vector(-231.97, 2433.21, 600.03125), Vector(304.02, 2423.08, 793.58), function(ply)
	if !ply.Winner then
		ply:SetPos(Vector(-69, 1923, 644.03125))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)