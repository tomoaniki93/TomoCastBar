-- =====================================
-- Movers.lua — Layout Manager for TomoCastbar
-- Replicates TomoMod's layout system:
--   • Header bar flottant (title, Grid, Lock, RL)
--   • Grille d'alignement + effet flashlight curseur (TomoMod algorithm)
--   • Mover overlay sur chaque castbar (label, coords, drag)
--   • Preview automatique en mode layout
-- =====================================

TomoCastbar_Movers = TomoCastbar_Movers or {}
local M = TomoCastbar_Movers
local L = TomoCastbar_L

-- =====================================
-- STATE
-- =====================================

local isUnlocked  = false
local headerBar   = nil
local lockBtn     = nil
local gridBtn     = nil
local gridFrame   = nil
local gridMode    = "dimmed"   -- "dimmed" | "bright" | "disabled"
local moverFrames = {}         -- { unit → moverFrame }
local initialized = false

-- =====================================
-- CONSTANTS — design identique TomoMod
-- =====================================

local FONT         = TomoCastbar_DB and TomoCastbar_DB.font or "Fonts\\FRIZQT__.TTF"
local ACCENT       = { 0.82, 0.71, 0.35 }   -- gold
local BG           = { 0.04, 0.04, 0.06, 0.94 }
local BORDER       = { 0.25, 0.24, 0.22, 1 }
local MOVER_ACCENT = { 0.82, 0.71, 0.35 }
local MOVER_BG     = { 0.04, 0.05, 0.05, 0.88 }
local MOVER_BORDER = { 0.65, 0.55, 0.25, 1 }
local COORD_COLOR  = { 0.45, 0.45, 0.45 }

