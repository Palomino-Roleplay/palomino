Palomino.Developer = Palomino.Developer or {}

local tDevelopers = {
    ["STEAM_0:1:56142649"] = "sil"
}

local PLAYER = FindMetaTable("Player")

function PLAYER:IsDeveloper()
    return tDevelopers[self:SteamID()] ~= nil
end