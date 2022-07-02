--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.Voteslay(ply, cmd, args)
	if !(GAMEMODE.Name == "Deathrun") or !ply:IsVIP() then
		return
	end
	
	local Info = args[1]
	local Reason = ""
	for k,v in pairs(args) do
		if(k > 1 and k != #args) then
			Reason = Reason..v.." "
		elseif k > 1 then
			Reason = Reason..v
		end
	end
	
	if !Info or Reason == "" then
		ply:PrintMessage(HUD_PRINTTALK, "Syntax: /voteslay PartialName Reason")
		return
	end
	
	Derma_QueryFixed( "Partial Name: " .. Info .. "\nReason: " .. Reason .. [[
	
	Are you sure you want to voteslay this person?
	You may only voteslay people who are holding up the round, stuck in the map or trap spamming.
	
	WARNING: Abusing this command will result in you being blacklisted and/or banned.]], "Voteslay Confirmation",
		"Yes", function() RunConsoleCommand( "st_voteslay_confirmed", Info, Reason ) end,
		"No" )
end
concommand.Add("st_voteslays", STGamemodes.Voteslay)