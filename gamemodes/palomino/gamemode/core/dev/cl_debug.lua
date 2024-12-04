Palomino.Dev = Palomino.Dev or {}
Palomino.Dev.Debug = Palomino.Dev.Debug or {}

local cvDebug = CreateConVar( "palomino_debug", "0", FCVAR_ARCHIVE, "Display debug information" )
local cvDebugAPI = CreateConVar( "palomino_debug_api", "0", FCVAR_ARCHIVE, "Display api debug information" )

hook.Add( "HUDPaint", "Palomino.Dev.Debug.HUDPaint", function()
    if not cvDebug:GetBool() then return end

    local iY = 200

    if cvDebugAPI:GetBool() then
        local sSessionToken = Palomino.API.SessionToken or "N/A"
        draw.SimpleText( "API Information:", "DebugOverlay", 10, iY, PUI.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        iY = iY + 16
        draw.SimpleText( sSessionToken, "DebugFixed", 10, iY, PUI.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end
end )