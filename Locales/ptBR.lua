-- =====================================
-- ptBR.lua — Português (Brasil) v2.0
-- =====================================
local addonLocale = GetLocale()
if addonLocale ~= "ptBR" and addonLocale ~= "ptPT" then return end

TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "carregado. Digite |cffd1b559/tcb|r para configurações ou |cffd1b559/tcb help|r para comandos."
L["UNKNOWN_COMMAND"]        = "Comando desconhecido. Digite /tcb help para a lista."
L["ALL_RESET"]              = "Todas as configurações restauradas."
L["DB_RESET"]               = "Banco de dados restaurado."
L["UNIT_RESET"]             = "Barra de conjuração %s restaurada."

L["HELP_HEADER"]            = "Comandos:"
L["HELP_CONFIG"]            = "  /tcb — Abrir configurações"
L["HELP_LOCK"]              = "  /tcb lock — Alternar bloqueio das barras"
L["HELP_RESET"]             = "  /tcb reset — Restaurar todas as configurações"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Restaurar barra do jogador"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Restaurar barra do alvo"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Restaurar barra do foco"
L["HELP_HELP"]              = "  /tcb help — Mostrar esta ajuda"

L["HELP_LAYOUT"]            = "  /tcb layout — Alternar Modo Layout (mover barras de conjuração)"

L["CASTBARS_LOCKED"]        = "Barras bloqueadas."
L["CASTBARS_UNLOCKED"]      = "Barras desbloqueadas — arraste para reposicionar."
L["MOVE_LABEL"]             = "(Mover)"
L["PREVIEW_CASTBAR"]        = "Visualização (%s)"
L["INTERRUPTED"]            = "Interrompido"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · configurações  ·  /tcb lock · desbloquear"
L["DB_NOT_INIT"]            = "Banco de dados ainda não inicializado."

L["CAT_GENERAL"]            = "Geral"
L["CAT_PLAYER"]             = "Jogador"
L["CAT_TARGET"]             = "Alvo"
L["CAT_FOCUS"]              = "Foco"

L["HEADER_GENERAL"]         = "Geral"
L["HEADER_TEXTURES"]        = "Texturas e Mídia"
L["HEADER_COLORS"]          = "Cores"
L["HEADER_SPARK"]           = "Animação de faísca"
L["HEADER_ADVANCED"]        = "Avançado"
L["HEADER_UNIT_CASTBAR"]    = "Barra %s"

L["SUBLABEL_FONTSIZE"]      = "Tamanho da fonte"
L["SUBLABEL_DIMENSIONS"]    = "Dimensões"
L["SUBLABEL_DISPLAY"]       = "Exibição"
L["SUBLABEL_POSITION"]      = "Posição"

L["HIDE_BLIZZARD"]          = "Ocultar barra Blizzard"
L["CUSTOM_BORDER"]          = "Borda personalizada"
L["SHOW_SPARK"]             = "Mostrar faísca"
L["SHOW_CHANNEL_TICKS"]     = "Mostrar ticks de canalização"
L["ENABLE"]                 = "Ativar"
L["SHOW_ICON"]              = "Mostrar ícone"
L["SHOW_TIMER"]             = "Mostrar temporizador"
L["SHOW_LATENCY"]           = "Mostrar latência"
L["USE_CLASS_COLOR"]        = "Cor de classe (Alvo/Foco)"

L["BACKGROUND_MODE"]        = "Fundo"
L["BG_CUSTOM"]              = "Textura personalizada"
L["BG_BLACK"]               = "Preto"
L["BG_TRANSPARENT"]         = "Transparente"
L["BAR_TEXTURE"]            = "Textura da barra"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Suave"
L["TEX_FLAT"]               = "Plano"

L["BAR_TEXTURE_LSM"]        = "Textura da barra (LibSharedMedia)"
L["FONT_LSM"]               = "Fonte (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia não carregado — usando texturas padrão."

L["SPARK_STYLE"]            = "Estilo de animação"
L["SPARK_COMET"]            = "Cometa"
L["SPARK_PULSE"]            = "Pulso"
L["SPARK_HELIX"]            = "Hélice"
L["SPARK_GLITCH"]           = "Glitch"
L["SPARK_GLOW_ALPHA"]       = "Intensidade do brilho"
L["SPARK_TAIL_ALPHA"]       = "Intensidade da cauda"
L["SPARK_COLOR_HEAD"]       = "Cor da faísca"
L["SPARK_COLOR_GLOW"]       = "Cor do brilho"
L["SPARK_COLOR_TAIL"]       = "Cor da cauda"

L["TIMER_FORMAT"]           = "Formato do temporizador"
L["TIMER_REMAINING"]        = "Restante (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Restante / Total (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Decorrido (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "Comprimento máximo do nome da magia"

L["SLIDER_SPARK_HEIGHT"]    = "Altura da faísca"
L["SLIDER_FONTSIZE"]        = "Tamanho da fonte"
L["SLIDER_WIDTH"]           = "Largura"
L["SLIDER_HEIGHT"]          = "Altura"

L["COLOR_CAST"]             = "Cor de conjuração"
L["COLOR_NI"]               = "Cor não interrompível"
L["COLOR_INTERRUPTED"]      = "Cor de interrupção"

L["RESET_ALL"]              = "Restaurar tudo"
L["RESET_POSITION"]         = "Restaurar posição %s"

L["INFO_DRAG"]              = "Use /tcb lock para desbloquear e arrastar as barras."
L["POSITION_RESET"]         = "Posição %s restaurada."

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — Modo Layout"
L["layout_mode_hint"]            = "Arraste as barras para reposicioná-las — clique em Bloquear quando terminar"
L["layout_btn_lock"]             = "Bloquear"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "Modo Layout ATIVADO — arraste as barras. Clique em Bloquear quando terminar."
L["layout_locked"]               = "Modo Layout DESATIVADO — posições salvas."
L["grid_dimmed"]                 = "Grade"
L["grid_bright"]                 = "Grade +"
L["grid_disabled"]               = "Grade OFF"
L["mover_player"]                = "Barra do Jogador"
L["mover_target"]                = "Barra do Alvo"
L["mover_focus"]                 = "Barra do Foco"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Modo Layout — arraste as barras para reposicioná-las"
L["btn_reload_ui"]               = "Recarregar interface"
L["INFO_DRAG_LAYOUT"]            = "Use o botão Layout (ou /tcb layout) para mover as barras."
