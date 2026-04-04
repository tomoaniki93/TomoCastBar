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

    -- [v3.0] Profile commands
    elseif msg:sub(1, 7) == "profile" then
        local sub = msg:sub(9) or ""
        local Prof = TomoCastbar_Profiles
        if not Prof then return end

        if sub == "" then
            -- Status
            Prof.EnsureProfilesDB()
            local active = Prof.GetActiveProfileName()
            local specEnabled = Prof.IsSpecProfilesEnabled()
            local status = specEnabled and L["PROFILE_STATUS_ON"] or L["PROFILE_STATUS_OFF"]
            local specID = Prof.GetCurrentSpecID()
            print("|cffd1b559TomoCastbar|r " .. string.format(L["PROFILE_STATUS"], status, specID))
            print("|cffd1b559TomoCastbar|r Active profile: |cffd1b559" .. active .. "|r")
            -- List profiles
            local order = TomoCastbarDB._profiles.profileOrder
            for _, name in ipairs(order) do
                local marker = (name == active) and " |cff00ff00◄|r" or ""
                print("  - " .. name .. marker)
            end

        elseif sub == "list" then
            Prof.EnsureProfilesDB()
            local order = TomoCastbarDB._profiles.profileOrder
            local active = Prof.GetActiveProfileName()
            for _, name in ipairs(order) do
                local marker = (name == active) and " |cff00ff00◄|r" or ""
                print("  - " .. name .. marker)
            end

        elseif sub:sub(1, 4) == "load" then
            local name = sub:sub(6)
            if name and name ~= "" then
                name = name:match("^%s*(.-)%s*$")
                if Prof.LoadNamedProfile(name) then
                    TomoCastbar_Module.RefreshAll()
                    print("|cffd1b559TomoCastbar|r Profile loaded: |cffd1b559" .. name .. "|r")
                else
                    print("|cffd1b559TomoCastbar|r Profile not found: " .. name)
                end
            end

        elseif sub:sub(1, 6) == "create" then
            local name = sub:sub(8)
            if name and name ~= "" then
                name = name:match("^%s*(.-)%s*$")
                if Prof.CreateNamedProfile(name) then
                    print("|cffd1b559TomoCastbar|r Profile created: |cffd1b559" .. name .. "|r")
                end
            end

        elseif sub:sub(1, 6) == "delete" then
            local name = sub:sub(8)
            if name and name ~= "" then
                name = name:match("^%s*(.-)%s*$")
                if Prof.DeleteNamedProfile(name) then
                    print("|cffd1b559TomoCastbar|r Profile deleted: " .. name)
                else
                    print("|cffd1b559TomoCastbar|r Cannot delete: " .. name)
                end
            end

        elseif sub:sub(1, 4) == "spec" then
            -- /tcb profile spec <specID> <profileName>
            local specID, profName = sub:match("spec%s+(%d+)%s+(.+)")
            if specID and profName then
                specID = tonumber(specID)
                profName = profName:match("^%s*(.-)%s*$")
                if Prof.AssignSpecToProfile(specID, profName) then
                    print("|cffd1b559TomoCastbar|r Spec " .. specID .. " → |cffd1b559" .. profName .. "|r")
                else
                    print("|cffd1b559TomoCastbar|r Profile not found: " .. profName)
                end
            else
                -- /tcb profile spec — show spec assignments
                Prof.EnsureProfilesDB()
                local numSpecs = GetNumSpecializations and GetNumSpecializations() or 0
                for i = 1, numSpecs do
                    local id, sName = GetSpecializationInfo(i)
                    if id then
                        local assigned = Prof.GetSpecAssignedProfile(id) or "|cff888888(none)|r"
                        print("  Spec " .. i .. " (" .. sName .. ") → " .. assigned)
                    end
                end
            end

        else
            print("|cffd1b559TomoCastbar|r " .. L["HELP_PROFILE"])
            print(L["HELP_PROFILE_TOGGLE"])
            print(L["HELP_PROFILE_COPY"])
        end

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
        print(L["HELP_PROFILE"])
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
mainFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

mainFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        TomoCastbar_InitDatabase()

        -- [v3.0] Initialiser les profils
        if TomoCastbar_Profiles then
            TomoCastbar_Profiles.EnsureProfilesDB()
        end

    elseif event == "PLAYER_LOGIN" then
        -- 1. Profils : tracking spec initial
        if TomoCastbar_Profiles then
            TomoCastbar_Profiles.InitSpecTracking()
        end

        -- 2. Castbars
        if TomoCastbar_Module and TomoCastbar_Module.Initialize then
            TomoCastbar_Module.Initialize()
        end

        -- 3. Layout manager (movers + header + grid)
        if TomoCastbar_Movers and TomoCastbar_Movers.Initialize then
            TomoCastbar_Movers.Initialize()
        end

        print("|cffd1b559TomoCastbar|r " .. L["ADDON_LOADED"])

        self:UnregisterEvent("ADDON_LOADED")

    elseif event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
        -- [v3.0] Auto-switch de profil par spécialisation
        if TomoCastbar_Profiles then
            local newSpecID = TomoCastbar_Profiles.GetCurrentSpecID()
            local switched = TomoCastbar_Profiles.OnSpecChanged(newSpecID)
            if switched then
                if TomoCastbar_Module and TomoCastbar_Module.RefreshAll then
                    TomoCastbar_Module.RefreshAll()
                end
                local L2 = TomoCastbar_L
                local name = TomoCastbar_Profiles.GetActiveProfileName()
                print("|cffd1b559TomoCastbar|r " .. string.format(L2["PROFILE_SWITCHED"], name))
            end
        end
    end
end)
