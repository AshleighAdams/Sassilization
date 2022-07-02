--------------------
-- STBase
-- By Spacetech
--------------------

concommand.Add("_ping", function(ply, cmd, arg)
	if(!ply.NextPing or (ply.NextPing and ply.NextPing <= CurTime())) then
		ply.NextPing = CurTime() + 5
		umsg.Start("pong", ply)
		umsg.End()
	end
end)
