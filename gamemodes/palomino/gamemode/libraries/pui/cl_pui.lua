PUI = PUI or {}

local tColorCache = {}
function PUI.Color( nRed, nGreen, nBlue, nAlpha )
    nAlpha = nAlpha or 255

    local sKey = string.format( "%d_%d_%d_%d", nRed, nGreen, nBlue, nAlpha )
    if tColorCache[ sKey ] then
        return tColorCache[ sKey ]
    end

    local cColor = Color( nRed, nGreen, nBlue, nAlpha )
    tColorCache[ sKey ] = cColor

    return cColor
end

PUI.GREEN = PUI.Color( 43, 195, 140 )
PUI.BLUE = PUI.Color( 0, 165, 207 )
PUI.PURPLE = PUI.Color( 141, 106, 159 )
PUI.GRAY = PUI.Color( 57, 62, 65 )
PUI.GREY = PUI.GRAY
PUI.YELLOW = PUI.Color( 252, 236, 82 )
PUI.RED = PUI.Color( 255, 90, 90 )

PUI.WHITE = PUI.Color( 255, 255, 255 )
PUI.BLACK = PUI.Color( 0, 0, 0 )

function PUI.DrawUVElement( oMaterial, nWidth, nAlpha )
    local nMaterialWidth = oMaterial:Width()
    local nMaterialHeight = oMaterial:Height()

    surface.SetDrawColor( 255, 255, 255, nAlpha )
    surface.SetMaterial( oMaterial )

    -- Left border
    surface.DrawTexturedRectUV( 0, 0, nMaterialWidth / 2, nMaterialHeight, 0, 0, 0.5, 1 )

    -- Middle (repeat middle column)
    surface.DrawTexturedRectUV( nMaterialWidth / 2, 0, nWidth - nMaterialWidth, nMaterialHeight, 0.5, 0, 0.5, 1 )

    -- Right border
    surface.DrawTexturedRectUV( nWidth - nMaterialWidth / 2, 0, nMaterialWidth / 2, nMaterialHeight, 0.5, 0, 1, 1 )
end

local tMaterialCache = {}
function PUI.Material( sPath, sSettings )
    sSettings = sSettings or ""

    local sKey = "Palomino." .. util.SHA256( sPath .. ";" .. sSettings )
    if tMaterialCache[ sKey ] then
        return tMaterialCache[ sKey ]
    end

    tMaterialCache[ sKey ] = Material( sPath, sSettings )

    return tMaterialCache[ sKey ]
end

local tFontCache = {}
function PUI.Font( tSettings )
    local sKey = "Palomino." .. util.SHA256( util.TableToJSON( tSettings ) )
    if tFontCache[ sKey ] then
        return sKey
    end

    surface.CreateFont( sKey, tSettings )

    tFontCache[ sKey ] = true

    return sKey
end

function PUI.StartOverlay()
    render.OverrideBlend(
        true,
        BLEND_DST_COLOR,
        BLEND_SRC_COLOR,
        BLENDFUNC_ADD
    )
end

function PUI.EndOverlay()
    render.OverrideBlend( false )
end