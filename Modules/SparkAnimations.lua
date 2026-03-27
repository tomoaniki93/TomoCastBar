-- =====================================
-- SparkAnimations.lua — v2.0
-- 4 spark animation styles for TomoCastbar
--
-- Styles :
--   Comet    — queue de comète classique (défaut)
--   Pulse    — anneaux expansifs / ripple
--   Helix    — vague sinusoïdale
--   Glitch   — glitch RGB chromatic aberration
-- =====================================

TomoCastbar_Spark = TomoCastbar_Spark or {}
local SA = TomoCastbar_Spark

-- =====================================
-- UPVALUES
-- =====================================
local GetTime   = GetTime
local math_sin  = math.sin
local math_cos  = math.cos
local math_abs  = math.abs
local math_max  = math.max
local math_min  = math.min
local math_pi   = math.pi
local math_random = math.random
local math_fmod = math.fmod

-- =====================================
-- UTILITIES
-- =====================================

local function Clamp(v, lo, hi)
    if v < lo then return lo elseif v > hi then return hi else return v end
end

local function SafeNum(v, default)
    if type(v) ~= "number" or v ~= v or math_abs(v) == math.huge then
        return default
    end
    return v
end

-- =====================================
-- REGISTRE DES STYLES
-- =====================================
SA.Styles = {}

-- =====================================
-- STYLE 1 : COMET (défaut)
-- Queue de comète derrière le spark head.
-- Simple, propre, performant.
-- =====================================
SA.Styles["Comet"] = function(spark, db, progress, barWidth, elapsed)
    local head = spark.head
    local glow = spark.glow
    local tails = spark.tails

    if not head then return end

    local xPos = barWidth * progress

    -- Head
    head:ClearAllPoints()
    head:SetPoint("CENTER", spark.bar, "LEFT", xPos, 0)
    head:Show()

    -- Glow pulse
    if glow then
        glow:ClearAllPoints()
        glow:SetPoint("CENTER", head, "CENTER", 0, 0)
        local pulse = 0.6 + 0.4 * math_sin(GetTime() * 6)
        glow:SetAlpha(Clamp(db.sparkGlowAlpha * pulse, 0, 1))
        glow:Show()
    end

    -- Tails : trail derrière, décalé en x
    local positions = { 0.06, 0.13, 0.21, 0.32 }
    for i, tail in ipairs(tails) do
        local trailX = -(positions[i] * barWidth)
        local clampedX = math_max(trailX, -xPos)
        tail:ClearAllPoints()
        tail:SetPoint("CENTER", head, "CENTER", clampedX, 0)
        local alpha = db.sparkTailAlpha * (1 - (i - 1) * 0.22)
        tail:SetAlpha(Clamp(alpha, 0, 1))
        tail:Show()
    end
end

