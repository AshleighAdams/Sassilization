--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:CreateHostage(Vector(-243, -376, 4682), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-203, -376, 4682), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-163, -376, 4682), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-123, -376, 4682), Angle(0, -90, 0))
STGamemodes:CreateHostage(Vector(-83, -376, 4682), Angle(0, -90, 0)) -- 1
STGamemodes:CreateHostage(Vector(-326, -441, 4682), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-326, -481, 4682), Angle(0, 0, 0))
STGamemodes:CreateHostage(Vector(-326, -521, 4682), Angle(0, 0, 0)) -- 2
STGamemodes:CreateHostage(Vector(-326, -561, 4682), Angle(0, 0, 0)) -- 3
STGamemodes:CreateHostage(Vector(-326, -601, 4682), Angle(0, 0, 0)) -- 4
--[[ STGamemodes:CreateHostage(Vector(-77, -447, 4817), Angle(0, 180, 0)) -- 1 old
STGamemodes:CreateHostage(Vector(-77, -527, 4817), Angle(0, 180, 0)) -- 2 old
STGamemodes:CreateHostage(Vector(-77, -607, 4817), Angle(0, 178, 0)) -- 3 old
STGamemodes:CreateHostage(Vector(-196, -370, 4817), Angle(0, -90, 0)) -- 4 old ]]

-- Skips hard/imposible jump at brick room.
STGamemodes.TouchEvents:Setup(Vector(-10, -448.98, 1012.03), Vector(-11, -623, 1048.03), function (ply)
	ply:SetPos(Vector(-222.95, -685.18, 1012.03))
end)