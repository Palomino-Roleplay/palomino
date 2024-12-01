Palomino = Palomino or {}
Palomino.Character = Palomino.Character or {}

local CreateCharacterPanel = {}

CreateCharacterPanel.MAT_BG = PUI.Material( "palomino/panels/createcharacter/bg_test_6.png" )
CreateCharacterPanel.MAT_OVERLAY = PUI.Material( "palomino/panels/createcharacter/overlay_test_2.png" )
CreateCharacterPanel.CREATE_ANIMATION_DURATION = 1

function CreateCharacterPanel:Init()
    self:SetSize( ScrW(), ScrH() )
    self:SetTitle( "" )
    self:SetDraggable( false )
    self:ShowCloseButton( false )

    -- -- Close Button
    self._dCloseButton = vgui.Create( "DButton", self )
    self._dCloseButton:SetText( "X" )
    self._dCloseButton:SetSize( 50, 50 )
    self._dCloseButton:SetPos( self:GetWide() - self._dCloseButton:GetWide(), 0 )
    self._dCloseButton.DoClick = function()
        self:Remove()
    end
    self._dCloseButton.Paint = function( _, w, h )
        -- draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
    end
    self._dCloseButton:SetZPos( 100 )

    -- DLeftPanel
    self._dLeftPanel = vgui.Create( "DPanel", self )
    self._dLeftPanel:SetSize( self:GetWide() * 0.25, self:GetTall() * 0.8 )
    self._dLeftPanel:SetPos( self:GetWide() * 0.05, self:GetTall() * 0.1 )
    self._dLeftPanel._nInitX, self._dLeftPanel._nInitY = self._dLeftPanel:GetPos()
    self._dLeftPanel.Paint = function( this, w, h )
        -- draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        -- this:SetAlpha( 128 )
    end

    -- DIconLayout
    self._dIconLayout = vgui.Create( "DIconLayout", self._dLeftPanel )
    self._dIconLayout:SetSize( self._dLeftPanel:GetWide(), self._dLeftPanel:GetTall() )
    -- self._dIconLayout:SetSize( FILL )
    self._dIconLayout:SetSpaceY( 10 )
    self._dIconLayout:SetLayoutDir( TOP )

    -- Header
    self._dHeader = self._dIconLayout:Add( "PHeader" )
    self._dHeader:SetWide( self._dIconLayout:GetWide() )
    self._dHeader:SetHeader( "NEW CHARACTER" )
    self._dHeader:SetSubHeader( "I'm not really sure what to put here. Any ideas?" )

    -- First Name
    self._dFirstNameLabel = self._dIconLayout:Add( "PLabel" )
    self._dFirstNameLabel:SetWide( self._dIconLayout:GetWide() )
    self._dFirstNameLabel:SetText( "FIRST NAME:" )

    self._dFirstNameEntry = self._dIconLayout:Add( "PTextEntry" )
    self._dFirstNameEntry:SetWide( self._dIconLayout:GetWide() )
    self._dFirstNameEntry:SetAllowedChars( "%a" )

    -- Last Name
    self._dLastNameLabel = self._dIconLayout:Add( "PLabel" )
    self._dLastNameLabel:SetWide( self._dIconLayout:GetWide() )
    self._dLastNameLabel:SetText( "LAST NAME:" )

    self._dLastNameEntry = self._dIconLayout:Add( "PTextEntry" )
    self._dLastNameEntry:SetWide( self._dIconLayout:GetWide() )
    self._dLastNameEntry:SetAllowedChars( "%a-" )

    -- Sex
    self._dSexLabel = self._dIconLayout:Add( "PLabel" )
    self._dSexLabel:SetWide( self._dIconLayout:GetWide() )
    self._dSexLabel:SetText( "SEX:" )

    self._dSexEntry = self._dIconLayout:Add( "PButtonSelect" )
    self._dSexEntry:SetWide( self._dIconLayout:GetWide() )
    self._dSexEntry:AddOption( "MALE" )
    -- self._dSexEntry:AddOption( "NONBINARY" )
    self._dSexEntry:AddOption( "FEMALE" )
    self._dSexEntry.OnUpdate = function( this, sSex, nIndex )
        if sSex == "MALE" then
            self._dModelEntry:SetOptions({
                "MALE_01",
                "MALE_02",
                "MALE_03",
                "MALE_04",
                "MALE_05",
                "MALE_06",
                "MALE_07",
                "MALE_08",
                "MALE_09",
            })

            self._dModelEntry:SetSelectedIndex( 1 )
        elseif sSex == "FEMALE" then
            self._dModelEntry:SetOptions({
                "FEMALE_01",
                "FEMALE_02",
                "FEMALE_03",
                "FEMALE_04",
                "FEMALE_05",
                "FEMALE_06",
            })

            self._dModelEntry:SetSelectedIndex( 1 )
        end
    end

    -- Model Select
    self._dModelLabel = self._dIconLayout:Add( "PLabel" )
    self._dModelLabel:SetWide( self._dIconLayout:GetWide() )
    self._dModelLabel:SetText( "MODEL:" )

    self._dModelEntry = self._dIconLayout:Add( "PArrowSelector" )
    self._dModelEntry:SetWide( self._dIconLayout:GetWide() )
    self._dModelEntry:SetOptions({
        "MALE_01",
        "MALE_02",
        "MALE_03",
        "MALE_04",
        "MALE_05",
        "MALE_06",
        "MALE_07",
        "MALE_08",
        "MALE_09",
    })
    self._dModelEntry.OnUpdate = function( this, sModel, nIndex )
        self:ChangeModel( string.format( "models/player/group01/%s.mdl", string.lower( sModel ) ) )
    end

    -- Face Select
    self._dFaceLabel = self._dIconLayout:Add( "PLabel" )
    self._dFaceLabel:SetWide( self._dIconLayout:GetWide() )
    self._dFaceLabel:SetText( "FACE:" )

    self._dFaceEntry = self._dIconLayout:Add( "PArrowSelector" )
    self._dFaceEntry:SetWide( self._dIconLayout:GetWide() )
    self._dFaceEntry:SetOptions({
        "FACE_01",
        "FACE_02",
        "FACE_03",
        "FACE_04",
        "FACE_05",
    })

    -- Agreement
    self._dAgreementLabel = self._dIconLayout:Add( "PLabel" )
    self._dAgreementLabel:SetWide( self._dIconLayout:GetWide() )
    self._dAgreementLabel:SetText( "AGREEMENT:" )

    self._dAgreementEntry = self._dIconLayout:Add( "PCheckbox" )
    self._dAgreementEntry:SetWide( self._dIconLayout:GetWide() )
    self._dAgreementEntry:SetLabel( "I agree to let others have fun." )

    -- Create Button
    self._dCreateButton = vgui.Create( "PPrimaryButton", self._dLeftPanel )
    self._dCreateButton:SetWide( self._dIconLayout:GetWide() )
    self._dCreateButton:SetLabel( "CREATE CHARACTER" )
    self._dCreateButton:Dock( BOTTOM )
    self._dCreateButton.DoClick = function()
        self:DoCreateAnimation()
    end



    -- DModelPanel
    self._dModelPanel1 = vgui.Create( "Palomino.CreateCharacter.Model", self )
    self._dModelPanel1:SetSize( self:GetTall() * 0.9, self:GetTall() )
    self._dModelPanel1:SetPos( self:GetWide() * 0.43, 0 )
    self._dModelPanel1:SetModel( "models/player/group01/male_01.mdl" )
    self._dModelPanel1:SetDisplayed( true, true )

    self._dModelPanel2 = vgui.Create( "Palomino.CreateCharacter.Model", self )
    self._dModelPanel2:SetSize( self:GetTall() * 0.9, self:GetTall() )
    self._dModelPanel2:SetPos( self:GetWide() * 0.43, 0 )
    self._dModelPanel2:SetModel( "models/player/group01/male_01.mdl" )
    self._dModelPanel2:SetDisplayed( false, true )

    -- self._dModelPanel1._nAnimationStart = 0
    -- self._dModelPanel2._nAnimationStart = 0



    -- Internal Vars
    self._bCreated = false
    self._nCreateAnimationStart = false
    self._nInit = false
