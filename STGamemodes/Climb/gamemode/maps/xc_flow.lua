--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:CreateHostage(Vector(3210, -1500, 66), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3210, -1525, 66), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3210, -1550, 66), Angle(0, 0, 0))

STGamemodes:CreateHostage(Vector(3210, -1700, 66), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(3210, -1725, 66), Angle(0, 0, 0))

STGamemodes.TouchEvents:Setup(Vector(-59.5, 481.28125, 8288.03125), 64, function(ply)
	ply:SetPos(Vector(223, 11.21875, 8289.03125))
end)

STGamemodes.TouchEvents:Setup(Vector(687.96875, 72.625, 5207.03125), 64, function(ply)
	ply:SetPos(Vector(280.84375, 88.59375, 5633.5625))
end)
