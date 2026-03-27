# TomoCastbar — Changelog

---

## [2.0.0] — 2026-03-27

### New Features

#### LibSharedMedia-3.0 Support
- **Bundled library** — LibStub, CallbackHandler-1.0, and LibSharedMedia-3.0 are now included in `Libs/`. No external dependency required.
- **Bar texture picker** — Lists all statusbar textures registered by LSM from other addons (SharedMedia, etc.). Replaces the 3-option dropdown.
- **Font picker** — All fonts registered in LSM are available for spell name and timer texts.
- **Live texture update** — When another addon changes the global LSM statusbar, all castbars update instantly without a reload.
- **Graceful fallback** — If LSM is unavailable or a media name is not found, falls back to built-in Blizzard textures and fonts.

#### Spark Animations — 4 Styles
The spark system has been completely rewritten as a dedicated module (`Modules/SparkAnimations.lua`). All styles share the same texture pool (1 head + 1 glow + 4 tails).

| Style | Description |
|---|---|
| **Comet** *(default)* | Classic trailing glow. Bright head with 4 fading tails. Clean and performant. |
| **Pulse** | Concentric expanding rings ripple outward from the leading edge, fading as they expand. |
| **Helix** | Tail elements oscillate vertically in phase-offset sine waves around the leading edge. |
| **Glitch** | Randomized RGB chromatic aberration layers flicker with a digital glitch aesthetic. |

New config options: Animation Style dropdown, Glow Intensity slider, Tail Intensity slider, Spark Head Color / Glow Color / Tail Color pickers.

#### Localization — 7 Languages
TomoCastbar now ships with 8 locales covering all major World of Warcraft regions:

| File | Language | Region |
|---|---|---|
| `enUS.lua` | English | Americas, Oceania |
| `frFR.lua` | Français | France, Belgium |
| `deDE.lua` | Deutsch | Germany, Austria, Switzerland |
| `esES.lua` | Español | Spain + Latin America (esMX) |
| `itIT.lua` | Italiano | Italy |
| `ptBR.lua` | Português | Brazil + Portugal (ptPT) |
| `ruRU.lua` | Русский | Russia, CIS |
| `zhCN.lua` | 简体中文 | Mainland China |

Each locale is loaded conditionally (`if GetLocale() ~= "xx" then return end`) so only one locale is active at runtime. enUS is the base — all keys fall back to English if a translation is missing. All 81 localization keys are covered in every language.

#### Timer Format Options
Three display modes selectable in config:

| Mode | Display | Use case |
|---|---|---|
| Remaining | `1.5` | Classic minimal |
| Remaining / Total | `1.5 / 3.0` | Arena — gauge cast length |
| Elapsed | `1.5` | Personal tracking preference |

#### Spell Name Truncation
New Max Length slider (0–40 characters). Long spell names are truncated with `…` to prevent overlap with the timer text. Set to `0` to disable.

#### Class Color for Target / Focus Bars
New Class Color checkbox. When enabled, target and focus castbars use the unit's class color. Falls back to the configured Cast Color for NPCs and unknown classes. Particularly useful in arena.

### Improvements

#### Precise Per-Cast Latency
- Previously used `GetNetStats()` which returns average world latency, not per-spell latency.
- Now tracks `UNIT_SPELLCAST_SENT` to measure the exact client→server round-trip for the current spell.
- Matches the behavior of Quartz's Latency module.

#### Interrupter Name Display
- Interrupt text now shows: `Interrupted (PlayerName)` instead of just `Interrupted`.
- GUID resolved via `UnitNameFromGUID()` from the `UNIT_SPELLCAST_INTERRUPTED` event.

#### Pushback Detection (`UNIT_SPELLCAST_DELAYED`)
- Now registered for all three units.
- When a cast is pushed back by damage, timings are re-read from the API and the bar updates instantly.

#### Zone Change / Login Recovery (`PLAYER_ENTERING_WORLD`)
- All three castbars register `PLAYER_ENTERING_WORLD`.
- Ongoing casts on the target or focus are now correctly detected after login, UI reload, or zone change.

#### Performance — OnUpdate Throttling
- Bar fill value and spark position update every frame (smooth 60 fps).
- Timer text throttled to **20 updates/second** (every 50ms), down from 60. ~66% reduction in `string.format` calls per castbar during combat.

