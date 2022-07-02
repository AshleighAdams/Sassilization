--------------------
-- STBase
-- By Sam
--------------------

function STNotifications:Send(message, Type, delay )
	if type(message) != "string" then
		return
	elseif type(Type) != "number" or Type < 1 then
		Type = NOTIFY_GENERIC
	elseif type(delay) != "number" then
		delay = 0
	end
	
	umsg.Start("STNotification")
		umsg.String(message)
		umsg.Short(Type)
		umsg.Short(delay)
	umsg.End()
end


concommand.Add("st_notification", function(ply,cmd,args)
	if IsValid(ply) && ply:IsPlayer() then
		if !ply:IsAdmin() then return end
	end

	-- no need to check args as function will handle it
	STNotifications:Send(args[1], args[2], args[3])
end)

STGamemodes:AddChatCommand("sendmsg","st_notification")