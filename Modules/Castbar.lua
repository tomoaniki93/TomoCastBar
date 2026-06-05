-- =====================================
-- Castbar.lua — v2.0
-- Standalone Castbar Module — Player, Target, Focus
-- Supports: Casts, Channels, Empowered (Evoker)
-- =====================================

TomoCastbar_Module = TomoCastbar_Module or {}
local CB = TomoCastbar_Module
local L  = TomoCastbar_L
local SA = TomoCastbar_Spark  -- SparkAnimations module

-- =====================================
-- [PERF] UPVALUES
-- =====================================
local GetTime           = GetTime
local math_max          = math.max
local math_min          = math.min
local math_floor        = math.floor
local math_sin          = math.sin
local string_format     = string.format
local UnitCastingInfo   = UnitCastingInfo
local UnitChannelInfo   = UnitChannelInfo
local UnitClass         = UnitClass
local IsPlayerSpell     = IsPlayerSpell
local GetNetStats       = GetNetStats
local UnitName          = UnitName
local UnitNameFromGUID  = UnitNameFromGUID
local UnitGUID          = UnitGUID
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local MAX_EMPOWER_STAGES = 4
local MAX_CHANNEL_TICKS  = 20
local TIMER_UPDATE_FREQ  = 0.05

-- =====================================
-- =====================================
-- (School colors removed — replaced by class color for all units)

-- =====================================
-- [LSM] LibSharedMedia-3.0
-- =====================================
local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)

-- Résout une texture de barre : LSM > fallback hardcodé
function CB.ResolveBarTexture(db)
    if LSM and db.barTextureLSM and db.barTextureLSM ~= "" then
        local path = LSM:Fetch("statusbar", db.barTextureLSM)
        if path then return path end
    end
    local fallback = {
        blizzard = "Interface\\TargetingFrame\\UI-StatusBar",
        smooth   = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
        flat     = "Interface\\Buttons\\WHITE8x8",
    }
    return fallback[db.barTexture] or fallback.blizzard
end

-- Résout une police : LSM > fallback hardcodé
function CB.ResolveFont(db)
    if LSM and db.fontLSM and db.fontLSM ~= "" then
        local path = LSM:Fetch("font", db.fontLSM)
        if path then return path end
    end
    return db.font or "Fonts\\FRIZQT__.TTF"
end

-- =====================================
-- [PERF] TABLE RÉUTILISABLE — GetSafeCastInfo
-- =====================================
local _castInfoCache = {}

local function GetSafeCastInfo(unit, isChannel)
    local name, _, texture, startTime, endTime, _, _, notInterruptible, spellID, numStages
    if isChannel then
        name, _, texture, startTime, endTime, _, notInterruptible, spellID, _, numStages = UnitChannelInfo(unit)
    else
        name, _, texture, startTime, endTime, _, _, notInterruptible, spellID = UnitCastingInfo(unit)
    end
    if type(name) == "nil" then return nil end
    _castInfoCache.name             = name
    _castInfoCache.texture          = texture
    _castInfoCache.startTime        = startTime
    _castInfoCache.endTime          = endTime
    _castInfoCache.notInterruptible = notInterruptible
    _castInfoCache.spellID          = spellID
    _castInfoCache.numStages        = numStages or 0
    return _castInfoCache
end

-- =====================================
-- CHANNEL TICK DATABASE
-- =====================================
local CHANNEL_TICK_DATA = {
    [15407]=6,[263165]=4,[48045]=4,[64843]=4,[47540]=9,[47666]=3,
    [5143]=5,[12051]=3,[205021]=5,
    [198590]=6,[234153]=5,[755]=5,
    [740]=4,[115175]=9,[113656]=4,[117952]=4,
    [120360]=3,[257044]=7,[206931]=3,[198013]=6,[211053]=3,
    [291944]=6,[356995]=3,
}
local CHANNEL_TICK_MODIFIERS = { [356995] = { 1219723, 1 } }

local function GetChannelTicks(spellID, durationMS)
    -- [v3.1] spellID peut être une valeur secrète sur unités ennemies (boss/arena).
    -- On ne tente l'indexation de la table QUE si la valeur n'est pas secrète.
    local safeID = spellID and (not issecretvalue or not issecretvalue(spellID)) and spellID or nil
    if safeID and CHANNEL_TICK_DATA[safeID] then
        local ticks = CHANNEL_TICK_DATA[safeID]
        local mod = CHANNEL_TICK_MODIFIERS[safeID]
        if mod and IsPlayerSpell(mod[1]) then ticks = ticks + mod[2] end
        return ticks
    end
    if durationMS and durationMS > 0 then return math_max(2, math_floor(durationMS / 1000 + 0.5)) end
    return 0
end

local EMPOWER_STAGE_COLORS = {
    { 0.80, 0.50, 0.10 }, { 0.90, 0.75, 0.10 },
    { 0.20, 0.70, 0.90 }, { 0.55, 0.30, 0.95 },
}

CB.castbars = {}
CB.groupAnchors = {}  -- [v3.1] ancres de groupe pour boss/arena

-- =====================================
-- [v3.0] INTERRUPT FEEDBACK — Texte centre écran
-- =====================================
local _interruptFrame = nil