#### Performance — Local Upvalues
- All frequently-called globals (`GetTime`, `math.max`, `math.min`, `string.format`, `UnitCastingInfo`, etc.) are cached as local upvalues at module scope.
- Eliminates repeated `_G` table lookups in `OnUpdate`.

#### Performance — Reusable Cast Info Table
- `GetSafeCastInfo()` reuses a single module-level table instead of allocating a new one per call.
- Reduces GC pressure during high-event combat.

### Files Changed

| File | Change |
|---|---|
| `TomoCastbar.toc` | Libs entries, all 8 locale entries, Notes-XX fields, version 2.0.0 |
| `Libs/LibStub/LibStub.lua` | **New** — bundled |
| `Libs/CallbackHandler-1.0/CallbackHandler-1.0.lua` | **New** — bundled |
| `Libs/LibSharedMedia-3.0/LibSharedMedia-3.0.lua` | **New** — bundled |
| `Modules/SparkAnimations.lua` | **New** — 4 animation styles, shared spark texture pool |
| `Modules/Castbar.lua` | LSM integration, spark dispatch, all new events, latency fix, perf improvements |
| `Core/Database.lua` | Added `barTextureLSM`, `fontLSM`, `sparkStyle`, `sparkGlowAlpha`, `sparkTailAlpha`, `sparkColor`, `sparkGlowColor`, `sparkTailColor`, `timerFormat`, `spellNameMaxLen`, `useClassColor` |
| `Locales/enUS.lua` | 81 keys, 16 new for v2.0 features |
| `Locales/frFR.lua` | Updated — all 81 keys translated |
| `Locales/deDE.lua` | **New** — German, full 81 keys |
| `Locales/esES.lua` | **New** — Spanish (ES + MX), full 81 keys |
| `Locales/itIT.lua` | **New** — Italian, full 81 keys |
| `Locales/ptBR.lua` | **New** — Portuguese (BR + PT), full 81 keys |
| `Locales/ruRU.lua` | **New** — Russian, full 81 keys |
| `Locales/zhCN.lua` | **New** — Simplified Chinese, full 81 keys |
| `Config/ConfigUI.lua` | *(pending)* New sections: Textures & Media (LSM), Spark Animation, Advanced |

### Upgrade Notes

- **No action required** — existing saved variables are automatically merged with new defaults.
- The new `barTextureLSM` defaults to `"Blizzard"` — same visual result as before.
- LibSharedMedia-3.0 is bundled. If already installed by another addon, LibStub's versioning handles coexistence safely.
- Use `/tcb reset` to apply all defaults from scratch if needed.

---

## [1.0.2] — Initial Release

- Player, target, and focus castbars (standalone, not attached to unit frames)
- Regular casts, channels, and empowered casts (Evoker stages with gradient overlays)
- Spark with custom texture, channel tick markers, empower stage dividers
- Not-interruptible overlay, latency bar (player only, via GetNetStats)
- Draggable positioning with lock/unlock system (`/tcb lock`)
- Custom border, background modes (custom texture / black / transparent)
- 3 bar texture options (Blizzard / Smooth / Flat)
- French (frFR) and English (enUS) locales
- Config panel with sidebar navigation (General, Player, Target, Focus)
- Slash commands: `/tcb`, `/tcb lock`, `/tcb reset [player|target|focus]`, `/tcb help`
- Hides Blizzard castbar frames on load

---

## [2.0.1] — 2026-03-27

### New — Layout Mode (Mover System)

Replaced the `/tcb lock` drag system with a full **Layout Mode** inspired by TomoMod's unified layout manager.

#### How it works

Type `/tcb layout` (or click the Layout button in the config panel) to enter Layout Mode. All three castbars immediately display a **mover overlay** and enter preview mode (visible even when not casting). Type it again — or click the **Lock** button in the floating header — to exit and save positions.

#### Floating Header Bar

A dark header bar appears at the top of the screen, identical in design to TomoMod's:

- **Title** — "TomoCastbar — Layout Mode" with teal accent
- **Grid** button — cycles through three grid modes: Grid / Grid+ / Grid OFF
- **Lock** button — exits layout mode and saves all positions
- **RL** button — reloads the UI

#### Alignment Grid with Cursor Flashlight

