local keyToID = {
	[IN_FORWARD] = 0,
	[IN_BACK] = 1,
	[IN_MOVELEFT] = 2,
	[IN_MOVERIGHT] = 3,
	[IN_JUMP] = 4,
	[IN_DUCK]  = 5,
	[IN_USE] = 6
}


local function SendKeyEvent(ply, key, hookstr)

	if IsValid(ply) and ply:Alive() and (key and table.HasValue(STGamemodes.ShowKeys:GetFilter(), key)) then

		local rf = RecipientFilter()
		for _, pl in pairs(STGamemodes:GetPlayers({TEAM_SPEC, TEAM_DEAD, TEAM_RED, TEAM_BLUE, TEAM_CLIMB})) do

			if IsValid(pl) then

				-- Check if a player is observing the player who pressed a key
				local target = pl:GetObserverTarget()
				if IsValid(target) and target == ply and ply != pl then
					rf:AddPlayer(pl)
				end

			end

		end
		
		umsg.Start(hookstr, rf)
			umsg.Short(key)
		umsg.End()

	end

end


hook.Add( "KeyPress", "BhopKeyPress", function(ply, key)
	SendKeyEvent(ply, key, "BhopSendKeyPress")
end )

hook.Add( "KeyRelease", "BhopKeyReleased", function(ply, key)
	SendKeyEvent(ply, key, "BhopSendKeyRelease")
end )