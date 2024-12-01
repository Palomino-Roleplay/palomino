DeriveGamemode( "sandbox" )

GM.Name = "Palomino"
GM.Author = "sil"
GM.Email = "palomino@sil.dev"
GM.Website = "palomino.gg"

Palomino = Palomino or {}

include( "boot/sh_load.lua" )
AddCSLuaFile( "boot/sh_load.lua" )

Palomino.Load.Gamemode()

-- function GM:Initialize()
-- 	Palomino._Boot.LoadGamemode()
-- end