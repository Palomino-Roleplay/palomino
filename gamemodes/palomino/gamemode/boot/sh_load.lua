Palomino.Load = Palomino.Load or {}

function Palomino.Load.Log( sMessage )
    MsgC(
        Color( 255, 255, 255 ),
        "[",
        Color( 100, 220, 100, 200 ),
        "Palomino Load",
        Color( 255, 255, 255 ),
        "]: ",
        SERVER and Color( 156, 241, 255, 200 ) or Color( 255, 241, 122, 200 ),
        sMessage,
        "\n"
    )
end

function Palomino.Load.File( sFilePath )
    -- @TODO: Consider error checking (xpcall)

    local sFileName = string.GetFileFromFilename( sFilePath )

    if string.StartsWith( sFileName, "sh_" ) then
        if SERVER then
            AddCSLuaFile( sFilePath )
            include( sFilePath )
        elseif CLIENT then
            include( sFilePath )
        end
    elseif string.StartsWith( sFileName, "cl_" ) then
        if SERVER then
            AddCSLuaFile( sFilePath )
        elseif CLIENT then
            include( sFilePath )
        end
    elseif string.StartsWith( sFileName, "sv_" ) then
        if SERVER then
            include( sFilePath )
        end
    end
end

function Palomino.Load.Folder( sDirectory )
    local tFiles, tFolders = file.Find( sDirectory .. "/*", "LUA" )

    Palomino.Load.Log( "Loading " .. #tFiles .. " files in " .. sDirectory )

    for _, sFile in ipairs( tFiles ) do
        Palomino.Load.File( sDirectory .. "/" .. sFile )
    end
end

function Palomino.Load.Modules( sDirectory )
    local tFiles, tFolders = file.Find( sDirectory .. "/*", "LUA" )

    Palomino.Load.Log( "Loading " .. #tFolders .. " modules in " .. sDirectory )

    for _, sFolder in ipairs( tFolders ) do
        Palomino.Load.Folder( sDirectory .. "/" .. sFolder )
    end
end

function Palomino.Load.Gamemode()
    Palomino.Load.Log( "Loading gamemode..." )

    Palomino.Load.Folder( GM.FolderName .. "/gamemode/libraries" )
    Palomino.Load.Modules( GM.FolderName .. "/gamemode/libraries" )

    Palomino.Load.Modules( GM.FolderName .. "/gamemode/core" )

    Palomino.Load.Log( "Loading complete!" )
end