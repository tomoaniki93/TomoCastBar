-- =====================================
-- deDE.lua — Deutsch (Deutschland) v2.0
-- =====================================
local addonLocale = GetLocale()
if addonLocale ~= "deDE" then return end

TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "geladen. Tippe |cffd1b559/tcb|r für die Einstellungen oder |cffd1b559/tcb help|r für Befehle."
L["UNKNOWN_COMMAND"]        = "Unbekannter Befehl. Tippe /tcb help für eine Liste."
L["ALL_RESET"]              = "Alle Einstellungen auf Standard zurückgesetzt."
L["DB_RESET"]               = "Datenbank auf Standard zurückgesetzt."
L["UNIT_RESET"]             = "%s Zauberstabbalken zurückgesetzt."

L["HELP_HEADER"]            = "Befehle:"
L["HELP_CONFIG"]            = "  /tcb — Einstellungen öffnen"
L["HELP_LOCK"]              = "  /tcb lock — Zauberstabbalkensperren umschalten"
L["HELP_RESET"]             = "  /tcb reset — Alle Einstellungen zurücksetzen"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Spieler-Balken zurücksetzen"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Ziel-Balken zurücksetzen"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Fokus-Balken zurücksetzen"
L["HELP_HELP"]              = "  /tcb help — Diese Hilfe anzeigen"

L["HELP_LAYOUT"]            = "  /tcb layout — Layout-Modus umschalten (Zauberstabbalkens verschieben)"

L["CASTBARS_LOCKED"]        = "Zauberstabbalkens gesperrt."
L["CASTBARS_UNLOCKED"]      = "Zauberstabbalkens entsperrt — ziehen zum Verschieben."
L["MOVE_LABEL"]             = "(Verschieben)"
L["PREVIEW_CASTBAR"]        = "Vorschau (%s)"
L["INTERRUPTED"]            = "Unterbrochen"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · Einstellungen  ·  /tcb lock · entsperren"
L["DB_NOT_INIT"]            = "Datenbank noch nicht initialisiert."

L["CAT_GENERAL"]            = "Allgemein"
L["CAT_PLAYER"]             = "Spieler"
L["CAT_TARGET"]             = "Ziel"
L["CAT_FOCUS"]              = "Fokus"

L["HEADER_GENERAL"]         = "Allgemein"
L["HEADER_TEXTURES"]        = "Texturen & Medien"
L["HEADER_COLORS"]          = "Farben"
L["HEADER_SPARK"]           = "Funken-Animation"
L["HEADER_ADVANCED"]        = "Erweitert"
L["HEADER_UNIT_CASTBAR"]    = "%s Zauberstabbalken"

L["SUBLABEL_FONTSIZE"]      = "Schriftgröße"
L["SUBLABEL_DIMENSIONS"]    = "Abmessungen"
L["SUBLABEL_DISPLAY"]       = "Anzeige"
L["SUBLABEL_POSITION"]      = "Position"

L["HIDE_BLIZZARD"]          = "Blizzard-Balken ausblenden"
L["CUSTOM_BORDER"]          = "Eigener Rahmen"
L["SHOW_SPARK"]             = "Funken anzeigen"
L["SHOW_CHANNEL_TICKS"]     = "Kanal-Ticks anzeigen"
L["ENABLE"]                 = "Aktivieren"
L["SHOW_ICON"]              = "Symbol anzeigen"
L["SHOW_TIMER"]             = "Timer anzeigen"
L["SHOW_LATENCY"]           = "Latenz anzeigen"
L["USE_CLASS_COLOR"]        = "Klassenfarbe"

L["BACKGROUND_MODE"]        = "Hintergrund"
L["BG_CUSTOM"]              = "Eigene Textur"
L["BG_BLACK"]               = "Schwarz"
L["BG_TRANSPARENT"]         = "Transparent"
L["BAR_TEXTURE"]            = "Balken-Textur"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Glatt"
L["TEX_FLAT"]               = "Flach"

L["BAR_TEXTURE_LSM"]        = "Balken-Textur (LibSharedMedia)"
L["FONT_LSM"]               = "Schriftart (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia nicht geladen — Standardtexturen werden verwendet."

L["SPARK_STYLE"]            = "Animationsstil"
L["SPARK_COMET"]            = "Komet"
L["SPARK_PULSE"]            = "Puls"
L["SPARK_HELIX"]            = "Helix"
L["SPARK_GLITCH"]           = "Glitch"
L["SPARK_GLOW_ALPHA"]       = "Leuchtstärke"
L["SPARK_TAIL_ALPHA"]       = "Schweifstärke"
L["SPARK_COLOR_HEAD"]       = "Funkenkopf-Farbe"
L["SPARK_COLOR_GLOW"]       = "Leuchtfarbe"
L["SPARK_COLOR_TAIL"]       = "Schweiffarbe"

L["TIMER_FORMAT"]           = "Timer-Format"
L["TIMER_REMAINING"]        = "Verbleibend (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Verbleibend / Gesamt (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Vergangen (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "Maximale Zaubernamenslänge"

