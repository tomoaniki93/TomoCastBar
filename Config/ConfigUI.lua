-- =====================================
-- ConfigUI.lua — v2.0 — Config Panel for TomoCastbar
-- Title bar: Layout + RL buttons (TomoMod style)
-- =====================================

TomoCastbar_Config = TomoCastbar_Config or {}
local C = TomoCastbar_Config
local W = TomoCastbar_Widgets
local T = W.Theme
local L = TomoCastbar_L

local FONT      = "Fonts\\FRIZQT__.TTF"
local FONT_BOLD = "Fonts\\FRIZQT__.TTF"

-- Couleurs Layout (gold — même palette que Movers.lua)
local ACCENT_R, ACCENT_G, ACCENT_B = 0.82, 0.71, 0.35

local configFrame
local currentCategory  = nil
local categoryPanels   = {}
local categoryButtons  = {}
local _layoutBtn       = nil  -- ref gardée pour UpdateLayoutBtnStyle()

-- =====================================
-- HELPER: Refresh castbars after settings change
-- =====================================
local function RefreshCastbars()
    if TomoCastbar_Module and TomoCastbar_Module.RefreshAll then
        TomoCastbar_Module.RefreshAll()
    end
end

-- =====================================
-- HELPER: Sync Layout button style (active / inactive)
-- Called from OnClick and OnLeave so the style is always current.
-- =====================================
local function UpdateLayoutBtnStyle()
    if not _layoutBtn then return end
    local unlocked = TomoCastbar_Movers and TomoCastbar_Movers.IsUnlocked
                     and TomoCastbar_Movers.IsUnlocked()
    if unlocked then
        _layoutBtn:SetBackdropColor(ACCENT_R * 0.18, ACCENT_G * 0.18, ACCENT_B * 0.18, 0.92)
        _layoutBtn:SetBackdropBorderColor(ACCENT_R, ACCENT_G, ACCENT_B, 1)
        _layoutBtn._txt:SetTextColor(ACCENT_R, ACCENT_G, ACCENT_B)
    else
        _layoutBtn:SetBackdropColor(0.06, 0.06, 0.09, 0.85)
        _layoutBtn:SetBackdropBorderColor(0.22, 0.22, 0.26, 0.8)
        _layoutBtn._txt:SetTextColor(ACCENT_R, ACCENT_G, ACCENT_B)
    end
end

-- =====================================
-- PANEL BUILDERS
-- =====================================

