-- =====================================
-- ruRU.lua — Русский (Россия) v2.0
-- =====================================
local addonLocale = GetLocale()
if addonLocale ~= "ruRU" then return end

TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "загружен. Введите |cffd1b559/tcb|r для настроек или |cffd1b559/tcb help|r для команд."
L["UNKNOWN_COMMAND"]        = "Неизвестная команда. Введите /tcb help для списка."
L["ALL_RESET"]              = "Все настройки сброшены."
L["DB_RESET"]               = "База данных сброшена."
L["UNIT_RESET"]             = "Панель %s сброшена."

L["HELP_HEADER"]            = "Команды:"
L["HELP_CONFIG"]            = "  /tcb — Открыть настройки"
L["HELP_LOCK"]              = "  /tcb lock — Заблокировать/разблокировать панели"
L["HELP_RESET"]             = "  /tcb reset — Сбросить все настройки"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — Сбросить панель игрока"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — Сбросить панель цели"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — Сбросить панель фокуса"
L["HELP_HELP"]              = "  /tcb help — Показать справку"

L["HELP_LAYOUT"]            = "  /tcb layout — Переключить режим Layout (перемещение панелей)"

L["CASTBARS_LOCKED"]        = "Панели заблокированы."
L["CASTBARS_UNLOCKED"]      = "Панели разблокированы — перетащите для перемещения."
L["MOVE_LABEL"]             = "(Переместить)"
L["PREVIEW_CASTBAR"]        = "Предпросмотр (%s)"
L["INTERRUPTED"]            = "Прервано"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · настройки  ·  /tcb lock · разблокировать"
L["DB_NOT_INIT"]            = "База данных ещё не инициализирована."

L["CAT_GENERAL"]            = "Основное"
L["CAT_PLAYER"]             = "Игрок"
L["CAT_TARGET"]             = "Цель"
L["CAT_FOCUS"]              = "Фокус"

L["HEADER_GENERAL"]         = "Основное"
L["HEADER_TEXTURES"]        = "Текстуры и медиа"
L["HEADER_COLORS"]          = "Цвета"
L["HEADER_SPARK"]           = "Анимация искры"
L["HEADER_ADVANCED"]        = "Дополнительно"
L["HEADER_UNIT_CASTBAR"]    = "Панель %s"

L["SUBLABEL_FONTSIZE"]      = "Размер шрифта"
L["SUBLABEL_DIMENSIONS"]    = "Размеры"
L["SUBLABEL_DISPLAY"]       = "Отображение"
L["SUBLABEL_POSITION"]      = "Положение"

L["HIDE_BLIZZARD"]          = "Скрыть панель Blizzard"
L["CUSTOM_BORDER"]          = "Своя рамка"
L["SHOW_SPARK"]             = "Показать искру"
L["SHOW_CHANNEL_TICKS"]     = "Показать тики канала"
L["ENABLE"]                 = "Включить"
L["SHOW_ICON"]              = "Показать иконку"
L["SHOW_TIMER"]             = "Показать таймер"
L["SHOW_LATENCY"]           = "Показать задержку"
L["USE_CLASS_COLOR"]        = "Цвет класса"

L["BACKGROUND_MODE"]        = "Фон"
L["BG_CUSTOM"]              = "Своя текстура"
L["BG_BLACK"]               = "Чёрный"
L["BG_TRANSPARENT"]         = "Прозрачный"
L["BAR_TEXTURE"]            = "Текстура панели"
L["TEX_BLIZZARD"]           = "Blizzard"
L["TEX_SMOOTH"]             = "Плавная"
L["TEX_FLAT"]               = "Плоская"

L["BAR_TEXTURE_LSM"]        = "Текстура панели (LibSharedMedia)"
L["FONT_LSM"]               = "Шрифт (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia не загружен — используются стандартные текстуры."

L["SPARK_STYLE"]            = "Стиль анимации"
L["SPARK_COMET"]            = "Комета"
L["SPARK_PULSE"]            = "Пульс"
L["SPARK_HELIX"]            = "Спираль"
L["SPARK_GLITCH"]           = "Глитч"
L["SPARK_GLOW_ALPHA"]       = "Интенсивность свечения"
L["SPARK_TAIL_ALPHA"]       = "Интенсивность шлейфа"
L["SPARK_COLOR_HEAD"]       = "Цвет головы искры"
L["SPARK_COLOR_GLOW"]       = "Цвет свечения"
L["SPARK_COLOR_TAIL"]       = "Цвет шлейфа"

L["TIMER_FORMAT"]           = "Формат таймера"
L["TIMER_REMAINING"]        = "Осталось (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "Осталось / Всего (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "Прошло (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "Макс. длина названия заклинания"

L["SLIDER_SPARK_HEIGHT"]    = "Высота искры"
L["SLIDER_FONTSIZE"]        = "Размер шрифта"
L["SLIDER_WIDTH"]           = "Ширина"
L["SLIDER_HEIGHT"]          = "Высота"

L["COLOR_CAST"]             = "Цвет заклинания"
L["COLOR_NI"]               = "Непрерываемое"
L["COLOR_INTERRUPTED"]      = "Цвет прерывания"

L["RESET_ALL"]              = "Сбросить всё"
L["RESET_POSITION"]         = "Сбросить положение %s"

L["INFO_DRAG"]              = "Используйте /tcb lock для разблокировки и перетаскивания панелей."
L["POSITION_RESET"]         = "Положение %s сброшено."

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — Режим Layout"
L["layout_mode_hint"]            = "Перетащите панели для изменения положения — нажмите Заблокировать по завершении"
L["layout_btn_lock"]             = "Заблокировать"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "Режим Layout ВКЛЮЧЁН — перетащите панели. Нажмите Заблокировать по завершении."
L["layout_locked"]               = "Режим Layout ВЫКЛЮЧЕН — позиции сохранены."
L["grid_dimmed"]                 = "Сетка"
L["grid_bright"]                 = "Сетка +"
L["grid_disabled"]               = "Сетка ВЫКЛ"
L["mover_player"]                = "Панель Игрока"
L["mover_target"]                = "Панель Цели"
L["mover_focus"]                 = "Панель Фокуса"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "Layout"
L["btn_layout_tooltip"]          = "Режим Layout — перетащите панели для перемещения"
L["btn_reload_ui"]               = "Перезагрузить интерфейс"
L["INFO_DRAG_LAYOUT"]            = "Используйте кнопку Layout (или /tcb layout) для перемещения панелей."
