--------------------
-- STBase
-- By Spacetech
--------------------

usermessage.Hook("player_suicide_timer", function(um)
	GAMEMODE.DeathTimer = CurTime() + GAMEMODE.SuicideTime
end)
