-- =====================================
-- enUS.lua — English locale v2.0
-- =====================================
TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

-- General
L["ADDON_LOADED"]           = "loaded. Type |cffd1b559/tcb|r to open config or |cffd1b559/tcb help|r for commands."
L["UNKNOWN_COMMAND"]        = "Unknown command. Type /tcb help for a list of commands."
L["ALL_RESET"]              = "All settings reset to defaults."
L["DB_RESET"]               = "Database reset to defaults."
L["UNIT_RESET"]             = "%s castbar reset to defaults."

-- Slash help
L["HELP_HEADER"]            = "Commands:"
L["HELP_CONFIG"]            = "  /tcb — Open config panel"
L["HELP_LOCK"]              = "  /tcb lock — Toggle Layout Mode (alias for /tcb layout)"
L["HELP_RESET"]             = "  /tcb reset — Reset all settings to defaults"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Reset player castbar"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Reset target castbar"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Reset focus castbar"
L["HELP_HELP"]              = "  /tcb help — Show this help"

-- Lock
L["CASTBARS_LOCKED"]        = "Castbars locked."
L["CASTBARS_UNLOCKED"]      = "Castbars unlocked — drag to reposition."
L["MOVE_LABEL"]             = "(Move)"

-- Castbar state
L["PREVIEW_CASTBAR"]        = "Castbar (%s)"
L["INTERRUPTED"]            = "Interrupted"

-- Config — frame
L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · toggle config  ·  /tcb lock · unlock castbars"
L["DB_NOT_INIT"]            = "Database not initialized yet."

-- Config — sidebar
L["CAT_GENERAL"]            = "General"
L["CAT_PLAYER"]             = "Player"
L["CAT_TARGET"]             = "Target"
L["CAT_FOCUS"]              = "Focus"

-- Config — section headers
L["HEADER_GENERAL"]         = "General"
L["HEADER_TEXTURES"]        = "Textures & Media"
L["HEADER_COLORS"]          = "Colors"
L["HEADER_SPARK"]           = "Spark Animation"
L["HEADER_ADVANCED"]        = "Advanced"
L["HEADER_UNIT_CASTBAR"]    = "%s Castbar"

-- Config — sub labels
L["SUBLABEL_FONTSIZE"]      = "Font Size"
L["SUBLABEL_DIMENSIONS"]    = "Dimensions"
L["SUBLABEL_DISPLAY"]       = "Display"
L["SUBLABEL_POSITION"]      = "Position"

-- Config — checkboxes
L["HIDE_BLIZZARD"]          = "Hide Blizzard Castbar"
L["CUSTOM_BORDER"]          = "Custom Border"
L["SHOW_SPARK"]             = "Show Spark"
L["SHOW_CHANNEL_TICKS"]     = "Show Channel Ticks"
L["ENABLE"]                 = "Enable"
L["SHOW_ICON"]              = "Show Icon"
L["SHOW_TIMER"]             = "Show Timer"
L["SHOW_LATENCY"]           = "Show Latency"
L["USE_CLASS_COLOR"]        = "Class Color (Target/Focus)"

-- Config — dropdowns
L["BACKGROUND_MODE"]        = "Background"
L["BG_CUSTOM"]              = "Custom Texture"
L["BG_BLACK"]               = "Black"
L["BG_TRANSPARENT"]         = "Transparent"
L["BAR_TEXTURE"]            = "Bar Texture"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Smooth"
L["TEX_FLAT"]               = "Flat"

-- [LSM]
L["BAR_TEXTURE_LSM"]        = "Bar Texture (LibSharedMedia)"
L["FONT_LSM"]               = "Font (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia not loaded — using built-in textures."

-- [ANIM] Spark styles
L["SPARK_STYLE"]            = "Animation Style"
L["SPARK_COMET"]            = "Comet"
L["SPARK_PULSE"]            = "Pulse"
L["SPARK_HELIX"]            = "Helix"
L["SPARK_GLITCH"]           = "Glitch"
L["SPARK_GLOW_ALPHA"]       = "Glow Intensity"
L["SPARK_TAIL_ALPHA"]       = "Tail Intensity"
L["SPARK_COLOR_HEAD"]       = "Spark Head Color"
L["SPARK_COLOR_GLOW"]       = "Glow Color"
L["SPARK_COLOR_TAIL"]       = "Tail Color"

-- Timer format
L["TIMER_FORMAT"]           = "Timer Format"
L["TIMER_REMAINING"]        = "Remaining (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Remaining / Total (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Elapsed (1.5)"

-- Spell name truncation
L["SPELL_NAME_TRUNCATE"]    = "Spell Name Max Length"

-- Config — sliders
L["SLIDER_SPARK_HEIGHT"]    = "Spark Height"
L["SLIDER_FONTSIZE"]        = "Font Size"
L["SLIDER_WIDTH"]           = "Width"
L["SLIDER_HEIGHT"]          = "Height"

-- Config — color pickers
L["COLOR_CAST"]             = "Cast Color"
L["COLOR_NI"]               = "Non-Interruptible Color"
L["COLOR_INTERRUPTED"]      = "Interrupted Color"

-- Config — buttons
L["RESET_ALL"]              = "Reset All to Defaults"
L["RESET_POSITION"]         = "Reset %s Position"

-- Config — info
L["INFO_DRAG"]              = "Use /tcb lock to unlock castbars and drag them to reposition."
L["POSITION_RESET"]         = "%s position reset."

-- Layout / Mover system (v2.0)
L["HELP_LAYOUT"]            = "  /tcb layout — Toggle Layout Mode (drag castbars to reposition)"
L["layout_mode_title"]      = "TomoCastbar — Layout Mode"
L["layout_mode_hint"]       = "Drag castbars to reposition — click Lock when done"
L["layout_btn_lock"]        = "Lock"
L["layout_btn_reload"]      = "RL"
L["layout_unlocked"]        = "Layout Mode ON — drag castbars to reposition. Click Lock when done."
L["layout_locked"]          = "Layout Mode OFF — positions saved."
L["grid_dimmed"]            = "Grid"
L["grid_bright"]            = "Grid +"
L["grid_disabled"]          = "Grid OFF"
L["mover_player"]           = "Player Castbar"
L["mover_target"]           = "Target Castbar"
L["mover_focus"]            = "Focus Castbar"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Layout Mode — drag castbars to reposition"
L["btn_reload_ui"]               = "Reload UI"
L["INFO_DRAG_LAYOUT"]            = "Use the Layout button above (or /tcb layout) to drag castbars."
