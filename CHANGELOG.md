# TomoCastbar — Changelog

---

## [3.0.1] — 2026-04-04

### Bug Fixes

#### Castbar Invisible Every Other Cast
Fixed a race condition between the fade-out animation and new cast starts. When a cast ended, the fade-out `AnimationGroup` would play. If a new cast started before it finished, the `OnFinished` callback would still call `Hide()` — hiding the active castbar.

- `CheckCast()` now stops any playing fade-out animation and resets alpha to 1 before setting up a new cast.
- The `OnFinished` callback now checks if a cast/channel/empower is active before hiding, as a safety net.

#### `ADDON_ACTION_FORBIDDEN` Error on Load
The CLEU listener frame for spell school colors was calling `RegisterEvent()` during file load, which is a protected action. This has been removed entirely (see below).

#### Spell School Colors Not Working
`C_Spell.GetSpellInfo()` does not return a `school` field, so school-based coloring always fell back to the default red. The entire school color system has been **replaced** by extending class color support to all units.

#### GCD Spark Losing Anchor After Refresh
The GCD spark captured `playerBar` once at creation. After `RefreshAll()`, the reference was stale. Now reads `CB.castbars["player"]` dynamically, and `RefreshAll()` properly cleans up and re-creates the GCD bar.

#### Dropdown Arrow Glyph Not Rendering
The Unicode character `▼` is not supported by WoW's default font (`FRIZQT__.TTF`). Replaced with the Blizzard texture `Interface\Buttons\Arrow-Down-Up`.

### Changes

#### Class Color Now Applies to All Units
`useClassColor` previously only affected target and focus bars. It now applies to **player**, **target**, and **focus** castbars. The school color system (`useSchoolColor`, `schoolColors`, CLEU listener) has been removed entirely.

### Config UI — All v3.0 Features Now Exposed
The following settings were implemented in modules but had no GUI controls. They are now fully accessible in the config panel (`/tcb`):

**General panel — new sections:**

| Section | Controls |
|---|---|
| Spark Animation | Style dropdown (Comet/Pulse/Helix/Glitch), Glow Intensity, Tail Intensity, Head/Glow/Tail color pickers |
| Advanced | Timer Format dropdown, Spell Name Max Length slider, Class Color checkbox, Transition Animations checkbox |
| GCD Spark | Enable checkbox, Height slider, Color picker |
| Interrupt Feedback | Enable checkbox, Duration slider, Color picker, Font Size slider |

**Per-unit panels (Player / Target / Focus):**

| Control | Description |
|---|---|
| Icon Position | Left / Right dropdown for spell icon placement |

### Files Changed

| File | Change |
|---|---|
| `Modules/Castbar.lua` | Fixed fade-out race condition; removed school color system (CLEU frame, cache, `GetSpellSchoolColor`); `useClassColor` applies to all units; GCD spark dynamic anchoring + cleanup in `RefreshAll()` |
| `Config/ConfigUI.lua` | Added Spark Animation, Advanced, GCD Spark, Interrupt Feedback sections to General panel; added Icon Side dropdown to unit panels; removed School Colors section |
| `Config/Widgets.lua` | Replaced Unicode `▼` arrow with Blizzard texture in dropdown widget |
| `Locales/enUS.lua` | Updated `USE_CLASS_COLOR` label |
| `Locales/frFR.lua` | Updated `USE_CLASS_COLOR` label |

---

## [3.0.0] — 2026-04-02

### New Features

#### Transition Animations
Cast completion and interruption now have smooth visual feedback instead of abrupt hide/show. All animations are driven by native `AnimationGroup` for zero-overhead rendering.

| Event | Animation |
|---|---|
| Cast succeeded | 0.3s fade-out (ease-out) |
| Channel / empower ended | 0.3s fade-out |
| Cast failed | 0.3s fade-out |
| Interrupted | Double flash pulse (0.24s) + 1s hold + fade-out |
| Interrupt bar timeout | Fade-out instead of hard hide |

New option: `showTransitions` (default: `true`). When disabled, bars hide instantly as before.

#### GCD Spark
A thin bar below the player castbar tracks the Global Cooldown in real-time.

- 4px default height, same width as the player castbar, anchored directly below it.
- Animated spark moves across the bar during GCD.
- Uses `C_Spell.GetSpellCooldown(61304)` — Midnight-safe (no secret numbers on cooldown data).
- Visible even when not casting — fills the gap between instant casts.
- Options: `showGCDSpark`, `gcdHeight`, `gcdColor`.

#### Spell School Colors (Player Only)
The player castbar can now color itself based on the spell's magic school.

| School | Default Color |
|---|---|
| Physical | Tan `(0.80, 0.70, 0.50)` |
| Holy | Gold `(1.00, 0.90, 0.50)` |
| Fire | Orange `(1.00, 0.50, 0.10)` |
| Nature | Green `(0.30, 0.70, 0.20)` |
| Frost | Blue `(0.40, 0.80, 1.00)` |
| Shadow | Purple `(0.50, 0.30, 0.80)` |
| Arcane | Violet `(0.70, 0.50, 1.00)` |

