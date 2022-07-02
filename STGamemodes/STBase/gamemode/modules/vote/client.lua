--------------------
-- STBase
-- By Spacetech
--------------------

util.PrecacheSound("buttons/blip1.wav")
util.PrecacheSound("buttons/button14.wav")

function STGamemodes.Vote:Reset(Name)
	self.Votes = {}
	self.Choices = {}
	self.Started = false
	self.Selected = false
	self.Voted = false
	self.Name = Name or false
end

STGamemodes.Vote:Reset()

function STGamemodes.Vote.Start(um)
	STGamemodes.Vote:Reset(um:ReadString())
end
usermessage.Hook("STGamemodes.Vote.Start", STGamemodes.Vote.Start)

function STGamemodes.Vote.SendChoice(um)
	local Insert = um:ReadString()
	local Bool = um:ReadBool()
	table.insert(STGamemodes.Vote.Choices, Insert)
	if(Bool) then
		surface.PlaySound("buttons/blip1.wav")
		local Table = {}
		-- table.insert(Table, "Ignore")
		for k,v in rpairs(STGamemodes.Vote.Choices) do
			table.insert(Table, v)
		end
		STGamemodes.Vote.Choices = Table
		STGamemodes.Vote.Started = true
	end
end
usermessage.Hook("STGamemodes.Vote.SendChoice", STGamemodes.Vote.SendChoice)

function STGamemodes.Vote.Voted(um)
	STGamemodes.Vote.Selected = um:ReadString()
	surface.PlaySound("buttons/button14.wav")
end
usermessage.Hook("STGamemodes.Vote.Voted", STGamemodes.Vote.Voted)

function STGamemodes.Vote.Set(um)
	local Name = um:ReadString()
	local Votes = um:ReadShort()
	STGamemodes.Vote.Votes[Name] = Votes
end
usermessage.Hook("STGamemodes.Vote.Set", STGamemodes.Vote.Set)

function STGamemodes.Vote.End(um)
	STGamemodes.Vote:Reset()
end
usermessage.Hook("STGamemodes.Vote.End", STGamemodes.Vote.End)

local VotedCol = Color(0, 255, 0, 255)

function STGamemodes.Vote:Draw()
	if(!self.Started) then
		return
	end
	
	local Table = {}
	for k,v in pairs(self.Choices) do
		-- local Text = tostring(v)
		-- if(string.find(string.lower(Text), "ignore") == nil) then
			-- if(self.Votes and self.Votes[Text]) then
				-- Text = Text.." ("..tostring(self.Votes[Text])..")"
			-- end
		-- end
		if(self.Selected == v) then
			table.insert(Table, {tostring(v), VotedCol})
		else
			table.insert(Table, tostring(v))
		end
	end
	
	if(GAMEMODE.Name == "Climb") then
		STGamemodes:BoxList(self.Name, Table, (ScrH() / 2) - (table.Count(Table) * 15) - 40, true)
	else
		STGamemodes:BoxList(self.Name, Table)
	end
end
hook.Add("HUDPaint", "STGamemodes.Vote:Draw", function() STGamemodes.Vote:Draw() end)

local NextVote = false
STGamemodes.VoteConfirmationOpened = false
function STGamemodes.Vote:PlayerBindPress(ply, bind)
	if(self.Started and self.Choices and !self.Voted) then
		local Bind = string.Trim(string.lower(bind))
		if(string.sub(Bind, 1, 4) == "slot") then
			local Vote = tonumber(string.sub(Bind, 5))
			local VoteFix = self.Choices[Vote]
			if(Vote and VoteFix and (!NextVote or NextVote <= CurTime())) then
				if(false and STGamemodes.VoteConfirmation) then
					if(!STGamemodes.VoteConfirmationOpened) then
						STGamemodes.VoteConfirmationOpened = true
						Derma_QueryFixed("Are you sure you want to vote: "..tostring(VoteFix).."?", "Confirmation",
							"Yes", function()
								NextVote = CurTime() + 1
								STGamemodes.VoteConfirmationOpened = false
								RunConsoleCommand("st_vote_cast", VoteFix)
							end, 
							"No", function()
								STGamemodes.VoteConfirmationOpened = false
							end
						)
					end
				else
					NextVote = CurTime() + 1
					RunConsoleCommand("st_vote_cast", VoteFix)
				end
				timer.Simple(0.5, function() self.Voted = true end ) 
				return true
			end
		end
	end
end
hook.Add("PlayerBindPress", "STGamemodes.Vote:PlayerBindPress", function(ply, bind) return STGamemodes.Vote:PlayerBindPress(ply, bind) end)

concommand.Add( "st_revote", function( ply )
	if STGamemodes.Vote.Started and STGamemodes.Vote.Selected then
		STGamemodes.Vote.Selected = false
		STGamemodes.Vote.Voted = false 
		LocalPlayer():ChatPrint( "You can now vote again" )
	end
end )