end

function CreateCharacterPanel:Paint()
    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( CreateCharacterPanel.MAT_BG )
    -- TIL my monitor isnt 21:9...
    local nWidth = 43 / 18 * ScrH()
    surface.DrawTexturedRect( ( ScrW() - nWidth ) / 2, 0, nWidth, ScrH() )

    if self._bCreated then
        surface.SetDrawColor( 0, 0, 0, 255 * self._nCreateAnimationProgress )
        surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    end

    -- PUI.StartOverlay()
    --     surface.SetDrawColor( 255, 255, 255, 255 )
    --     surface.SetMaterial( CreateCharacterPanel.MAT_OVERLAY )
    --     surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )
    -- PUI.EndOverlay()
end

-- FUN FACT: I fucked them up. The active panel is the one that is not displayed.
-- Sorry for the confusion <3
function CreateCharacterPanel:GetActiveModelPanel()
    return self._dModelPanel1:GetDisplayed() and self._dModelPanel1 or self._dModelPanel2
end

function CreateCharacterPanel:GetInactiveModelPanel()
    return self._dModelPanel1:GetDisplayed() and self._dModelPanel2 or self._dModelPanel1
end

function CreateCharacterPanel:ChangeModel(sModel)
    local dActivePanel = self:GetActiveModelPanel()
    local dInactivePanel = self:GetInactiveModelPanel()

    dActivePanel._nSequence = dInactivePanel._nSequence

    dActivePanel:SetZPos(1)
    dInactivePanel:SetZPos(0)

    -- Set the new model on the inactive panel
    dActivePanel:SetModel(sModel)

    -- Start the transition
    if not self._nInit then
        self._nInit = true
    else
        dActivePanel:SetDisplayed(false)
        dInactivePanel:SetDisplayed(true)
    end
