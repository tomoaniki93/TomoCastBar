-- =====================================
-- itIT.lua — Italiano (Italia) v2.0
-- =====================================
local addonLocale = GetLocale()
if addonLocale ~= "itIT" then return end

TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "caricato. Digita |cffd1b559/tcb|r per le impostazioni o |cffd1b559/tcb help|r per i comandi."
L["UNKNOWN_COMMAND"]        = "Comando sconosciuto. Digita /tcb help per la lista."
L["ALL_RESET"]              = "Tutte le impostazioni ripristinate."
L["DB_RESET"]               = "Database ripristinato."
L["UNIT_RESET"]             = "Barra %s ripristinata."

L["HELP_HEADER"]            = "Comandi:"
L["HELP_CONFIG"]            = "  /tcb — Apri configurazione"
L["HELP_LOCK"]              = "  /tcb lock — Blocca/sblocca le barre"
L["HELP_RESET"]             = "  /tcb reset — Ripristina tutte le impostazioni"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Ripristina barra giocatore"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Ripristina barra bersaglio"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Ripristina barra focus"
L["HELP_HELP"]              = "  /tcb help — Mostra questo aiuto"

L["HELP_LAYOUT"]            = "  /tcb layout — Attiva Modalità Layout (sposta le barre di lancio)"

L["CASTBARS_LOCKED"]        = "Barre bloccate."
L["CASTBARS_UNLOCKED"]      = "Barre sbloccate — trascina per riposizionare."
L["MOVE_LABEL"]             = "(Sposta)"
L["PREVIEW_CASTBAR"]        = "Anteprima (%s)"
L["INTERRUPTED"]            = "Interrotto"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · impostazioni  ·  /tcb lock · sblocca"
L["DB_NOT_INIT"]            = "Database non ancora inizializzato."

L["CAT_GENERAL"]            = "Generale"
L["CAT_PLAYER"]             = "Giocatore"
L["CAT_TARGET"]             = "Bersaglio"
L["CAT_FOCUS"]              = "Focus"

L["HEADER_GENERAL"]         = "Generale"
L["HEADER_TEXTURES"]        = "Texture e Media"
L["HEADER_COLORS"]          = "Colori"
L["HEADER_SPARK"]           = "Animazione scintilla"
L["HEADER_ADVANCED"]        = "Avanzato"
L["HEADER_UNIT_CASTBAR"]    = "Barra %s"

L["SUBLABEL_FONTSIZE"]      = "Dimensione carattere"
L["SUBLABEL_DIMENSIONS"]    = "Dimensioni"
L["SUBLABEL_DISPLAY"]       = "Visualizzazione"
L["SUBLABEL_POSITION"]      = "Posizione"

L["HIDE_BLIZZARD"]          = "Nascondi barra Blizzard"
L["CUSTOM_BORDER"]          = "Bordo personalizzato"
L["SHOW_SPARK"]             = "Mostra scintilla"
L["SHOW_CHANNEL_TICKS"]     = "Mostra tick canale"
L["ENABLE"]                 = "Attiva"
L["SHOW_ICON"]              = "Mostra icona"
L["SHOW_TIMER"]             = "Mostra timer"
L["SHOW_LATENCY"]           = "Mostra latenza"
L["USE_CLASS_COLOR"]        = "Colore classe"

L["BACKGROUND_MODE"]        = "Sfondo"
L["BG_CUSTOM"]              = "Texture personalizzata"
L["BG_BLACK"]               = "Nero"
L["BG_TRANSPARENT"]         = "Trasparente"
L["BAR_TEXTURE"]            = "Texture barra"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Morbido"
L["TEX_FLAT"]               = "Piatto"

L["BAR_TEXTURE_LSM"]        = "Texture barra (LibSharedMedia)"
L["FONT_LSM"]               = "Carattere (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia non caricato — uso texture integrate."

L["SPARK_STYLE"]            = "Stile animazione"
L["SPARK_COMET"]            = "Cometa"
L["SPARK_PULSE"]            = "Pulsazione"
L["SPARK_HELIX"]            = "Elica"
L["SPARK_GLITCH"]           = "Glitch"
L["SPARK_GLOW_ALPHA"]       = "Intensità bagliore"
L["SPARK_TAIL_ALPHA"]       = "Intensità scia"
L["SPARK_COLOR_HEAD"]       = "Colore testa scintilla"
L["SPARK_COLOR_GLOW"]       = "Colore bagliore"
L["SPARK_COLOR_TAIL"]       = "Colore scia"

L["TIMER_FORMAT"]           = "Formato timer"
L["TIMER_REMAINING"]        = "Rimanente (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Rimanente / Totale (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Trascorso (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "Lunghezza massima nome incantesimo"

L["SLIDER_SPARK_HEIGHT"]    = "Altezza scintilla"
L["SLIDER_FONTSIZE"]        = "Dimensione carattere"
L["SLIDER_WIDTH"]           = "Larghezza"
L["SLIDER_HEIGHT"]          = "Altezza"

L["COLOR_CAST"]             = "Colore lancio"
L["COLOR_NI"]               = "Non interrompibile"
L["COLOR_INTERRUPTED"]      = "Colore interruzione"

L["RESET_ALL"]              = "Ripristina tutto"
L["RESET_POSITION"]         = "Ripristina posizione %s"

L["INFO_DRAG"]              = "Usa /tcb lock per sbloccare e trascinare le barre."
L["POSITION_RESET"]         = "Posizione %s ripristinata."

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — Modalità Layout"
L["layout_mode_hint"]            = "Trascina le barre per riposizionarle — clicca Blocca quando hai finito"
L["layout_btn_lock"]             = "Blocca"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "Modalità Layout ATTIVA — trascina le barre. Clicca Blocca quando hai finito."
L["layout_locked"]               = "Modalità Layout DISATTIVA — posizioni salvate."
L["grid_dimmed"]                 = "Griglia"
L["grid_bright"]                 = "Griglia +"
L["grid_disabled"]               = "Griglia OFF"
L["mover_player"]                = "Barra Giocatore"
L["mover_target"]                = "Barra Bersaglio"
L["mover_focus"]                 = "Barra Focus"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Modalità Layout — trascina le barre per riposizionarle"
L["btn_reload_ui"]               = "Ricarica interfaccia"
L["INFO_DRAG_LAYOUT"]            = "Usa il pulsante Layout (o /tcb layout) per spostare le barre."
