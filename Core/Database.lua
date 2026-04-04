-- =====================================
-- Database.lua — v2.0 — Defaults & DB Management
-- =====================================

local DEFAULT_FONT    = "Fonts\\FRIZQT__.TTF"
local DEFAULT_TEXTURE = "Interface\\TargetingFrame\\UI-StatusBar"
local ADDON_PATH      = "Interface\\AddOns\\TomoCastbar\\Assets\\Textures\\"

TomoCastbar_Defaults = {
    -- Globaux
    texture   = DEFAULT_TEXTURE,
    font      = DEFAULT_FONT,
    fontSize  = 12,

    -- [LSM] LibSharedMedia — noms de médias (vide = non-LSM)
    barTextureLSM = "Blizzard",       -- nom du statusbar dans LSM
    fontLSM       = "",               -- nom de la police dans LSM (vide = police par défaut)

    -- Textures (fallback si LSM non disponible)
    backgroundMode   = "custom",
    barTexture       = "blizzard",
    useCustomBorder  = true,
    showChannelTicks = true,

    -- Chemins des assets custom
    customBackgroundPath = ADDON_PATH .. "background",
    customBorderPath     = ADDON_PATH .. "border",
    customSparkPath      = ADDON_PATH .. "cast_spark",

    -- [ANIM] Spark
    showSpark      = true,
    sparkHeight    = 26,       -- gardé pour rétrocompatibilité (remplacé par height unit)
    sparkStyle     = "Comet",  -- "Comet" | "Pulse" | "Helix" | "Glitch"
    sparkGlowAlpha = 0.7,      -- intensité du glow
    sparkTailAlpha = 0.6,      -- intensité des queues

    -- [ANIM] Couleurs du spark (r/g/b)
    sparkColor     = { r = 1.0, g = 0.85, b = 0.5  },  -- tête : doré
    sparkGlowColor = { r = 0.8, g = 0.6,  b = 1.0  },  -- halo : violet
    sparkTailColor = { r = 1.0, g = 0.7,  b = 0.3  },  -- queue : orange

    -- Couleurs de barre
    castbarColor          = { r = 0.80, g = 0.10, b = 0.10 },
    castbarNIColor        = { r = 0.50, g = 0.50, b = 0.50 },
    castbarInterruptColor = { r = 0.10, g = 0.80, b = 0.10 },

    -- Options avancées
    timerFormat     = "remaining",  -- "remaining" | "remaining_total" | "elapsed"
    spellNameMaxLen = 0,            -- 0 = désactivé
    useClassColor   = false,

    -- Blizzard
    hideBlizzardCastbar = true,

    -- [v3.0] Transition Animations
    showTransitions = true,

    -- [v3.0] GCD Spark (joueur uniquement)
    showGCDSpark = true,
    gcdHeight    = 4,
    gcdColor     = { r = 1.0, g = 1.0, b = 1.0 },

    -- [v3.0] Couleur par école de magie (joueur uniquement)
    useSchoolColor = false,
    schoolColors   = {
        [1]  = { r = 0.80, g = 0.70, b = 0.50 },  -- Physical
        [2]  = { r = 1.00, g = 0.90, b = 0.50 },  -- Holy
        [4]  = { r = 1.00, g = 0.50, b = 0.10 },  -- Fire
        [8]  = { r = 0.30, g = 0.70, b = 0.20 },  -- Nature
        [16] = { r = 0.40, g = 0.80, b = 1.00 },  -- Frost
        [32] = { r = 0.50, g = 0.30, b = 0.80 },  -- Shadow
        [64] = { r = 0.70, g = 0.50, b = 1.00 },  -- Arcane
    },

    -- [v3.0] Interrupt Feedback (texte centre écran)
    showInterruptFeedback    = true,
    interruptFeedbackDuration = 1.5,
    interruptFeedbackColor   = { r = 0.10, g = 0.80, b = 0.10 },
    interruptFeedbackFontSize = 28,

    -- [v3.0] Profils (initialisés par TomoCastbar_Profiles.EnsureProfilesDB)
    _profiles = {},

    -- Par unité
    player = {
        enabled     = true,
        width       = 260,
        height      = 20,
        showIcon    = true,
        showTimer   = true,
        showLatency = true,
        iconSide    = "LEFT",
        position    = { point = "BOTTOM", relativePoint = "CENTER", x = -280, y = -220 },
    },
    target = {
        enabled     = true,
        width       = 260,
        height      = 20,
        showIcon    = true,
        showTimer   = true,
        showLatency = false,
        iconSide    = "LEFT",
        position    = { point = "BOTTOM", relativePoint = "CENTER", x = 280, y = -250 },
    },
    focus = {
        enabled     = true,
        width       = 200,
        height      = 16,
        showIcon    = true,
        showTimer   = true,
        showLatency = false,
        iconSide    = "LEFT",
        position    = { point = "CENTER", relativePoint = "CENTER", x = -350, y = 100 },
    },
}