end

function CreateCharacterPanel:Think()
    if self._bCreated then
        self._nCreateAnimationProgress = math.ease.OutQuad(math.Clamp((CurTime() - self._nCreateAnimationStart) / self.CREATE_ANIMATION_DURATION, 0, 1))
        self._dLeftPanel:SetPos( self._dLeftPanel._nInitX - ( self._nCreateAnimationProgress * ( self._dLeftPanel._nInitX + self._dLeftPanel:GetWide() ) ), self._dLeftPanel._nInitY )
        self._dLeftPanel:SetAlpha( 255 * (1 - self._nCreateAnimationProgress) )

        if self._nCreateAnimationProgress >= 1 and not self._bCreateAnimationComplete then
            self._bCreateAnimationComplete = true

            local dActivePanel = self:GetActiveModelPanel()
            local dInactivePanel = self:GetInactiveModelPanel()

            dActivePanel.Entity:SetModel( dInactivePanel.Entity:GetModel() )

            -- self:GetActiveModelPanel():SetDisplayed( true )
            -- self:GetInactiveModelPanel():SetDisplayed( true )
            dActivePanel._bDeleteNonOverlay = true
            dActivePanel:SetDisplayed( false )
            dInactivePanel:SetDisplayed( true )

            -- self:GetInactiveModelPanel():SetDisplayed( true )
        end
    end
end

function CreateCharacterPanel:DoCreateAnimation()
    self._bCreated = true
    self._nCreateAnimationStart = CurTime()
end

vgui.Register( "Palomino.CreateCharacter", CreateCharacterPanel, "DFrame" )

-- @CreateCharacter.Model

local CreateCharacterModelPanel = {}
CreateCharacterModelPanel.ANIMATION_DURATION = 1
CreateCharacterModelPanel.OVERLAY_HEIGHT = 500  -- Height of the overlay band at transition edge
CreateCharacterModelPanel.Sequences = {
    "pose_standing_02",
    "pose_standing_01",
    -- "pose_standing_04",
    "idle_all_scared",
    "idle_all_01",
}

function CreateCharacterModelPanel:Init()
    self:SetFOV(6)
    self._nSequence = 1
    self._nAnimationStart = 0
    
    -- Set up lighting
    self:SetDirectionalLight(BOX_TOP, (Color(71, 172, 255):ToVector() * 1):ToColor())
    self:SetDirectionalLight(BOX_BACK, (Color(0, 0, 0):ToVector() * 1):ToColor())
    self:SetDirectionalLight(BOX_LEFT, (Color(52, 124, 184):ToVector() * 1):ToColor())
    self:SetDirectionalLight(BOX_BOTTOM, (Color(93, 57, 151):ToVector() * 1):ToColor())
    self:SetDirectionalLight(BOX_RIGHT, (Color(44, 104, 71):ToVector() * 1):ToColor())
    self:SetDirectionalLight(BOX_FRONT, (Color(255, 255, 255):ToVector() * 1):ToColor())
end

function CreateCharacterModelPanel:DoClick()
    self._nSequence = self._nSequence + 1
    if self._nSequence > #self.Sequences then
        self._nSequence = 1
    end
end

