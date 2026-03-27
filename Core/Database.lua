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

    -- Par unité
    player = {
        enabled     = true,
        width       = 260,
        height      = 20,
        showIcon    = true,
        showTimer   = true,
        showLatency = true,
        position    = { point = "BOTTOM", relativePoint = "CENTER", x = -280, y = -220 },
    },
    target = {
        enabled     = true,
        width       = 260,
        height      = 20,
        showIcon    = true,
        showTimer   = true,
        showLatency = false,
        position    = { point = "BOTTOM", relativePoint = "CENTER", x = 280, y = -250 },
    },
    focus = {
        enabled     = true,
        width       = 200,
        height      = 16,
        showIcon    = true,
        showTimer   = true,
        showLatency = false,
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
