--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Gagged = {}
STGamemodes.Voice = 0
function STGamemodes.PlayerMeta:IsGagged()
	if(self and self:IsValid()) then
		return self.Gagged or self:GetNWBool("Gagged", false)
	end
	return false
end

function STGamemodes.PlayerMeta:SetGagged(Bool)
	self.Gagged = Bool
	STGamemodes.Gagged[self:SteamID()] = Bool
	self:SetNWBool("Gagged", Bool)
end

function STGamemodes.Gag(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end

	if STGamemodes.Voice < 1 and !ply:IsSuperAdmin() then
		ply:ChatPrint("Voice Chat is currrently disabled.")
		return 
	end
	
	local Name = args[1]
	
	if(!Name) then
		ply:ChatPrint("Syntax: /gag PlayerName Reason")
		return
	end

	local Reason, Start = "", 1
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif k > Start and k == #args then 
			Reason = Reason..v
		end
	end
	
	local Target = STGamemodes.FindByPartial(Name)
	
	if(type(Target) == "string") then
		ply:ChatPrint(Target)
	else
		if(!ply:IsSuperAdmin() and Target:IsMod()) then
			ply:ChatPrint("You can't gag mods/admins!")
			if Target:IsSuperAdmin() then 
				Target:ChatPrint( ply:CName() .." tried to gag you" ) 
			end 
		else
			local Text = STGamemodes.GetPrefix(ply).." "..ply:CName().." gagged "..Target:CName()
			if(Target:IsGagged()) then
				Text = STGamemodes.GetPrefix(ply).." "..ply:CName().." ungagged "..Target:CName()
				Target:SetGagged(false)
				STGamemodes.Logs:ParseLog("%s ungagged %s", ply, Target)
			else
				if Reason and Reason != "" then Text = Text .." (Reason: ".. Reason ..")" end 
				Target:SetGagged(true)
				STGamemodes.Logs:ParseLog("%s gagged %s", ply, Target)
				STGamemodes:AddHistory(Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID(), "gagged", Reason)
			end
			STGamemodes:PrintAll(Text)
		end
	end
end
concommand.Add("st_gag", STGamemodes.Gag)

function STGamemodes.VoiceUpdateClients( num, ply, spawn )
	if spawn and STGamemodes.Voice == 0 then return end
	if ply then
		umsg.Start( "STGamemodes.VoiceSetVar", ply )
	else
		umsg.Start( "STGamemodes.VoiceSetVar" )
	end
	umsg.Char( num )
	umsg.End()
end

hook.Add( "PlayerInitialSpawn", "UpdateVoiceClient", function( ply )
	STGamemodes.VoiceUpdateClients( STGamemodes.Voice, ply, true )
end )

function STGamemodes.Commands.Voice( ply, cmd, args )
	if (!ply:IsSuperAdmin()) or (!args[1] and !args[2]) then
		ply:SendLua( "STGamemodes.Voice.ToggleVoice()" )
		return
	end
	
	local Vote = tonumber(args[2]) or 1
	local Target = tonumber(args[1])
	local TargetS

	if (Target and Target > 3 and Target < 0) or (Vote and Vote != 1 and Vote != 0) then
		ply:ChatPrint("Syntax: /voice [1(All)/2(VIP)/3(Staff)] [0(No Vote)/1(Vote)]")
		return
	end

	if Target == 0 and (Vote == 0 or !Vote) and STGamemodes.Voice > 0 then
		STGamemodes.Voice = 0
		STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has turned Voice Chat off" )
		-- RunConsoleCommand("sv_voiceenable", "0")
		STGamemodes.VoiceUpdateClients( 0 )
		return
	elseif Target == 0 and (Vote == 0 or !Vote) and STGamemodes.Voice == 0 then
		ply:ChatPrint( "Voice Chat is already off" )
		return
	elseif (Target and Target == STGamemodes.Voice) or (!Target and STGamemodes.Voice == 1 ) then
		ply:ChatPrint( "Voice Chat is already set on this" )
		return
	end

	if Target then
		if Target == 1 then
			TargetS = "Everyone"
		elseif Target == 2 then
			TargetS = "VIPs"
		elseif Target == 3 then
			TargetS = "Staff"
		end
	end

	if Vote == 1 and Target > 0 then
		STGamemodes.Vote:Start("Enable Voice Chat for ".. TargetS .."?", {{"Yes", true}, {"No", false}}, 
			function()
				STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has started a Voice Chat Vote for ".. TargetS )
			end,
			function(Success, Ply, Canceled)
				if Canceled then 
					STGamemodes:PrintAll( "Voice Chat vote has been canceled by Administrator" )
				elseif Success then
					STGamemodes.Voice = Target
					STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has turned Voice Chat on for ".. TargetS )
					-- RunConsoleCommand("sv_voiceenable", "1")
					STGamemodes.VoiceUpdateClients( Target )
				else
					STGamemodes:PrintAll( "Voice Chat vote for ".. TargetS .." failed" )
				end
			end)
	elseif Vote == 0 and Target > 0 then
		STGamemodes.Voice = Target 
		STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has turned Voice Chat on for ".. TargetS )
		-- RunConsoleCommand("sv_voiceenable", "1")
		STGamemodes.VoiceUpdateClients( Target )
	else
		STGamemodes.Vote:Start("Disable Voice Chat?", {{"Yes", true}, {"No", false}}, 
		function()
			STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has started a vote to turn Voice Chat off" )
		end,
		function(Success, Ply, Canceled)
			if Canceled then 
				STGamemodes:PrintAll( "Turn off Voice Chat Vote has been canceled by Administrator" )
			elseif Success then
				STGamemodes.Voice = 0
				STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has turned Voice Chat off" )
				-- RunConsoleCommand("sv_voiceenable", "0")
				STGamemodes.VoiceUpdateClients( 0 )
			else
				STGamemodes:PrintAll( "Turn off Voice Chat Vote failed" )
			end
		end,
		ply)
	end
end
concommand.Add("st_voice", STGamemodes.Commands.Voice )
