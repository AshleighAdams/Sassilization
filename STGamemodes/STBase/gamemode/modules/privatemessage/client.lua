--------------------
-- STBase
-- By Spacetech
--------------------

usermessage.Hook("STGamemodes.ChatBox.PMTo", function(um)
	local ply = um:ReadEntity()
	local target = um:ReadEntity()
	local Text = um:ReadString()
	
	if(!STValidEntity(ply) or !STValidEntity(target)) then
		return
	end
	
	STGamemodes.ChatBox:AddChatManual(ply, "[PM] To "..target:CName(), Text, Color(209,24,255,255), color_white, ply:GetRank())
end)

usermessage.Hook("STGamemodes.ChatBox.PMFrom", function(um)
	local ply = um:ReadEntity()
	local target = um:ReadEntity()
	local Text = um:ReadString()
	
	if(!STValidEntity(ply) or !STValidEntity(target)) then
		return
	end
	
	STGamemodes.ChatBox:AddChatManual(ply, "[PM] From "..ply:CName(), Text, Color(209,82,255,255), color_white, ply:GetRank())
end)

usermessage.Hook("STGamemodes.ChatBox.PMAdmins", function(um)
	local ply = um:ReadEntity()
	local target = um:ReadEntity()
	local Text = um:ReadString()
	
	if(!STValidEntity(ply) or !STValidEntity(target)) then
		return
	end

	if target == LocalPlayer() or ply == LocalPlayer() then return end 
	
	STGamemodes.ChatBox:AddChatManual(target, "[PM] From "..ply:CName().." To "..target:CName(), Text, Color(209,82,255,255), color_white, ply:GetRank())
	-- chat.AddText(Color(209,82,255,255),"[PM] From "..ply:CName().." To "..target:CName()..": ", color_white, Text)
end)