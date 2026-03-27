-- =====================================
-- Init.lua — v2.0 — Initialization & Slash Commands
-- =====================================

local addonName = ...
local mainFrame = CreateFrame("Frame")
local L = TomoCastbar_L

-- =====================================
-- SLASH COMMANDS
-- =====================================

SLASH_TOMOCASTBAR1 = "/tcb"
SLASH_TOMOCASTBAR2 = "/tomocastbar"
SlashCmdList["TOMOCASTBAR"] = function(msg)
    msg = string.lower(msg or "")

    -- Layout mode (principal : remplace /tcb lock)
    if msg == "layout" or msg == "l" then
        if TomoCastbar_Movers and TomoCastbar_Movers.Toggle then
            TomoCastbar_Movers.Toggle()
        end

    -- Alias rétrocompatibilité : /tcb lock → ouvre le layout mode
    elseif msg == "lock" then
        if TomoCastbar_Movers and TomoCastbar_Movers.Toggle then
            TomoCastbar_Movers.Toggle()
        end

    elseif msg == "reset" then
        TomoCastbar_ResetDatabase()
        TomoCastbar_Module.RefreshAll()
        print("|cffd1b559TomoCastbar|r " .. L["ALL_RESET"])

    elseif msg == "reset player" then
        TomoCastbar_ResetUnit("player")
        TomoCastbar_Module.RefreshAll()

    elseif msg == "reset target" then
        TomoCastbar_ResetUnit("target")
        TomoCastbar_Module.RefreshAll()

    elseif msg == "reset focus" then
        TomoCastbar_ResetUnit("focus")
        TomoCastbar_Module.RefreshAll()

    elseif msg == "" or msg == "config" or msg == "options" then
        if TomoCastbar_Config and TomoCastbar_Config.Toggle then
            TomoCastbar_Config.Toggle()
        end

    elseif msg == "help" then
        print("|cffd1b559TomoCastbar|r " .. L["HELP_HEADER"])
        print(L["HELP_CONFIG"])
        print(L["HELP_LAYOUT"])
        print(L["HELP_RESET"])
        print(L["HELP_RESET_PLAYER"])
        print(L["HELP_RESET_TARGET"])
        print(L["HELP_RESET_FOCUS"])
        print(L["HELP_HELP"])
    else
        print("|cffd1b559TomoCastbar|r " .. L["UNKNOWN_COMMAND"])
    end
end

-- =====================================
-- ADDON_LOADED / PLAYER_LOGIN
-- =====================================

mainFrame:RegisterEvent("ADDON_LOADED")
mainFrame:RegisterEvent("PLAYER_LOGIN")

mainFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        TomoCastbar_InitDatabase()

    elseif event == "PLAYER_LOGIN" then
        -- 1. Castbars
        if TomoCastbar_Module and TomoCastbar_Module.Initialize then
            TomoCastbar_Module.Initialize()
        end

        -- 2. Layout manager (movers + header + grid)
        if TomoCastbar_Movers and TomoCastbar_Movers.Initialize then
            TomoCastbar_Movers.Initialize()
        end

        print("|cffd1b559TomoCastbar|r " .. L["ADDON_LOADED"])

        self:UnregisterEvent("ADDON_LOADED")
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)
