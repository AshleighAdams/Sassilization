--------------------
-- STBase
-- By Spacetech
--------------------

Jukebox = {}
Jukebox.DJMode = false

function Jukebox.SecondsToFormat(Seconds)
	if(!Seconds) then
		return "N/A"
	end
	local Original 	= tonumber(Seconds)
	if(!Original) then
		return "N/A"
	end
	local Hours 	= math.floor(Seconds / 60 / 60)
	local Minutes 	= math.floor(Seconds / 60)
	local Seconds 	= math.floor(Seconds - (Minutes * 60))
	local Timeleft 	= ""
	if(Hours > 0) then
		Timeleft = Hours..":"
	end
	if(Minutes > 0) then
		Timeleft = Timeleft..Minutes..":"
	end
	if(Seconds >= 10) then
		Timeleft = Timeleft..Seconds
	elseif(Minutes > 0) then
		Timeleft = Timeleft.."0"..Seconds
	else
		Timeleft = Timeleft..Seconds
	end
	return Timeleft, Original
end

function math.AdvRound(Number, Decimal) 
	local Decimal = Decimal or 0; 
	return math.Round(Number * (10 ^ Decimal)) / (10 ^ Decimal)
end
