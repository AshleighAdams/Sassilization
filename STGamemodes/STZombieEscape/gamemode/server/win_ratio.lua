--------------------
-- STBase
-- By Spacetech
--------------------

Zombie_Wins = 0
Human_Wins = 0

function LoadWins()
	tmysql.query( "SELECT * FROM ze_wins WHERE map='".. STGamemodes.Maps.CurrentMap .."'", function(Res, Stat, Err)
		if(Err != 0 or !Stat) then
			return
		end
		if(Res) then
			PrintTable(Res)
			for k,v in pairs(Res) do 
				Human_Wins = tonumber(v[2])
				Zombie_Wins = tonumber(v[3])
			end
		end 
	end ) 
end 
hook.Add( "OnDBConnect", "LoadRatioStuff", LoadWins )

function Update_Wins( Winner )
	if Zombie_Wins == 0 and Human_Wins == 0 then  -- Assume it hasn't been made yet.
		if Winner == "zombies" then 
			Zombie_Wins = Zombie_Wins + 1 
		else 
			Human_Wins = Human_Wins + 1
		end 

		tmysql.query("INSERT INTO ze_wins (map,humans, zombies) VALUES ('".. STGamemodes.Maps.CurrentMap .."','".. Human_Wins .."','".. Zombie_Wins .."')" )

	else -- It already exists, lets update it.
		tmysql.query("UPDATE ze_wins SET ".. Winner .."=".. Winner .."+1 WHERE map='".. STGamemodes.Maps.CurrentMap .."'")

		if Winner == "zombies" then 
			Zombie_Wins = Zombie_Wins + 1 
		else 
			Human_Wins = Human_Wins + 1
		end 
	end 
end 