--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:AddChatCommand("scream","st_scream")
STGamemodes:AddChatCommand("infect","st_infect")
STGamemodes:AddChatCommand("human","st_human")

concommand.Add("st_scream", function(ply,cmd,args)
	if !IsValid(ply) || !ply:IsZombie() then return end
	
	if(ply.ScreamCount == nil or ply.LastScream == nil) then
		ply.ScreamCount = 0
		ply.LastScream = 0
	end
	
	if ply.ScreamCount >= 5 || CurTime() < ply.LastScream + 3 then return end
	
	ply:ZScream()
	ply.ScreamCount = ply.ScreamCount + 1
end)

concommand.Add("st_human", function(ply,cmd,args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	
	local Target = args[1]
	if(!Target) then
		ply:ChatPrint("The syntax is /human playername")
		return
	end
	
	Target = STGamemodes.FindByPartial(Target)
	if(Target and STValidEntity(Target) and Target:IsPlayer()) then
		if Target:Team() != TEAM_HUMANS then
			Target:GoTeam(TEAM_HUMANS)
			ply:ChatPrint("Your target has been humanized!")
		else
			ply:ChatPrint("Your target is already a human")
		end
	else
		ply:ChatPrint(Target)
	end
end)

concommand.Add("st_infect", function(ply,cmd,args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	
	local Target = args[1]
	if(!Target) then
		ply:ChatPrint("The syntax is /infect playername")
		return
	end
	
	Target = STGamemodes.FindByPartial(Target)
	if(Target and STValidEntity(Target) and Target:IsPlayer()) then
		if(!Target:IsZombie()) then
			Target:Zombify()
			if !Target:Alive() then
				Target:Spawn()
			end
			ply:ChatPrint("Your target has been infected!")
		else
			ply:ChatPrint("Your target is already infected")
		end
	else
		ply:ChatPrint(Target)
	end
end)

--[[concommand.Add("st_difficulty", function(ply,cmd,args)
	if(IsValid(ply) && !ply:IsAdmin()) then
		return
	end

	local difficulty = GAMEMODE:GetNextDifficulty()
	if difficulty then
		STNotifications:Send("The difficulty will be set to " .. tostring(difficulty.Name) .. " next round")
		GAMEMODE.NextDifficulty = difficulty.Target
	else
		ply:ChatPrint("There was a problem setting the next diffulty.")
	end
end)

-- ***REMOVE THESE BEFORE RELEASE***
STGamemodes:AddChatCommand("bot","st_bot")
STGamemodes:AddChatCommand("knockback","st_knockback")

concommand.Add("st_bot", function(ply,cmd,args)
	if !ply:IsAdmin() then return end
	RunConsoleCommand("bot")
end)

concommand.Add("st_knockback", function(ply,cmd,args)
	if(!ply:IsAdmin() || !args[1]) then
		return
	end
	
	local multiplier = tonumber(args[1])
	if !multiplier then return end
	
	-- Set knockback on zombies
	for _, pl in ipairs(team.GetPlayers(TEAM_ZOMBIES)) do
		pl.KnockbackMultiplier = multiplier
	end
	
	for _, pl in ipairs(player.GetAll()) do
		pl:ChatPrint(ply:Nick() .. " has set the knockback multiplier to " .. tostring(multiplier))
	end
end)]]