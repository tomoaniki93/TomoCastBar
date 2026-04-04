-- =====================================
-- esES.lua — Español (España) v2.0
-- También válido para esMX (Latinoamérica)
-- =====================================
local addonLocale = GetLocale()
if addonLocale ~= "esES" and addonLocale ~= "esMX" then return end

TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "cargado. Escribe |cffd1b559/tcb|r para abrir ajustes o |cffd1b559/tcb help|r para los comandos."
L["UNKNOWN_COMMAND"]        = "Comando desconocido. Escribe /tcb help para ver la lista."
L["ALL_RESET"]              = "Todos los ajustes restablecidos."
L["DB_RESET"]               = "Base de datos restablecida."
L["UNIT_RESET"]             = "Barra de lanzamiento %s restablecida."

L["HELP_HEADER"]            = "Comandos:"
L["HELP_CONFIG"]            = "  /tcb — Abrir configuración"
L["HELP_LOCK"]              = "  /tcb lock — Bloquear/desbloquear barras"
L["HELP_RESET"]             = "  /tcb reset — Restablecer todos los ajustes"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Restablecer barra del jugador"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Restablecer barra del objetivo"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Restablecer barra de foco"
L["HELP_HELP"]              = "  /tcb help — Mostrar esta ayuda"

L["HELP_LAYOUT"]            = "  /tcb layout — Activar Modo Layout (mover barras de lanzamiento)"

L["CASTBARS_LOCKED"]        = "Barras bloqueadas."
L["CASTBARS_UNLOCKED"]      = "Barras desbloqueadas — arrástralas para moverlas."
L["MOVE_LABEL"]             = "(Mover)"
L["PREVIEW_CASTBAR"]        = "Vista previa (%s)"
L["INTERRUPTED"]            = "Interrumpido"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · configuración  ·  /tcb lock · desbloquear"
L["DB_NOT_INIT"]            = "Base de datos no inicializada aún."

L["CAT_GENERAL"]            = "General"
L["CAT_PLAYER"]             = "Jugador"
L["CAT_TARGET"]             = "Objetivo"
L["CAT_FOCUS"]              = "Foco"

L["HEADER_GENERAL"]         = "General"
L["HEADER_TEXTURES"]        = "Texturas y Medios"
L["HEADER_COLORS"]          = "Colores"
L["HEADER_SPARK"]           = "Animación de chispa"
L["HEADER_ADVANCED"]        = "Avanzado"
L["HEADER_UNIT_CASTBAR"]    = "Barra %s"

L["SUBLABEL_FONTSIZE"]      = "Tamaño de fuente"
L["SUBLABEL_DIMENSIONS"]    = "Dimensiones"
L["SUBLABEL_DISPLAY"]       = "Visualización"
L["SUBLABEL_POSITION"]      = "Posición"

L["HIDE_BLIZZARD"]          = "Ocultar barra Blizzard"
L["CUSTOM_BORDER"]          = "Borde personalizado"
L["SHOW_SPARK"]             = "Mostrar chispa"
L["SHOW_CHANNEL_TICKS"]     = "Mostrar ticks de canalización"
L["ENABLE"]                 = "Activar"
L["SHOW_ICON"]              = "Mostrar icono"
L["SHOW_TIMER"]             = "Mostrar temporizador"
L["SHOW_LATENCY"]           = "Mostrar latencia"
L["USE_CLASS_COLOR"]        = "Color de clase"

L["BACKGROUND_MODE"]        = "Fondo"
L["BG_CUSTOM"]              = "Textura personalizada"
L["BG_BLACK"]               = "Negro"
L["BG_TRANSPARENT"]         = "Transparente"
L["BAR_TEXTURE"]            = "Textura de barra"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Suave"
L["TEX_FLAT"]               = "Plano"

L["BAR_TEXTURE_LSM"]        = "Textura de barra (LibSharedMedia)"
L["FONT_LSM"]               = "Fuente (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia no cargado — usando texturas integradas."

L["SPARK_STYLE"]            = "Estilo de animación"
L["SPARK_COMET"]            = "Cometa"
L["SPARK_PULSE"]            = "Pulso"
L["SPARK_HELIX"]            = "Hélice"
L["SPARK_GLITCH"]           = "Glitch"
L["SPARK_GLOW_ALPHA"]       = "Intensidad del resplandor"
L["SPARK_TAIL_ALPHA"]       = "Intensidad de la estela"
L["SPARK_COLOR_HEAD"]       = "Color de la chispa"
L["SPARK_COLOR_GLOW"]       = "Color del resplandor"
L["SPARK_COLOR_TAIL"]       = "Color de la estela"

L["TIMER_FORMAT"]           = "Formato del temporizador"
L["TIMER_REMAINING"]        = "Restante (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Restante / Total (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Transcurrido (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "Longitud máxima del nombre del hechizo"

L["SLIDER_SPARK_HEIGHT"]    = "Altura de la chispa"
L["SLIDER_FONTSIZE"]        = "Tamaño de fuente"
L["SLIDER_WIDTH"]           = "Ancho"
L["SLIDER_HEIGHT"]          = "Alto"

L["COLOR_CAST"]             = "Color de lanzamiento"
L["COLOR_NI"]               = "Color no interrumpible"
L["COLOR_INTERRUPTED"]      = "Color de interrupción"

L["RESET_ALL"]              = "Restablecer todo"
L["RESET_POSITION"]         = "Restablecer posición %s"

L["INFO_DRAG"]              = "Usa /tcb lock para desbloquear y arrastrar las barras."
L["POSITION_RESET"]         = "Posición %s restablecida."

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — Modo Layout"
L["layout_mode_hint"]            = "Arrastra las barras para reposicionarlas — haz clic en Bloquear cuando termines"
L["layout_btn_lock"]             = "Bloquear"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "Modo Layout ACTIVADO — arrastra las barras. Haz clic en Bloquear cuando termines."
L["layout_locked"]               = "Modo Layout DESACTIVADO — posiciones guardadas."
L["grid_dimmed"]                 = "Cuadrícula"
L["grid_bright"]                 = "Cuadrícula +"
L["grid_disabled"]               = "Cuadrícula OFF"
L["mover_player"]                = "Barra Jugador"
L["mover_target"]                = "Barra Objetivo"
L["mover_focus"]                 = "Barra Foco"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Modo Layout — arrastra las barras para reposicionarlas"
L["btn_reload_ui"]               = "Recargar interfaz"
L["INFO_DRAG_LAYOUT"]            = "Usa el botón Layout (o /tcb layout) para mover las barras."