function CreateCharacterModelPanel:DrawModel()
    local eEntity = self.Entity

    render.SetModelLighting(0, 1, 1, 1)

    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.ClearStencil()

    render.SetStencilEnable(true)

    -- Calculate animation progress
    local nAnimationProgress = math.ease.OutQuad(math.Clamp((CurTime() - self._nAnimationStart) / self.ANIMATION_DURATION, 0, 1))
    -- Adjust Y position to start above screen and end below it
    local nY = (0 - self.OVERLAY_HEIGHT) + ((ScrH() + self.OVERLAY_HEIGHT * 2) * nAnimationProgress)

    -- Step 0: Write the outer mask to bit 4
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilReferenceValue(4)
    render.SetStencilWriteMask(4)

    render.OverrideColorWriteEnable(true, false)
    cam.Start2D()
        if self._bDisplayed then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(0, nY, self:GetWide(), ScrH() - nY)
        else
            if self._bDeleteNonOverlay then
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(0, nY - self.OVERLAY_HEIGHT, self:GetWide(), nY)
            else
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(0, 0, self:GetWide(), nY)
            end
        end
    cam.End2D()
    render.OverrideColorWriteEnable(false)

    -- Step 1: Draw model where mask exists
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilReferenceValue(5)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(4)

    -- if ( ( not self:GetParent()._bCreated ) or not self:GetDisplayed() ) or not self._bKeepAlive then
        -- eEntity:SetupBones()
        eEntity:DrawModel()
    -- end

    cam.Start2D()
        -- Step 2: Write sliding rectangle to bit 2 where bits 4 and 1 exist
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilReferenceValue(7)
        render.SetStencilWriteMask(2)
        render.SetStencilTestMask(5)

        if self._bDisplayed then
            -- surface.SetDrawColor(255, 255, 255, 255)
            -- surface.DrawRect(0, nY - self.OVERLAY_HEIGHT/2, self:GetWide(), self.OVERLAY_HEIGHT)
        else
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(0, nY - self.OVERLAY_HEIGHT, self:GetWide(), self.OVERLAY_HEIGHT)
        end

        -- Step 3: Draw overlay where all bits exist
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilReferenceValue(7)
        render.SetStencilTestMask(7)

        local oOverlayMaterial = self:GetParent().MAT_OVERLAY
        local nX, nY_screen = self:LocalToScreen(0, 0)

        surface.SetMaterial(oOverlayMaterial)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectUV(
            0, 0,
            self:GetWide(),
            self:GetTall(),
            nX / oOverlayMaterial:Width(),
            nY_screen / oOverlayMaterial:Height(),
            (nX + self:GetWide()) / oOverlayMaterial:Width(),
            (nY_screen + self:GetTall()) / oOverlayMaterial:Height()
        )
    cam.End2D()

    -- Step 4: Draw wireframe in the transition band
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilReferenceValue(7)
    render.SetStencilTestMask(7)

    render.SetBlend(0.1)
    eEntity:SetMaterial("models/wireframe")
    eEntity:DrawModel()
    eEntity:SetMaterial("")
    render.SetBlend(1)

    render.SetStencilEnable(false)
    render.SetBlend(1)
end

function CreateCharacterModelPanel:SetDisplayed(bDisplayed, bIgnoreAnimation)
    self._bDisplayed = bDisplayed

    if not bIgnoreAnimation then
        self._nAnimationStart = CurTime()
    end
end

function CreateCharacterModelPanel:LayoutEntity( eEntity )
    if self:GetParent()._bCreated then
        eEntity:SetSequence( eEntity:LookupSequence( "pose_standing_04" ) )
    else
        eEntity:SetSequence( eEntity:LookupSequence( self.Sequences[ self._nSequence ] ) )
    end

    local vHeadPos = self.Entity:GetBonePosition(self.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    local vSpinePos = self.Entity:GetBonePosition(self.Entity:LookupBone("ValveBiped.Bip01_Spine"))
    self:SetLookAt( vSpinePos-Vector(0, 0, -8))
    self:SetCamPos( vSpinePos-Vector(-90 * 4, -50 * 4, 0))
    self.Entity:SetEyeTarget( vHeadPos + Vector( 16, 1, 0 ) )
end

function CreateCharacterModelPanel:Think()

end

function CreateCharacterModelPanel:GetDisplayed()
    return self._bDisplayed
end

vgui.Register( "Palomino.CreateCharacter.Model", CreateCharacterModelPanel, "DModelPanel" )



concommand.Add( "prp_createcharacter", function()
    if IsValid( Palomino.Character.Panel ) then
        Palomino.Character.Panel:Remove()
        Palomino.Character.Panel = nil

        return
    end

    Palomino.Character.Panel = vgui.Create( "Palomino.CreateCharacter" )
    Palomino.Character.Panel:MakePopup()
    Palomino.Character.Panel:Center()
end )