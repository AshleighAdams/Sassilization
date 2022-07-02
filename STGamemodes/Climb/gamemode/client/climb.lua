--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.VoteConfirmation = true

STGamemodes.LastCalled = CurTime()
STGamemodes.Climb = {
	"Save",
	"Last",
	"Next",
	"Prev",
	"Clear"
}

local ScoreboardStatus = ""
function GM:Think()
	STGamemodes:DistanceCloaking()
	
	-- local CurrentStatus = LocalPlayer():GetNWString("ScoreboardStatus", "")
	-- if(ScoreboardStatus != CurrentStatus) then
		-- ScoreboardStatus = CurrentStatus
		-- if(CurrentStatus == "Playing") then
			-- self.DrawStartTimer = CurTime()
		-- else
			-- self.DrawStartTimer = false
		-- end
	-- end
end

usermessage.Hook( "STGamemodes.TimerStart", function( um )
	STGamemodes.DrawStartTimer = um:ReadFloat()
end )

usermessage.Hook( "STGamemodes.TimerPause", function( um )
	STGamemodes.DrawStartTimer = false
end )

usermessage.Hook( "STGamemodes.TimerResume", function( um )
	STGamemodes.DrawStartTimer = um:ReadFloat()
end )

local Opened = false
usermessage.Hook( "STGamemodes.ClimbRestart", function()
	if Opened then return end
	Opened = true
	Derma_QueryFixed( "Are you sure you want to restart your climb?", "Confirmation",
		"Yes", function() RunConsoleCommand( "st_climbrestart" ) Opened = false end,
		"No", function() Opened = false end
	)
end )

hook.Add("HUDPaint", "STGamemodes.STClimb.HUDPaint", function()
	if(!LocalPlayer() or !LocalPlayer():Alive()) then
		return
	end
	STGamemodes:BoxList("Climb", STGamemodes.Climb)
end)

hook.Add("PlayerBindPress", "STGamemodes.STClimb.PlayerBindPress", function(ply, bind)
	local Bind = STGamemodes:FixString(bind)
	if(!STGamemodes.Vote.Started or (STGamemodes.Vote.Started and STGamemodes.Vote.Voted)) then
		if(string.sub(Bind, 1, 4) == "slot") then
			local Num = string.sub(Bind, 5)
			if(tonumber(Num) <= 5) then
				if(STGamemodes.LastCalled <= CurTime()) then
					if(tonumber(Num) == 5) then
						Derma_QueryFixed("Are you sure you want to clear your save slots?", "Confirmation",
							"Yes",
							function()
								RunConsoleCommand("st_climbcmd", Num)
							end,
							"No",
							function()
							end
						)
					else
						RunConsoleCommand("st_climbcmd", Num)
					end
					STGamemodes.LastCalled = CurTime() + 1
				end
				return true
			end
		end
	end
end)

hook.Add("HUDShouldDraw", "STGamemodes.STClimb.HUDShouldDraw", function(name)
	if(name == "CHudHealth") then
		return false
	end
end)