function TomoCastbar_InitDatabase()
    if not TomoCastbarDB then TomoCastbarDB = {} end
    TomoCastbar_MergeTables(TomoCastbarDB, TomoCastbar_Defaults)
end

function TomoCastbar_ResetDatabase()
    TomoCastbarDB = CopyTable(TomoCastbar_Defaults)
    local L = TomoCastbar_L
    print("|cffd1b559TomoCastbar|r " .. L["DB_RESET"])
end

function TomoCastbar_ResetUnit(unitKey)
    if TomoCastbar_Defaults[unitKey] then
        TomoCastbarDB[unitKey] = CopyTable(TomoCastbar_Defaults[unitKey])
        local L = TomoCastbar_L
        print("|cffd1b559TomoCastbar|r " .. string.format(L["UNIT_RESET"], unitKey))
    end
end

-- =====================================
-- [v3.0] PROFILE MANAGEMENT
-- Architecture TomoMod :
--   TomoCastbarDB._profiles = {
--     named        = { ["Default"] = snapshot, ... },
--     profileOrder = { "Default", ... },
--     activeProfile  = "Default",
--     specProfiles   = { [specID] = "nomProfil" },
--   }
-- =====================================

TomoCastbar_Profiles = {}
local Prof = TomoCastbar_Profiles

local EXCLUDED_KEYS = { ["_profiles"] = true }

local function DeepCopy(src)
    if type(src) ~= "table" then return src end
    local copy = {}
    for k, v in pairs(src) do copy[k] = DeepCopy(v) end
    return copy
end

local function SnapshotSettings()
    local snap = {}
    for k, v in pairs(TomoCastbarDB) do
        if not EXCLUDED_KEYS[k] then snap[k] = DeepCopy(v) end
    end
    return snap
end

local function ApplySnapshot(snap)
    for k in pairs(TomoCastbarDB) do
        if not EXCLUDED_KEYS[k] then TomoCastbarDB[k] = nil end
    end
    for k, v in pairs(snap) do
        if not EXCLUDED_KEYS[k] then TomoCastbarDB[k] = DeepCopy(v) end
    end
    TomoCastbar_MergeTables(TomoCastbarDB, TomoCastbar_Defaults)
end

function Prof.EnsureProfilesDB()
    if not TomoCastbarDB._profiles then TomoCastbarDB._profiles = {} end
    local db = TomoCastbarDB._profiles
    if not db.named        then db.named        = {} end
    if not db.profileOrder then db.profileOrder = {} end
    if not db.specProfiles then db.specProfiles = {} end
    if not db.activeProfile then db.activeProfile = "Default" end
    if not db.named["Default"] then
        db.named["Default"] = SnapshotSettings()
    end
    local hasDefault = false
    for _, n in ipairs(db.profileOrder) do
        if n == "Default" then hasDefault = true; break end
    end
    if not hasDefault then table.insert(db.profileOrder, 1, "Default") end
    -- Sync : tout profil dans named doit être dans profileOrder
    local inOrder = {}
    for _, n in ipairs(db.profileOrder) do inOrder[n] = true end
    for name in pairs(db.named) do
        if not inOrder[name] then table.insert(db.profileOrder, name) end
    end
end

function Prof.GetActiveProfileName()
    Prof.EnsureProfilesDB()
    return TomoCastbarDB._profiles.activeProfile or "Default"
end

