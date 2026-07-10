# TomoCastbar

A lightweight, standalone castbar addon for World of Warcraft (Retail — Midnight 12.x).

Replaces the default Blizzard castbar with clean, fully customizable bars for **Player**, **Target**, and **Focus** units. Supports regular casts, channels, **Empowered casts** (Evoker stage markers with gradient overlays), and **channel tick markers**.

![TomoCastbar](https://img.shields.io/badge/TomoCastbar-v3.1.2-d1b559?style=for-the-badge) ![WoW](https://img.shields.io/badge/WoW-Midnight-blue?style=for-the-badge) ![Interface](https://img.shields.io/badge/Interface-120007-orange?style=for-the-badge)

---

## What's new in v2.0

- **Layout Mode** — TomoMod-style layout manager with floating header, alignment grid and cursor flashlight, per-castbar mover overlays with live coordinates and individual Reset buttons
- **4 spark animation styles** — Comet, Pulse, Helix, Glitch — each with configurable colors and intensity
- **LibSharedMedia-3.0** — access all textures and fonts registered by other addons (bundled, zero external dependency)
- **8 locales** — English, French, German, Spanish, Italian, Portuguese, Russian, Simplified Chinese
- **Precise per-cast latency** — now uses `UNIT_SPELLCAST_SENT` instead of `GetNetStats()` for an exact server round-trip per spell
- **Interrupter name** — displays `Interrupted (PlayerName)` in PvP
- **Pushback support** — `UNIT_SPELLCAST_DELAYED` keeps the bar in sync when a cast is pushed back by damage
- **Zone change recovery** — `PLAYER_ENTERING_WORLD` detects ongoing casts after login, reload, or zone change
- **Timer format choices** — Remaining / Remaining+Total / Elapsed
- **Spell name truncation** — configurable max length with automatic ellipsis
- **Class color** — target and focus bars can use the unit's class color
- **GUI buttons** — Layout Mode and Reload UI buttons directly in the config panel title bar

---

## Features

### Castbars

- **Player / Target / Focus** — independently configurable, fully standalone
- **Empowered cast support** — stage markers and gradient overlays for Evoker abilities (Fire Breath, Eternity Surge…)
- **Channel tick markers** — tick positions computed from a built-in spell database with talent-aware modifiers (e.g. Disintegrate +1 tick with talent)
- **Non-interruptible indicator** — overlay color change when a cast cannot be interrupted
- **Interrupted flash** — brief color flash with the interrupter's name in PvP
- **Latency overlay** — player castbar shows the exact server round-trip for the current spell (via `UNIT_SPELLCAST_SENT`)
- **Pushback detection** — bar timings resync instantly when a cast is delayed by damage
- **Zone change recovery** — ongoing casts on target/focus are detected after login, `/reload`, or zone change

### Spark Animations

Four animation styles, all using a shared texture pool (head + glow + 4 tails):

| Style | Description |
|---|---|
| **Comet** *(default)* | Classic trailing glow — bright head with 4 fading tails |
| **Pulse** | Concentric expanding rings ripple outward from the leading edge |
| **Helix** | Tail elements oscillate in phase-offset sine waves |
| **Glitch** | RGB chromatic aberration with a digital glitch aesthetic |

Colors (head, glow, tails) and intensity (glow alpha, tail alpha) are individually configurable.

### Layout Mode

Inspired by TomoMod's unified layout manager — `/tcb layout` or the **Layout** button in the config panel:

- **Floating header bar** at the top of the screen with title, Grid, Lock, and RL buttons
- **Alignment grid** (32px spacing) with three modes: Grid / Grid+ / Grid OFF
- **Cursor flashlight effect** — grid lines near the cursor glow brighter with quadratic falloff over 200px, identical algorithm to TomoMod
- **Per-castbar mover overlays** — teal header strip with unit name and live X/Y coordinates, translucent body over the castbar preview, drag to reposition, auto-save on drop
- **↺ Reset** button per castbar to restore default position
- **Preview mode** — castbars show their content while unlocked so you position exactly what you see

### Media & Textures (LibSharedMedia-3.0)

- Bar textures and fonts from any LSM-compatible addon (SharedMedia, etc.) appear automatically in the dropdowns
- Live texture update when another addon changes the global LSM statusbar — no reload required
- Graceful fallback to built-in Blizzard textures and fonts if LSM is unavailable

### Config Panel

Dark-themed window with sidebar navigation. **Title bar** includes Layout Mode and Reload UI buttons (identical design to TomoMod).

### Localization

8 locales included — each loads conditionally, only one is active at runtime. Falls back to English for any missing key.

| File | Language | Regions |
|---|---|---|
| `enUS.lua` | English | Americas, Oceania |
| `frFR.lua` | Français | France, Belgium |
| `deDE.lua` | Deutsch | Germany, Austria, Switzerland |
| `esES.lua` | Español | Spain + Latin America |
| `itIT.lua` | Italiano | Italy |
| `ptBR.lua` | Português | Brazil + Portugal |
| `ruRU.lua` | Русский | Russia, CIS |
| `zhCN.lua` | 简体中文 | Mainland China |

---

## Installation

1. Download the latest release
2. Place the `TomoCastbar` folder into:
   ```
   World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Restart WoW or type `/reload` in-game

---

## Slash Commands

| Command | Description |
|---|---|
| `/tcb` | Open the config panel |
| `/tcb reset` | Reset all settings to defaults |
| `/tcb help` | Show all available commands |

---

## Config Panel

Open with `/tcb` — dark-themed config window with sidebar navigation and **Layout** + **RL** buttons in the title bar.

- **General**
  - Background mode (Custom / Black / Transparent)
  - Bar texture — LSM picker if available, otherwise Blizzard / Smooth / Flat
  - Font — LSM picker if available
  - Custom border toggle
  - Spark toggle, style, height, glow/tail intensity, head/glow/tail colors
  - Channel tick markers toggle
  - Cast colors (normal / non-interruptible / interrupted)
  - Class color for target/focus bars
  - Timer format (Remaining / Remaining+Total / Elapsed)
  - Spell name max length
  - Font size slider
  - Hide Blizzard castbar toggle
  - Full reset button

- **Player** — Enable/disable, width, height, icon, timer, latency, Layout button, reset position
- **Target** — Enable/disable, width, height, icon, timer, class color, Layout button, reset position
- **Focus** — Enable/disable, width, height, icon, timer, class color, Layout button, reset position

---

## Default Settings

| Unit | Width | Height | Icon | Timer | Latency |
|---|---|---|---|---|---|
| Player | 260 | 20 | Yes | Yes | Yes |
| Target | 260 | 20 | Yes | Yes | No |
| Focus  | 200 | 16 | Yes | Yes | No |

**Default colors:**
- Cast: `rgb(204, 26, 26)` — red
- Non-interruptible: `rgb(128, 128, 128)` — grey
- Interrupted: `rgb(26, 204, 26)` — green
- Spark head: gold · Spark glow: violet · Spark tail: orange

**Default options:**
- Background mode: Custom texture
- Bar texture: Blizzard (LSM name `"Blizzard"`)
- Custom border: Enabled
- Spark: Enabled — style: Comet
- Channel ticks: Enabled
- Class color: Disabled
- Timer format: Remaining
- Spell name max length: 0 (disabled)
- Hide Blizzard castbar: Enabled
- Font size: 12

---

## Channel Tick Database

Built-in database covering all major channeled spells across all classes. For unlisted spells, a fallback heuristic computes ~1 tick per second.

Talent-aware modifiers are supported — Evoker's Disintegrate gains +1 tick when talent 1219723 is active.

---

## Empowered Cast Gradients

Evoker empowered spells display colored stage zones that progressively reveal as the cast progresses:

| Stage | Color |
|---|---|
| 1 | Orange |
| 2 | Gold |
| 3 | Cyan |
| 4 | Purple |

---

**Credits**

Built by TomoAniki · Extracted and evolved from TomoMod · Layout Mode algorithm adapted from TomoMod
