--[[-------------------------------------------------------------------
		Difficulty Brushes
---------------------------------------------------------------------]]
DIFFICULTY_NORMAL	= GM:AddDifficulty("Normal", "dif_brush_normal")
DIFFICULTY_HARD		= GM:AddDifficulty("Hard", "dif_brush_hard")
DIFFICULTY_HYPER	= GM:AddDifficulty("Hyper", "dif_brush_hyper")
DIFFICULTY_ULTIMATE	= GM:AddDifficulty("Ultimate", "dif_brush_ultimate")

--[[-------------------------------------------------------------------
		Custom Model Override
---------------------------------------------------------------------]]
GM.PlayerModelOverride = {
	[TEAM_ZOMBIES] = {
		Model("models/player/aliendrone.mdl")
	}
}

--[[-------------------------------------------------------------------
		Boss Entities
---------------------------------------------------------------------]]
-- Normal
GM:AddBoss("Predator", "predboss_2", "aztecboss_math_health")	-- predator that shoots lasers
GM:AddBoss("Predator", "predboss_2", "aztecboss_math_health_2")	-- ground stomp

-- Hard
GM:AddBoss("Predator", "mob_grudge_model_1", "mob_grudge_math")
--GM:AddBoss("Predator", "endboss_predator", "bosshealth_endboss") -- adds intial health?

-- Hyper
GM:AddBoss("Predator", "cboss_predator", "cboss_predatorhealth_counter")

-- Ultimate
GM:AddBoss("Predator", "mob_grudge_model_2", "fboss_math_2")	-- endboss
GM:AddBoss("Predator", "mob_grudge_model_2", "fboss_math_1")	-- endboss rage mode
GM:AddBoss("Predator", "fboss_ee_model", "fboss_ee_math")		-- endboss rage mode?

--[[-------------------------------------------------------------------
		Achievements
---------------------------------------------------------------------]]
STGamemodes.TouchEvents:Setup(Vector(8830, 8156,-2119), Vector(9019, 8582, -2010), function(ply)
	if !ply:IsZombie() then
		STAchievements:Award(ply, "GET TO THE CHOPPA!!!", true)
	end
end)

-- Hard ending helicopter awards achievement for humans
STGamemodes.TouchEvents:Setup(Vector(-9564, 9002, 5001), Vector(-9978, 9203, 5123), function(ply)
	if !ply:IsZombie() then
		STAchievements:Award(ply, "GET TO THE CHOPPA!!!", true)
	end
end)

--[[-------------------------------------------------------------------
		Map Fixes
---------------------------------------------------------------------]]
hook.Add("OnRoundChange", "RemoveWaterSplashes", function()
	-- Remove shitty entities that cause water splashing
	for _, v in pairs( ents.FindByName("splash_*") ) do
		if IsValid(v) then
			v:Remove()
		end
	end
end)

GM:IgnoreMessages({"TYPE MAT_COLORCORRECTION 1 IN CONSOLE FOR BETTER VISUALS"})