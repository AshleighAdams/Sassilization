--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.LastSays = {}
function STGamemodes:AntiChatSpam( ply, Text )
	if(!ply:IsMod()) then
		local SteamID = ply:SteamID()
		local Return = nil
		if(!self.LastSays[SteamID]) then
			self.LastSays[SteamID] = {}
			self.LastSays[SteamID].Number = 1
		end
		
		local Number = self.LastSays[SteamID].Number
		
		self.LastSays[SteamID][Number] = {Text, CurTime()}
		
		local Text1 = false
		local Time1 = false
		if(self.LastSays[SteamID][1]) then
			Text1 = self.LastSays[SteamID][1][1]
			Time1 = self.LastSays[SteamID][1][2]
		end
		
		local Text2 = false
		local Time2 = false
		if(self.LastSays[SteamID][2]) then
			Text2 = self.LastSays[SteamID][2][1]
			Time2 = self.LastSays[SteamID][2][2]
		end
		
		local Text3 = false
		local Time3 = false
		if(self.LastSays[SteamID][3]) then
			Text3 = self.LastSays[SteamID][3][1]
			Time3 = self.LastSays[SteamID][3][2]
		end
		
		if(Text1 and Time1 and Text2 and Time2 and Text3 and Time3) then
			if(Text == Text1 and Text == Text2 and Text == Text3) then
				if(Time1 + 20 > CurTime() and Time2 + 20 > CurTime() and Time3 + 20 > CurTime()) then
					local Reason = "You Spammed: '"..Text.."'"
					-- AppendLog("../data/ChatSpam", "("..SteamID..") "..ply:CName().." was spamming: "..Text.."\n")
					if(!self.LastSays[SteamID].Muted) then
						self:AddHistory(ply:Name(), SteamID, "Console", "Console", "muted", "Spammer", 120)
						ply:SetCMuted(true)
						self.Logs:ParseLog("%s has been muted for spamming", ply)
						self:PrintAll(ply:CName() .." has been muted for spamming")
						ply:ChatPrint("[WARNING] You have one strike for spamming, two means being kicked.")
						timer.Create( "UnMute-"..ply:SteamID(), 10, 1, function()
							if ply:IsValid() then 
								ply:SetCMuted(false)
								self.Logs:ParseLog("%s auto unmuted (Timer Expired)", ply )
								self:PrintAll( ply:CName() .." has been unmuted. (Time Expired)" )
							end 
						end )
						self.LastSays[SteamID].Muted = true
					else
						if(self.LastSays[SteamID].Kicked) then
							-- self.Bans:AddMySQLBan(ply:SteamID(), 3600, ply:CName(), "Spammer")
							self.Bans:AddCommand(nil, {ply:SteamID(), 24, ply:Name(), "Spammer"})
							self:PrintAll(ply:CName() .." has been banned for spamming")
						else
							self.LastSays[SteamID].Kicked = true
							self:PrintAll(ply:CName() .." has been kicked for spamming")
							ply:ChatPrint("[WARNING] You have two strikes for spamming, three means being banned")
							self:AddHistory(ply:Name(), ply:SteamID(), "Console", "Console", "kicked", "Spammer")
						end
						self.SecretKick(ply, Reason)
					end
					Return = ""
				end
			end
		end
		
		if(Number >= 3) then
			self.LastSays[SteamID].Number = 1
		else
			self.LastSays[SteamID].Number = Number + 1
		end
		
		if Return == "" then return "" end
	end
end
