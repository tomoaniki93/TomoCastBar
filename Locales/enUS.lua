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
L["USE_CLASS_COLOR"]        = "Use Class Color"

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

-- [v3.0] Transitions
L["SHOW_TRANSITIONS"]            = "Cast Transition Animations"

-- [v3.0] GCD Spark
L["SHOW_GCD_SPARK"]              = "Show GCD Spark"
L["GCD_HEIGHT"]                  = "GCD Bar Height"
L["GCD_COLOR"]                   = "GCD Color"

-- [v3.0] School Colors
L["USE_SCHOOL_COLOR"]            = "Spell School Colors (Player)"
L["SCHOOL_PHYSICAL"]             = "Physical"
L["SCHOOL_HOLY"]                 = "Holy"
L["SCHOOL_FIRE"]                 = "Fire"
L["SCHOOL_NATURE"]               = "Nature"
L["SCHOOL_FROST"]                = "Frost"
L["SCHOOL_SHADOW"]               = "Shadow"
L["SCHOOL_ARCANE"]               = "Arcane"

-- [v3.0] Icon Side
L["ICON_SIDE"]                   = "Icon Position"
L["ICON_LEFT"]                   = "Left"
L["ICON_RIGHT"]                  = "Right"

-- [v3.0] Interrupt Feedback
L["SHOW_INTERRUPT_FEEDBACK"]     = "Interrupt Feedback Text"
L["INTERRUPT_FEEDBACK_DURATION"] = "Display Duration"
L["INTERRUPT_FEEDBACK_COLOR"]    = "Feedback Color"
L["INTERRUPT_FEEDBACK_FONTSIZE"] = "Feedback Font Size"
L["INTERRUPT_FEEDBACK_TEXT"]     = "Interrupted!"
L["INTERRUPT_FEEDBACK_FULL"]     = "Interrupted! %s"

-- [v3.0] Profiles
L["PROFILE_ENABLED"]             = "Spec Profiles enabled. Current spec: %d"
L["PROFILE_DISABLED"]            = "Spec Profiles disabled. Using global settings."
L["PROFILE_SWITCHED"]            = "Switched to profile: %s"
L["PROFILE_COPIED"]              = "Current settings copied to spec %d."
L["PROFILE_STATUS"]              = "Spec Profiles: %s (active spec: %d)"
L["PROFILE_STATUS_ON"]           = "ON"
L["PROFILE_STATUS_OFF"]          = "OFF"
L["HELP_PROFILE"]                = "  /tcb profile — Show profile status"
L["HELP_PROFILE_TOGGLE"]         = "  /tcb profile on/off — Enable/disable spec profiles"
L["HELP_PROFILE_COPY"]           = "  /tcb profile copy <1-4> — Copy current settings to spec #"

-- =====================================
-- [v3.1] Boss / Arena groups + Profiles UI
-- =====================================
L["CAT_BOSS"]                   = "Boss"
L["CAT_ARENA"]                  = "Arena"
L["CAT_PROFILES"]               = "Profiles"
L["SUBLABEL_STACKING"]          = "Stacking"
L["SLIDER_NUMBARS"]             = "Number of Bars"
L["GROWTH_DIRECTION"]           = "Growth Direction"
L["GROWTH_UP"]                  = "Upward"
L["GROWTH_DOWN"]                = "Downward"
L["SLIDER_SPACING"]             = "Bar Spacing"
L["INFO_BOSS"]                  = "Boss castbars appear during encounters. Up to 5 stacked bars (boss1-boss5)."
L["INFO_ARENA"]                 = "Arena enemy castbars appear in arena matches. Up to 5 stacked bars (arena1-arena5)."
L["PROFILES_DESC"]              = "Profiles save your entire TomoCastbar configuration. Create named setups or auto-load one per specialization."
L["PROFILE_ACTIVE_LABEL"]       = "Active profile: %s"
L["PROFILE_SELECT"]             = "Selected Profile"
L["PROFILE_LOAD_BTN"]           = "Load Selected"
L["PROFILE_DELETE_BTN"]         = "Delete Selected"
L["HEADER_PROFILES_CREATE"]     = "Create / Duplicate"
L["PROFILE_NAME_FIELD"]         = "New Profile Name"
L["PROFILE_CREATE_BTN"]         = "Create New"
L["PROFILE_DUPLICATE_BTN"]      = "Duplicate Selected"
L["PROFILE_SPEC_HEADER"]        = "Spec Profiles (Auto-Switch)"
L["PROFILE_SPEC_INFO"]          = "Assign a profile to your current specialization. It loads automatically when you switch specs."
L["PROFILE_SPEC_CURRENT"]       = "Current spec: %s → %s"
L["PROFILE_SPEC_ASSIGN"]        = "Assign Current Spec To"
L["PROFILE_SPEC_CLEAR"]         = "Clear Spec Assignment"
L["PROFILE_NONE"]               = "(none)"
L["PROFILE_CREATED"]            = "Profile created: %s"
L["PROFILE_DELETED"]            = "Profile deleted: %s"
L["PROFILE_LOADED"]             = "Profile loaded: %s"
L["PROFILE_CANNOT_DELETE"]      = "Cannot delete the Default profile."
L["PROFILE_NAME_EMPTY"]         = "Please enter a profile name."
L["PROFILE_EXISTS"]             = "A profile with that name already exists."
L["PROFILE_SPEC_ASSIGNED"]      = "Spec assigned to profile: %s"
L["PROFILE_SPEC_UNASSIGNED"]    = "Spec assignment cleared."
