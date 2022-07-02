--------------------
-- STBase
-- By Spacetech
--------------------

function CCGiveSWEP()
end
concommand.Remove("gm_giveswep")

function CCSpawnSWEP()
end
concommand.Remove("gm_spawnswep")

concommand.Remove("rateuser")
hook.Remove("PlayerInitialSpawn", "PlayerRatingsRestore")