L["SLIDER_SPARK_HEIGHT"]    = "Funkenhöhe"
L["SLIDER_FONTSIZE"]        = "Schriftgröße"
L["SLIDER_WIDTH"]           = "Breite"
L["SLIDER_HEIGHT"]          = "Höhe"

L["COLOR_CAST"]             = "Wirkfarbe"
L["COLOR_NI"]               = "Nicht unterbrechbar"
L["COLOR_INTERRUPTED"]      = "Unterbrochen-Farbe"

L["RESET_ALL"]              = "Alles zurücksetzen"
L["RESET_POSITION"]         = "%s Position zurücksetzen"

L["INFO_DRAG"]              = "Nutze /tcb lock zum Entsperren und Verschieben der Balken."
L["POSITION_RESET"]         = "%s Position zurückgesetzt."

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — Layout-Modus"
L["layout_mode_hint"]            = "Balken ziehen zum Neu-Positionieren — Sperren klicken wenn fertig"
L["layout_btn_lock"]             = "Sperren"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "Layout-Modus AN — Balken ziehen. Sperren klicken wenn fertig."
L["layout_locked"]               = "Layout-Modus AUS — Positionen gespeichert."
L["grid_dimmed"]                 = "Gitter"
L["grid_bright"]                 = "Gitter +"
L["grid_disabled"]               = "Gitter AUS"
L["mover_player"]                = "Spieler-Balken"
L["mover_target"]                = "Ziel-Balken"
L["mover_focus"]                 = "Fokus-Balken"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Layout-Modus — Balken ziehen zum Verschieben"
L["btn_reload_ui"]               = "Benutzeroberfläche neu laden"
L["INFO_DRAG_LAYOUT"]            = "Nutze den Layout-Button oben (oder /tcb layout) zum Verschieben der Balken."

-- =====================================
-- [v3.1] Boss-/Arena-Gruppen + Profil-UI
-- =====================================
L["CAT_BOSS"]                   = "Boss"
L["CAT_ARENA"]                  = "Arena"
L["CAT_PROFILES"]               = "Profile"
L["SUBLABEL_STACKING"]          = "Stapelung"
L["SLIDER_NUMBARS"]             = "Anzahl der Leisten"
L["GROWTH_DIRECTION"]           = "Wachstumsrichtung"
L["GROWTH_UP"]                  = "Nach oben"
L["GROWTH_DOWN"]                = "Nach unten"
L["SLIDER_SPACING"]             = "Leistenabstand"
L["INFO_BOSS"]                  = "Boss-Zauberleisten erscheinen in Begegnungen. Bis zu 5 gestapelte Leisten (boss1-boss5)."
L["INFO_ARENA"]                 = "Arena-Gegnerleisten erscheinen in Arenakämpfen. Bis zu 5 gestapelte Leisten (arena1-arena5)."
L["PROFILES_DESC"]              = "Profile speichern die gesamte TomoCastbar-Konfiguration. Erstelle benannte Setups oder lade je Spezialisierung automatisch eines."
L["PROFILE_ACTIVE_LABEL"]       = "Aktives Profil: %s"
L["PROFILE_SELECT"]             = "Ausgewähltes Profil"
L["PROFILE_LOAD_BTN"]           = "Auswahl laden"
L["PROFILE_DELETE_BTN"]         = "Auswahl löschen"
L["HEADER_PROFILES_CREATE"]     = "Erstellen / Duplizieren"
L["PROFILE_NAME_FIELD"]         = "Neuer Profilname"
L["PROFILE_CREATE_BTN"]         = "Erstellen"
L["PROFILE_DUPLICATE_BTN"]      = "Auswahl duplizieren"
L["PROFILE_SPEC_HEADER"]        = "Spezialisierungsprofile (Auto)"
L["PROFILE_SPEC_INFO"]          = "Weise deiner aktuellen Spezialisierung ein Profil zu. Es wird beim Wechsel automatisch geladen."
L["PROFILE_SPEC_CURRENT"]       = "Aktuelle Spez: %s → %s"
L["PROFILE_SPEC_ASSIGN"]        = "Aktuelle Spez zuweisen zu"
L["PROFILE_SPEC_CLEAR"]         = "Zuweisung entfernen"
L["PROFILE_NONE"]               = "(keine)"
L["PROFILE_CREATED"]            = "Profil erstellt: %s"
L["PROFILE_DELETED"]            = "Profil gelöscht: %s"
L["PROFILE_LOADED"]             = "Profil geladen: %s"
L["PROFILE_CANNOT_DELETE"]      = "Das Standardprofil kann nicht gelöscht werden."
L["PROFILE_NAME_EMPTY"]         = "Bitte einen Profilnamen eingeben."
L["PROFILE_EXISTS"]             = "Ein Profil mit diesem Namen existiert bereits."
L["PROFILE_SPEC_ASSIGNED"]      = "Spez dem Profil zugewiesen: %s"
L["PROFILE_SPEC_UNASSIGNED"]    = "Spez-Zuweisung entfernt."
