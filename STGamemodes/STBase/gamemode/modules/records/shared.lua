--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Records = {}
STGamemodes.Records.Enabled = false 
STGamemodes.Records.Top = {}
STGamemodes.Records.Map = game.GetMap()
STGamemodes.Records.Loaded = false 
-- STGamemodes.Records.Bhop = false
STGamemodes.Records.TablePrefixes = {}
STGamemodes.Records.TablePrefixes["Bunny Hop"] = "bh"
STGamemodes.Records.TablePrefixes["Climb"] = "cl"

function STGamemodes.Records:GetEnabled()
	if !GAMEMODE or !GAMEMODE.Name then 
		return false 
	else 
		if !self.TablePrefixes[GAMEMODE.Name] then 
			return false 
		end 
		return true 
	end 
end 

function STGamemodes.Records:GetPre()
	return self.TablePrefixes[GAMEMODE.Name]
end 

function STGamemodes.Records:Load( Open, Map )
	if !self:GetEnabled() then 
		return 
	end 

	local Map = Map or game.GetMap()
	self.Loaded = false 
	self.Top = {}
	
	if Open then self:OpenTop( Map ) end 
	http.Fetch("<URL HERE>prefix=".. self:GetPre() .."&map=".. Map, function(String) 
		if !String or String == "" or (string.find(String, "<html>") and string.find(String, "</html>")) then
			timer.Simple( 30, function() self:Load() end) -- No records?  Lets check again later.
			return
		end 
		String = string.Explode( "(|)", String )

		for k,v in pairs(String) do 
			if v and v != "" then 
				table.insert( self.Top, string.Explode( "(*)", v) ) 
			end 
		end

		-- self.Top = Json.Decode(String)

		self.Loaded = true 

		-- Open the menu
		if CLIENT and Open and LocalPlayer():IsValid() then 
			self:OpenTop( Map )
		end
	end )
end

function STGamemodes.Records:LoadPersonalRecord( ply, echo, time, map )
	if !self:GetEnabled() then 
		return 
	end 

	local Echoed = false 
	local map = map or self.Map 

	http.Fetch( "<URL HERE>?prefix=".. self:GetPre() .."&map=".. map .."&sid=".. ply:SteamID(), function(String) 
		if String and String != "" and !(string.find(String, "<html>") and string.find(String, "</html>")) then 
			ply.Record = tonumber(String)
			-- Need to check if in top 10
			if echo then 
				if !ply.Record then return end
				if ply.Record < 1 then
					ply:ChatPrint("You have not completed ".. map)
					Echoed = true 
					return
				end
				
				ply:ChatPrint( "Your record on ".. map .." is ".. STGamemodes:SecondsToFormat( ply.Record, true ) )
				Echoed = true 
			elseif time and (ply.Record == 0 or !ply.Record or time > ply.Record) then 
				ply:ChatPrint( "You've earned a new personal record on ".. map .."!" ) 
			end
		else 
			ply.Record = false 
		end 
	end )

	timer.Simple( 5, function() 
		if echo and !Echoed then 
			ply:ChatPrint( "Your record appears to be having problems loading!" ) 
		end 
	end )
end