--------------------
-- STBase
-- By Spacetech
--------------------

usermessage.Hook("STGamemodes.Timer", function(um)
	local Time = um:ReadShort()
	if Time > 0 then
		STGamemodes.DrawStartTimer = Time 
	else 
		STGamemodes.DrawStartTimer = nil 
	end 
end)