--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.PrivateMessage = {}

function STGamemodes.PrivateMessage.Send(ply, cmd, args)
	local Target = args[1]
	
	if ply:IsCMuted() then
		ply:ChatPrint("You are muted.")
		return
	end	

	local Message = args[2]

	if (!Target or !Message) then
		ply:ChatPrint("The syntax is '/pm [playername] [message]'")
		return
	end

	Target = STGamemodes.FindByPartial(Target)

	if (Target == ply) then
		ply:ChatPrint("You can't PM your self.")
		return
	end

	table.remove(args,1)
	Message = table.concat(args," ")

	if (STGamemodes:AntiChatSpam( ply, Message ) == "") then
		return
	end 

	if (Target && STValidEntity(Target) && Target:IsPlayer()) then
		umsg.Start("STGamemodes.ChatBox.PMTo", ply)
			umsg.Entity(ply)
			umsg.Entity(Target)
			umsg.String(Message)
		umsg.End()
		
		umsg.Start("STGamemodes.ChatBox.PMFrom", Target)	
			umsg.Entity(ply)
			umsg.Entity(Target)
			umsg.String(Message)
		umsg.End()
	end

	STGamemodes.Logs:ParseLog("[PM (From %s to %s)] - %s", ply, Target, Message)

	for _, v in pairs(player.GetAll()) do
		if v:IsMod() then
			umsg.Start("STGamemodes.ChatBox.PMAdmins", v)
				umsg.Entity(ply)
				umsg.Entity(Target)
				umsg.String(Message)
			umsg.End()
		end
	end
end
concommand.Add("st_sendpm", STGamemodes.PrivateMessage.Send)


STGamemodes:AddChatCommand("message", "st_sendpm")
STGamemodes:AddChatCommand("pm", "st_sendpm")