-- =====================================
-- STYLE 2 : PULSE
-- Anneaux concentriques expansifs (ripple).
-- =====================================
SA.Styles["Pulse"] = function(spark, db, progress, barWidth, elapsed)
    local head = spark.head
    local glow = spark.glow
    local tails = spark.tails

    if not head then return end

    local xPos = barWidth * progress
    local now  = GetTime()
    local h    = db.height or 20

    -- Head reste fixe sur le leading edge
    head:ClearAllPoints()
    head:SetPoint("CENTER", spark.bar, "LEFT", xPos, 0)
    head:Show()

    -- Glow discret
    if glow then
        glow:ClearAllPoints()
        glow:SetPoint("CENTER", head, "CENTER", 0, 0)
        glow:SetAlpha(Clamp(db.sparkGlowAlpha * 0.5, 0, 1))
        glow:Show()
    end

    -- Tails = anneaux expansifs
    local cycleDur = 0.7  -- durée d'un cycle ripple en secondes
    for i, tail in ipairs(tails) do
        local offset  = (i - 1) * (cycleDur / #tails)
        local t       = math_fmod(now + offset, cycleDur) / cycleDur  -- 0 → 1
        local scale   = 0.2 + t * 2.2
        local size    = h * scale
        local alpha   = Clamp(db.sparkTailAlpha * (1 - t * t), 0, 1)

        tail:ClearAllPoints()
        tail:SetPoint("CENTER", head, "CENTER", 0, 0)
        tail:SetSize(size, size)
        tail:SetAlpha(alpha)
        tail:Show()
    end
end

-- =====================================
-- STYLE 3 : HELIX
-- Queues qui oscillent verticalement en vague sinusoïdale.
-- =====================================
SA.Styles["Helix"] = function(spark, db, progress, barWidth, elapsed)
    local head = spark.head
    local glow = spark.glow
    local tails = spark.tails

    if not head then return end

    local xPos    = barWidth * progress
    local now     = GetTime()
    local h       = db.height or 20
    local amp     = h * 0.5     -- amplitude verticale
    local speed   = 7           -- vitesse de l'onde

    -- Head
    head:ClearAllPoints()
    head:SetPoint("CENTER", spark.bar, "LEFT", xPos, 0)
    head:Show()

    -- Glow
    if glow then
        glow:ClearAllPoints()
        glow:SetPoint("CENTER", head, "CENTER", 0, 0)
        local pulse = 0.5 + 0.5 * math_sin(now * 4)
        glow:SetAlpha(Clamp(db.sparkGlowAlpha * pulse, 0, 1))
        glow:Show()
    end

    -- Tails : décalages x et y sinusoïdaux, alternés
    local xOffsets = { -12, -24, -38, -56 }
    local phases   = { 0, math_pi / 2, math_pi, math_pi * 1.5 }

    for i, tail in ipairs(tails) do
        local trailX  = xOffsets[i]
        local clampedX = math_max(trailX, -xPos)
        local yOff    = amp * math_sin(now * speed + phases[i])
        local alpha   = db.sparkTailAlpha * (1 - (i - 1) * 0.2)

        tail:ClearAllPoints()
        tail:SetPoint("CENTER", head, "CENTER", clampedX, yOff)
        tail:SetAlpha(Clamp(alpha, 0, 1))
        tail:Show()
    end
end

-- =====================================
-- STYLE 4 : GLITCH
-- Aberration chromatique RGB aléatoire.
-- Crée un effet de décalage numérique.
-- =====================================
SA.Styles["Glitch"] = function(spark, db, progress, barWidth, elapsed)
    local head = spark.head
    local glow = spark.glow
    local tails = spark.tails

    if not head then return end

    local xPos = barWidth * progress
    local now  = GetTime()

    -- Head caché (le glitch remplace l'aspect normal)
    head:ClearAllPoints()
    head:SetPoint("CENTER", spark.bar, "LEFT", xPos, 0)
    head:SetAlpha(0.3)
    head:Show()

    if glow then glow:Hide() end

    -- Tails = couches RVB décalées aléatoirement
    local colors = {
        { 1, 0.1, 0.1 },   -- rouge
        { 0.1, 0.8, 0.1 }, -- vert
        { 0.1, 0.1, 1 },   -- bleu
        { 1, 1, 1 },        -- blanc
    }
    local glitchChance = 0.4  -- 40% de frames avec glitch actif

    for i, tail in ipairs(tails) do
        if math_random() < glitchChance then
            local ox = math_random(-8, 8)
            local oy = math_random(-3, 3)
            local col = colors[i] or colors[1]

            tail:ClearAllPoints()
            tail:SetPoint("CENTER", head, "CENTER", ox, oy)
            tail:SetVertexColor(col[1], col[2], col[3], 1)
            local alpha = db.sparkTailAlpha * (0.4 + math_random() * 0.5)
            tail:SetAlpha(Clamp(alpha, 0, 1))
            tail:Show()
        else
            tail:Hide()
        end
    end
end

-- =====================================
-- DISPATCH : Run la bonne animation
-- =====================================

function SA.Update(spark, db, progress, barWidth, elapsed)
    if not spark or not spark.bar then return end

    -- Hors plage : tout masquer
    if progress <= 0.001 or progress >= 0.999 then
        SA.HideAll(spark)
        return
    end

    local style = db.sparkStyle or "Comet"
    local fn = SA.Styles[style]
    if not fn then fn = SA.Styles["Comet"] end

    local ok, err = pcall(fn, spark, db, progress, barWidth, elapsed)
    if not ok then
        -- Fallback silencieux sur Comet
        pcall(SA.Styles["Comet"], spark, db, progress, barWidth, elapsed)
    end
end

-- =====================================
-- HIDE ALL spark elements
-- =====================================

function SA.HideAll(spark)
    if not spark then return end
    if spark.head  then spark.head:Hide()  end
    if spark.glow  then spark.glow:Hide()  end
    if spark.tails then
        for _, t in ipairs(spark.tails) do
            t:Hide()
        end
    end
end

-- =====================================
-- CRÉER LES TEXTURES DU SPARK
-- Appelé une seule fois par castbar dans CB.CreateCastbar
-- =====================================

function SA.CreateSparkTextures(castbar, db)
    local spark = {}
    spark.bar = castbar

    local h = db.height or 20

    -- Head : texture principale au leading edge
    local head = castbar:CreateTexture(nil, "OVERLAY", nil, 5)
    head:SetTexture(db.customSparkPath)
    head:SetSize(14, h * 1.4)
    head:SetBlendMode("ADD")
    head:SetAlpha(0.95)
    head:Hide()
    spark.head = head

    -- Glow : halo doux autour du head
    local glow = castbar:CreateTexture(nil, "OVERLAY", nil, 4)
    glow:SetTexture("Interface\\CastingBar\\UI-CastingBar-Pushback")
    glow:SetSize(h * 3.5, h * 2.2)
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0)
    glow:Hide()
    spark.glow = glow

    -- 4 tails mutualisées pour tous les styles
    -- Chaque style les repositionne et re-dimensionne selon ses besoins
    local tailTex    = db.customSparkPath
    local tailSizes  = {
        { 28, h * 1.2 },
        { 20, h * 0.9 },
        { 14, h * 0.7 },
        { 10, h * 0.5 },
    }

    spark.tails = {}
    for i = 1, 4 do
        local tail = castbar:CreateTexture(nil, "OVERLAY", nil, 3)
        -- Le style Pulse a besoin de textures rondes → on utilise WHITE8x8 overridable
        tail:SetTexture(tailTex)
        tail:SetSize(tailSizes[i][1], tailSizes[i][2])
        tail:SetBlendMode("ADD")
        tail:Hide()
        spark.tails[i] = tail
    end

    return spark
end

-- =====================================
-- RE-APPLIQUER LES COULEURS DU SPARK
-- (après changement de couleur en config)
-- =====================================

function SA.ApplyColors(spark, db)
    if not spark then return end
    local sc = db.sparkColor or { r=1, g=1, b=1 }
    local gc = db.sparkGlowColor or { r=0.8, g=0.6, b=1 }
    local tc = db.sparkTailColor or { r=0.9, g=0.7, b=0.3 }

    if spark.head then spark.head:SetVertexColor(sc.r, sc.g, sc.b, 1) end
    if spark.glow then spark.glow:SetVertexColor(gc.r, gc.g, gc.b, 1) end
    if spark.tails then
        for _, t in ipairs(spark.tails) do
            t:SetVertexColor(tc.r, tc.g, tc.b, 1)
        end
    end
end

-- =====================================
-- RE-DIMENSIONNER LES TAILS
-- (après changement de hauteur en config)
-- =====================================

function SA.ApplySizes(spark, db)
    if not spark then return end
    local h = db.height or 20
    local sizes = {
        { 28, h * 1.2 },
        { 20, h * 0.9 },
        { 14, h * 0.7 },
        { 10, h * 0.5 },
    }
    if spark.head then spark.head:SetSize(14, h * 1.4) end
    if spark.glow then spark.glow:SetSize(h * 3.5, h * 2.2) end
    if spark.tails then
        for i, t in ipairs(spark.tails) do
            if sizes[i] then t:SetSize(sizes[i][1], sizes[i][2]) end
        end
    end
end