Detection uses `C_Spell.GetSpellInfo(spellID).school` with `bit.band` fallback for composite schools. All colors are configurable in `db.schoolColors`. Option: `useSchoolColor` (default: `false`).

#### Interrupt Feedback Text
When the player successfully interrupts a target's cast, a large text appears at the center of the screen:

- Format: `Interrupted! SpellName` (localized).
- Green color, 28px THICKOUTLINE, 0.8s hold + 0.7s fade-out.
- Only triggers when the `interrupterGUID` matches `UnitGUID("player")`.
- Options: `showInterruptFeedback`, `interruptFeedbackDuration`, `interruptFeedbackColor`, `interruptFeedbackFontSize`.

#### Configurable Icon Position
Each unit's spell icon can now be placed on the left or right side of the castbar.

- New per-unit option: `iconSide = "LEFT"` (default) or `"RIGHT"`.
- Useful for players who position castbars near the edges of the screen.

#### Named Profile System
Full profile management inspired by TomoMod / EllesmereUI architecture.

**Architecture:**
```
TomoCastbarDB._profiles = {
    named        = { ["Default"] = snapshot, ... },
    profileOrder = { "Default", ... },
    activeProfile  = "Default",
    specProfiles   = { [specID] = "profileName" },
}
```

**Features:**
- Named profiles: create, load, delete, duplicate.
- Spec-to-profile mapping: assign any spec to any named profile.
- Auto-save before every switch (no data loss).
- `PLAYER_SPECIALIZATION_CHANGED` triggers automatic profile switch + `RefreshAll()` (no reload needed).
- Snapshot/Apply pattern: profiles store a complete copy of all non-internal settings.
- `TomoCastbar_Profiles` module with the same API surface as `TomoMod_Profiles`.

**Slash Commands:**

| Command | Action |
|---|---|
| `/tcb profile` | Show status + list all profiles |
| `/tcb profile list` | List all profiles |
| `/tcb profile create <name>` | Create profile from current settings |
| `/tcb profile load <name>` | Load a named profile |
| `/tcb profile delete <name>` | Delete a profile (not Default) |
| `/tcb profile spec` | Show spec → profile assignments |
| `/tcb profile spec <id> <name>` | Assign spec to profile |

### Files Changed

| File | Change |
|---|---|
| `Core/Database.lua` | New defaults (transitions, GCD, school colors, interrupt feedback, icon side); `TomoCastbar_Profiles` module (named profiles, spec mapping, snapshot/apply) |
| `Modules/Castbar.lua` | Icon side support; school color in `ApplyBarColor`; transition `AnimationGroup`s (fade + flash); `FadeOut` / `FlashBar` helpers; interrupt feedback frame; GCD spark system; `UnitGUID` upvalue; `SCHOOL_MASK_COLORS` + `GetSpellSchoolColor` |
| `Core/Init.lua` | `PLAYER_SPECIALIZATION_CHANGED` event; profile slash commands (`/tcb profile ...`); `TomoCastbar_Profiles.InitSpecTracking()` on login |
| `Locales/enUS.lua` | 30 new keys (transitions, GCD, school colors, icon side, interrupt feedback, profiles) |
| `Locales/frFR.lua` | French translations for all new keys |
| `TomoCastbar.toc` | Version 3.0.0, updated Notes |

### Upgrade Notes

- **No action required** — existing SavedVariables are merged with new defaults automatically.
- The profile system initializes with a `Default` profile containing current settings.
- School colors default to `false` (opt-in). GCD spark and transitions default to `true`.
- The `_profiles` key is excluded from profile snapshots to prevent recursion.

---

## [2.1.0] — 2026-04-02

### New — Cast Target Name Display

Target and focus castbars now display the name of the unit being targeted by the cast, shown directly after the spell name. This provides immediate context about who the enemy is casting on — particularly useful in PvP and dungeon scenarios.

#### How it works

- A new `targetText` FontString is created for **target** and **focus** castbars only (not player).
- Anchored to the right of the spell name with a `→` separator: `Fireball → TomoAniki`.
- The target name is retrieved via `UnitName(unitID .. "target")` on each cast start/update.
- **No truncation** — the full target name is always displayed regardless of length.
- Text uses a softer alpha (0.6) to visually distinguish it from the spell name without being too subtle.

#### Behavior

| State | Display |
|---|---|
| Cast with target | `Fireball → PlayerName` |
| Cast without resolvable target | `Fireball` (no arrow, no text) |
| Interrupted | `Interrupted (Name)` — target text cleared |
| Preview (Layout Mode) | `Preview: target → YourName` |

#### Technical Details

- `UnitName()` added to local upvalues for performance.
- `targetText` is cleared in `ResetState()`, `HidePreview()`, and on interrupt events.
- No new SavedVariables or config options — the feature is always active on target/focus bars.

### Files Changed

| File | Change |
|---|---|
| `Modules/Castbar.lua` | Added `UnitName` upvalue; `targetText` FontString creation for target/focus; target name display in `CheckCast`; cleanup in `ResetState`, `ShowPreview`, `HidePreview` |

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