function Prof.GetProfileList()
    Prof.EnsureProfilesDB()
    return TomoCastbarDB._profiles.profileOrder, TomoCastbarDB._profiles.named
end

function Prof.AutoSaveActiveProfile()
    Prof.EnsureProfilesDB()
    local name = TomoCastbarDB._profiles.activeProfile or "Default"
    TomoCastbarDB._profiles.named[name] = SnapshotSettings()
end

function Prof.CreateNamedProfile(name)
    if not name or name:match("^%s*$") then return false end
    name = name:match("^%s*(.-)%s*$")
    Prof.EnsureProfilesDB()
    Prof.AutoSaveActiveProfile()
    local db = TomoCastbarDB._profiles
    db.named[name] = SnapshotSettings()
    local found = false
    for _, n in ipairs(db.profileOrder) do
        if n == name then found = true; break end
    end
    if not found then table.insert(db.profileOrder, 2, name) end
    db.activeProfile = name
    return true
end

function Prof.LoadNamedProfile(name)
    Prof.EnsureProfilesDB()
    local db = TomoCastbarDB._profiles
    local snap = db.named[name]
    if not snap then return false end
    Prof.AutoSaveActiveProfile()
    ApplySnapshot(snap)
    db.activeProfile = name
    return true
end

function Prof.DeleteNamedProfile(name)
    if name == "Default" then return false end
    Prof.EnsureProfilesDB()
    local db = TomoCastbarDB._profiles
    db.named[name] = nil
    for i, n in ipairs(db.profileOrder) do
        if n == name then table.remove(db.profileOrder, i); break end
    end
    for specID, pName in pairs(db.specProfiles) do
        if pName == name then db.specProfiles[specID] = nil end
    end
    if db.activeProfile == name then db.activeProfile = "Default" end
    return true
end

function Prof.DuplicateProfile(fromName, toName)
    if not toName or toName:match("^%s*$") then return false end
    toName = toName:match("^%s*(.-)%s*$")
    Prof.EnsureProfilesDB()
    local db = TomoCastbarDB._profiles
    local snap = db.named[fromName]
    if not snap or db.named[toName] then return false end
    db.named[toName] = DeepCopy(snap)
    local found = false
    for i, n in ipairs(db.profileOrder) do
        if n == fromName then table.insert(db.profileOrder, i + 1, toName); found = true; break end
    end
    if not found then table.insert(db.profileOrder, toName) end
    return true
end

-- === Spec → Profil nommé ===

function Prof.GetCurrentSpecID()
    local idx = GetSpecialization and GetSpecialization()
    if not idx then return 0 end
    local id = GetSpecializationInfo(idx)
    return id or 0
end

function Prof.AssignSpecToProfile(specID, profileName)
    Prof.EnsureProfilesDB()
    local db = TomoCastbarDB._profiles
    if not db.named[profileName] then return false end
    db.specProfiles[specID] = profileName
    return true
end

function Prof.UnassignSpec(specID)
    Prof.EnsureProfilesDB()
    TomoCastbarDB._profiles.specProfiles[specID] = nil
end

function Prof.GetSpecAssignedProfile(specID)
    Prof.EnsureProfilesDB()
    return TomoCastbarDB._profiles.specProfiles[specID]
end

function Prof.IsSpecProfilesEnabled()
    Prof.EnsureProfilesDB()
    for _ in pairs(TomoCastbarDB._profiles.specProfiles) do return true end
    return false
end

function Prof.OnSpecChanged(newSpecID)
    Prof.EnsureProfilesDB()
    if not Prof.IsSpecProfilesEnabled() then return false end
    if not newSpecID or newSpecID == 0 then return false end
    local targetName = Prof.GetSpecAssignedProfile(newSpecID)
    if not targetName then return false end
    local currentName = Prof.GetActiveProfileName()
    if currentName == targetName then return false end
    Prof.AutoSaveActiveProfile()
    local db = TomoCastbarDB._profiles
    local snap = db.named[targetName]
    if snap then
        ApplySnapshot(snap)
        db.activeProfile = targetName
        return true
    end
    return false
end

function Prof.InitSpecTracking()
    Prof._lastSpecID = Prof.GetCurrentSpecID()
end
