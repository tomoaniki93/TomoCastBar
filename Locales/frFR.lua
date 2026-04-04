-- =====================================
-- frFR.lua — Locale française v2.0
-- =====================================
TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "chargé. Tape |cffd1b559/tcb|r pour la config ou |cffd1b559/tcb help|r pour les commandes."
L["UNKNOWN_COMMAND"]        = "Commande inconnue. Tape /tcb help pour la liste."
L["ALL_RESET"]              = "Tous les paramètres réinitialisés."
L["DB_RESET"]               = "Base de données réinitialisée."
L["UNIT_RESET"]             = "Castbar %s réinitialisée."

L["HELP_HEADER"]            = "Commandes :"
L["HELP_CONFIG"]            = "  /tcb — Ouvrir la configuration"
L["HELP_LOCK"]              = "  /tcb lock — Verrouiller/déverrouiller les castbars"
L["HELP_RESET"]             = "  /tcb reset — Réinitialiser tous les paramètres"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Réinitialiser la castbar joueur"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Réinitialiser la castbar cible"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Réinitialiser la castbar focus"
L["HELP_HELP"]              = "  /tcb help — Afficher cette aide"

L["HELP_LAYOUT"]            = "  /tcb layout — Basculer le Mode Layout (déplacer les castbars)"

L["CASTBARS_LOCKED"]        = "Castbars verrouillées."
L["CASTBARS_UNLOCKED"]      = "Castbars déverrouillées — glisse pour repositionner."
L["MOVE_LABEL"]             = "(Déplacer)"
L["PREVIEW_CASTBAR"]        = "Castbar (%s)"
L["INTERRUPTED"]            = "Interrompu"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · config  ·  /tcb lock · déverrouiller"
L["DB_NOT_INIT"]            = "Base de données non initialisée."

L["CAT_GENERAL"]            = "Général"
L["CAT_PLAYER"]             = "Joueur"
L["CAT_TARGET"]             = "Cible"
L["CAT_FOCUS"]              = "Focus"

L["HEADER_GENERAL"]         = "Général"
L["HEADER_TEXTURES"]        = "Textures & Médias"
L["HEADER_COLORS"]          = "Couleurs"
L["HEADER_SPARK"]           = "Animation de l'étincelle"
L["HEADER_ADVANCED"]        = "Avancé"
L["HEADER_UNIT_CASTBAR"]    = "Castbar %s"

L["SUBLABEL_FONTSIZE"]      = "Taille de la police"
L["SUBLABEL_DIMENSIONS"]    = "Dimensions"
L["SUBLABEL_DISPLAY"]       = "Affichage"
L["SUBLABEL_POSITION"]      = "Position"

L["HIDE_BLIZZARD"]          = "Masquer la castbar Blizzard"
L["CUSTOM_BORDER"]          = "Bordure personnalisée"
L["SHOW_SPARK"]             = "Afficher l'étincelle"
L["SHOW_CHANNEL_TICKS"]     = "Afficher les ticks de canal"
L["ENABLE"]                 = "Activer"
L["SHOW_ICON"]              = "Afficher l'icône"
L["SHOW_TIMER"]             = "Afficher le timer"
L["SHOW_LATENCY"]           = "Afficher la latence"
L["USE_CLASS_COLOR"]        = "Couleur de classe"

L["BACKGROUND_MODE"]        = "Fond"
L["BG_CUSTOM"]              = "Texture personnalisée"
L["BG_BLACK"]               = "Noir"
L["BG_TRANSPARENT"]         = "Transparent"
L["BAR_TEXTURE"]            = "Texture de barre"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Douce"
L["TEX_FLAT"]               = "Plate"

L["BAR_TEXTURE_LSM"]        = "Texture de barre (LibSharedMedia)"
L["FONT_LSM"]               = "Police (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia non chargé — utilisation des textures intégrées."

L["SPARK_STYLE"]            = "Style d'animation"
L["SPARK_COMET"]            = "Comète"
L["SPARK_PULSE"]            = "Pulsation"
L["SPARK_HELIX"]            = "Hélice"
L["SPARK_GLITCH"]           = "Glitch"
L["SPARK_GLOW_ALPHA"]       = "Intensité du halo"
L["SPARK_TAIL_ALPHA"]       = "Intensité des queues"
L["SPARK_COLOR_HEAD"]       = "Couleur de la tête"
L["SPARK_COLOR_GLOW"]       = "Couleur du halo"
L["SPARK_COLOR_TAIL"]       = "Couleur des queues"

