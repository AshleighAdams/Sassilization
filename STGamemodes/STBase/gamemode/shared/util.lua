--------------------
-- STBase
-- By Spacetech
--------------------

function AppendLog(File, Msg) 
	if File and File != "" and Msg and Msg != "" then 
		if !file.Exists(File, "DATA") then 
			file.Write(File, Msg) 
		else 
			file.Append(File, Msg) 
		end 
	end 
end 

function STValidEntity(ent)
	local Type = type(ent)
    if(Type == "string" or Type == "number") then
		return false
	end
    if(!ent or !ent.IsValid) then
		return false
	end  
    return ent:IsValid()
end

function STFormatNum(n) --Thank you DarkRP<3
	if (!n) then
		return 0
	end
	n = tonumber(n)
	//if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

function lcos(a, b, angC, isRads)
	if isRads then angC = math.rad(angC) end
	return math.sqrt(a^2 + b^2 - 2*a*b*math.cos(angC))
end

function lcos2(a, b, c)
	return math.acos((a^2 + b^2 - c^2) / 2*a*b)
end

function STGamemodes.Truncate(text, width, font)
	if (font) then
		surface.SetFont(font)
	end

	local tw, th = surface.GetTextSize(text)
	if (tw > width) then
		local chars = string.ToTable(text)
		local addWidth = surface.GetTextSize("...")
		local newString = ""
		for _, v in pairs(chars) do
			local cw = surface.GetTextSize(v)
			if (addWidth + cw > width) then
				break
			end
			newString = newString..v
			addWidth = addWidth + cw
		end
		return newString.."..."
	else
		return text
	end
end