-- Icônes embarquées (textures ASCII pour ne pas dépendre d'assets externes)
local ICON_LAYOUT = "Interface\\AddOns\\TomoCastbar\\Assets\\Textures\\background"
local ICON_LOCK   = "Interface\\AddOns\\TomoCastbar\\Assets\\Textures\\border"
local ICON_RELOAD = "Interface\\AddOns\\TomoCastbar\\Assets\\Textures\\background"

-- =====================================
-- GRID — identique TomoMod (grille + flashlight curseur)
-- =====================================

local GRID_SPACING      = 32
local GRID_ALPHA_DIM    = 0.12
local GRID_ALPHA_BRIGHT = 0.28
local GRID_CENTER_DIM   = 0.22
local GRID_CENTER_BRT   = 0.50
local LIGHT_RADIUS      = 200
local LIGHT_BOOST       = 0.65
local SEG_SIZE          = 8

local function GridBaseAlpha()
    return gridMode == "bright" and GRID_ALPHA_BRIGHT or GRID_ALPHA_DIM
end
local function GridCenterAlpha()
    return gridMode == "bright" and GRID_CENTER_BRT or GRID_CENTER_DIM
end
local function CycleGridMode()
    if     gridMode == "dimmed"   then gridMode = "bright"
    elseif gridMode == "bright"   then gridMode = "disabled"
    else                               gridMode = "dimmed" end
end
local function GridBtnLabel()
    if gridMode == "bright"   then return L["grid_bright"]   or "Grid +"   end
    if gridMode == "dimmed"   then return L["grid_dimmed"]   or "Grid"     end
    return                              L["grid_disabled"]   or "Grid OFF"
end

local function SyncGridBtn()
    if not gridBtn then return end
    local active = (gridMode ~= "disabled")
    local r, g, b = ACCENT[1], ACCENT[2], ACCENT[3]
    if active then
        gridBtn:SetBackdropBorderColor(r, g, b, 0.7)
        gridBtn._txt:SetTextColor(r, g, b)
        gridBtn._normalBorder   = { r, g, b, 0.7 }
        gridBtn._normalTxtColor = { r, g, b }
    else
        gridBtn:SetBackdropBorderColor(0.30, 0.30, 0.30, 0.5)
        gridBtn._txt:SetTextColor(0.45, 0.45, 0.45)
        gridBtn._normalBorder   = { 0.30, 0.30, 0.30, 0.5 }
        gridBtn._normalTxtColor = { 0.45, 0.45, 0.45 }
    end
    gridBtn._txt:SetText(GridBtnLabel())
end

local function ApplyGridMode()
    if not gridFrame then return end
    if gridMode == "disabled" or not isUnlocked then
        gridFrame:Hide()
    else
        gridFrame:Rebuild()
        gridFrame:Show()
    end
    SyncGridBtn()
end

local function CreateGridOverlay()
    if gridFrame then return gridFrame end

    gridFrame = CreateFrame("Frame", "TomoCastbarLayoutGrid", UIParent)
    gridFrame:SetFrameStrata("BACKGROUND")
    gridFrame:SetAllPoints(UIParent)
    gridFrame:SetFrameLevel(1)
    gridFrame:EnableMouse(false)
    gridFrame._lines = {}
    gridFrame._glows = {}

    -- ── Rebuild : reconstruction complète ─────────────────────────────────────
    function gridFrame:Rebuild()
        for _, tex in ipairs(self._lines) do tex:Hide() end

        local w     = UIParent:GetWidth()
        local h     = UIParent:GetHeight()
        local ar    = ACCENT[1]; local ag = ACCENT[2]; local ab = ACCENT[3]
        local baseA = GridBaseAlpha()
        local centA = GridCenterAlpha()
        local idx   = 0

        local function AddLine(isVert, pos, alpha)
            idx = idx + 1
            local tex = self._lines[idx]
            if not tex then
                tex = self:CreateTexture(nil, "BACKGROUND", nil, -7)
                self._lines[idx] = tex
            end
            tex:SetColorTexture(ar, ag, ab, alpha)
            tex._baseAlpha = alpha
            tex._isVert    = isVert
            tex._pos       = pos
            tex:ClearAllPoints()
            if isVert then
                tex:SetSize(1, h)
                tex:SetPoint("TOPLEFT", UIParent, "TOPLEFT", pos, 0)
            else
                tex:SetSize(w, 1)
                tex:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -pos)
            end
            tex:Show()
        end

        local cx = math.floor(w / 2)
        local cy = math.floor(h / 2)

        -- Verticales
        local x = cx - GRID_SPACING
        while x > 0 do AddLine(true, x, baseA); x = x - GRID_SPACING end
        x = cx + GRID_SPACING
        while x < w do AddLine(true, x, baseA); x = x + GRID_SPACING end

        -- Horizontales
        local y = cy - GRID_SPACING
        while y > 0 do AddLine(false, y, baseA); y = y - GRID_SPACING end
        y = cy + GRID_SPACING
        while y < h do AddLine(false, y, baseA); y = y + GRID_SPACING end

        -- Croix centrale (level -6)
        for _, isVert in ipairs({true, false}) do
            idx = idx + 1
            local tex = self._lines[idx]
            if not tex then
                tex = self:CreateTexture(nil, "BACKGROUND", nil, -6)
                self._lines[idx] = tex
            end
            tex:SetColorTexture(ar, ag, ab, centA)
            tex._baseAlpha = centA
            tex._isVert    = isVert
            tex._pos       = 0
            tex:ClearAllPoints()
            if isVert then
                tex:SetSize(1, h); tex:SetPoint("TOP", UIParent, "TOP", 0, 0)
            else
                tex:SetSize(w, 1); tex:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
            end
            tex:Show()
        end

        self._lineCount = idx
    end

    -- ── Cursor flashlight OnUpdate (algorithme TomoMod) ───────────────────────
    local function GetGlow(i)
        local g = gridFrame._glows[i]
        if not g then
            g = gridFrame:CreateTexture(nil, "BACKGROUND", nil, -5)
            gridFrame._glows[i] = g
        end
        return g
    end

    gridFrame._gridElapsed = 0
    gridFrame:SetScript("OnUpdate", function(self, elapsed)
        if not self:IsShown() then return end
        self._gridElapsed = self._gridElapsed + elapsed
        if self._gridElapsed < 0.03 then return end
        self._gridElapsed = 0

        local ar2  = ACCENT[1]; local ag2 = ACCENT[2]; local ab2 = ACCENT[3]
        local uiH  = UIParent:GetHeight()
        local uiW  = UIParent:GetWidth()
        local scale = UIParent:GetEffectiveScale()
        local mcx, mcy = GetCursorPosition()
        local curX  = mcx / scale
        local curY  = mcy / scale
        local curYt = uiH - curY

        local R2    = LIGHT_RADIUS * LIGHT_RADIUS
        local gIdx  = 0
        local lc    = self._lineCount or #self._lines
        local sqrt2 = math.sqrt
        local abs2  = math.abs
        local min2  = math.min
        local max2  = math.max

        for i = 1, lc do
            local tex = self._lines[i]
            if tex and tex:IsShown() and tex._baseAlpha then
                tex:SetColorTexture(ar2, ag2, ab2, tex._baseAlpha)

                local perpDist
                local lineX, lineY
                if tex._isVert then
                    lineX    = (tex._pos == 0) and (uiW * 0.5) or tex._pos
                    perpDist = abs2(lineX - curX)
                else
                    lineY    = (tex._pos == 0) and (uiH * 0.5) or tex._pos
                    perpDist = abs2(lineY - curYt)
                end

                if perpDist < LIGHT_RADIUS then
                    local halfSpan = sqrt2(R2 - perpDist * perpDist)

                    if tex._isVert then
                        local startY = curY - halfSpan
                        local endY   = curY + halfSpan
                        local segY   = startY
                        while segY < endY do
                            local segEnd = min2(segY + SEG_SIZE, endY)
                            local midY   = (segY + segEnd) * 0.5
                            local dx = lineX - curX
                            local dy = midY  - curY
                            local d2 = dx*dx + dy*dy
                            if d2 < R2 then
                                local t     = 1 - sqrt2(d2) / LIGHT_RADIUS
                                local alpha = LIGHT_BOOST * t * t
                                if alpha > 0.004 then
                                    gIdx = gIdx + 1
                                    local g = GetGlow(gIdx)
                                    g:SetColorTexture(ar2, ag2, ab2, alpha)
                                    g:ClearAllPoints()
                                    g:SetSize(1, segEnd - segY)
                                    g:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT",
                                        lineX, max2(0, segY))
                                    g:Show()
                                end
                            end
                            segY = segEnd
                        end
                    else
                        local startX = curX - halfSpan
                        local endX   = curX + halfSpan
                        local segX   = startX
                        while segX < endX do
                            local segEnd = min2(segX + SEG_SIZE, endX)
                            local midX   = (segX + segEnd) * 0.5
                            local dx = midX  - curX
                            local dy = lineY - curYt
                            local d2 = dx*dx + dy*dy
                            if d2 < R2 then
                                local t     = 1 - sqrt2(d2) / LIGHT_RADIUS
                                local alpha = LIGHT_BOOST * t * t
                                if alpha > 0.004 then
                                    gIdx = gIdx + 1
                                    local g = GetGlow(gIdx)
                                    g:SetColorTexture(ar2, ag2, ab2, alpha)
                                    g:ClearAllPoints()
                                    g:SetSize(segEnd - segX, 1)
                                    g:SetPoint("TOPLEFT", UIParent, "TOPLEFT",
                                        max2(0, segX), -lineY)
                                    g:Show()
                                end
                            end
                            segX = segEnd
                        end
                    end
                end
            end
        end

        for j = gIdx + 1, #self._glows do
            if self._glows[j] then self._glows[j]:Hide() end
        end
    end)

    gridFrame:Hide()
    return gridFrame
