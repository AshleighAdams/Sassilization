--------------------
-- STBase
-- By Spacetech
--------------------

-- Unlocks the first button for the secret ending.
hook.Add("OnRoundChange", "ButtonUnlocker", function()
	for k,v in pairs(ents.FindByName("deathrun_bonus_b1")) do
		v:Fire("Unlock")
	end
end)

STGamemodes.KeyValues:AddChange( "trap2_movelinear", "blockdamage", "1000" )
STGamemodes.KeyValues:AddChange( "deathrun_minilevel2_smoke", "weapon_frag", "1" )

--[[ -- Kills players if they try getting in the way of the ball trap by jumping into its pipe.
STGamemodes.TouchEvents:Setup(Vector(-584, 704, 96), 80, function(ply)
	ply:Kill()
end) ]]

-- Fix for the water kill trigger in the smokewar minigame.
STGamemodes.TouchEvents:Setup(Vector(-1792, -1792, -15), Vector(-1280, -1024, -4), function(ply)
	ply:Kill()
end)