The same grid algorithm as TomoMod (originally inspired by EllesmereUI):

- Full-screen alignment grid at 32px spacing
- Brighter center crosshair
- Three modes: **Grid** (dimmed, default), **Grid+** (bright), **Grid OFF**
- **Cursor flashlight effect** — grid segments near the cursor glow brighter, with quadratic falloff over a 200px radius, computed from segmented line pools (no allocation per frame)

#### Per-Castbar Mover Overlays

Each castbar (Player, Target, Focus) gets a dedicated mover frame:

- **Teal header strip** with the unit name (localized) and live X/Y coordinates
- **Dark translucent body** over the castbar's preview area
- **Drag** anywhere on the frame to move the underlying castbar; position saves automatically on drop
- **↺ Reset** button (below each mover) to restore the default position for that unit
- Castbar shows its preview content (icon, spell name, timer) so you can see exactly what you're positioning

#### Commands

| Command | Action |
|---|---|
| `/tcb layout` | Toggle Layout Mode |
| `/tcb l` | Same (short alias) |
| `/tcb lock` | Same (backward compatibility) |

#### Localization

All new Layout Mode strings are localized in all 8 languages: `layout_mode_title`, `layout_mode_hint`, `layout_btn_lock`, `layout_btn_reload`, `layout_unlocked`, `layout_locked`, `grid_dimmed`, `grid_bright`, `grid_disabled`, `mover_player`, `mover_target`, `mover_focus`.

### Files Changed

| File | Change |
|---|---|
| `Modules/Movers.lua` | **New** — full layout manager (header, grid, mover overlays) |
| `Core/Init.lua` | Added `/tcb layout` command, `TomoCastbar_Movers.Initialize()` call |
| `Locales/enUS.lua` | Added 14 new layout/mover keys |
| `Locales/frFR.lua` | French translations for layout/mover keys |
| `Locales/deDE.lua` | German translations |
| `Locales/esES.lua` | Spanish translations |
| `Locales/itIT.lua` | Italian translations |
| `Locales/ptBR.lua` | Portuguese translations |
| `Locales/ruRU.lua` | Russian translations |
| `Locales/zhCN.lua` | Chinese translations |
| `TomoCastbar.toc` | Added `Modules\Movers.lua` entry |

### Removed

- `TomoCastbar_Utils.SetupDraggable()` is no longer called from `Castbar.lua` for position management. The Movers system replaces it entirely. The function remains in `Utils.lua` for potential reuse.
- `/tcb lock` now opens Layout Mode instead of toggling a simple drag overlay.

---

## [2.0.2] — 2026-03-27

### New — Layout & RL buttons in the config GUI

The config panel title bar now has two action buttons on the right side of the header, identical in design and behaviour to TomoMod's:

**Layout button** (teal, left of RL)
- Toggles Layout Mode directly from the config panel without closing it.
- The button style updates dynamically: dark teal background + full teal border when Layout Mode is active, neutral border when inactive.
- A `GameTooltip` appears on hover.
- Also added as a secondary button inside each unit panel (Player / Target / Focus), just above the Reset Position button, for direct access from where you're editing dimensions.

**RL button** (amber, left of ×)
- Calls `ReloadUI()` immediately.
- Same amber palette as TomoMod (dark amber background, amber border, amber text).
- `GameTooltip` on hover with the localized "Reload UI" string.

**Accent line**
- A subtle 2px teal accent line now runs along the very top of the title bar, matching the Movers header bar aesthetic.

**Version**
- Title bar version string updated to `v2.0.0`.

### Files Changed

| File | Change |
|---|---|
| `Config/ConfigUI.lua` | Layout + RL buttons in title bar; Layout button in unit panels; accent line; version bump; `UpdateLayoutBtnStyle()` helper |
| `Locales/enUS.lua` | Added `btn_layout`, `btn_layout_tooltip`, `btn_reload_ui`, `INFO_DRAG_LAYOUT` |
| `Locales/frFR.lua` | French translations |
| `Locales/deDE.lua` | German translations |
| `Locales/esES.lua` | Spanish translations |
| `Locales/itIT.lua` | Italian translations |
| `Locales/ptBR.lua` | Portuguese translations |
| `Locales/ruRU.lua` | Russian translations |
| `Locales/zhCN.lua` | Chinese translations |