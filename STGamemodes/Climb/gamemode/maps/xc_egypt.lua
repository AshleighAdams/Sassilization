--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:EnablePitchCheck(true)

STGamemodes.RemoveHostages = {
	Vector(-1591.96875, 6541.53125, 1959.46875)
}

STGamemodes.TouchEvents:Setup(Vector(3.65625, 799.125, 1791.5), 64, function(ply)
	ply:SetPos(Vector(-214.71875, 678.9375, 1793.8125))
end)

STGamemodes.TouchEvents:Setup(Vector(-480.4375, 6847.625, 1958.53125), 64, function(ply)
	ply:SetPos(Vector(-690.46875, 7299.3125, 1958.78125))
end)

STGamemodes.TouchEvents:Setup(Vector(779, 5349.90625, 4763.03125), 64, function(ply)
	ply:SetPos(Vector(911.95660400391, 4466.0776367188, 4743.5615234375))
end)