local function ShowInterruptFeedback(spellName)
    local db = TomoCastbarDB
    if not db or not db.showInterruptFeedback then return end

    if not _interruptFrame then
        _interruptFrame = CreateFrame("Frame", "TomoCastbar_InterruptFeedback", UIParent)
        _interruptFrame:SetSize(400, 60)
        _interruptFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
        _interruptFrame:SetFrameStrata("HIGH")

        local text = _interruptFrame:CreateFontString(nil, "OVERLAY")
        text:SetPoint("CENTER")
        text:SetJustifyH("CENTER")
        _interruptFrame.text = text

        -- Fade-out animation
        local ag = _interruptFrame:CreateAnimationGroup()
        local hold = ag:CreateAnimation("Alpha")
        hold:SetFromAlpha(1); hold:SetToAlpha(1)
        hold:SetDuration(0.8); hold:SetOrder(1)
        local fade = ag:CreateAnimation("Alpha")
        fade:SetFromAlpha(1); fade:SetToAlpha(0)
        fade:SetDuration(0.7); fade:SetSmoothing("OUT"); fade:SetOrder(2)
        ag:SetScript("OnFinished", function()
            _interruptFrame:SetAlpha(0); _interruptFrame:Hide()
        end)
        _interruptFrame._fadeAG = ag
    end

    local L = TomoCastbar_L
    local col = db.interruptFeedbackColor or { r = 0.1, g = 0.8, b = 0.1 }
    local fSize = db.interruptFeedbackFontSize or 28
    local font = CB.ResolveFont(db)

    _interruptFrame.text:SetFont(font, fSize, "THICKOUTLINE")
    _interruptFrame.text:SetTextColor(col.r, col.g, col.b, 1)

    if spellName and spellName ~= "" then
        _interruptFrame.text:SetText(string_format(L["INTERRUPT_FEEDBACK_FULL"], spellName))
    else
        _interruptFrame.text:SetText(L["INTERRUPT_FEEDBACK_TEXT"])
    end

    _interruptFrame:SetAlpha(1)
    _interruptFrame:Show()
    if _interruptFrame._fadeAG:IsPlaying() then _interruptFrame._fadeAG:Stop() end
    _interruptFrame._fadeAG:Play()
end

-- =====================================
-- COULEUR DE CLASSE
-- =====================================
local function GetUnitClassColor(unit)
    local _, class = UnitClass(unit)
    if class and RAID_CLASS_COLORS[class] then
        local c = RAID_CLASS_COLORS[class]
        return c.r, c.g, c.b
    end
    return nil
end

-- =====================================
-- BORDURE
-- =====================================
local function CreateBorder(frame, db)
    if db and db.useCustomBorder and db.customBorderPath then
        local border = frame:CreateTexture(nil, "OVERLAY", nil, 7)
        border:SetTexture(db.customBorderPath)
        border:SetPoint("TOPLEFT",     frame, "TOPLEFT",     -4,  4)
        border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",  4, -4)
        frame.customBorder = border
        return
    end
    local function Edge(p1, p2, w, h)
        local t = frame:CreateTexture(nil, "OVERLAY", nil, 7)
        t:SetColorTexture(0, 0, 0, 1)
        t:SetPoint(p1); t:SetPoint(p2)
        if w then t:SetWidth(w) end
        if h then t:SetHeight(h) end
    end
    Edge("TOPLEFT","TOPRIGHT",nil,1); Edge("BOTTOMLEFT","BOTTOMRIGHT",nil,1)
    Edge("TOPLEFT","BOTTOMLEFT",1,nil); Edge("TOPRIGHT","BOTTOMRIGHT",1,nil)
end

-- =====================================
-- FORMAT DU TIMER
-- =====================================
local function FormatTimer(duration_obj, castStartSec, format)
    if not duration_obj then return "" end
    local rem = math_max(0, duration_obj:GetRemainingDuration(0))
    if format == "remaining_total" then
        local total = castStartSec and ((GetTime() + rem) - castStartSec) or rem
        return string_format("%.1f / %.1f", rem, total)
    elseif format == "elapsed" then
        if castStartSec then return string_format("%.1f", math_max(0, GetTime() - castStartSec)) end
        return string_format("%.1f", rem)
    end
    return string_format("%.1f", rem)
end

local function TruncateSpellName(name, maxLen)
    if not maxLen or maxLen <= 0 then return name end
    if #name > maxLen then return name:sub(1, maxLen) .. "…" end
    return name
end

-- =====================================
-- LATENCE PRÉCISE PAR SORT
-- =====================================
local _playerLatency = { sendTime = nil, timeDiff = 0 }
do
    local latFrame = CreateFrame("Frame")
    local lastCastChangeTime = nil
    latFrame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
    latFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
    latFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    latFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    latFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
    latFrame:SetScript("OnEvent", function(_, event, unit)
        if event == "CURRENT_SPELL_CAST_CHANGED" then
            lastCastChangeTime = GetTime()
        elseif event == "UNIT_SPELLCAST_SENT" and unit == "player" then
            _playerLatency.sendTime = lastCastChangeTime; lastCastChangeTime = nil
        elseif unit == "player" then
            _playerLatency.sendTime = nil
        end
    end)
end

-- =====================================
-- CRÉATION DE LA CASTBAR
-- =====================================