end

-- =====================================
-- HEADER BAR — identique TomoMod
-- =====================================

local function MakeBtn(parent, w, label, iconColor, bgColor, borderColor)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(w, 26)
    btn:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    btn:SetBackdropColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4] or 0.8)
    btn:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4] or 0.7)

    local txt = btn:CreateFontString(nil, "OVERLAY")
    txt:SetFont(FONT, 11, "")
    txt:SetPoint("CENTER", btn, "CENTER", 0, 0)
    txt:SetText(label)
    txt:SetTextColor(iconColor[1], iconColor[2], iconColor[3])
    btn._txt = txt

    btn._normalBorder   = { borderColor[1], borderColor[2], borderColor[3], borderColor[4] or 0.7 }
    btn._normalTxtColor = { iconColor[1],   iconColor[2],   iconColor[3] }

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 1, 1, 0.9)
        self._txt:SetTextColor(1, 1, 1)
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(unpack(self._normalBorder))
        self._txt:SetTextColor(unpack(self._normalTxtColor))
    end)

    return btn
end

local function CreateHeaderBar()
    if headerBar then return end

    local BAR_W = 700
    local BAR_H = 62
    local ROW1_Y =  15
    local ROW2_Y = -13

    headerBar = CreateFrame("Frame", "TomoCastbarLayoutHeader", UIParent, "BackdropTemplate")
    headerBar:SetSize(BAR_W, BAR_H)
    headerBar:SetPoint("TOP", UIParent, "TOP", 0, -6)
    headerBar:SetFrameStrata("DIALOG")
    headerBar:SetFrameLevel(600)
    headerBar:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    headerBar:SetBackdropColor(unpack(BG))
    headerBar:SetBackdropBorderColor(unpack(BORDER))
    headerBar:Hide()

    -- Accent line (top)
    local accent = headerBar:CreateTexture(nil, "OVERLAY")
    accent:SetHeight(2)
    accent:SetPoint("TOPLEFT",  0, 0)
    accent:SetPoint("TOPRIGHT", 0, 0)
    accent:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)

    -- Diamond icon (pas de dépendance texture externe)
    local iconDot = headerBar:CreateTexture(nil, "OVERLAY")
    iconDot:SetSize(8, 8)
    iconDot:SetPoint("LEFT", 14, ROW1_Y)
    iconDot:SetColorTexture(ACCENT[1], ACCENT[2], ACCENT[3], 1)

    -- Titre (row 1, gauche)
    local titleLbl = headerBar:CreateFontString(nil, "OVERLAY")
    titleLbl:SetFont(FONT, 13, "")
    titleLbl:SetPoint("LEFT", iconDot, "RIGHT", 8, 0)
    titleLbl:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])
    titleLbl:SetText(L["layout_mode_title"] or "TomoCastbar — Layout Mode")

    -- Hint text (row 2, gauche)
    local hint = headerBar:CreateFontString(nil, "OVERLAY")
    hint:SetFont(FONT, 10, "")
    hint:SetPoint("LEFT", 30, ROW2_Y)
    hint:SetTextColor(0.50, 0.50, 0.50)
    hint:SetText(L["layout_mode_hint"] or "Drag castbars to reposition — click Lock when done")

    -- RL button (extrême droite)
    local rlBtn = MakeBtn(headerBar, 52, L["layout_btn_reload"] or "RL",
        { 0.9, 0.7, 0.2 },
        { 0.10, 0.08, 0.04 }, { 0.7, 0.5, 0.1 }
    )
    rlBtn:SetPoint("RIGHT", headerBar, "RIGHT", -4, ROW1_Y)
    rlBtn:SetScript("OnClick", function() ReloadUI() end)

    -- Lock button
    lockBtn = MakeBtn(headerBar, 100, L["layout_btn_lock"] or "Lock",
        { ACCENT[1], ACCENT[2], ACCENT[3] },
        { ACCENT[1]*0.2, ACCENT[2]*0.2, ACCENT[3]*0.2 },
        { ACCENT[1],     ACCENT[2],     ACCENT[3]      }
    )
    lockBtn:SetPoint("RIGHT", rlBtn, "LEFT", -6, 0)
    lockBtn:SetScript("OnClick", function() M.SetUnlocked(false) end)

    -- Grid button
    gridBtn = MakeBtn(headerBar, 84, GridBtnLabel(),
        { ACCENT[1], ACCENT[2], ACCENT[3] },
        { 0.04, 0.10, 0.08 }, { ACCENT[1], ACCENT[2], ACCENT[3] }
    )
    gridBtn:SetPoint("RIGHT", lockBtn, "LEFT", -6, 0)
    gridBtn:SetScript("OnClick", function()
        CycleGridMode()
        ApplyGridMode()
    end)
    gridBtn:SetScript("OnLeave", function() SyncGridBtn() end)
