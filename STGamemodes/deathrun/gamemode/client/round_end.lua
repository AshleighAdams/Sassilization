--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes:OnConsoleChat(Text)
	if(string.find(Text, "A New Round will begin in", 1, true)) then
		GAMEMODE.RoundEndTime = false
	end
end

usermessage.Hook("DeathrunEndRoundTimer", function(um)
	GAMEMODE.RoundEndTime = um:ReadLong()
	RunConsoleCommand("st_roundend_confirm")
end)