function CB.CreateCastbar(unit, opts)
    local db = TomoCastbarDB
    if not db then return nil end
    -- [v3.1] unit = clé logique (lookup db + classe de fonctionnalités).
    --        unitID = token WoW réel ("player"/"target"/"focus"/"boss1".."arena5").
    --        Pour player/target/focus, unit == unitID (comportement inchangé).
    opts = opts or {}
    local unitID       = opts.unitID   or unit
    local unitSettings = opts.settings or db[unit]
    if not unitSettings or not unitSettings.enabled then return nil end

    -- [LSM] Texture et police résolues
    local tex  = CB.ResolveBarTexture(db)
    local font = CB.ResolveFont(db)

    local castbar = CreateFrame("StatusBar", "TomoCastbar_" .. unitID, UIParent)
    castbar:SetSize(unitSettings.width, unitSettings.height)
    castbar:SetStatusBarTexture(tex)
    castbar:GetStatusBarTexture():SetHorizTile(false)
    castbar:SetMinMaxValues(0, 100)
    castbar:SetValue(100)

    local cbColors = db.castbarColor
    local baseR, baseG, baseB = 0.8, 0.1, 0.1
    if cbColors then baseR, baseG, baseB = cbColors.r, cbColors.g, cbColors.b end
    castbar:SetStatusBarColor(baseR, baseG, baseB, 1)
    castbar._baseColor = { baseR, baseG, baseB }

    castbar:SetParent(UIParent)
    castbar:ClearAllPoints()
    if opts.anchorFrame then
        -- [v3.1] Barre de groupe (boss/arena) : empilée sous l'ancre commune,
        -- pas de drag individuel (seule l'ancre est déplaçable via le Layout Mode).
        local prev    = opts.prevBar
        local spacing = opts.spacing or 4
        local growth  = opts.growth or "DOWN"
        if not prev then
            castbar:SetPoint("TOPLEFT", opts.anchorFrame, "TOPLEFT", 0, 0)
        elseif growth == "UP" then
            castbar:SetPoint("BOTTOMLEFT", prev, "TOPLEFT", 0, spacing)
        else
            castbar:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -spacing)
        end
        -- Stubs lock : toute itération sur CB.castbars reste sûre.
        castbar.isLocked = true
        castbar.SetLocked = function(self, locked) self.isLocked = locked end
        castbar.IsLocked  = function(self) return self.isLocked end
    else
        local pos = unitSettings.position or { point="CENTER", relativePoint="CENTER", x=0, y=0 }
        castbar:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)

        TomoCastbar_Utils.SetupDraggable(castbar, function()
            local point, _, relativePoint, x, y = castbar:GetPoint()
            unitSettings.position = unitSettings.position or {}
            unitSettings.position.point = point; unitSettings.position.relativePoint = relativePoint
            unitSettings.position.x = x; unitSettings.position.y = y
        end)
    end
    castbar:SetFrameStrata("MEDIUM")

    -- Fond
    local bg = castbar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    local bgMode = db.backgroundMode or "custom"
    if bgMode == "transparent" then bg:SetColorTexture(0,0,0,0)
    elseif bgMode == "black"   then bg:SetColorTexture(0,0,0,0.85)
    else
        if db.customBackgroundPath then
            bg:SetTexture(db.customBackgroundPath)
            bg:SetVertexColor(0.12, 0.12, 0.15, 0.95)
        else bg:SetColorTexture(0,0,0,0.85) end
    end
    castbar.bg = bg

    CreateBorder(castbar, db)

    -- NI overlay
    local statustexture = castbar:GetStatusBarTexture()
    local niOverlay = castbar:CreateTexture(nil, "ARTWORK", nil, 1)
    niOverlay:SetPoint("TOPLEFT",     statustexture, "TOPLEFT",     0, 0)
    niOverlay:SetPoint("BOTTOMRIGHT", statustexture, "BOTTOMRIGHT", 0, 0)
    local niColors = db.castbarNIColor
    local niR, niG, niB = 0.5, 0.5, 0.5
    if niColors then niR, niG, niB = niColors.r, niColors.g, niColors.b end
    niOverlay:SetColorTexture(niR, niG, niB, 1)
    niOverlay:SetAlpha(0); niOverlay:Show()
    castbar.niOverlay = niOverlay

    -- Latence (joueur uniquement)
    if unitID == "player" then
        local latencyTex = castbar:CreateTexture(nil, "ARTWORK", nil, 2)
        latencyTex:SetPoint("TOP",    castbar, "TOP",    0, 0)
        latencyTex:SetPoint("BOTTOM", castbar, "BOTTOM", 0, 0)
        latencyTex:SetPoint("RIGHT",  castbar, "RIGHT",  0, 0)
        latencyTex:SetWidth(1); latencyTex:SetTexture(tex)
        latencyTex:SetVertexColor(baseR*0.35, baseG*0.35, baseB*0.35, 0.85)
        latencyTex:Hide()
        castbar.latencyTex = latencyTex
    end

    -- Stage markers (Empowered)
    castbar.stageMarkers = {}
    for i = 1, MAX_EMPOWER_STAGES do
        local marker = castbar:CreateTexture(nil, "OVERLAY", nil, 2)
        marker:SetWidth(2)
        marker:SetPoint("TOP",    castbar, "TOP",    0, 0)
        marker:SetPoint("BOTTOM", castbar, "BOTTOM", 0, 0)
        marker:SetColorTexture(1, 1, 1, 0.7); marker:Hide()
        castbar.stageMarkers[i] = marker
    end
    castbar.stageOverlays = {}; castbar._stageBoundaries = {}
    for i = 1, MAX_EMPOWER_STAGES do
        local overlay = castbar:CreateTexture(nil, "ARTWORK", nil, 3)
        overlay:SetPoint("TOP", castbar, "TOP", 0, 0)
        overlay:SetPoint("BOTTOM", castbar, "BOTTOM", 0, 0)
        local col = EMPOWER_STAGE_COLORS[i] or { 0.5, 0.5, 0.5 }
        overlay:SetColorTexture(col[1], col[2], col[3], 0.45); overlay:Hide()
        castbar.stageOverlays[i] = overlay
    end

    -- Tick markers (canal)
    castbar.tickMarkers = {}
    for i = 1, MAX_CHANNEL_TICKS do
        local tick = castbar:CreateTexture(nil, "OVERLAY", nil, 1)
        tick:SetWidth(1)
        tick:SetPoint("TOP",    castbar, "TOP",    0, 0)
        tick:SetPoint("BOTTOM", castbar, "BOTTOM", 0, 0)
        tick:SetColorTexture(1, 1, 1, 0.5); tick:Hide()
        castbar.tickMarkers[i] = tick
    end
    castbar._numTicks = 0

    -- [ANIM] Spark — créé via SparkAnimations.lua
    castbar._spark = nil
    if db.showSpark then
        local sparkDb = {
            height          = unitSettings.height,
            customSparkPath = db.customSparkPath,
            sparkColor      = db.sparkColor,
            sparkGlowColor  = db.sparkGlowColor,
            sparkTailColor  = db.sparkTailColor,
            sparkGlowAlpha  = db.sparkGlowAlpha or 0.7,
            sparkTailAlpha  = db.sparkTailAlpha or 0.6,
        }
        castbar._spark = SA.CreateSparkTextures(castbar, sparkDb)
        SA.ApplyColors(castbar._spark, sparkDb)
    end

    -- Icône
    if unitSettings.showIcon then
        local icon = castbar:CreateTexture(nil, "OVERLAY")
        icon:SetSize(unitSettings.height, unitSettings.height)
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        castbar.icon = icon

        local side = unitSettings.iconSide or "LEFT"
        if side == "RIGHT" then
            icon:SetPoint("LEFT", castbar, "RIGHT", 3, 0)
        else
            icon:SetPoint("RIGHT", castbar, "LEFT", -3, 0)
        end

        local iconBorder = CreateFrame("Frame", nil, castbar)
        iconBorder:SetPoint("TOPLEFT",     icon, "TOPLEFT",     -1,  1)
        iconBorder:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT",  1, -1)
        CreateBorder(iconBorder, db)
        castbar.iconBorder = iconBorder
    end

    -- Textes
    local fontSize = db.fontSize or 12
    local spellText = castbar:CreateFontString(nil, "OVERLAY")
    spellText:SetFont(font, fontSize, "OUTLINE")
    spellText:SetPoint("LEFT", 4, 0); spellText:SetTextColor(1, 1, 1, 1)
    spellText:SetJustifyH("LEFT"); castbar.spellText = spellText

    if unitSettings.showTimer then
        local timerText = castbar:CreateFontString(nil, "OVERLAY")
        timerText:SetFont(font, fontSize, "OUTLINE")
        timerText:SetPoint("RIGHT", -4, 0); timerText:SetTextColor(1, 1, 1, 0.9)
        castbar.timerText = timerText
    end

    -- Nom de la cible du cast (toutes unités sauf le joueur)
    if unitID ~= "player" then
        local targetText = castbar:CreateFontString(nil, "OVERLAY")
        targetText:SetFont(font, fontSize, "OUTLINE")
        targetText:SetPoint("LEFT", spellText, "RIGHT", 4, 0)
        targetText:SetTextColor(1, 1, 1, 0.6)
        targetText:SetJustifyH("LEFT")
        castbar.targetText = targetText
    end

    -- [v3.0] Transition Animations
    do
        -- Fade-out (succès / fin de cast)
        local fadeAG = castbar:CreateAnimationGroup()
        local fadeA = fadeAG:CreateAnimation("Alpha")
        fadeA:SetFromAlpha(1); fadeA:SetToAlpha(0)
        fadeA:SetDuration(0.3); fadeA:SetSmoothing("OUT")
        fadeAG:SetScript("OnFinished", function()
            castbar:SetAlpha(1)
            -- Ne pas masquer si un nouveau cast est déjà en cours
            if not castbar.casting and not castbar.channeling and not castbar.empowered and not castbar.failstart then
                castbar:Hide()
            end
        end)
        castbar._fadeAG = fadeAG

        -- Flash (interruption sur la barre)
        local flashAG = castbar:CreateAnimationGroup()
        local fl1 = flashAG:CreateAnimation("Alpha")
        fl1:SetFromAlpha(1); fl1:SetToAlpha(0.15); fl1:SetDuration(0.06); fl1:SetOrder(1)
        local fl2 = flashAG:CreateAnimation("Alpha")
        fl2:SetFromAlpha(0.15); fl2:SetToAlpha(1); fl2:SetDuration(0.06); fl2:SetOrder(2)
        local fl3 = flashAG:CreateAnimation("Alpha")
        fl3:SetFromAlpha(1); fl3:SetToAlpha(0.3); fl3:SetDuration(0.06); fl3:SetOrder(3)
        local fl4 = flashAG:CreateAnimation("Alpha")
        fl4:SetFromAlpha(0.3); fl4:SetToAlpha(1); fl4:SetDuration(0.06); fl4:SetOrder(4)
        castbar._flashAG = flashAG
    end

    -- État
    castbar.unit = unitID; castbar.casting = false; castbar.channeling = false
    castbar.empowered = false; castbar.numStages = 0; castbar.duration_obj = nil
    castbar.failstart = nil; castbar._preview = false; castbar._castStartMS = nil
    castbar._castEndMS = nil; castbar._channelSpellID = nil; castbar._timerElapsed = 0

    castbar:Hide()

    -- =====================
    -- HELPERS INTERNES
    -- =====================

    local function HideTickMarkers(self)
        for i = 1, MAX_CHANNEL_TICKS do self.tickMarkers[i]:Hide() end
        self._numTicks = 0
    end

    local function UpdateTickMarkers(self)
        HideTickMarkers(self)
        if not db.showChannelTicks or not self.channeling then return end
        local dSec = self._realDurationSec
        if not dSec or dSec <= 0 then return end
        local numTicks = GetChannelTicks(self._channelSpellID, dSec * 1000)
        if numTicks < 2 then return end
        self._numTicks = numTicks
        local bw = self:GetWidth()
        for i = 1, numTicks - 1 do
            local m = self.tickMarkers[i]
            if m then
                local xPos = bw * (i / numTicks)
                m:ClearAllPoints()
                m:SetPoint("TOP",    self, "TOPLEFT",    xPos, 0)
                m:SetPoint("BOTTOM", self, "BOTTOMLEFT", xPos, 0)
                m:Show()
            end
        end
    end

    local function HideStageMarkers(self)
        for i = 1, MAX_EMPOWER_STAGES do self.stageMarkers[i]:Hide() end
        if self.stageOverlays then for i = 1, MAX_EMPOWER_STAGES do self.stageOverlays[i]:Hide() end end
        if self._stageBoundaries then wipe(self._stageBoundaries) end
    end

    local function UpdateStageMarkers(self)
        HideStageMarkers(self)
        if not self.empowered or self.numStages <= 0 then return end
        local bw = self:GetWidth()
        local dSec = self._realDurationSec
        if not dSec or dSec <= 0 then return end
        pcall(function()
            local totalMS = dSec * 1000
            if totalMS <= 0 then return end
            local cumulative = 0
            local boundaries = {}; boundaries[0] = 0
            for stage = 0, self.numStages - 1 do
                local stageDur = GetUnitEmpowerStageDuration(self.unit, stage)
                if not stageDur or stageDur <= 0 then break end
                cumulative = cumulative + stageDur
                local pct = cumulative / totalMS
                boundaries[stage + 1] = pct
                if stage < self.numStages - 1 then
                    local xPos = bw * pct
                    local marker = self.stageMarkers[stage + 1]
                    if marker then
                        marker:ClearAllPoints()
                        marker:SetPoint("TOP",    self, "TOPLEFT",    xPos, 0)
                        marker:SetPoint("BOTTOM", self, "BOTTOMLEFT", xPos, 0)
                        marker:Show()
                    end
                end
            end
            self._stageBoundaries = boundaries
            for stage = 1, self.numStages do
                local overlay = self.stageOverlays[stage]
                if overlay then
                    local lp = boundaries[stage-1] or 0
                    local rp = boundaries[stage]   or 1
                    overlay:ClearAllPoints()
                    overlay:SetPoint("TOPLEFT",    self, "TOPLEFT",    bw*lp, 0)
                    overlay:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", bw*lp, 0)
                    overlay:SetWidth(math_max(1, bw*rp - bw*lp))
                    overlay:SetAlpha(0); overlay:Show()
                end
            end
        end)
    end

    local function ResetState(self)
        self.casting=false; self.channeling=false; self.empowered=false
        self.numStages=0; self.duration_obj=nil; self._castStartMS=nil
        self._castEndMS=nil; self._realStartSec=nil; self._realEndSec=nil
        self._realDurationSec=nil; self._channelSpellID=nil; self._timerElapsed=0
        self._lastSpellID = nil
        HideStageMarkers(self); HideTickMarkers(self)
        if self.latencyTex  then self.latencyTex:Hide() end
        if self._spark      then SA.HideAll(self._spark) end
        if self.targetText  then self.targetText:SetText("") end
    end

    -- [v3.0] Transition : fade-out au lieu d'un Hide() brut
    local function FadeOut(self)
        ResetState(self)
        if db.showTransitions and self._fadeAG and not self._fadeAG:IsPlaying() then
            self._fadeAG:Play()
        else
            self:Hide()
        end
    end

    -- [v3.0] Flash + hold (pour les interruptions sur la barre)
    local function FlashBar(self)
        if db.showTransitions and self._flashAG then
            if self._flashAG:IsPlaying() then self._flashAG:Stop() end
            self._flashAG:Play()
        end
    end

    function castbar:ShowPreview()
        self._preview = true; ResetState(self); self.failstart = nil
        self.niOverlay:SetAlpha(0)
        self:SetMinMaxValues(0, 100); self:SetValue(100); self:SetReverseFill(false)
        local bc = self._baseColor or { 0.8, 0.1, 0.1 }
        self:SetStatusBarColor(bc[1], bc[2], bc[3], 1)
        if self.spellText then self.spellText:SetText(string_format(L["PREVIEW_CASTBAR"], self.unit)) end
        if self.targetText then self.targetText:SetText("→ " .. (UnitName("player") or "Target")) end
        if self.timerText then self.timerText:SetText("1.5") end
        if self.icon then self.icon:SetTexture("Interface\\Icons\\Spell_Nature_Lightning") end
        if self.latencyTex then
            if unitSettings.showLatency then self.latencyTex:SetWidth(math_max(2, self:GetWidth()*0.04)); self.latencyTex:Show()
            else self.latencyTex:Hide() end
        end
        if self._spark then
            SA.Update(self._spark, {
                height=unitSettings.height, sparkStyle=db.sparkStyle,
                sparkGlowAlpha=db.sparkGlowAlpha or 0.7, sparkTailAlpha=db.sparkTailAlpha or 0.6,
            }, 0.75, self:GetWidth(), 0)
        end
        self:Show()
    end

    function castbar:HidePreview()
        self._preview = false
        if self.spellText  then self.spellText:SetText("") end
        if self.targetText then self.targetText:SetText("") end
        if self.timerText  then self.timerText:SetText("") end
        if self.icon      then self.icon:SetTexture(nil)  end
        if self.latencyTex then self.latencyTex:Hide() end
        if self._spark    then SA.HideAll(self._spark) end
        HideStageMarkers(self)
        if not self.casting and not self.channeling and not self.empowered and not self.failstart then self:Hide() end
    end

    local function UpdateLatency(self)
        if not self.latencyTex then return end
        if not unitSettings.showLatency or not self.casting then self.latencyTex:Hide(); return end
        local dSec = self._realDurationSec
        if not dSec or dSec <= 0 then self.latencyTex:Hide(); return end
        local latSec
        if unit == "player" and _playerLatency.sendTime then
            latSec = GetTime() - _playerLatency.sendTime
            _playerLatency.timeDiff = latSec; _playerLatency.sendTime = nil
        else
            local _, _, _, latWorld = GetNetStats()
            latSec = (latWorld or 0) / 1000
        end
        local bw = self:GetWidth()
        local w = math_min(bw*0.25, math_max(2, (latSec/(dSec)) * bw))
        if w > 0 then
            local bc = self._baseColor or { 0.8, 0.1, 0.1 }
            self.latencyTex:SetVertexColor(bc[1]*0.35, bc[2]*0.35, bc[3]*0.35, 0.85)
            self.latencyTex:SetWidth(w); self.latencyTex:Show()
        else self.latencyTex:Hide() end
    end

    local function ApplyBarColor(self, unitID, spellID)
        if db.useClassColor then
            local colorUnit = (unit == "player") and "player" or unitID
            local r, g, b = GetUnitClassColor(colorUnit)
            if r then self:SetStatusBarColor(r, g, b, 1); self._baseColor = {r, g, b}; return end
        end
        local bc = db.castbarColor; local r, g, b = 0.8, 0.1, 0.1
        if bc then r, g, b = bc.r, bc.g, bc.b end
        self:SetStatusBarColor(r, g, b, 1); self._baseColor = {r, g, b}
    end

    local function CheckCast(self, isInterrupt, interrupterGUID)
        local unitID = self.unit
        if isInterrupt then
            -- [v3.0] Interrupt feedback — vérifie si c'est le joueur qui a interrompu
            if (unit == "target" or unit == "focus") and interrupterGUID then
                local playerGUID = UnitGUID("player")
                if playerGUID and interrupterGUID == playerGUID then
                    local lastSpellName = self.spellText and self.spellText:GetText() or ""
                    ShowInterruptFeedback(lastSpellName)
                end
            end

            self.niOverlay:SetAlpha(0); ResetState(self)
            local intCol = db.castbarInterruptColor
            if intCol then self:SetStatusBarColor(intCol.r, intCol.g, intCol.b, 1)
            else self:SetStatusBarColor(0.1, 0.8, 0.1, 1) end
            if self.spellText then
                local interrupterName = interrupterGUID and UnitNameFromGUID(interrupterGUID)
                if interrupterName and type(interrupterName) == "string" then
                    self.spellText:SetText((INTERRUPTED or L["INTERRUPTED"]) .. " (" .. interrupterName .. ")")
                else self.spellText:SetText(INTERRUPTED or L["INTERRUPTED"]) end
            end
            if self.targetText then self.targetText:SetText("") end
            FlashBar(self)
            self.failstart = GetTime(); self:SetMinMaxValues(0,100); self:SetValue(100); self:Show()
            return
        end
        if self.failstart then
            if GetTime() - self.failstart > 1 then
                self.failstart = nil; FadeOut(self)
            end
            return
        end
        local info = GetSafeCastInfo(unitID, false)
        local bchannel, bempowered, numStages, channelSpellID = false, false, 0, nil
        if not info then
            info = GetSafeCastInfo(unitID, true)
            if info then
                channelSpellID = info.spellID
                if info.numStages and info.numStages > 0 then bempowered=true; numStages=info.numStages
                else bchannel=true end
            end
        end
        if not info then ResetState(self); self:Hide(); return end

        -- Stopper le fade-out si un nouveau cast arrive pendant l'animation
        if self._fadeAG and self._fadeAG:IsPlaying() then
            self._fadeAG:Stop()
            self:SetAlpha(1)
        end

        local duration = (bchannel or bempowered) and UnitChannelDuration(unitID) or UnitCastingDuration(unitID)
        self.duration_obj = duration
        self._castStartMS = info.startTime; self._castEndMS = info.endTime
        self._realStartSec=nil; self._realEndSec=nil; self._realDurationSec=nil
        self._lastSpellID = info.spellID
        if duration then
            local ok, rStart, rEnd, rDur = pcall(function()
                local rem = duration:GetRemainingDuration(0)
                local now = GetTime(); local endT = now + rem
                return endT-rem, endT, rem
            end)
            if ok then self._realStartSec=rStart; self._realEndSec=rEnd; self._realDurationSec=rDur end
        end
        self.casting=(not bchannel and not bempowered); self.channeling=bchannel
        self.empowered=bempowered; self.numStages=numStages
        self._channelSpellID=channelSpellID; self.failstart=nil; self._timerElapsed=0
        self:SetMinMaxValues(info.startTime, info.endTime); self:SetReverseFill(bchannel)
        ApplyBarColor(self, unitID, info.spellID)
        if self.spellText then self.spellText:SetText(TruncateSpellName(info.name, db.spellNameMaxLen)) end
        if self.targetText then
            local castTarget = UnitName(unitID .. "target")
            if castTarget and type(castTarget) == "string" then
                self.targetText:SetText("→ " .. castTarget)
            else
                self.targetText:SetText("")
            end
        end
        if self.icon then self.icon:SetTexture(info.texture) end
        local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(info.notInterruptible, 1, 0)
        self.niOverlay:SetAlpha(alpha)
        if bempowered then UpdateStageMarkers(self); HideTickMarkers(self)
        elseif bchannel then HideStageMarkers(self); UpdateTickMarkers(self)
        else HideStageMarkers(self); HideTickMarkers(self) end
        UpdateLatency(self)
        self:Show()
    end

    -- =====================
    -- OnUpdate
    -- =====================
    castbar:SetScript("OnUpdate", function(self, elapsed)
        if self._preview then return end
        if self.failstart then
            if GetTime() - self.failstart > 1 then self.failstart = nil; FadeOut(self) end
            return
        end
        if not self.casting and not self.channeling and not self.empowered then self:Hide(); return end

        self:SetValue(GetTime() * 1000, Enum.StatusBarInterpolation.ExponentialEaseOut)

        -- [ANIM] Spark
        if self._spark and db.showSpark then
            local startSec = self._realStartSec; local endSec = self._realEndSec
            if startSec and endSec and endSec > startSec then
                local now = GetTime()
                local pct = self.channeling and ((endSec-now)/(endSec-startSec)) or ((now-startSec)/(endSec-startSec))
                pct = math_max(0, math_min(pct, 1))
                SA.Update(self._spark, {
                    height=unitSettings.height, sparkStyle=db.sparkStyle,
                    sparkGlowAlpha=db.sparkGlowAlpha or 0.7, sparkTailAlpha=db.sparkTailAlpha or 0.6,
                }, pct, self:GetWidth(), elapsed)
            else SA.HideAll(self._spark) end
        end

        -- [PERF] Timer throttlé
        self._timerElapsed = self._timerElapsed + elapsed
        if self._timerElapsed >= TIMER_UPDATE_FREQ then
            self._timerElapsed = 0
            if self.timerText and self.duration_obj then
                self.timerText:SetText(FormatTimer(self.duration_obj, self._realStartSec, db.timerFormat))
            end
        end

        -- Empowered overlays
        if self.empowered and self._stageBoundaries and self.numStages > 0 then
            local startSec = self._realStartSec; local endSec = self._realEndSec
            if startSec and endSec and endSec > startSec then
                local pct = math_max(0, math_min((GetTime()-startSec)/(endSec-startSec), 1))
                for stage = 1, self.numStages do
                    local overlay = self.stageOverlays[stage]
                    if overlay and overlay:IsShown() then
                        local lp = self._stageBoundaries[stage-1] or 0
                        local rp = self._stageBoundaries[stage]   or 1
                        if pct >= rp then overlay:SetAlpha(0.50)
                        elseif pct > lp then overlay:SetAlpha(0.15 + ((pct-lp)/(rp-lp))*0.35)
                        else overlay:SetAlpha(0) end
                    end
                end
            end
        end
    end)

    -- =====================
    -- EVENTS
    -- =====================
    local events = CreateFrame("Frame")
    events:RegisterUnitEvent("UNIT_SPELLCAST_START",             unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_STOP",              unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_FAILED",            unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED",       unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED",         unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START",     unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP",      unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE",    unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE",     unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START",     unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP",      unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE",    unitID)
    events:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED",           unitID)
    -- [v3.1] Événements d'apparition de l'unité → recheck d'un cast déjà en cours
    if unitID == "target" then
        events:RegisterEvent("PLAYER_TARGET_CHANGED")
    elseif unitID == "focus" then
        events:RegisterEvent("PLAYER_FOCUS_CHANGED")
    elseif unitID:sub(1, 4) == "boss" then
        events:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
        events:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", unitID)
    elseif unitID:sub(1, 5) == "arena" then
        events:RegisterEvent("ARENA_OPPONENT_UPDATE")
    end
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- [LSM] Callback global : on re-résout la texture si un autre addon change le global
    if LSM then
        LSM.RegisterCallback(castbar, "LibSharedMedia_SetGlobal", function(_, mediaType)
            if mediaType == "statusbar" then
                castbar:SetStatusBarTexture(CB.ResolveBarTexture(db))
            end
        end)
    end

    events:SetScript("OnEvent", function(self, event, eventUnit, _, _, interrupterGUID)
        if castbar._preview then return end
        if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_ENTERING_WORLD"
            or event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" or event == "ARENA_OPPONENT_UPDATE" or event == "UNIT_TARGETABLE_CHANGED" then
            castbar.failstart = nil; CheckCast(castbar, false); return
        end
        if eventUnit ~= unit then return end
        if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_EMPOWER_START" then
            castbar.failstart = nil; CheckCast(castbar, false)
        elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" or event == "UNIT_SPELLCAST_EMPOWER_UPDATE" then
            if castbar.channeling or castbar.empowered then CheckCast(castbar, false) end
        elseif event == "UNIT_SPELLCAST_DELAYED" then
            if castbar.casting then CheckCast(castbar, false) end
        elseif event == "UNIT_SPELLCAST_INTERRUPTIBLE" or event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" then
            if castbar.casting or castbar.channeling or castbar.empowered then CheckCast(castbar, false) end
        elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
            CheckCast(castbar, true, interrupterGUID)
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            if castbar.channeling or castbar.empowered then return end
            FadeOut(castbar)
        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED"
            or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_EMPOWER_STOP" then
            if not castbar.failstart then FadeOut(castbar) end
        end
    end)

    castbar.eventFrame = events
    castbar:EnableMouse(false)
    CB.castbars[unitID] = castbar
    return castbar
end

-- =====================================
-- [v3.1] GROUPES BOSS / ARENA
-- Une ancre commune (frame déplaçable) + N barres empilées (boss1..5 / arena1..5).
-- =====================================
function CB.CreateUnitGroup(groupKey, prefix)
    local db = TomoCastbarDB
    local gs = db and db[groupKey]
    if not gs or not gs.enabled then return end

    -- Ancre (réutilisée entre les refresh)
    local anchor = CB.groupAnchors[groupKey]
    if not anchor then
        anchor = CreateFrame("Frame", "TomoCastbar_" .. groupKey .. "Anchor", UIParent)
        CB.groupAnchors[groupKey] = anchor
    end
    anchor:SetSize(gs.width, gs.height)
    anchor:SetMovable(true)
    anchor:SetClampedToScreen(true)
    local pos = gs.position or { point = "CENTER", relativePoint = "CENTER", x = 0, y = 0 }
    anchor:ClearAllPoints()
    anchor:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    anchor:Show()

    -- Barres membres
    anchor._bars = {}
    local count = math_min(gs.numBars or 5, 5)
    local prev  = nil
    for i = 1, count do
        local bar = CB.CreateCastbar(groupKey, {
            unitID      = prefix .. i,
            settings    = gs,
            anchorFrame = anchor,
            index       = i,
            prevBar     = prev,
            growth      = gs.growth or "DOWN",
            spacing     = gs.spacing or 4,
        })
        if bar then anchor._bars[i] = bar; prev = bar end
    end

    -- Preview Layout Mode : on relaie sur toutes les barres membres
    anchor.ShowPreview = function()
        for _, b in ipairs(anchor._bars) do if b.ShowPreview then b:ShowPreview() end end
    end
    anchor.HidePreview = function()
        for _, b in ipairs(anchor._bars) do if b.HidePreview then b:HidePreview() end end
    end
end

-- [v3.1] Cibles du Layout Mode : player/target/focus (castbars) + boss/arena (ancres).
function CB.GetMoverTargets()
    local db  = TomoCastbarDB
    local Loc = TomoCastbar_L
    local out = {}
    local function label(key, fallback) return (Loc and Loc[key]) or fallback end

    for _, u in ipairs({ "player", "target", "focus" }) do
        local cb = CB.castbars[u]
        if cb and db[u] and db[u].enabled then
            out[#out + 1] = { key = u, frame = cb, label = label("CAT_" .. u:upper(), u) }
        end
    end
    if db.boss and db.boss.enabled and CB.groupAnchors.boss then
        out[#out + 1] = { key = "boss", frame = CB.groupAnchors.boss, label = label("CAT_BOSS", "Boss") }
    end
    if db.arena and db.arena.enabled and CB.groupAnchors.arena then
        out[#out + 1] = { key = "arena", frame = CB.groupAnchors.arena, label = label("CAT_ARENA", "Arena") }
    end
    return out
end

-- =====================================
-- INITIALISATION
-- =====================================
function CB.Initialize()
    local db = TomoCastbarDB
    if not db then return end
    if db.hideBlizzardCastbar then CB.HideBlizzardCastbar() end
    for _, unit in ipairs({ "player", "target", "focus" }) do
        if db[unit] and db[unit].enabled then CB.CreateCastbar(unit) end
    end
    -- [v3.1] Groupes boss / arena (n'apparaissent qu'en encounter / arène)
    CB.CreateUnitGroup("boss", "boss")
    CB.CreateUnitGroup("arena", "arena")
    -- [v3.0] GCD Spark
    if db.showGCDSpark then CB.CreateGCDSpark() end
end

-- =====================================
-- [v3.0] GCD SPARK — Mini-barre sous la player castbar
-- =====================================

function CB.CreateGCDSpark()
    local db = TomoCastbarDB
    if not db or not db.player or not db.player.enabled then return end
    if CB._gcdBar then return end

    local playerBar = CB.castbars["player"]
    local unitS     = db.player
    local gcdH      = db.gcdHeight or 4
    local tex       = CB.ResolveBarTexture(db)

    local gcd = CreateFrame("StatusBar", "TomoCastbar_GCD", UIParent)
    gcd:SetSize(unitS.width, gcdH)
    gcd:SetStatusBarTexture(tex)
    gcd:GetStatusBarTexture():SetHorizTile(false)
    gcd:SetMinMaxValues(0, 1)
    gcd:SetValue(0)
    gcd:SetFrameStrata("MEDIUM")

    local col = db.gcdColor or { r = 1, g = 1, b = 1 }
    gcd:SetStatusBarColor(col.r, col.g, col.b, 0.6)

    -- Fond
    local bg = gcd:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.5)

    -- Spark minimaliste
    local spark = gcd:CreateTexture(nil, "OVERLAY")
    spark:SetSize(2, gcdH * 1.6)
    spark:SetColorTexture(1, 1, 1, 0.8)
    spark:Hide()
    gcd._spark = spark

    -- Positionnement : toujours ancré sous la player castbar
    local function AnchorGCD()
        gcd:ClearAllPoints()
        local bar = CB.castbars["player"]
        if bar then
            gcd:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -2)
            gcd:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", 0, -2)
        else
            local pos = unitS.position or { point = "CENTER", relativePoint = "CENTER", x = 0, y = 0 }
            gcd:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y - unitS.height - 4)
        end
    end
    AnchorGCD()
    gcd.AnchorGCD = AnchorGCD

    -- État
    gcd._gcdStart = 0
    gcd._gcdDur   = 0
    gcd._active   = false

    gcd:SetScript("OnUpdate", function(self, elapsed)
        if not self._active then return end
        local now = GetTime()
        local elapsed_t = now - self._gcdStart
        if elapsed_t >= self._gcdDur then
            self._active = false
            self:SetValue(0)
            self._spark:Hide()
            self:Hide()
            return
        end
        local pct = elapsed_t / self._gcdDur
        self:SetValue(pct)
        self._spark:ClearAllPoints()
        self._spark:SetPoint("CENTER", self, "LEFT", self:GetWidth() * pct, 0)
        self._spark:Show()
    end)

    -- Events
    local evFrame = CreateFrame("Frame")
    evFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    evFrame:SetScript("OnEvent", function()
        local ok, cdInfo = pcall(C_Spell.GetSpellCooldown, 61304)
        if ok and cdInfo and cdInfo.duration and cdInfo.duration > 0 and cdInfo.duration <= 2.0 then
            gcd._gcdStart = cdInfo.startTime
            gcd._gcdDur   = cdInfo.duration
            gcd._active   = true
            gcd:SetMinMaxValues(0, 1)
            gcd:Show()
        end
    end)

    gcd:EnableMouse(false)
    gcd:Hide()
    CB._gcdBar = gcd
end

-- =====================================
-- BLIZZARD CASTBAR
-- =====================================
local BLIZZARD_CASTBAR_FRAMES = {
    "PlayerCastingBarFrame","PetCastingBarFrame","TargetFrameSpellBar","FocusFrameSpellBar",
}
local function KillFrame(frame)
    if not frame then return end
    frame:UnregisterAllEvents(); frame:Hide()
    frame:SetScript("OnShow", function(self) self:Hide() end)
    if frame.Icon then frame.Icon:Hide() end; if frame.Border then frame.Border:Hide() end
    if frame.BorderShield then frame.BorderShield:Hide() end
    if frame.Flash then frame.Flash:Hide() end; if frame.Spark then frame.Spark:Hide() end
    if frame.Text then frame.Text:Hide() end
end
local function RestoreFrame(frame)
    if not frame then return end
    frame:SetScript("OnShow", nil); frame:Show()
    if frame.Icon then frame.Icon:Show() end; if frame.Border then frame.Border:Show() end
    if frame.Text then frame.Text:Show() end; if frame.Spark then frame.Spark:Show() end
end
function CB.HideBlizzardCastbar()
    for _, name in ipairs(BLIZZARD_CASTBAR_FRAMES) do KillFrame(_G[name]) end
end
function CB.ShowBlizzardCastbar()
    for _, name in ipairs(BLIZZARD_CASTBAR_FRAMES) do RestoreFrame(_G[name]) end
end

-- =====================================
-- LOCK / UNLOCK
-- =====================================
function CB.ToggleLock()
    local anyUnlocked = false
    for _, cb in pairs(CB.castbars) do if not cb:IsLocked() then anyUnlocked=true; break end end
    if anyUnlocked then
        for _, cb in pairs(CB.castbars) do cb:SetLocked(true); cb:HidePreview() end
        print("|cffd1b559TomoCastbar|r " .. L["CASTBARS_LOCKED"])
    else
        for _, cb in pairs(CB.castbars) do cb:SetLocked(false); cb:ShowPreview() end
        print("|cffd1b559TomoCastbar|r " .. L["CASTBARS_UNLOCKED"])
    end
end

-- =====================================
-- REFRESH ALL
-- =====================================
function CB.RefreshAll()
    for unit, cb in pairs(CB.castbars) do
        if cb.eventFrame then
            if LSM and LSM.UnregisterCallback then LSM.UnregisterCallback(cb, "LibSharedMedia_SetGlobal") end
            cb.eventFrame:UnregisterAllEvents(); cb.eventFrame:SetScript("OnEvent", nil)
        end
        -- [v3.1] detach sans reparent nil (evite un crash moteur sur Midnight)
        cb:SetScript("OnUpdate", nil); cb:Hide(); cb:ClearAllPoints()
    end
    wipe(CB.castbars)
    -- [v3.1] Ancres de groupe : masquées et vidées (re-peuplées par Initialize)
    if CB.groupAnchors then
        for _, anchor in pairs(CB.groupAnchors) do
            if anchor._bars then wipe(anchor._bars) end
            anchor:Hide(); anchor:ClearAllPoints()
        end
    end
    if CB._gcdBar then
        CB._gcdBar:SetScript("OnUpdate", nil)
        CB._gcdBar:Hide(); CB._gcdBar:ClearAllPoints()
        CB._gcdBar = nil
    end
    CB.Initialize()
end