end

-- =====================================
-- MOVER OVERLAYS
-- Un frame visuel par castbar, positionné dessus.
-- Affiche : label unité, dimensions, coords X/Y live, bouton Reset.
-- Le frame entier est draggable → déplace la castbar en dessous.
-- =====================================

local MOVER_HEADER_H = 20   -- hauteur du header strip du mover

local function FormatCoords(cb)
    local point, _, relativePoint, x, y = cb:GetPoint()
    if not x then return "X: 0  Y: 0" end
    return string.format("X: %d  Y: %d", math.floor(x + 0.5), math.floor(y + 0.5))
end

local function CreateMoverFrame(unit, castbar, labelText)
    local db       = TomoCastbarDB
    local unitDB   = db and db[unit]

    -- ── Outer frame : même taille que la castbar + espace header ────────────
    local mf = CreateFrame("Frame", "TomoCastbarMover_" .. unit, UIParent, "BackdropTemplate")
    mf:SetFrameStrata("HIGH")
    mf:SetFrameLevel(500)
    mf:SetMovable(true)
    mf:SetClampedToScreen(true)

    -- ── Taille : castbar width × (castbar height + MOVER_HEADER_H) ──────────
    local cbW = castbar:GetWidth()
    local cbH = castbar:GetHeight()
    mf:SetSize(cbW, cbH + MOVER_HEADER_H)

    -- ── Position : aligner exactement sur la castbar ────────────────────────
    local function SyncToBar()
        mf:ClearAllPoints()
        local cbPoint, _, cbRelPoint, cbX, cbY = castbar:GetPoint()
        if cbPoint then
            -- On veut que le bas du mover = bas de la castbar
            -- donc le top du mover = top castbar + MOVER_HEADER_H
            mf:SetPoint(cbPoint, UIParent, cbRelPoint, cbX, cbY + MOVER_HEADER_H)
        else
            mf:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        end
    end
    SyncToBar()

    -- ── Fond du mover ─────────────────────────────────────────────────────
    mf:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    mf:SetBackdropColor(MOVER_BG[1], MOVER_BG[2], MOVER_BG[3], MOVER_BG[4])
    mf:SetBackdropBorderColor(MOVER_BORDER[1], MOVER_BORDER[2], MOVER_BORDER[3], 1)

    -- ── Accent line (top) ────────────────────────────────────────────────
    local accentLine = mf:CreateTexture(nil, "OVERLAY")
    accentLine:SetHeight(2)
    accentLine:SetPoint("TOPLEFT",  0, 0)
    accentLine:SetPoint("TOPRIGHT", 0, 0)
    accentLine:SetColorTexture(MOVER_ACCENT[1], MOVER_ACCENT[2], MOVER_ACCENT[3], 1)

    -- ── Diamond indicator ────────────────────────────────────────────────
    local dot = mf:CreateTexture(nil, "OVERLAY")
    dot:SetSize(6, 6)
    dot:SetPoint("LEFT", mf, "TOPLEFT", 8, -MOVER_HEADER_H * 0.5)
    dot:SetColorTexture(MOVER_ACCENT[1], MOVER_ACCENT[2], MOVER_ACCENT[3], 1)

    -- ── Label unité ─────────────────────────────────────────────────────
    local lbl = mf:CreateFontString(nil, "OVERLAY")
    lbl:SetFont(FONT, 11, "")
    lbl:SetPoint("LEFT", dot, "RIGHT", 6, 0)
    lbl:SetTextColor(MOVER_ACCENT[1], MOVER_ACCENT[2], MOVER_ACCENT[3])
    lbl:SetText(labelText)

    -- ── Coords (live, droite du header) ──────────────────────────────────
    local coords = mf:CreateFontString(nil, "OVERLAY")
    coords:SetFont(FONT, 10, "")
    coords:SetPoint("RIGHT", mf, "TOPRIGHT", -8, -MOVER_HEADER_H * 0.5)
    coords:SetTextColor(COORD_COLOR[1], COORD_COLOR[2], COORD_COLOR[3])
    coords:SetText(FormatCoords(castbar))
    mf._coords = coords

    -- ── Séparateur header / corps ─────────────────────────────────────────
    local sep = mf:CreateTexture(nil, "OVERLAY")
    sep:SetHeight(1)
    sep:SetPoint("BOTTOMLEFT",  mf, "TOPLEFT",  0, -(MOVER_HEADER_H - 1))
    sep:SetPoint("BOTTOMRIGHT", mf, "TOPRIGHT", 0, -(MOVER_HEADER_H - 1))
    sep:SetColorTexture(MOVER_BORDER[1], MOVER_BORDER[2], MOVER_BORDER[3], 0.6)

    -- ── Corps : fond translucide sur la zone castbar ──────────────────────
    local body = mf:CreateTexture(nil, "BACKGROUND")
    body:SetPoint("TOPLEFT",     mf, "TOPLEFT",  0, -(MOVER_HEADER_H - 1))
    body:SetPoint("BOTTOMRIGHT", mf, "BOTTOMRIGHT", 0, 0)
    body:SetColorTexture(0, 0, 0, 0.35)

    -- ── Hachures diagonales (hint visuel de draggabilité) ─────────────────
    -- 3 petites lignes dans le coin droit du corps
    local function MakeHatch(xOff, yOff)
        local h = mf:CreateTexture(nil, "OVERLAY")
        h:SetSize(12, 1)
        h:SetPoint("BOTTOMRIGHT", mf, "BOTTOMRIGHT", xOff, yOff)
        h:SetColorTexture(MOVER_ACCENT[1], MOVER_ACCENT[2], MOVER_ACCENT[3], 0.3)
    end
    MakeHatch(-4, 5)
    MakeHatch(-4, 8)
    MakeHatch(-4, 11)

    -- ── Bouton Reset (coin bas-droit externe) ─────────────────────────────
    local resetBtn = CreateFrame("Button", nil, mf, "BackdropTemplate")
    resetBtn:SetSize(52, 18)
    resetBtn:SetPoint("TOPRIGHT", mf, "BOTTOMRIGHT", 0, -4)
    resetBtn:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    resetBtn:SetBackdropColor(0.04, 0.10, 0.08, 0.9)
    resetBtn:SetBackdropBorderColor(MOVER_ACCENT[1]*0.6, MOVER_ACCENT[2]*0.6, MOVER_ACCENT[3]*0.6, 0.7)

    local resetLbl = resetBtn:CreateFontString(nil, "OVERLAY")
    resetLbl:SetFont(FONT, 10, "")
    resetLbl:SetPoint("CENTER")
    resetLbl:SetTextColor(MOVER_ACCENT[1]*0.8, MOVER_ACCENT[2]*0.8, MOVER_ACCENT[3]*0.8)
    resetLbl:SetText(L["RESET_POSITION"] and string.format(L["RESET_POSITION"], "") or "↺ Reset")

    resetBtn:SetScript("OnEnter", function()
        resetBtn:SetBackdropBorderColor(MOVER_ACCENT[1], MOVER_ACCENT[2], MOVER_ACCENT[3], 0.9)
        resetLbl:SetTextColor(MOVER_ACCENT[1], MOVER_ACCENT[2], MOVER_ACCENT[3])
    end)
    resetBtn:SetScript("OnLeave", function()
        resetBtn:SetBackdropBorderColor(MOVER_ACCENT[1]*0.6, MOVER_ACCENT[2]*0.6, MOVER_ACCENT[3]*0.6, 0.7)
        resetLbl:SetTextColor(MOVER_ACCENT[1]*0.8, MOVER_ACCENT[2]*0.8, MOVER_ACCENT[3]*0.8)
    end)
    resetBtn:SetScript("OnClick", function()
        if TomoCastbar_Defaults and TomoCastbar_Defaults[unit] and TomoCastbar_Defaults[unit].position then
            if unitDB then
                unitDB.position = CopyTable(TomoCastbar_Defaults[unit].position)
            end
            local pos = TomoCastbar_Defaults[unit].position
            castbar:ClearAllPoints()
            castbar:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
            SyncToBar()
            coords:SetText(FormatCoords(castbar))
        end
        print("|cffd1b559TomoCastbar|r " .. (L["POSITION_RESET"] and string.format(L["POSITION_RESET"], unit) or unit .. " position reset"))
    end)

    -- ── DRAG ─────────────────────────────────────────────────────────────
    -- Le mover drag → castbar suit
    mf:EnableMouse(true)
    mf:RegisterForDrag("LeftButton")

    mf:SetScript("OnDragStart", function(self)
        castbar:StartMoving()
        self:SetScript("OnUpdate", function()
            -- Resync position du mover pendant le drag
            SyncToBar()
            coords:SetText(FormatCoords(castbar))
        end)
    end)

    mf:SetScript("OnDragStop", function(self)
        castbar:StopMovingOrSizing()
        self:SetScript("OnUpdate", nil)
        SyncToBar()

        -- Sauvegarde de la position
        local point, _, relativePoint, x, y = castbar:GetPoint()
        if point and unitDB then
            unitDB.position = unitDB.position or {}
            unitDB.position.point         = point
            unitDB.position.relativePoint = relativePoint
            unitDB.position.x             = x
            unitDB.position.y             = y
        end
        coords:SetText(FormatCoords(castbar))
    end)

    -- Cursor : main pour indiquer le drag
    mf:SetScript("OnEnter", function()
        mf:SetBackdropBorderColor(1, 1, 1, 0.6)
    end)
    mf:SetScript("OnLeave", function()
        mf:SetBackdropBorderColor(MOVER_BORDER[1], MOVER_BORDER[2], MOVER_BORDER[3], 1)
    end)

    -- Rendre la castbar movable pendant le layout
    castbar:SetMovable(true)
    castbar:SetClampedToScreen(true)

    mf:Hide()
    mf._syncToBar = SyncToBar
    mf._resetBtn  = resetBtn

    return mf
