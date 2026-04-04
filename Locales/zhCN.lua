-- =====================================
-- zhCN.lua — 简体中文 (中国大陆) v2.0
-- =====================================
local addonLocale = GetLocale()
if addonLocale ~= "zhCN" then return end

TomoCastbar_L = TomoCastbar_L or {}
local L = TomoCastbar_L

L["ADDON_LOADED"]           = "已加载。输入 |cffd1b559/tcb|r 打开设置，或 |cffd1b559/tcb help|r 查看命令。"
L["UNKNOWN_COMMAND"]        = "未知命令。输入 /tcb help 查看列表。"
L["ALL_RESET"]              = "所有设置已重置为默认值。"
L["DB_RESET"]               = "数据库已重置。"
L["UNIT_RESET"]             = "%s 施法条已重置。"

L["HELP_HEADER"]            = "命令："
L["HELP_CONFIG"]            = "  /tcb — 打开设置面板"
L["HELP_LOCK"]              = "  /tcb lock — 锁定/解锁施法条"
L["HELP_RESET"]             = "  /tcb reset — 重置所有设置"
L["HELP_RESET_PLAYER"]      = "  /tcb reset player — 重置玩家施法条"
L["HELP_RESET_TARGET"]      = "  /tcb reset target — 重置目标施法条"
L["HELP_RESET_FOCUS"]       = "  /tcb reset focus — 重置焦点施法条"
L["HELP_HELP"]              = "  /tcb help — 显示此帮助"

L["HELP_LAYOUT"]            = "  /tcb layout — 切换布局模式（拖动施法条）"

L["CASTBARS_LOCKED"]        = "施法条已锁定。"
L["CASTBARS_UNLOCKED"]      = "施法条已解锁 — 拖动以重新定位。"
L["MOVE_LABEL"]             = "（移动）"
L["PREVIEW_CASTBAR"]        = "预览 (%s)"
L["INTERRUPTED"]            = "被打断"

L["CONFIG_TITLE"]           = "|cffd1b559Tomo|r|cffffffffCastbar|r"
L["CONFIG_FOOTER"]          = "/tcb · 设置  ·  /tcb lock · 解锁"
L["DB_NOT_INIT"]            = "数据库尚未初始化。"

L["CAT_GENERAL"]            = "常规"
L["CAT_PLAYER"]             = "玩家"
L["CAT_TARGET"]             = "目标"
L["CAT_FOCUS"]              = "焦点"

L["HEADER_GENERAL"]         = "常规"
L["HEADER_TEXTURES"]        = "纹理与媒体"
L["HEADER_COLORS"]          = "颜色"
L["HEADER_SPARK"]           = "火花动画"
L["HEADER_ADVANCED"]        = "高级"
L["HEADER_UNIT_CASTBAR"]    = "%s 施法条"

L["SUBLABEL_FONTSIZE"]      = "字体大小"
L["SUBLABEL_DIMENSIONS"]    = "尺寸"
L["SUBLABEL_DISPLAY"]       = "显示"
L["SUBLABEL_POSITION"]      = "位置"

L["HIDE_BLIZZARD"]          = "隐藏暴雪施法条"
L["CUSTOM_BORDER"]          = "自定义边框"
L["SHOW_SPARK"]             = "显示火花"
L["SHOW_CHANNEL_TICKS"]     = "显示引导刻度"
L["ENABLE"]                 = "启用"
L["SHOW_ICON"]              = "显示图标"
L["SHOW_TIMER"]             = "显示计时器"
L["SHOW_LATENCY"]           = "显示延迟"
L["USE_CLASS_COLOR"]        = "职业颜色"

L["BACKGROUND_MODE"]        = "背景"
L["BG_CUSTOM"]              = "自定义纹理"
L["BG_BLACK"]               = "黑色"
L["BG_TRANSPARENT"]         = "透明"
L["BAR_TEXTURE"]            = "进度条纹理"
L["TEX_BLIZZARD"]           = "暴雪"
L["TEX_SMOOTH"]             = "平滑"
L["TEX_FLAT"]               = "纯色"

L["BAR_TEXTURE_LSM"]        = "进度条纹理 (LibSharedMedia)"
L["FONT_LSM"]               = "字体 (LibSharedMedia)"
L["LSM_NOT_LOADED"]         = "LibSharedMedia 未加载 — 使用内置纹理。"

L["SPARK_STYLE"]            = "动画样式"
L["SPARK_COMET"]            = "彗星"
L["SPARK_PULSE"]            = "脉冲"
L["SPARK_HELIX"]            = "螺旋"
L["SPARK_GLITCH"]           = "故障"
L["SPARK_GLOW_ALPHA"]       = "光晕强度"
L["SPARK_TAIL_ALPHA"]       = "尾焰强度"
L["SPARK_COLOR_HEAD"]       = "火花头颜色"
L["SPARK_COLOR_GLOW"]       = "光晕颜色"
L["SPARK_COLOR_TAIL"]       = "尾焰颜色"

L["TIMER_FORMAT"]           = "计时器格式"
L["TIMER_REMAINING"]        = "剩余 (1.5)"
L["TIMER_REMAINING_TOTAL"]  = "剩余 / 总计 (1.5 / 3.0)"
L["TIMER_ELAPSED"]          = "已用 (1.5)"

L["SPELL_NAME_TRUNCATE"]    = "法术名称最大长度"

L["SLIDER_SPARK_HEIGHT"]    = "火花高度"
L["SLIDER_FONTSIZE"]        = "字体大小"
L["SLIDER_WIDTH"]           = "宽度"
L["SLIDER_HEIGHT"]          = "高度"

L["COLOR_CAST"]             = "施法颜色"
L["COLOR_NI"]               = "不可打断颜色"
L["COLOR_INTERRUPTED"]      = "被打断颜色"

L["RESET_ALL"]              = "重置所有"
L["RESET_POSITION"]         = "重置 %s 位置"

L["INFO_DRAG"]              = "使用 /tcb lock 解锁并拖动施法条。"
L["POSITION_RESET"]         = "%s 位置已重置。"

-- Layout / Mover system (v2.0)
L["layout_mode_title"]           = "TomoCastbar — 布局模式"
L["layout_mode_hint"]            = "拖动施法条以重新定位 — 完成后点击锁定"
L["layout_btn_lock"]             = "锁定"
L["layout_btn_reload"]           = "RL"
L["layout_unlocked"]             = "布局模式已启用 — 拖动施法条。完成后点击锁定。"
L["layout_locked"]               = "布局模式已关闭 — 位置已保存。"
L["grid_dimmed"]                 = "网格"
L["grid_bright"]                 = "网格 +"
L["grid_disabled"]               = "网格 关"
L["mover_player"]                = "玩家施法条"
L["mover_target"]                = "目标施法条"
L["mover_focus"]                 = "焦点施法条"

-- Config GUI buttons (v2.0.1)
L["btn_layout"]                  = "布局"
L["btn_layout_tooltip"]          = "布局模式 — 拖动施法条以重新定位"
L["btn_reload_ui"]               = "重载界面"
L["INFO_DRAG_LAYOUT"]            = "使用上方的布局按钮（或 /tcb layout）来移动施法条。"