L["TIMER_FORMAT"]           = "Format du timer"
L["TIMER_REMAINING"]        = "Restant (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Restant / Total (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Écoulé (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "Longueur max du nom de sort"

L["SLIDER_SPARK_HEIGHT"]    = "Hauteur de l'étincelle"
L["SLIDER_FONTSIZE"]        = "Taille de police"
L["SLIDER_WIDTH"]           = "Largeur"
L["SLIDER_HEIGHT"]          = "Hauteur"

L["COLOR_CAST"]             = "Couleur de cast"
L["COLOR_NI"]               = "Couleur non-interruptible"
L["COLOR_INTERRUPTED"]      = "Couleur interruption"

L["RESET_ALL"]              = "Réinitialiser tout"
L["RESET_POSITION"]         = "Réinitialiser la position %s"

L["INFO_DRAG"]              = "Utilise /tcb lock pour déverrouiller et déplacer les castbars."
L["POSITION_RESET"]         = "Position %s réinitialisée."

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — Mode Layout"
L["layout_mode_hint"]            = "Glisse les castbars pour les repositionner — clique sur Verrouiller quand c'est fait"
L["layout_btn_lock"]             = "Verrouiller"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "Mode Layout ACTIVÉ — glisse les castbars pour les repositionner. Clique sur Verrouiller."
L["layout_locked"]               = "Mode Layout DÉSACTIVÉ — positions sauvegardées."
L["grid_dimmed"]                 = "Grille"
L["grid_bright"]                 = "Grille +"
L["grid_disabled"]               = "Grille OFF"
L["mover_player"]                = "Castbar Joueur"
L["mover_target"]                = "Castbar Cible"
L["mover_focus"]                 = "Castbar Focus"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Mode Layout — glisse les castbars pour les repositionner"
L["btn_reload_ui"]               = "Recharger l'interface"
L["INFO_DRAG_LAYOUT"]            = "Utilise le bouton Layout ci-dessus (ou /tcb layout) pour déplacer les castbars."

-- [v3.0] Transitions
L["SHOW_TRANSITIONS"]            = "Animations de transition"

-- [v3.0] GCD Spark
L["SHOW_GCD_SPARK"]              = "Afficher le spark GCD"
L["GCD_HEIGHT"]                  = "Hauteur de la barre GCD"
L["GCD_COLOR"]                   = "Couleur GCD"

-- [v3.0] School Colors
L["USE_SCHOOL_COLOR"]            = "Couleur par école de magie (Joueur)"
L["SCHOOL_PHYSICAL"]             = "Physique"
L["SCHOOL_HOLY"]                 = "Sacré"
L["SCHOOL_FIRE"]                 = "Feu"
L["SCHOOL_NATURE"]               = "Nature"
L["SCHOOL_FROST"]                = "Givre"
L["SCHOOL_SHADOW"]               = "Ombre"
L["SCHOOL_ARCANE"]               = "Arcane"

-- [v3.0] Icon Side
L["ICON_SIDE"]                   = "Position de l'icône"
L["ICON_LEFT"]                   = "Gauche"
L["ICON_RIGHT"]                  = "Droite"

-- [v3.0] Interrupt Feedback
L["SHOW_INTERRUPT_FEEDBACK"]     = "Texte de feedback d'interruption"
L["INTERRUPT_FEEDBACK_DURATION"] = "Durée d'affichage"
L["INTERRUPT_FEEDBACK_COLOR"]    = "Couleur du feedback"
L["INTERRUPT_FEEDBACK_FONTSIZE"] = "Taille de police du feedback"
L["INTERRUPT_FEEDBACK_TEXT"]     = "Interrompu !"
L["INTERRUPT_FEEDBACK_FULL"]     = "Interrompu ! %s"

-- [v3.0] Profiles
L["PROFILE_ENABLED"]             = "Profils par spé activés. Spé actuelle : %d"
L["PROFILE_DISABLED"]            = "Profils par spé désactivés. Réglages globaux."
L["PROFILE_SWITCHED"]            = "Profil chargé : %s"
L["PROFILE_COPIED"]              = "Réglages copiés vers la spé %d."
L["PROFILE_STATUS"]              = "Profils par spé : %s (spé active : %d)"
L["PROFILE_STATUS_ON"]           = "ON"
L["PROFILE_STATUS_OFF"]          = "OFF"
L["HELP_PROFILE"]                = "  /tcb profile — Afficher le statut des profils"
L["HELP_PROFILE_TOGGLE"]         = "  /tcb profile on/off — Activer/désactiver les profils par spé"
L["HELP_PROFILE_COPY"]           = "  /tcb profile copy <1-4> — Copier les réglages vers la spé #"
