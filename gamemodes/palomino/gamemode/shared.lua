DeriveGamemode( "sandbox" )

GM.Name = "Palomino"
GM.Author = "sil"
GM.Email = "palomino@sil.dev"
GM.Website = "palomino.gg"

Palomino = Palomino or {}
Palomino.VERSION = "0.0.1-pre-alpha"

include( "boot/sh_load.lua" )
AddCSLuaFile( "boot/sh_load.lua" )

Palomino.Load.Gamemode()