end

-- =====================================
-- NOMS D'UNITÉS LOCALISÉS
-- =====================================

local UNIT_LABELS = {
    player = function() return L["CAT_PLAYER"] or "Player" end,
    target = function() return L["CAT_TARGET"] or "Target" end,
    focus  = function() return L["CAT_FOCUS"]  or "Focus"  end,
}

-- =====================================
-- SHOW / HIDE MOVERS
-- =====================================

local function ShowMovers()
    local CB = TomoCastbar_Module
    if not CB or not CB.castbars then return end

    for _, unit in ipairs({"player", "target", "focus"}) do
        local castbar = CB.castbars[unit]
        if castbar then
            -- Créer le mover s'il n'existe pas encore
            if not moverFrames[unit] then
                local labelFn = UNIT_LABELS[unit]
                local label   = labelFn and labelFn() or unit
                moverFrames[unit] = CreateMoverFrame(unit, castbar, label)
            end

            -- Resync taille (la castbar peut avoir changé de dimensions via /tcb reset)
            local mf  = moverFrames[unit]
            local cbW = castbar:GetWidth()
            local cbH = castbar:GetHeight()
            mf:SetSize(cbW, cbH + MOVER_HEADER_H)

            -- Preview de la castbar
            if castbar.ShowPreview then castbar:ShowPreview() end

            mf._syncToBar()
            mf:Show()
        end
    end
