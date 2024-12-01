PUI = PUI or {}

-- @PHeader

local PHeader = {}

AccessorFunc( PHeader, "_sHeader", "Header" )
AccessorFunc( PHeader, "_sSubHeader", "SubHeader" )

function PHeader:Init()
    -- @TODO: Scale
    self:SetTall( 80 )

    self._sHeaderFont = PUI.Font( {
        font = "Inter Bold",
        size = 48
    } )

    self._sSubHeaderFont = PUI.Font( {
        font = "Inter",
        size = 16
    } )

    self._cHeaderColor = PUI.WHITE
    self._cSubHeaderColor = ColorAlpha( PUI.WHITE, 150 )
end

function PHeader:Paint( nWidth, nHeight )
    draw.SimpleText( self:GetHeader() or "", self._sHeaderFont, 0, 0, self._cHeaderColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    -- @TODO: Scale Y pos
    draw.SimpleText( self:GetSubHeader() or "", self._sSubHeaderFont, 0, 48, self._cSubHeaderColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

vgui.Register( "PHeader", PHeader, "DPanel" )

-- @PCheckbox

local PCheckbox = {}

PCheckbox.MAT_DEFAULT = PUI.Material( "palomino/pui/pcheckbox_unchecked.png", "" )
PCheckbox.MAT_CHECKED = PUI.Material( "palomino/pui/pcheckbox_checked.png", "" )

AccessorFunc( PCheckbox, "_bChecked", "Checked" )
AccessorFunc( PCheckbox, "_sLabel", "Label", FORCE_STRING )

function PCheckbox:Init()
    self:SetTall( PCheckbox.MAT_DEFAULT:Height() )
    self:SetText( "" )

    self._bChecked = false

    self._sFont = PUI.Font( {
        font = "Inter Medium",
        size = 20
    } )
end

function PCheckbox:Paint( nWidth, nHeight )
    if self:GetChecked() then
        surface.SetMaterial( PCheckbox.MAT_CHECKED )
    else
        surface.SetMaterial( PCheckbox.MAT_DEFAULT )
    end

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 0, 0, nHeight, nHeight )

    -- @TODO: Scale
    draw.SimpleText( self:GetLabel(), self._sFont, nHeight + 10, nHeight / 2, PUI.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

function PCheckbox:DoClick()
    self:SetChecked( not self:GetChecked() )
end

vgui.Register( "PCheckbox", PCheckbox, "DButton" )

-- @PLabel

local PLabel = {}
PLabel.DEFAULT_ALPHA = 64

AccessorFunc( PLabel, "_sText", "Text" )

function PLabel:Init()
    -- @TODO: Scale
    self:SetTall( 16 )

    self._sFont = PUI.Font( {
        font = "Inter",
        size = 16
    } )

    self._cTextColor = ColorAlpha( PUI.WHITE, PLabel.DEFAULT_ALPHA )
end

function PLabel:Paint( nWidth, nHeight )
    draw.SimpleText( self:GetText(), self._sFont, 0, nHeight / 2, self._cTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

vgui.Register( "PLabel", PLabel, "DPanel" )

-- @PButtonSelect

local PButtonSelect = {}

PButtonSelect.MAT_DEFAULT = PUI.Material( "palomino/pui/pbuttonselect_test_1.png", "" )
PButtonSelect.MAT_HOVERED = PUI.Material( "palomino/pui/pbuttonselect_test_1_hovered.png", "" )
PButtonSelect.MAT_SELECTED = PUI.Material( "palomino/pui/pbuttonselect_test_1_selected.png", "" )
PButtonSelect.SPACE_BETWEEN = 3
PButtonSelect.DEFAULT_ALPHA = 32

function PButtonSelect:Init()
    self:SetTall( PButtonSelect.MAT_DEFAULT:Height() )

    self._sFont = PUI.Font( {
        font = "Inter SemiBold",
        size = 20
    } )

    self.tOptions = {}

    self._nSelectedIndex = -1
    self._tOptionButtons = {}
end

function PButtonSelect:GetSelectedIndex()
    return self._nSelectedIndex
end

function PButtonSelect:GetSelectedOption()
    return self.tOptions[ self._nSelectedIndex ]
end

function PButtonSelect:SetSelectedIndex( nIndex )
    self._nSelectedIndex = nIndex

    self:OnUpdate( self.tOptions[ nIndex ], nIndex )
end

function PButtonSelect:AddOption( sOption )
    table.insert( self.tOptions, sOption )

    self._tOptionButtons[ #self.tOptions ] = vgui.Create( "PButtonSelectButton", self )
    self._tOptionButtons[ #self.tOptions ]:SetValue( sOption )
    self._tOptionButtons[ #self.tOptions ]._nOptionIndex = #self.tOptions

    self:DoButtonLayout()
end

function PButtonSelect:Think()
    if self._nSelectedIndex == -1 then
        self._nSelectedIndex = 1
        self:OnUpdate( self.tOptions[ self._nSelectedIndex ], self._nSelectedIndex )

        self:DoButtonLayout()
    end
end

function PButtonSelect:DoButtonLayout()
    local nNumSpaces = #self.tOptions - 1
    local nOptionWidth = math.floor( ( self:GetWide() - ( nNumSpaces * PButtonSelect.SPACE_BETWEEN ) ) / #self.tOptions )

    for nIndex, dButtonSelectButton in ipairs( self._tOptionButtons ) do
        dButtonSelectButton:SetPos( ( nIndex - 1 ) * ( nOptionWidth + PButtonSelect.SPACE_BETWEEN ), 0 )
        dButtonSelectButton:SetSize( nOptionWidth, self:GetTall() )
    end
end

function PButtonSelect:OnUpdate( sOption, nIndex )
    -- Override
end

function PButtonSelect:Paint()
    return
end

vgui.Register( "PButtonSelect", PButtonSelect, "DPanel" )

PButtonSelectButton = PButtonSelectButton or {}

AccessorFunc( PButtonSelectButton, "_sValue", "Value" )

function PButtonSelectButton:Init()
    self:SetTall( PButtonSelect.MAT_DEFAULT:Height() )
    self:SetText( "" )

    self._nOptionIndex = -1

    self._sFont = PUI.Font( {
        font = "Inter SemiBold",
        size = 20
    } )
end

function PButtonSelectButton:PaintUV( oMaterial, nWidth, nHeight )
    -- surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( oMaterial )

    local nMaterialWidth = oMaterial:Width()
    local nMaterialHeight = oMaterial:Height()

    if self._nOptionIndex == 1 then
        surface.DrawTexturedRectUV( 0, 0, nMaterialWidth / 2, nMaterialHeight, 0, 0, 0.5, 1 )
        surface.DrawTexturedRectUV( nMaterialWidth / 2, 0, nWidth - nMaterialWidth / 2, nMaterialHeight, 0.5, 0, 0.5, 1 )
    elseif self._nOptionIndex == #self:GetParent().tOptions then
        surface.DrawTexturedRectUV( 0, 0, nWidth - nMaterialWidth / 2, nMaterialHeight, 0.5, 0, 0.5, 1 )
        surface.DrawTexturedRectUV( nWidth - nMaterialWidth / 2, 0, nMaterialWidth / 2, nMaterialHeight, 0.5, 0, 1, 1 )
    else
        surface.DrawTexturedRectUV( 0, 0, nWidth, nMaterialHeight, 0.5, 0, 0.5, 1 )
    end
end

function PButtonSelectButton:Paint( nWidth, nHeight )
    local bIsHovered = self:IsHovered()
    local bIsSelected = self:GetParent():GetSelectedIndex() == self._nOptionIndex

    if bIsSelected then
        local oMaterial = PButtonSelect.MAT_SELECTED
        surface.SetDrawColor( 255, 255, 255, 255 )
        self:PaintUV( oMaterial, nWidth, nHeight )
    elseif bIsHovered then
        surface.SetDrawColor( 255, 255, 255, PButtonSelect.DEFAULT_ALPHA )
        local oMaterial = PButtonSelect.MAT_HOVERED
        self:PaintUV( oMaterial, nWidth, nHeight )
    else
        surface.SetDrawColor( 255, 255, 255, PButtonSelect.DEFAULT_ALPHA )
        local oMaterial = PButtonSelect.MAT_DEFAULT
        self:PaintUV( oMaterial, nWidth, nHeight )
    end

    draw.SimpleText( self:GetValue(), self._sFont, nWidth / 2, nHeight / 2, PUI.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PButtonSelectButton:DoClick()
    self:GetParent()._nSelectedIndex = self._nOptionIndex
    self:GetParent():OnUpdate( self:GetValue(), self._nOptionIndex )
end

vgui.Register( "PButtonSelectButton", PButtonSelectButton, "DButton" )

-- @PPrimaryButton

local PPrimaryButton = {}

PPrimaryButton.MAT_DEFAULT = PUI.Material( "palomino/pui/pprimarybutton_test.png", "" )
PPrimaryButton.MAT_HOVERED = PUI.Material( "palomino/pui/pprimarybutton_test.png", "" )

AccessorFunc( PPrimaryButton, "_sLabel", "Label" )

function PPrimaryButton:Init()
    self:SetTall( PPrimaryButton.MAT_DEFAULT:Height() )
    self:SetText( "" )

    self._sFont = PUI.Font( {
        font = "Inter SemiBold",
        size = 20
    } )
end

function PPrimaryButton:Paint( nWidth, nHeight )
    local bIsHovered = self:IsHovered()

    if bIsHovered then
        PUI.DrawUVElement( PPrimaryButton.MAT_HOVERED, nWidth, 255 )
    else
        PUI.DrawUVElement( PPrimaryButton.MAT_DEFAULT, nWidth, 255 )
    end

    draw.SimpleText( self:GetLabel(), self._sFont, nWidth / 2, nHeight / 2, PUI.BLACK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "PPrimaryButton", PPrimaryButton, "DButton" )

-- @PButton

local PButton = {}

PButton.MAT_DEFAULT = PUI.Material( "palomino/pui/pbutton_test_3.png", "" )
PButton.MAT_HOVERED = PUI.Material( "palomino/pui/pbutton_test_3_hovered.png", "" )
PButton.MAT_PRESSED = PUI.Material( "palomino/pui/pbutton_test_3_pressed.png", "" )
PButton.MAT_PRIMARY = PUI.Material( "palomino/pui/pbutton_test_primary.png", "" )
PButton.TRANSITION_TIME = 0.15

AccessorFunc( PButton, "_sLabel", "Label" )

function PButton:Init()
    self:SetTall( PButton.MAT_DEFAULT:Height() )
    self:SetText( "" )

    self._sFont = PUI.Font( {
        font = "Inter SemiBold",
        size = 20
    } )
end

function PButton:Paint( nWidth, nHeight )
    local bIsHovered = self:IsHovered()
    local bIsDown = self:IsDown()

    if bIsDown then
        PUI.DrawUVElement( PButton.MAT_PRESSED, nWidth, 255 )
    elseif bIsHovered then
        self._nHoverTime = self._nSelectTime or CurTime()

        PUI.DrawUVElement( PButton.MAT_HOVERED, nWidth, 255 )
    else
        self._nHoverTime = nil
        PUI.DrawUVElement( PButton.MAT_DEFAULT, nWidth, 255 )
    end

    draw.SimpleText( self:GetLabel(), self._sFont, nWidth / 2, nHeight / 2, PUI.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "PUI.Button", PButton, "DButton" )

-- @PArrowSelector

local PArrowSelector = {}

PArrowSelector.MAT_DEFAULT = PUI.Material( "palomino/pui/textentry_test_3.png", "" )
PArrowSelector.MAT_HOVERED = PUI.Material( "palomino/pui/textentry_test_3_hovered.png", "" )
PArrowSelector.MAT_UPDATE = PUI.Material( "palomino/pui/textentry_test_4_selected.png", "" )
PArrowSelector.TRANSITION_TIME = 0.2
PArrowSelector.ARROW_UNHOVERED_ALPHA = 100
PArrowSelector.DEFAULT_ALPHA = 32

function PArrowSelector:Init()
    self:SetTall( PArrowSelector.MAT_DEFAULT:Height() )
    self:SetText( "" )

    self._sFont = PUI.Font( {
        font = "Inter SemiBold",
        size = 20
    } )

    self._nSelectTime = 0
    self._nSelectedIndex = 1
    self.tOptions = {}

    self._dArrowLeft = vgui.Create( "DButton", self )
    self._dArrowLeft:SetSize( self:GetTall(), self:GetTall() )
    self._dArrowLeft:SetPos( 0, 0 )
    self._dArrowLeft:SetFont( self._sFont )
    self._dArrowLeft:SetText( "" )
    self._dArrowLeft._nAlpha = PArrowSelector.ARROW_UNHOVERED_ALPHA
    self._dArrowLeft.Paint = function( this, nWidth, nHeight )
        self._dArrowLeft._bHovered = this:IsHovered()
        self._dArrowLeft._nAlpha = Lerp( FrameTime() * 30, self._dArrowLeft._nAlpha, this:IsHovered() and 255 or PArrowSelector.ARROW_UNHOVERED_ALPHA )
        local cColor = ColorAlpha( PUI.WHITE, self._dArrowLeft._nAlpha )

        draw.SimpleText( "<", self._sFont, nWidth / 2, nHeight / 2, cColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    self._dArrowLeft.DoClick = function()
        if self._nSelectedIndex <= 1 then
            self._nSelectedIndex = #self.tOptions
        else
            self._nSelectedIndex = self._nSelectedIndex - 1
        end

        self._nSelectTime = CurTime()
        self:OnUpdate( self._nSelectedIndex )
    end

    self._dArrowRight = vgui.Create( "DButton", self )
    self._dArrowRight:SetSize( self:GetTall(), self:GetTall() )
    self._dArrowRight:SetPos( self:GetWide() - self._dArrowRight:GetWide(), 0 )
    self._dArrowRight:SetFont( self._sFont )
    self._dArrowRight:SetText( "" )
    self._dArrowRight._nAlpha = PArrowSelector.ARROW_UNHOVERED_ALPHA
    self._dArrowRight.Paint = function( this, nWidth, nHeight )
        self._dArrowRight._bHovered = this:IsHovered()
        self._dArrowRight._nAlpha = Lerp( FrameTime() * 30, self._dArrowRight._nAlpha, this:IsHovered() and 255 or PArrowSelector.ARROW_UNHOVERED_ALPHA )
        local cColor = ColorAlpha( PUI.WHITE, self._dArrowRight._nAlpha )

        draw.SimpleText( ">", self._sFont, nWidth / 2, nHeight / 2, cColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    self._dArrowRight.DoClick = function()
        if self._nSelectedIndex >= #self.tOptions then
            self._nSelectedIndex = 1
        else
            self._nSelectedIndex = self._nSelectedIndex + 1
        end

        self._nSelectTime = CurTime()
        self:OnUpdate( self.tOptions[self._nSelectedIndex], self._nSelectedIndex )
    end
end

function PArrowSelector:GetSelectedIndex()
    return self._nSelectedIndex
end

function PArrowSelector:SetSelectedIndex( nIndex )
    self._nSelectedIndex = nIndex

    self:OnUpdate( self.tOptions[ nIndex ], nIndex )
end

function PArrowSelector:GetSelectedOption()
    return self.tOptions[ self._nSelectedIndex ]
end

function PArrowSelector:DoClick()
    self._dArrowRight:DoClick()
end

function PArrowSelector:DoRightClick()
    self._dArrowLeft:DoClick()
end

function PArrowSelector:Think()
    if self._nSelectedIndex > #self.tOptions then
        self._nSelectedIndex = 1
    end

    if self._dArrowRight:GetX() ~= self:GetWide() - self._dArrowRight:GetWide() then
        self._dArrowRight:SetPos( self:GetWide() - self._dArrowRight:GetWide(), 0 )
    end
end

function PArrowSelector:Paint( nWidth, nHeight )
    if CurTime() - self._nSelectTime < PArrowSelector.TRANSITION_TIME then
        local nAlphaMultiplier = math.ease.OutCubic( math.Clamp( ( CurTime() - self._nSelectTime ) / PArrowSelector.TRANSITION_TIME, 0, 1 ) )

        PUI.DrawUVElement( PArrowSelector.MAT_UPDATE, nWidth, 255 - 255 * nAlphaMultiplier )
        PUI.DrawUVElement( PArrowSelector.MAT_HOVERED, nWidth, self.DEFAULT_ALPHA * nAlphaMultiplier )
    else
        local bIsHovered = self:IsHovered() or self._dArrowLeft._bHovered or self._dArrowRight._bHovered
        if bIsHovered then
            PUI.DrawUVElement( PArrowSelector.MAT_HOVERED, nWidth, self.DEFAULT_ALPHA )
        else
            PUI.DrawUVElement( PArrowSelector.MAT_DEFAULT, nWidth, self.DEFAULT_ALPHA )
        end
    end

    draw.SimpleText( self.tOptions[ self._nSelectedIndex ] or "", self._sFont, nWidth / 2, nHeight / 2, PUI.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PArrowSelector:AddOption( sOption )
    table.insert( self.tOptions, sOption )
end

function PArrowSelector:SetOptions( tOptions )
    self.tOptions = tOptions
end

function PArrowSelector:OnUpdate( sOption, nIndex )
    -- Override
end

vgui.Register( "PArrowSelector", PArrowSelector, "DButton" )

-- @PTextEntry

local PTextEntry = {}

PTextEntry.MAT_DEFAULT = PUI.Material( "palomino/pui/textentry_test_3.png", "" )
PTextEntry.MAT_HOVERED = PUI.Material( "palomino/pui/textentry_test_3_hovered.png", "" )
PTextEntry.MAT_SELECTED = PUI.Material( "palomino/pui/textentry_test_4_selected.png", "" )
PTextEntry.TRANSITION_TIME = 0.15
PTextEntry.DEFAULT_ALPHA = 32

function PTextEntry:Init()
    self:SetTall( PTextEntry.MAT_DEFAULT:Height() )
    self:SetCursor( "beam" )
    self:SetText( "" )

    self._bHasFocus = false
    self._sFont = PUI.Font( {
        font = "Inter SemiBold",
        size = 20
    } )

    self._dTextEntry = vgui.Create( "DTextEntry", self )
    self._dTextEntry:SetPos( PTextEntry.MAT_DEFAULT:Width() / 2, 0 )
    self._dTextEntry:SetSize( self:GetWide() - PTextEntry.MAT_DEFAULT:Width(), self:GetTall() )
    self._dTextEntry:SetFont( self._sFont )
    self._dTextEntry.Paint = function( this, nWidth, nHeight )
        local sText = this:GetValue()
        draw.SimpleText( sText, self._sFont, 0, nHeight / 2, PUI.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

        -- Draw cursor
        if this:HasFocus() and self._nSelectTime then
            local nCursorPos = this:GetCaretPos()
            local sTextBeforeCursor = sText:sub( 1, nCursorPos )
            local nTextWidth = surface.GetTextSize( sTextBeforeCursor )
            local nCursorX = nTextWidth

            if ( self._nSelectTime - CurTime() ) % 1 > 0.5 then
                draw.SimpleText( "|", self._sFont, nCursorX, nHeight / 2, PUI.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end
        end

        -- Draw selected text
        local nSelectedRangeStart, nSelectedRangeEnd = this:GetSelectedTextRange()
        if nSelectedRangeStart ~= nSelectedRangeEnd then
            local sTextBeforeSelection = sText:sub( 1, nSelectedRangeStart )
            local nTextWidthBeforeSelection = surface.GetTextSize( sTextBeforeSelection )
            local nSelectionWidth = surface.GetTextSize( sText:sub( nSelectedRangeStart + 1, nSelectedRangeEnd ) )

            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawRect( nTextWidthBeforeSelection, 0, nSelectionWidth, nHeight )

            -- Draw selected text
            draw.SimpleText( sText:sub( nSelectedRangeStart + 1, nSelectedRangeEnd ), self._sFont, nTextWidthBeforeSelection, nHeight / 2, PUI.BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
    end

    self._dTextEntry.OnGetFocus = function( this )
        self._bHasFocus = true
    end

    self._dTextEntry.OnLoseFocus = function( this )
        self._bHasFocus = self:IsDown()

        if self._bHasFocus then
            self._dTextEntry:RequestFocus()
        end
    end

    self._dTextEntry.OnChange = function( this )
        -- Check if value of length is greater than the width of the text entry
        local sText = this:GetValue()

        if #sText > self:GetMaxChars() then
            this:SetText( sText:sub( 1, self:GetMaxChars() ) )
            this:SetCaretPos( #sText )
        end
    end
end

function PTextEntry:SetMaxChars( nMaxChars )
    self._nMaxChars = nMaxChars
end

function PTextEntry:GetMaxChars()
    return self._nMaxChars or 24
end

function PTextEntry:GetValue()
    return self._dTextEntry:GetValue()
end

function PTextEntry:Think()
    if self._dTextEntry:GetSize() ~= self:GetSize() - PTextEntry.MAT_DEFAULT:Width() then
        self._dTextEntry:SetSize( self:GetWide() - PTextEntry.MAT_DEFAULT:Width(), self:GetTall() )
    end
end

function PTextEntry:DoClick()
    if not self._bHasFocus then
        self._dTextEntry:RequestFocus()
    else
        local nLocalCursorX, nLocalCursorY = self._dTextEntry:LocalCursorPos()

        if nLocalCursorX < 0 then
            self._dTextEntry:SetCaretPos( 0 )
        else
            local sText = self._dTextEntry:GetText()
            local nTextWidth = surface.GetTextSize( sText )

            if nLocalCursorX > nTextWidth then
                self._dTextEntry:SetCaretPos( #sText )
            end
        end
    end
end

function PTextEntry:Paint( nWidth, nHeight )
    local bIsHovered = self:IsHovered() or self._dTextEntry:IsHovered()
    local bHasFocus = self._bHasFocus

    if bHasFocus then
        if not self._nSelectTime then self._nSelectTime = CurTime() end

        local nAlphaMultiplier = math.ease.OutCubic( math.Clamp( ( CurTime() - self._nSelectTime ) / PTextEntry.TRANSITION_TIME, 0, 1 ) )

        PUI.DrawUVElement( PTextEntry.MAT_HOVERED, nWidth, self.DEFAULT_ALPHA - self.DEFAULT_ALPHA * nAlphaMultiplier )
        PUI.DrawUVElement( PTextEntry.MAT_SELECTED, nWidth, 255 * nAlphaMultiplier )
    else
        self._nSelectTime = nil

        if bIsHovered then
            PUI.DrawUVElement( PTextEntry.MAT_HOVERED, nWidth, self.DEFAULT_ALPHA )
        else
            PUI.DrawUVElement( PTextEntry.MAT_DEFAULT, nWidth, self.DEFAULT_ALPHA )
        end
    end
end

vgui.Register( "PTextEntry", PTextEntry, "DButton" )

-- @PElementsFrame

PUI.ElementsFrame = PUI.ElementsFrame or nil
concommand.Add( "pui_elements", function()
    if IsValid( PUI.ElementsFrame ) then
        PUI.ElementsFrame:Remove()
        PUI.ElementsFrame = nil
        return
    end

    PUI.ElementsFrame = vgui.Create( "DFrame" )
    PUI.ElementsFrame:SetSize( ScrW() / 4, ScrH() )
    PUI.ElementsFrame:SetPos( ScrW() / 2 - ScrW() / 8, 0 )
    PUI.ElementsFrame:MakePopup()

    PUI.ElementsFrame.Scroll = vgui.Create( "DScrollPanel", PUI.ElementsFrame )
    PUI.ElementsFrame.Scroll:Dock( FILL )

    PUI.ElementsFrame.Scroll.Layout = vgui.Create( "DIconLayout", PUI.ElementsFrame.Scroll )
    PUI.ElementsFrame.Scroll.Layout:Dock( FILL )

    PUI.ElementsFrame.Scroll.Layout.Header = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PHeader" ) )
    PUI.ElementsFrame.Scroll.Layout.Header:SetHeader( "PUI ELEMENTS" )
    PUI.ElementsFrame.Scroll.Layout.Header:SetSubHeader( "A list of sexy PUI elements for you to use." )
    PUI.ElementsFrame.Scroll.Layout.Header:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.TextEntryLabel = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PLabel" ) )
    PUI.ElementsFrame.Scroll.Layout.TextEntryLabel:SetText( "TEXT ENTRY:" )
    PUI.ElementsFrame.Scroll.Layout.TextEntryLabel:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.TextEntry = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PTextEntry" ) )
    PUI.ElementsFrame.Scroll.Layout.TextEntry:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.ArrowSelectorLabel = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PLabel" ) )
    PUI.ElementsFrame.Scroll.Layout.ArrowSelectorLabel:SetText( "ARROW SELECTOR:" )
    PUI.ElementsFrame.Scroll.Layout.ArrowSelectorLabel:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.ArrowSelector = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PArrowSelector" ) )
    PUI.ElementsFrame.Scroll.Layout.ArrowSelector:AddOption( "Option 1" )
    PUI.ElementsFrame.Scroll.Layout.ArrowSelector:AddOption( "Option 2" )
    PUI.ElementsFrame.Scroll.Layout.ArrowSelector:AddOption( "Option 3" )
    PUI.ElementsFrame.Scroll.Layout.ArrowSelector:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.PrimaryButtonLabel = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PLabel" ) )
    PUI.ElementsFrame.Scroll.Layout.PrimaryButtonLabel:SetText( "PRIMARY BUTTON:" )
    PUI.ElementsFrame.Scroll.Layout.PrimaryButtonLabel:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.PrimaryButton = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PPrimaryButton" ) )
    PUI.ElementsFrame.Scroll.Layout.PrimaryButton:SetLabel( "Primary Button" )
    PUI.ElementsFrame.Scroll.Layout.PrimaryButton:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.ButtonLabel = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PLabel" ) )
    PUI.ElementsFrame.Scroll.Layout.ButtonLabel:SetText( "BUTTON:" )
    PUI.ElementsFrame.Scroll.Layout.ButtonLabel:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.Button = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PUI.Button" ) )
    PUI.ElementsFrame.Scroll.Layout.Button:SetLabel( "Button" )
    PUI.ElementsFrame.Scroll.Layout.Button:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.ButtonSelectLabel = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PLabel" ) )
    PUI.ElementsFrame.Scroll.Layout.ButtonSelectLabel:SetText( "BUTTON SELECT:" )
    PUI.ElementsFrame.Scroll.Layout.ButtonSelectLabel:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.ButtonSelect = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PButtonSelect" ) )
    PUI.ElementsFrame.Scroll.Layout.ButtonSelect:AddOption( "Male" )
    PUI.ElementsFrame.Scroll.Layout.ButtonSelect:AddOption( "Female" )
    PUI.ElementsFrame.Scroll.Layout.ButtonSelect:AddOption( "Other" )
    PUI.ElementsFrame.Scroll.Layout.ButtonSelect:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.CheckboxLabel = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PLabel" ) )
    PUI.ElementsFrame.Scroll.Layout.CheckboxLabel:SetText( "CHECKBOX:" )
    PUI.ElementsFrame.Scroll.Layout.CheckboxLabel:Dock( TOP )

    PUI.ElementsFrame.Scroll.Layout.Checkbox = PUI.ElementsFrame.Scroll.Layout:Add( vgui.Create( "PCheckbox" ) )
    PUI.ElementsFrame.Scroll.Layout.Checkbox:SetLabel( "I agree to let others have fun." )
    PUI.ElementsFrame.Scroll.Layout.Checkbox:Dock( TOP )
end )