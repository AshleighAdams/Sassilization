--[[-------------------------------------------------------------------
		Difficulty Brushes
---------------------------------------------------------------------]]
DIFFICULTY_MEDIUM 	= GM:AddDifficulty("Medium", "dificultad_inicio_medio")
DIFFICULTY_HARD		= GM:AddDifficulty("Hard", "dificultad_inicio_dificil")
DIFFICULTY_EXTREME 	= GM:AddDifficulty("Extreme", "dificultad_inicio_extremo")
DIFFICULTY_EXTREME2	= GM:AddDifficulty("Extreme II", "dificultad_inicio_extremo2")
--GM:AddDifficulty("ZM", "dificultad_inicio_zm")

--[[-------------------------------------------------------------------
		Boss Entities
---------------------------------------------------------------------]]
-- Red Scorpian
GM:AddBoss("Guard Scorpion", "monstruo", "Monstruo_Breakable")

-- Bahamut, dragon thing
GM:AddBoss("Bahamut", "bahamut", "bahamut_vida")
--GM:AddBoss("bahamut2", "bahamut_vida")
--GM:AddBoss("mh2bahamut", "bahamut_vida")

--[[-------------------------------------------------------------------
		Achievements
---------------------------------------------------------------------]]
-- Normal difficulty ending helicopter awards achievement for humans
STGamemodes.TouchEvents:Setup(Vector(-10990, 4213, 12), Vector(-10758, 3877, 227), function(ply)
	local bDifficulty = GAMEMODE:IsDifficultyEnabled(DIFFICULTY_EXTREME) || GAMEMODE:IsDifficultyEnabled(DIFFICULTY_EXTREME2)
	if !ply:IsZombie() && bDifficulty then
		STAchievements:Award(ply, "Legend", true)
	end
end)

--[[-------------------------------------------------------------------
		Map Fixes
---------------------------------------------------------------------]]
-- Prevent humans from jumping down yellow panels before boss starts
STGamemodes.TouchEvents:Setup(Vector(-7250,9597,-5241), Vector(-7124,9411,-4650), function(ply)
	ply:SetPos(Vector(-7479,9047,-4733))
	ply:SetEyeAngles(Angle(0,180,0))
end)

-- Yellow ledges near reactor floor ladder
STGamemodes.TouchEvents:Setup(Vector(-9972,8600,-5272), Vector(-10099,8454,-4364), function(ply)
	ply:SetPos(Vector(-10011,8887,-4733))
	ply:SetEyeAngles(Angle(0,180,0))
end)

-- Remove human health reset trigger
-- OnStartTouch : !activator,AddOutput,health 100,0,-1
-- filtername : humanos
--[[hook.Add("OnRoundChange", "RemoveHealthModifier", function()
	for _, v in pairs( ents.FindInSphere(Vector(-8448.5, -1537.28, -73.5), 32 ) ) do
		if IsValid(v) and v:GetClass() == "trigger_multiple" then
			v:Remove()
		end
	end
end)]]