end

local function HideMovers()
    for unit, mf in pairs(moverFrames) do
        local CB = TomoCastbar_Module
        local castbar = CB and CB.castbars and CB.castbars[unit]

        if castbar then
            castbar:SetMovable(false)
            if castbar.HidePreview then castbar:HidePreview() end
        end

        mf:Hide()
    end
end

-- =====================================
-- API PUBLIQUE
-- =====================================

function M.SetUnlocked(unlock)
    if not initialized then return end
    isUnlocked = unlock

    if unlock then
        ShowMovers()
        if headerBar then headerBar:Show() end
        ApplyGridMode()
        print("|cffd1b559TomoCastbar|r " .. (L["layout_unlocked"] or "Layout Mode ON — drag castbars to reposition. Click Lock when done."))
    else
        HideMovers()
        if headerBar then headerBar:Hide() end
        if gridFrame then gridFrame:Hide() end
        print("|cffd1b559TomoCastbar|r " .. (L["layout_locked"] or "Layout Mode OFF — positions saved."))
    end
end

function M.Toggle()
    M.SetUnlocked(not isUnlocked)
end

function M.IsUnlocked()
    return isUnlocked
end

-- =====================================
-- INITIALIZE
-- =====================================

function M.Initialize()
    L = TomoCastbar_L
    CreateGridOverlay()
    CreateHeaderBar()
    initialized = true
    isUnlocked  = false
end