-- ===== GENERAL =====
local function BuildGeneralPanel(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local db = TomoCastbarDB
    if not db then return scroll end

    local y = -10

    local _, ny = W.CreateSectionHeader(c, L["HEADER_GENERAL"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["HIDE_BLIZZARD"], db.hideBlizzardCastbar, y, function(v)
        db.hideBlizzardCastbar = v
        if v then TomoCastbar_Module.HideBlizzardCastbar()
        else      TomoCastbar_Module.ShowBlizzardCastbar() end
    end)
    y = ny

    -- Textures
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["HEADER_TEXTURES"], y)
    y = ny

    local bgOptions = {
        { key = "custom",      label = L["BG_CUSTOM"] },
        { key = "black",       label = L["BG_BLACK"] },
        { key = "transparent", label = L["BG_TRANSPARENT"] },
    }
    local _, ny = W.CreateDropdown(c, L["BACKGROUND_MODE"], bgOptions, db.backgroundMode or "custom", y, function(key)
        db.backgroundMode = key
        RefreshCastbars()
    end)
    y = ny

    local texOptions = {
        { key = "blizzard", label = L["TEX_BLIZZARD"] },
        { key = "smooth",   label = L["TEX_SMOOTH"] },
        { key = "flat",     label = L["TEX_FLAT"] },
    }
    local _, ny = W.CreateDropdown(c, L["BAR_TEXTURE"], texOptions, db.barTexture or "blizzard", y, function(key)
        db.barTexture = key
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["CUSTOM_BORDER"], db.useCustomBorder, y, function(v)
        db.useCustomBorder = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_SPARK"], db.showSpark, y, function(v)
        db.showSpark = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_CHANNEL_TICKS"], db.showChannelTicks, y, function(v)
        db.showChannelTicks = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_SPARK_HEIGHT"], db.sparkHeight or 26, 12, 50, 1, y, function(v)
        db.sparkHeight = v
        RefreshCastbars()
    end)
    y = ny

    -- Colors
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["HEADER_COLORS"], y)
    y = ny

    local _, ny = W.CreateColorPicker(c, L["COLOR_CAST"], db.castbarColor, y, function(r, g, b)
        db.castbarColor.r = r; db.castbarColor.g = g; db.castbarColor.b = b
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateColorPicker(c, L["COLOR_NI"], db.castbarNIColor, y, function(r, g, b)
        db.castbarNIColor.r = r; db.castbarNIColor.g = g; db.castbarNIColor.b = b
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateColorPicker(c, L["COLOR_INTERRUPTED"], db.castbarInterruptColor, y, function(r, g, b)
        db.castbarInterruptColor.r = r; db.castbarInterruptColor.g = g; db.castbarInterruptColor.b = b
        RefreshCastbars()
    end)
    y = ny

    -- ===== SPARK ANIMATION =====
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["HEADER_SPARK"], y)
    y = ny

    local sparkStyleOptions = {
        { key = "Comet",  label = L["SPARK_COMET"] },
        { key = "Pulse",  label = L["SPARK_PULSE"] },
        { key = "Helix",  label = L["SPARK_HELIX"] },
        { key = "Glitch", label = L["SPARK_GLITCH"] },
    }
    local _, ny = W.CreateDropdown(c, L["SPARK_STYLE"], sparkStyleOptions, db.sparkStyle or "Comet", y, function(key)
        db.sparkStyle = key
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["SPARK_GLOW_ALPHA"], db.sparkGlowAlpha or 0.7, 0, 1, 0.05, y, function(v)
        db.sparkGlowAlpha = v
        RefreshCastbars()
    end, "%.2f")
    y = ny

    local _, ny = W.CreateSlider(c, L["SPARK_TAIL_ALPHA"], db.sparkTailAlpha or 0.6, 0, 1, 0.05, y, function(v)
        db.sparkTailAlpha = v
        RefreshCastbars()
    end, "%.2f")
    y = ny

    local _, ny = W.CreateColorPicker(c, L["SPARK_COLOR_HEAD"], db.sparkColor, y, function(r, g, b)
        db.sparkColor.r = r; db.sparkColor.g = g; db.sparkColor.b = b
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateColorPicker(c, L["SPARK_COLOR_GLOW"], db.sparkGlowColor, y, function(r, g, b)
        db.sparkGlowColor.r = r; db.sparkGlowColor.g = g; db.sparkGlowColor.b = b
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateColorPicker(c, L["SPARK_COLOR_TAIL"], db.sparkTailColor, y, function(r, g, b)
        db.sparkTailColor.r = r; db.sparkTailColor.g = g; db.sparkTailColor.b = b
        RefreshCastbars()
    end)
    y = ny

    -- ===== ADVANCED =====
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["HEADER_ADVANCED"], y)
    y = ny

    local timerOptions = {
        { key = "remaining",       label = L["TIMER_REMAINING"] },
        { key = "remaining_total", label = L["TIMER_REMAINING_TOTAL"] },
        { key = "elapsed",         label = L["TIMER_ELAPSED"] },
    }
    local _, ny = W.CreateDropdown(c, L["TIMER_FORMAT"], timerOptions, db.timerFormat or "remaining", y, function(key)
        db.timerFormat = key
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["SPELL_NAME_TRUNCATE"], db.spellNameMaxLen or 0, 0, 30, 1, y, function(v)
        db.spellNameMaxLen = v
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["USE_CLASS_COLOR"], db.useClassColor, y, function(v)
        db.useClassColor = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_TRANSITIONS"], db.showTransitions, y, function(v)
        db.showTransitions = v
    end)
    y = ny

    -- Font size
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_FONTSIZE"], y)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_FONTSIZE"], db.fontSize, 8, 24, 1, y, function(v)
        db.fontSize = v
        RefreshCastbars()
    end)
    y = ny

    -- ===== GCD SPARK =====
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["SHOW_GCD_SPARK"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_GCD_SPARK"], db.showGCDSpark, y, function(v)
        db.showGCDSpark = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["GCD_HEIGHT"], db.gcdHeight or 4, 2, 12, 1, y, function(v)
        db.gcdHeight = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateColorPicker(c, L["GCD_COLOR"], db.gcdColor, y, function(r, g, b)
        db.gcdColor.r = r; db.gcdColor.g = g; db.gcdColor.b = b
        RefreshCastbars()
    end)
    y = ny

    -- ===== INTERRUPT FEEDBACK =====
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["SHOW_INTERRUPT_FEEDBACK"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_INTERRUPT_FEEDBACK"], db.showInterruptFeedback, y, function(v)
        db.showInterruptFeedback = v
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["INTERRUPT_FEEDBACK_DURATION"], db.interruptFeedbackDuration or 1.5, 0.5, 5, 0.1, y, function(v)
        db.interruptFeedbackDuration = v
    end, "%.1f")
    y = ny

    local _, ny = W.CreateColorPicker(c, L["INTERRUPT_FEEDBACK_COLOR"], db.interruptFeedbackColor, y, function(r, g, b)
        db.interruptFeedbackColor.r = r; db.interruptFeedbackColor.g = g; db.interruptFeedbackColor.b = b
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["INTERRUPT_FEEDBACK_FONTSIZE"], db.interruptFeedbackFontSize or 28, 12, 48, 1, y, function(v)
        db.interruptFeedbackFontSize = v
    end)
    y = ny

    -- Reset
    local _, ny = W.CreateSeparator(c, y)
    y = ny

    local _, ny = W.CreateButton(c, L["RESET_ALL"], 220, y, function()
        TomoCastbar_ResetDatabase()
        RefreshCastbars()
        C.Hide()
        C.configDirty = true
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- ===== PER-UNIT PANEL =====
local function BuildUnitPanel(parent, unitKey, displayName)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local db = TomoCastbarDB
    if not db or not db[unitKey] then return scroll end

    local unitDB = db[unitKey]
    local y = -10

    local _, ny = W.CreateSectionHeader(c, string.format(L["HEADER_UNIT_CASTBAR"], displayName), y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["ENABLE"], unitDB.enabled, y, function(v)
        unitDB.enabled = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_DIMENSIONS"], y)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_WIDTH"], unitDB.width, 80, 500, 5, y, function(v)
        unitDB.width = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_HEIGHT"], unitDB.height, 8, 50, 1, y, function(v)
        unitDB.height = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_DISPLAY"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_ICON"], unitDB.showIcon, y, function(v)
        unitDB.showIcon = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_TIMER"], unitDB.showTimer, y, function(v)
        unitDB.showTimer = v
        RefreshCastbars()
    end)
    y = ny

    if unitDB.showLatency ~= nil then
        local _, ny = W.CreateCheckbox(c, L["SHOW_LATENCY"], unitDB.showLatency, y, function(v)
            unitDB.showLatency = v
            RefreshCastbars()
        end)
        y = ny
    end

    local iconSideOptions = {
        { key = "LEFT",  label = L["ICON_LEFT"] },
        { key = "RIGHT", label = L["ICON_RIGHT"] },
    }
    local _, ny = W.CreateDropdown(c, L["ICON_SIDE"], iconSideOptions, unitDB.iconSide or "LEFT", y, function(key)
        unitDB.iconSide = key
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_POSITION"], y)
    y = ny

    -- Info drag → pointe vers /tcb layout
    local _, ny = W.CreateInfoText(c, L["INFO_DRAG_LAYOUT"] or L["INFO_DRAG"], y)
    y = ny

    -- Bouton Layout direct depuis le panel unité
    local _, ny = W.CreateButton(c, L["btn_layout"] or "Layout Mode", 200, y, function()
        if TomoCastbar_Movers and TomoCastbar_Movers.Toggle then
            TomoCastbar_Movers.Toggle()
            UpdateLayoutBtnStyle()
        end
    end)
    y = ny

    local _, ny = W.CreateButton(c, string.format(L["RESET_POSITION"], displayName), 240, y, function()
        if TomoCastbar_Defaults[unitKey] then
            unitDB.position = CopyTable(TomoCastbar_Defaults[unitKey].position)
            local cb = TomoCastbar_Module.castbars[unitKey]
            if cb then
                local pos = unitDB.position
                cb:ClearAllPoints()
                cb:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
            end
            print("|cffd1b559TomoCastbar|r " .. string.format(L["POSITION_RESET"], displayName))
        end
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- ===== BOSS / ARENA GROUP PANEL =====
local function BuildGroupPanel(parent, groupKey, displayName)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local db = TomoCastbarDB
    if not db or not db[groupKey] then return scroll end

    local gDB = db[groupKey]
    local y = -10

    local _, ny = W.CreateSectionHeader(c, string.format(L["HEADER_UNIT_CASTBAR"], displayName), y)
    y = ny

    local infoKey = (groupKey == "boss") and "INFO_BOSS" or "INFO_ARENA"
    local _, ny = W.CreateInfoText(c, L[infoKey] or "", y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["ENABLE"], gDB.enabled, y, function(v)
        gDB.enabled = v
        RefreshCastbars()
    end)
    y = ny

    -- Stacking
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_STACKING"], y)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_NUMBARS"], gDB.numBars or 5, 1, 5, 1, y, function(v)
        gDB.numBars = v
        RefreshCastbars()
    end)
    y = ny

    local growthOptions = {
        { key = "UP",   label = L["GROWTH_UP"] },
        { key = "DOWN", label = L["GROWTH_DOWN"] },
    }
    local _, ny = W.CreateDropdown(c, L["GROWTH_DIRECTION"], growthOptions, gDB.growth or "DOWN", y, function(key)
        gDB.growth = key
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_SPACING"], gDB.spacing or 4, 0, 20, 1, y, function(v)
        gDB.spacing = v
        RefreshCastbars()
    end)
    y = ny

    -- Dimensions
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_DIMENSIONS"], y)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_WIDTH"], gDB.width, 80, 500, 5, y, function(v)
        gDB.width = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateSlider(c, L["SLIDER_HEIGHT"], gDB.height, 8, 50, 1, y, function(v)
        gDB.height = v
        RefreshCastbars()
    end)
    y = ny

    -- Display
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_DISPLAY"], y)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_ICON"], gDB.showIcon, y, function(v)
        gDB.showIcon = v
        RefreshCastbars()
    end)
    y = ny

    local _, ny = W.CreateCheckbox(c, L["SHOW_TIMER"], gDB.showTimer, y, function(v)
        gDB.showTimer = v
        RefreshCastbars()
    end)
    y = ny

    local iconSideOptions = {
        { key = "LEFT",  label = L["ICON_LEFT"] },
        { key = "RIGHT", label = L["ICON_RIGHT"] },
    }
    local _, ny = W.CreateDropdown(c, L["ICON_SIDE"], iconSideOptions, gDB.iconSide or "LEFT", y, function(key)
        gDB.iconSide = key
        RefreshCastbars()
    end)
    y = ny

    -- Position
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["SUBLABEL_POSITION"], y)
    y = ny
    local _, ny = W.CreateInfoText(c, L["INFO_DRAG_LAYOUT"] or L["INFO_DRAG"], y)
    y = ny

    local _, ny = W.CreateButton(c, L["btn_layout"] or "Layout Mode", 200, y, function()
        if TomoCastbar_Movers and TomoCastbar_Movers.Toggle then
            TomoCastbar_Movers.Toggle()
            UpdateLayoutBtnStyle()
        end
    end)
    y = ny

    local _, ny = W.CreateButton(c, string.format(L["RESET_POSITION"], displayName), 240, y, function()
        if TomoCastbar_Defaults[groupKey] and TomoCastbar_Defaults[groupKey].position then
            gDB.position = CopyTable(TomoCastbar_Defaults[groupKey].position)
            local anchor = TomoCastbar_Module.groupAnchors and TomoCastbar_Module.groupAnchors[groupKey]
            if anchor then
                local pos = gDB.position
                anchor:ClearAllPoints()
                anchor:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
            end
            print("|cffd1b559TomoCastbar|r " .. string.format(L["POSITION_RESET"], displayName))
        end
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- ===== PROFILES PANEL =====
local function BuildProfilesPanel(parent)
    local scroll = W.CreateScrollPanel(parent)
    local c = scroll.child
    local Prof = TomoCastbar_Profiles
    if not Prof then return scroll end
    Prof.EnsureProfilesDB()

    local y = -10
    local selected = Prof.GetActiveProfileName()

    local _, ny = W.CreateSectionHeader(c, L["CAT_PROFILES"], y)
    y = ny
    local _, ny = W.CreateInfoText(c, L["PROFILES_DESC"] or "", y)
    y = ny
    local _, ny = W.CreateSubLabel(c, string.format(L["PROFILE_ACTIVE_LABEL"], Prof.GetActiveProfileName()), y)
    y = ny

    local function profileOptions()
        local order = Prof.GetProfileList()
        local opts = {}
        for _, name in ipairs(order) do opts[#opts + 1] = { key = name, label = name } end
        return opts
    end

    local _, ny = W.CreateDropdown(c, L["PROFILE_SELECT"], profileOptions(), selected, y, function(key)
        selected = key
    end)
    y = ny

    local _, ny = W.CreateButton(c, L["PROFILE_LOAD_BTN"], 200, y, function()
        if Prof.LoadNamedProfile(selected) then
            print("|cffd1b559TomoCastbar|r " .. string.format(L["PROFILE_LOADED"], selected))
            RefreshCastbars(); C.configDirty = true; C.Hide()
        end
    end)
    y = ny

    local _, ny = W.CreateButton(c, L["PROFILE_DELETE_BTN"], 200, y, function()
        if selected == "Default" then
            print("|cffd1b559TomoCastbar|r " .. L["PROFILE_CANNOT_DELETE"])
            return
        end
        if Prof.DeleteNamedProfile(selected) then
            print("|cffd1b559TomoCastbar|r " .. string.format(L["PROFILE_DELETED"], selected))
            RefreshCastbars(); C.configDirty = true; C.Hide()
        end
    end)
    y = ny

    -- Create / Duplicate
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSubLabel(c, L["HEADER_PROFILES_CREATE"], y)
    y = ny

    local nameBox, ny = W.CreateEditBox(c, L["PROFILE_NAME_FIELD"], y)
    y = ny

    local function readName()
        local name = nameBox:GetText()
        if not name or name:match("^%s*$") then
            print("|cffd1b559TomoCastbar|r " .. L["PROFILE_NAME_EMPTY"])
            return nil
        end
        name = name:match("^%s*(.-)%s*$")
        local _, named = Prof.GetProfileList()
        if named[name] then
            print("|cffd1b559TomoCastbar|r " .. L["PROFILE_EXISTS"])
            return nil
        end
        return name
    end

    local _, ny = W.CreateButton(c, L["PROFILE_CREATE_BTN"], 200, y, function()
        local name = readName()
        if name and Prof.CreateNamedProfile(name) then
            print("|cffd1b559TomoCastbar|r " .. string.format(L["PROFILE_CREATED"], name))
            RefreshCastbars(); C.configDirty = true; C.Hide()
        end
    end)
    y = ny

    local _, ny = W.CreateButton(c, L["PROFILE_DUPLICATE_BTN"], 200, y, function()
        local name = readName()
        if name and Prof.DuplicateProfile(selected, name) then
            print("|cffd1b559TomoCastbar|r " .. string.format(L["PROFILE_CREATED"], name))
            C.configDirty = true; C.Hide()
        end
    end)
    y = ny

    -- Spec auto-switch
    local _, ny = W.CreateSeparator(c, y)
    y = ny
    local _, ny = W.CreateSectionHeader(c, L["PROFILE_SPEC_HEADER"], y)
    y = ny
    local _, ny = W.CreateInfoText(c, L["PROFILE_SPEC_INFO"] or "", y)
    y = ny

    local specName = "—"
    do
        local idx = GetSpecialization and GetSpecialization()
        if idx then
            local _, sName = GetSpecializationInfo(idx)
            if sName then specName = sName end
        end
    end
    local assigned = Prof.GetSpecAssignedProfile(Prof.GetCurrentSpecID()) or L["PROFILE_NONE"]

    local specStatusFS, ny = W.CreateSubLabel(c, string.format(L["PROFILE_SPEC_CURRENT"], specName, assigned), y)
    y = ny

    local function refreshSpecStatus()
        local a = Prof.GetSpecAssignedProfile(Prof.GetCurrentSpecID()) or L["PROFILE_NONE"]
        if specStatusFS then specStatusFS:SetText(string.format(L["PROFILE_SPEC_CURRENT"], specName, a)) end
    end

    local _, ny = W.CreateDropdown(c, L["PROFILE_SPEC_ASSIGN"], profileOptions(), assigned, y, function(key)
        local sid = Prof.GetCurrentSpecID()
        if sid and sid ~= 0 and Prof.AssignSpecToProfile(sid, key) then
            print("|cffd1b559TomoCastbar|r " .. string.format(L["PROFILE_SPEC_ASSIGNED"], key))
            refreshSpecStatus()
        end
    end)
    y = ny

    local _, ny = W.CreateButton(c, L["PROFILE_SPEC_CLEAR"], 220, y, function()
        local sid = Prof.GetCurrentSpecID()
        if sid and sid ~= 0 then
            Prof.UnassignSpec(sid)
            print("|cffd1b559TomoCastbar|r " .. L["PROFILE_SPEC_UNASSIGNED"])
            refreshSpecStatus()
        end
    end)
    y = ny

    c:SetHeight(math.abs(y) + 40)
    if scroll.UpdateScroll then scroll.UpdateScroll() end
    return scroll
end

-- =====================================
-- CATEGORIES
-- =====================================

local categories = {
    { key = "general",  label = L["CAT_GENERAL"],  icon = "+", builder = function(p) return BuildGeneralPanel(p) end },
    { key = "player",   label = L["CAT_PLAYER"],   icon = "+", builder = function(p) return BuildUnitPanel(p, "player", L["CAT_PLAYER"]) end },
    { key = "target",   label = L["CAT_TARGET"],   icon = "+", builder = function(p) return BuildUnitPanel(p, "target", L["CAT_TARGET"]) end },
    { key = "focus",    label = L["CAT_FOCUS"],    icon = "+", builder = function(p) return BuildUnitPanel(p, "focus",  L["CAT_FOCUS"])  end },
    { key = "boss",     label = L["CAT_BOSS"],     icon = "+", builder = function(p) return BuildGroupPanel(p, "boss",  L["CAT_BOSS"])   end },
    { key = "arena",    label = L["CAT_ARENA"],    icon = "+", builder = function(p) return BuildGroupPanel(p, "arena", L["CAT_ARENA"])  end },
    { key = "profiles", label = L["CAT_PROFILES"], icon = "+", builder = function(p) return BuildProfilesPanel(p) end },
}

-- =====================================
-- CREATE MAIN FRAME
-- =====================================

local function CreateConfigFrame()
    if configFrame then return end

    configFrame = CreateFrame("Frame", "TomoCastbarConfigFrame", UIParent, "BackdropTemplate")
    configFrame:SetSize(620, 680)
    configFrame:SetPoint("CENTER")
    configFrame:SetFrameStrata("HIGH")
    configFrame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 2,
    })
    configFrame:SetBackdropColor(unpack(T.bg))
    configFrame:SetBackdropBorderColor(unpack(T.border))
    configFrame:SetMovable(true)
    configFrame:SetClampedToScreen(true)
    configFrame:EnableMouse(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", configFrame.StartMoving)
    configFrame:SetScript("OnDragStop",  configFrame.StopMovingOrSizing)
    configFrame:Hide()

    tinsert(UISpecialFrames, "TomoCastbarConfigFrame")

    -- =====================================
    -- TITLE BAR
    -- =====================================
    local TITLE_H = 44

    local titleBar = CreateFrame("Frame", nil, configFrame)
    titleBar:SetSize(configFrame:GetWidth(), TITLE_H)
    titleBar:SetPoint("TOP", 0, 0)

    local titleBg = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBg:SetAllPoints()
    titleBg:SetColorTexture(0.06, 0.06, 0.08, 1)

    -- Accent line (top — même que Movers header)
    local accentLine = titleBar:CreateTexture(nil, "OVERLAY")
    accentLine:SetHeight(2)
    accentLine:SetPoint("TOPLEFT",  0, 0)
    accentLine:SetPoint("TOPRIGHT", 0, 0)
    accentLine:SetColorTexture(ACCENT_R, ACCENT_G, ACCENT_B, 0.7)

    -- Titre + version (gauche)
    local titleText = titleBar:CreateFontString(nil, "OVERLAY")
    titleText:SetFont(FONT_BOLD, 15, "")
    titleText:SetPoint("LEFT", 16, 0)
    titleText:SetText(L["CONFIG_TITLE"])

    local versionText = titleBar:CreateFontString(nil, "OVERLAY")
    versionText:SetFont(FONT, 10, "")
    versionText:SetPoint("LEFT", titleText, "RIGHT", 8, -1)
    versionText:SetTextColor(unpack(T.textDim))
    versionText:SetText("v3.1.1")

    -- =====================================
    -- CLOSE BUTTON (×) — extrême droite
    -- =====================================
    local closeBtn = CreateFrame("Button", nil, titleBar)
    closeBtn:SetSize(32, 32)
    closeBtn:SetPoint("RIGHT", -4, 0)

    local closeTxt = closeBtn:CreateFontString(nil, "OVERLAY")
    closeTxt:SetFont(FONT_BOLD, 18, "")
    closeTxt:SetPoint("CENTER")
    closeTxt:SetText("×")
    closeTxt:SetTextColor(unpack(T.textDim))

    closeBtn:SetScript("OnEnter", function() closeTxt:SetTextColor(unpack(T.red)) end)
    closeBtn:SetScript("OnLeave", function() closeTxt:SetTextColor(unpack(T.textDim)) end)
    closeBtn:SetScript("OnClick", function() configFrame:Hide() end)

    -- =====================================
    -- RL BUTTON — à gauche du close (identique TomoMod)
    -- =====================================
    local rlBtn = CreateFrame("Button", nil, titleBar, "BackdropTemplate")
    rlBtn:SetSize(44, 24)
    rlBtn:SetPoint("RIGHT", closeBtn, "LEFT", -4, 0)
    rlBtn:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    rlBtn:SetBackdropColor(0.10, 0.08, 0.04, 0.85)
    rlBtn:SetBackdropBorderColor(0.60, 0.42, 0.08, 0.75)

    local rlTxt = rlBtn:CreateFontString(nil, "OVERLAY")
    rlTxt:SetFont(FONT, 11, "")
    rlTxt:SetPoint("CENTER")
    rlTxt:SetText(L["layout_btn_reload"] or "RL")
    rlTxt:SetTextColor(0.85, 0.65, 0.20)

    rlBtn:SetScript("OnEnter", function()
        rlBtn:SetBackdropBorderColor(1, 0.80, 0.25, 1)
        rlTxt:SetTextColor(1, 0.90, 0.40)
        if GameTooltip then
            GameTooltip:SetOwner(rlBtn, "ANCHOR_BOTTOM")
            GameTooltip:SetText(L["btn_reload_ui"] or "Reload UI", 1, 1, 1)
            GameTooltip:Show()
        end
    end)
    rlBtn:SetScript("OnLeave", function()
        rlBtn:SetBackdropBorderColor(0.60, 0.42, 0.08, 0.75)
        rlTxt:SetTextColor(0.85, 0.65, 0.20)
        if GameTooltip then GameTooltip:Hide() end
    end)
    rlBtn:SetScript("OnClick", function() ReloadUI() end)

    -- =====================================
    -- LAYOUT BUTTON — à gauche du RL (identique TomoMod)
    -- =====================================
    local layoutBtn = CreateFrame("Button", nil, titleBar, "BackdropTemplate")
    layoutBtn:SetSize(84, 24)
    layoutBtn:SetPoint("RIGHT", rlBtn, "LEFT", -6, 0)
    layoutBtn:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    -- Style initial (inactif)
    layoutBtn:SetBackdropColor(0.06, 0.06, 0.09, 0.85)
    layoutBtn:SetBackdropBorderColor(0.22, 0.22, 0.26, 0.8)

    -- Dot décoratif
    local layoutDot = layoutBtn:CreateTexture(nil, "OVERLAY")
    layoutDot:SetSize(6, 6)
    layoutDot:SetPoint("LEFT", layoutBtn, "LEFT", 8, 0)
    layoutDot:SetColorTexture(ACCENT_R, ACCENT_G, ACCENT_B, 1)

    local layoutTxt = layoutBtn:CreateFontString(nil, "OVERLAY")
    layoutTxt:SetFont(FONT, 11, "")
    layoutTxt:SetPoint("LEFT", layoutDot, "RIGHT", 6, 0)
    layoutTxt:SetText(L["btn_layout"] or "Layout")
    layoutTxt:SetTextColor(ACCENT_R, ACCENT_G, ACCENT_B)
    layoutBtn._txt = layoutTxt   -- requis par UpdateLayoutBtnStyle()

    layoutBtn:SetScript("OnEnter", function()
        layoutBtn:SetBackdropBorderColor(ACCENT_R, ACCENT_G, ACCENT_B, 1)
        layoutTxt:SetTextColor(1, 1, 1)
        layoutDot:SetColorTexture(1, 1, 1, 1)
        if GameTooltip then
            GameTooltip:SetOwner(layoutBtn, "ANCHOR_BOTTOM")
            GameTooltip:SetText(L["btn_layout_tooltip"] or "Layout Mode\nDrag castbars to reposition", 1, 1, 1)
            GameTooltip:Show()
        end
    end)
    layoutBtn:SetScript("OnLeave", function()
        UpdateLayoutBtnStyle()
        layoutDot:SetColorTexture(ACCENT_R, ACCENT_G, ACCENT_B, 1)
        if GameTooltip then GameTooltip:Hide() end
    end)
    layoutBtn:SetScript("OnClick", function()
        if TomoCastbar_Movers and TomoCastbar_Movers.Toggle then
            TomoCastbar_Movers.Toggle()
        end
        UpdateLayoutBtnStyle()
    end)

    _layoutBtn = layoutBtn

    -- =====================================
    -- TITLE BAR SEPARATOR
    -- =====================================
    local titleSep = configFrame:CreateTexture(nil, "ARTWORK")
    titleSep:SetHeight(1)
    titleSep:SetPoint("TOPLEFT",  0, -TITLE_H)
    titleSep:SetPoint("TOPRIGHT", 0, -TITLE_H)
    titleSep:SetColorTexture(unpack(T.border))

    -- =====================================
    -- SIDEBAR
    -- =====================================
    local sidebarWidth = 140

    local sidebar = CreateFrame("Frame", nil, configFrame)
    sidebar:SetPoint("TOPLEFT",  0, -(TITLE_H + 1))
    sidebar:SetPoint("BOTTOMLEFT", 0, 0)
    sidebar:SetWidth(sidebarWidth)

    local sidebarBg = sidebar:CreateTexture(nil, "BACKGROUND")
    sidebarBg:SetAllPoints()
    sidebarBg:SetColorTexture(0.06, 0.06, 0.08, 1)

    local sidebarSep = configFrame:CreateTexture(nil, "ARTWORK")
    sidebarSep:SetWidth(1)
    sidebarSep:SetPoint("TOPLEFT",    sidebarWidth, -(TITLE_H + 1))
    sidebarSep:SetPoint("BOTTOMLEFT", sidebarWidth, 0)
    sidebarSep:SetColorTexture(unpack(T.border))

    -- Category buttons
    for i, cat in ipairs(categories) do
        local btn = CreateFrame("Button", nil, sidebar)
        btn:SetSize(sidebarWidth, 36)
        btn:SetPoint("TOPLEFT", 0, -(i - 1) * 36 - 8)

        local btnBg = btn:CreateTexture(nil, "BACKGROUND")
        btnBg:SetAllPoints()
        btnBg:SetColorTexture(0, 0, 0, 0)
        btn.bg = btnBg

        local indicator = btn:CreateTexture(nil, "OVERLAY")
        indicator:SetSize(3, 24)
        indicator:SetPoint("LEFT", 0, 0)
        indicator:SetColorTexture(unpack(T.accent))
        indicator:Hide()
        btn.indicator = indicator

        local icon = btn:CreateFontString(nil, "OVERLAY")
        icon:SetFont(FONT, 13, "")
        icon:SetPoint("LEFT", 14, 0)
        icon:SetText(cat.icon)
        icon:SetTextColor(unpack(T.textDim))
        btn.icon = icon

        local label = btn:CreateFontString(nil, "OVERLAY")
        label:SetFont(FONT, 12, "")
        label:SetPoint("LEFT", icon, "RIGHT", 8, 0)
        label:SetText(cat.label)
        label:SetTextColor(unpack(T.textDim))
        btn.label = label

        btn:SetScript("OnEnter", function()
            if currentCategory ~= cat.key then btnBg:SetColorTexture(0.12, 0.12, 0.15, 1) end
        end)
        btn:SetScript("OnLeave", function()
            if currentCategory ~= cat.key then btnBg:SetColorTexture(0, 0, 0, 0) end
        end)
        btn:SetScript("OnClick", function() C.SwitchCategory(cat.key) end)

        categoryButtons[cat.key] = btn
    end

    -- =====================================
    -- CONTENT AREA
    -- =====================================
    local content = CreateFrame("Frame", nil, configFrame)
    content:SetPoint("TOPLEFT",  sidebarWidth + 1, -(TITLE_H + 1))
    content:SetPoint("BOTTOMRIGHT", 0, 0)
    configFrame.content = content

    -- =====================================
    -- FOOTER
    -- =====================================
    local footerSep = configFrame:CreateTexture(nil, "ARTWORK")
    footerSep:SetHeight(1)
    footerSep:SetPoint("BOTTOMLEFT",  sidebarWidth + 1, 32)
    footerSep:SetPoint("BOTTOMRIGHT", 0, 32)
    footerSep:SetColorTexture(unpack(T.separator))

    local footerText = configFrame:CreateFontString(nil, "OVERLAY")
    footerText:SetFont(FONT, 9, "")
    footerText:SetPoint("BOTTOMRIGHT", -12, 10)
    footerText:SetTextColor(unpack(T.textDim))
    footerText:SetText(L["CONFIG_FOOTER"])
end

-- =====================================
-- SWITCH CATEGORY
-- =====================================

function C.SwitchCategory(key)
    if currentCategory == key then return end

    for _, panel in pairs(categoryPanels) do panel:Hide() end

    for catKey, btn in pairs(categoryButtons) do
        if catKey == key then
            btn.bg:SetColorTexture(0.10, 0.10, 0.13, 1)
            btn.indicator:Show()
            btn.icon:SetTextColor(unpack(T.accent))
            btn.label:SetTextColor(unpack(T.text))
        else
            btn.bg:SetColorTexture(0, 0, 0, 0)
            btn.indicator:Hide()
            btn.icon:SetTextColor(unpack(T.textDim))
            btn.label:SetTextColor(unpack(T.textDim))
        end
    end

    if not categoryPanels[key] then
        for _, cat in ipairs(categories) do
            if cat.key == key and cat.builder then
                local panel = cat.builder(configFrame.content)
                panel:SetAllPoints(configFrame.content)
                categoryPanels[key] = panel
                break
            end
        end
    end

    if categoryPanels[key] then categoryPanels[key]:Show() end
    currentCategory = key

    -- Resync le bouton Layout à l'ouverture d'un panel
    UpdateLayoutBtnStyle()
end

-- =====================================
-- TOGGLE / SHOW / HIDE
-- =====================================

function C.Toggle()
    if not TomoCastbarDB then
        print("|cffd1b559TomoCastbar|r " .. L["DB_NOT_INIT"])
        return
    end

    if C.configDirty then
        if configFrame then
            configFrame:Hide()
            configFrame:ClearAllPoints()  -- [v3.1] detach sans reparent nil (sûr sur Midnight)
            configFrame = nil
        end
        categoryPanels  = {}
        categoryButtons = {}
        currentCategory = nil
        _layoutBtn      = nil
        C.configDirty   = false
    end

    if not configFrame then CreateConfigFrame() end

    if configFrame:IsShown() then
        configFrame:Hide()
    else
        configFrame:Show()
        if not currentCategory then C.SwitchCategory("general") end
        UpdateLayoutBtnStyle()
    end
end

function C.Show()
    if not configFrame or not configFrame:IsShown() then C.Toggle() end
end

function C.Hide()
    if configFrame and configFrame:IsShown() then configFrame:Hide() end
end
